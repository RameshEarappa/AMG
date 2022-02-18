report 60110 "Purchase Order Summary"
{
    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    Caption = 'PO Summary Report';

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = where("Document Type" = const(order));
            RequestFilterFields = "Buy-from Vendor No.", "Order Date", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Project Code";

            trigger OnPostDataItem()
            begin
                Export2Excel("Purchase Header");
            end;
        }
    }

    local procedure Export2Excel(var PurchaseHeader: Record "Purchase Header")
    var
        TempExcelBuf: Record "Excel Buffer" temporary;
    begin
        TempExcelBuf.CreateNewBook('Sheet1');//Sheet Name
        FillExcelBuffer(TempExcelBuf, PurchaseHeader);
        TempExcelBuf.CloseBook();
        TempExcelBuf.SetFriendlyFilename('Purchase Order Summary');//Excel File Name
        TempExcelBuf.OpenExcel();
    end;

    local procedure FillExcelBuffer(var TempExcelBuffer: Record "Excel Buffer" temporary; var PurchaseHeader: Record "Purchase Header")
    var
        TempExcelBufferSheet: Record "Excel Buffer" temporary;

    begin
        FillHeaderData(TempExcelBufferSheet, 1, PurchaseHeader);//First Row
        RowNo := 2;//Second Row
        if PurchaseHeader.FindSet() then
            repeat
                FillPurchaseOrderData(TempExcelBufferSheet, RowNo, PurchaseHeader);
                RowNo := RowNo + 1;
            until PurchaseHeader.Next() = 0;

        TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 7, DiscountG, true, false, false);//Fill Total 'Discount'
        TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 8, NetAmountG, true, false, false);//Fill Total 'Net Amount'    
        TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 9, DiscountAEDG, true, false, false);//Fill Total 'Discount AED'
        TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 10, NetAmountAEDG, true, false, false);//Fill Total 'Net Amount AED'
        TempExcelBuffer.WriteAllToCurrentSheet(TempExcelBufferSheet);
    end;


    local procedure FillHeaderData(var TempExcelBuffer: Record "Excel Buffer"; RowNo: Integer; var PurchaseHeader: Record "Purchase Header")
    var
    begin
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 1, 'PO Number', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 2, 'Purchase Requisition', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 3, 'Vendor No', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 4, 'Suppliers Name', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 5, 'Currency', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 6, 'Exch Rate', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 7, 'Discount', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 8, 'Net Amount', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 9, 'Discount In AED', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 10, 'Net Amount In AED', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 11, 'Coordinator', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 12, 'Record Created By', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 13, 'Date', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 14, 'STATUS', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 15, 'Vessel No', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 16, 'Vessel Name', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 17, 'Job Number', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 18, 'Segment', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 19, 'Mubarak Supplier', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 20, 'Mubark Supplier Name', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 21, 'GRN Number', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 22, 'Invoice Number', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 23, 'Payment Terms', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 24, 'Purpose', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 25, 'BackCharge', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 26, 'BackCharge To', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 27, '', true, false, false);
    end;

    local procedure FillPurchaseOrderData(var TempExcelBuffer: Record "Excel Buffer"; RowNo: Integer; var PurchaseHeader: Record "Purchase Header")
    var
        CurrencyCodeL: Code[20];
        ExcahangeRateL: Decimal;
        DiscountAEDL: Decimal;
        NetAmountAEDL: Decimal;
        // DiscountL: Decimal;
        //NetAmountL: Decimal;
        DimensionValueL: Record "Dimension Value";
        StatusL: Text;
        GRNumberL: Code[500];
        InvoiceNo: Code[500];
        Invoiceno1: Code[500];
    begin
        PurchaseHeader.CalcFields("Invoice Discount Amount", "Amount Including VAT");
        CLEAR(InvoiceNo);
        PurchRecpHeaderG.SetRange("Order No.", PurchaseHeader."No.");
        if PurchRecpHeaderG.FindSet() then begin
            repeat
                GRNumberL := PurchRecpHeaderG."No." + ' ,' + GRNumberL;

                RecPurchInvHeader.Reset;
                RecPurchInvHeader.SetRange("Receipt No.", PurchRecpHeaderG."No.");
                if RecPurchInvHeader.findfirst then begin

                    InvoiceNo := InvoiceNo + ' ' + RecPurchInvHeader."Document No.";

                    VendLedgEntry.Reset;
                    VendLedgEntry.setrange("Document No.", RecPurchInvHeader."Document No.");
                    if VendLedgEntry.findfirst then begin
                        VendLEdgEntry1.reset;
                        VendLEdgEntry1.setrange("Entry No.", VendLedgEntry."Closed by Entry No.");
                        if VendLedgEntry1.findfirst then;
                    end;
                    //UNTIL RecPurchInvHeader.next = 0;
                end;

                REcPurchline.Reset;
                REcPurchline.setrange("Document Type", REcPurchline."Document Type"::Invoice);
                REcPurchline.SetRange("Receipt No.", PurchRecpHeaderG."No.");
                if REcPurchline.findfirst then;
            until PurchRecpHeaderG.next = 0;
        end;






        PurchaseLineG.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseLineG.SetRange("Document No.", PurchaseHeader."No.");
        //if PurchaseLineG.Type IN [PurchaseLineG."Type"::Item, PurchaseLineG."Type"::"G/L Account"] then begin
        PurchaseLineG.CalcSums(Quantity, "Quantity Received");
        if (PurchaseLineG.Quantity = PurchaseLineG."Quantity Received") AND (PurchaseLineG.Quantity > 0) then
            StatusL := 'Closed'
        else begin
            if PurchaseLineG."Quantity Received" = 0 then
                StatusL := 'Open'
            else
                StatusL := 'Partially Received';
        end;

        if PurchaseHeader.AMG_ShortClosedOrCancelled then begin
            if PurchaseHeader.AMG_ShortClosed then
                StatusL := 'Shortclosed'
            else
                if PurchaseHeader.AMG_Cancelled then
                    StatusL := 'Canceled';
        end;


        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 1, PurchaseHeader."No.", false, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 2, PurchaseHeader."AMG_InitSourceNo", false, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 3, PurchaseHeader."Buy-from Vendor No.", false, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 4, PurchaseHeader."Buy-from Vendor Name", false, false, false);
        if PurchaseHeader."Currency Code" = '' then
            CurrencyCodeL := 'AED'
        else
            CurrencyCodeL := PurchaseHeader."Currency Code";

        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 5, CurrencyCodeL, false, false, false);
        if CurrencyCodeL = 'AED' then
            ExcahangeRateL := 1
        else
            ExcahangeRateL := 1 / PurchaseHeader."Currency Factor";
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 6, ExcahangeRateL, false, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 7, PurchaseHeader."Invoice Discount Amount", false, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 8, PurchaseHeader."Amount Including VAT", false, false, false);
        DiscountAEDL := ExcahangeRateL * PurchaseHeader."Invoice Discount Amount";
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 9, DiscountAEDL, false, false, false);
        NetAmountAEDL := ExcahangeRateL * PurchaseHeader."Amount Including VAT";
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 10, NetAmountAEDL, false, false, false);
        RecCoordinator.Reset;
        if RecCoordinator.get(PurchaseHeader."Coordinator No.") then;
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 11, RecCoordinator."Coordinator Name", false, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 12, PurchaseHeader."Record Created By", false, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 13, Format(PurchaseHeader."Order Date"), false, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 14, StatusL, false, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 15, PurchaseHeader."Shortcut Dimension 1 Code", false, false, false);
        DimensionValueL.SetRange("Code", PurchaseHeader."Shortcut Dimension 1 Code");
        if DimensionValueL.FindFirst() then;
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 16, DimensionValueL.Name, false, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 17, PurchaseHeader."Project Code", false, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 18, PurchaseHeader."Shortcut Dimension 2 Code", false, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 19, PurchaseHeader."Mubarak Supplier", false, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 20, PurchaseHeader."Mubark Supplier Name", false, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 21, GRNumberL, false, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 22, InvoiceNo, false, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 23, PurchaseHeader."Payment Terms Code", false, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 24, PurchaseHeader.Purpose, false, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 25, PurchaseHeader.Backcharge, false, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 26, PurchaseHeader."Backcharge To", false, false, false);

        DiscountG := DiscountG + PurchaseHeader."Invoice Discount Amount";
        NetAmountG := NetAmountG + PurchaseHeader."Amount Including VAT";
        DiscountAEDG := DiscountAEDG + DiscountAEDL;
        NetAmountAEDG := NetAmountAEDG + NetAmountAEDL;



    end;


    var
        PurchRecpHeaderG: Record "Purch. Rcpt. Header";
        PurchaseLineG: Record "Purchase Line";
        GenLedgSetUpG: Record "General Ledger Setup";
        DiscountG: Decimal;
        NetAmountG: Decimal;
        DiscountAEDG: Decimal;
        NetAmountAEDG: Decimal;
        ShorcutDimension3G: Code[30];
        DimSetEntry: Record "Dimension Set Entry";

        RecPurchInvHeader: Record "Purch. Inv. Line";
        RecCoordinator: Record Coordinator;
        GRNDate: Date;
        GRNDAteTExt: TExt;

        REcPurchline: record "Purchase Line";

        RecpurchRcptLine: Record "Purch. Rcpt. Line";
        PINo: Text[100];

        VendLedgEntry: Record "Vendor Ledger Entry";
        VendLEdgEntry1: record "Vendor Ledger Entry";
        RowNo: Integer;

}