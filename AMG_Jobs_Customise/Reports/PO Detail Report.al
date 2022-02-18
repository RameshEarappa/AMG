report 60111 "Purchase Order Detail"
{
    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    Caption = 'PO Detail Report';

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
    trigger OnPreReport()
    var
        myInt: Integer;
    begin

    end;

    local procedure Export2Excel(var PurchaseHeader: Record "Purchase Header")
    var
        TempExcelBuf: Record "Excel Buffer" temporary;
    begin
        TempExcelBuf.reset;
        TempExcelBuf.deleteall;
        TempExcelBuf.CreateNewBook('Sheet1');//Sheet Name
        FillExcelBuffer(TempExcelBuf, PurchaseHeader);
        TempExcelBuf.CloseBook();
        TempExcelBuf.SetFriendlyFilename('Purchase Order Detail');//Excel File Name
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
                //FillPurchaseOrderData(TempExcelBufferSheet, RowNo, PurchaseHeader);
                PurchaseHeader.CalcFields("Invoice Discount Amount", "Amount Including VAT");
                PurchaseHeader.CalcFields(Amount);
                CLEAR(InvoiceNo);
                CLEAR(Preassignedno);
                PurchRecpHeaderG.SetRange("Order No.", PurchaseHeader."No.");
                if PurchRecpHeaderG.FindSet() then begin
                    repeat
                        REcPurchline.Reset;
                        REcPurchline.setrange("Document Type", REcPurchline."Document Type"::Invoice);
                        REcPurchline.SetRange("Receipt No.", PurchRecpHeaderG."No.");
                        if REcPurchline.findfirst then;

                        RecPurchInvHeader.Reset;
                        RecPurchInvHeader.SetRange("Receipt No.", PurchRecpHeaderG."No.");
                        if RecPurchInvHeader.findfirst then begin
                            InvoiceNo := RecPurchInvHeader."Document No.";

                            RecpurchInvHeader1.Reset;
                            RecpurchInvHeader1.SetRange("No.", InvoiceNo);
                            if RecpurchInvHeader1.findfirst then
                                Preassignedno := RecpurchInvHeader1."Pre-Assigned No.";
                        end;



                        VendLedgEntry.Reset;
                        VendLedgEntry.setrange("Document No.", InvoiceNo);
                        if VendLedgEntry.findfirst then begin
                            VendLEdgEntry1.reset;
                            VendLEdgEntry1.setrange("Entry No.", VendLedgEntry."Closed by Entry No.");
                            if VendLedgEntry1.findfirst then;
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

                        Recpurchrcptline.reset;
                        RecpurchRcptLine.setrange("Document No.", PurchRecpHeaderG."No.");
                        RecpurchRcptLine.SetFilter("No.", '<>%1', '');
                        Recpurchrcptline.setfilter(Quantity, '>%1', 0);
                        if RecpurchRcptLine.findset then begin
                            repeat
                                RecPurchLine1.Reset;
                                Recpurchline1.setrange("Document No.", "Purchase Header"."No.");
                                Recpurchline1.setrange("Line No.", RecpurchRcptLine."Line No.");
                                RecPurchLine1.setrange("No.", RecpurchRcptLine."No.");
                                if RecPurchLine1.findfirst then;

                                RecpurchRcptline1.setrange("Document No.", RecpurchRcptline."Document No.");
                                RecpurchRcptLine1.setrange("No.", RecpurchRcptLine."No.");
                                Recpurchrcptline1.setfilter(Quantity, '<%1', 0);
                                if not recpurchrcptline1.findfirst then begin
                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 1, PurchaseHeader."No.", false, false, false);
                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 2, PurchaseHeader."AMG_InitSourceNo", false, false, false);
                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 3, PurchaseHeader."Buy-from Vendor No.", false, false, false);
                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 4, PurchaseHeader."Buy-from Vendor Name", false, false, false);
                                    if PurchaseHeader."Currency Code" = '' then
                                        CurrencyCodeL := 'AED'
                                    else
                                        CurrencyCodeL := PurchaseHeader."Currency Code";

                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 5, CurrencyCodeL, false, false, false);
                                    if CurrencyCodeL = 'AED' then
                                        ExcahangeRateL := 1
                                    else
                                        ExcahangeRateL := 1 / PurchaseHeader."Currency Factor";
                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 6, ExcahangeRateL, false, false, false);
                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 7, PurchaseHeader."Invoice Discount Amount", false, false, false);
                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 8, RecPurchLine1."Amount Including VAT", false, false, false);
                                    DiscountAEDL := ExcahangeRateL * PurchaseHeader."Invoice Discount Amount";
                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 9, DiscountAEDL, false, false, false);
                                    NetAmountAEDL := ExcahangeRateL * RecPurchLine1."Amount Including VAT";
                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 10, NetAmountAEDL, false, false, false);
                                    NetAmountExclVATAEDL := ExcahangeRateL * (RecPurchLine1.Quantity * RecPurchLine1."Direct Unit Cost");
                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 11, NetAmountExclVATAEDL, false, false, false);
                                    RecCoordinator.Reset;
                                    if RecCoordinator.get(PurchaseHeader."Coordinator No.") then;
                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 12, RecCoordinator."Coordinator Name", false, false, false);
                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 13, PurchaseHeader."Record Created By", false, false, false);
                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 14, Format(PurchaseHeader."Order Date"), false, false, false);
                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 15, StatusL, false, false, false);
                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 16, PurchaseHeader."Shortcut Dimension 1 Code", false, false, false);
                                    DimensionValueL.SetRange("Code", PurchaseHeader."Shortcut Dimension 1 Code");
                                    if DimensionValueL.FindFirst() then;
                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 17, DimensionValueL.Name, false, false, false);
                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 18, PurchaseHeader."Project Code", false, false, false);
                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 19, PurchaseHeader."Shortcut Dimension 2 Code", false, false, false);
                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 20, PurchaseHeader."Mubarak Supplier", false, false, false);
                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 21, PurchaseHeader."Mubark Supplier Name", false, false, false);
                                    //message(PurchRecpHeaderG."No.");
                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 22, PurchRecpHeaderG."No.", false, false, false);
                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 23, PurchRecpHeaderG."Posting Date", false, false, false);
                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 24, Preassignedno, false, false, false);
                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 25, RecpurchRcptLine.Type, false, false, false);
                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 26, RecpurchRcptLine."No.", false, false, false);
                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 27, RecPurchLine1.Description, false, false, false);
                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 28, Recpurchline1.Quantity, false, false, false);
                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 29, Recpurchline1."Unit Cost", false, false, false);
                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 30, Recpurchline1."Unit of Measure", false, false, false);
                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 31, Recpurchline1."Shortcut Dimension 1 Code", false, false, false);
                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 32, Recpurchline1."Shortcut Dimension 2 Code", false, false, false);
                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 33, Recpurchline1."Location Code", false, false, false);
                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 34, Recpurchline1."Gen. Prod. Posting Group", false, false, false);
                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 35, InvoiceNo, false, false, false);
                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 36, VendLEdgEntry1."Voucher No.", false, false, false);
                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 37, PurchaseHeader."Payment Terms Code", false, false, false);
                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 38, PurchaseHeader.Purpose, false, false, false);
                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 39, PurchaseHeader.Backcharge, false, false, false);
                                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 40, PurchaseHeader."Backcharge To", false, false, false);
                                    //TempExcelBufferSheet.Insert();
                                    DiscountG := DiscountG + PurchaseHeader."Invoice Discount Amount";
                                    NetAmountG := NetAmountG + RecPurchLine1."Amount Including VAT";
                                    DiscountAEDG := DiscountAEDG + DiscountAEDL;
                                    NetAmountAEDG := NetAmountAEDG + NetAmountAEDL;
                                    NetAmountExclVATAEDG := NetAmountExclVATAEDG + NetAmountExclVATAEDL;
                                    RowNo := RowNo + 1;
                                end;
                            until recpurchrcptline.next = 0;
                        end;
                    until PurchRecpHeaderG.Next() = 0;
                end else begin
                    //Message('1');

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


                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 1, PurchaseHeader."No.", false, false, false);
                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 2, PurchaseHeader."AMG_InitSourceNo", false, false, false);
                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 3, PurchaseHeader."Buy-from Vendor No.", false, false, false);
                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 4, PurchaseHeader."Buy-from Vendor Name", false, false, false);
                    if PurchaseHeader."Currency Code" = '' then
                        CurrencyCodeL := 'AED'
                    else
                        CurrencyCodeL := PurchaseHeader."Currency Code";

                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 5, CurrencyCodeL, false, false, false);
                    if CurrencyCodeL = 'AED' then
                        ExcahangeRateL := 1
                    else
                        ExcahangeRateL := 1 / PurchaseHeader."Currency Factor";
                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 6, ExcahangeRateL, false, false, false);
                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 7, PurchaseHeader."Invoice Discount Amount", false, false, false);
                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 8, PurchaseHeader."Amount Including VAT", false, false, false);
                    DiscountAEDL := ExcahangeRateL * PurchaseHeader."Invoice Discount Amount";
                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 9, DiscountAEDL, false, false, false);
                    NetAmountAEDL := ExcahangeRateL * PurchaseHeader."Amount Including VAT";
                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 10, NetAmountAEDL, false, false, false);
                    PurchaseHeader.CALCFIELDS(Amount);
                    NetAmountExclVATAEDL := ExcahangeRateL * ("PurchaseHeader"."Amount");

                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 11, NetAmountExclVATAEDL, false, false, false);
                    RecCoordinator.Reset;
                    if RecCoordinator.get(PurchaseHeader."Coordinator No.") then;
                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 12, RecCoordinator."Coordinator Name", false, false, false);
                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 13, PurchaseHeader."Record Created By", false, false, false);
                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 14, Format(PurchaseHeader."Order Date"), false, false, false);
                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 15, StatusL, false, false, false);
                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 16, PurchaseHeader."Shortcut Dimension 1 Code", false, false, false);
                    DimensionValueL.SetRange("Code", PurchaseHeader."Shortcut Dimension 1 Code");
                    if DimensionValueL.FindFirst() then;
                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 17, DimensionValueL.Name, false, false, false);
                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 18, PurchaseHeader."Project Code", false, false, false);
                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 19, PurchaseHeader."Shortcut Dimension 2 Code", false, false, false);
                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 20, PurchaseHeader."Mubarak Supplier", false, false, false);
                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 21, PurchaseHeader."Mubark Supplier Name", false, false, false);
                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 22, '', false, false, false);
                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 23, '', false, false, false);
                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 24, '', false, false, false);
                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 25, PurchaseLineG.Type, false, false, false);
                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 26, PurchaseLineG."No.", false, false, false);
                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 27, PurchaseLineG.Description, false, false, false);
                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 28, PurchaseLineG.Quantity, false, false, false);
                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 29, PurchaseLineG."Unit Cost", false, false, false);
                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 30, PurchaseLineG."Unit of Measure", false, false, false);
                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 31, PurchaseLineG."Shortcut Dimension 1 Code", false, false, false);
                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 32, PurchaseLineG."Shortcut Dimension 2 Code", false, false, false);
                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 33, PurchaseLineG."Location Code", false, false, false);
                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 34, PurchaseLineG."Gen. Prod. Posting Group", false, false, false);
                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 35, '', false, false, false);
                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 36, '', false, false, false);
                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 37, PurchaseHeader."Payment Terms Code", false, false, false);
                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 38, PurchaseHeader.Purpose, false, false, false);
                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 39, PurchaseHeader.Backcharge, false, false, false);
                    TempExcelBufferSheet.EnterCell(TempExcelBufferSheet, RowNo, 40, PurchaseHeader."Backcharge To", false, false, false);

                    DiscountG := DiscountG + PurchaseHeader."Invoice Discount Amount";
                    NetAmountG := NetAmountG + PurchaseHeader."Amount Including VAT";
                    DiscountAEDG := DiscountAEDG + DiscountAEDL;
                    NetAmountAEDG := NetAmountAEDG + NetAmountAEDL;
                    RowNo := RowNo + 1;

                end;
            until PurchaseHeader.Next() = 0;

        TempExcelBufferSheet.EnterCell(TempExcelBuffersheet, RowNo, 7, DiscountG, true, false, false);//Fill Total 'Discount'
        TempExcelBuffersheet.EnterCell(TempExcelBuffersheet, RowNo, 8, NetAmountG, true, false, false);//Fill Total 'Net Amount'    
        TempExcelBuffersheet.EnterCell(TempExcelBuffersheet, RowNo, 9, DiscountAEDG, true, false, false);//Fill Total 'Discount AED'
        TempExcelBuffersheet.EnterCell(TempExcelBuffersheet, RowNo, 10, NetAmountAEDG, true, false, false);//Fill Total 'Net Amount AED'
        TempExcelBuffersheet.EnterCell(TempExcelBuffersheet, RowNo, 11, NetAmountExclVATAEDG, true, false, false);//Fill Total 'Net Amount AED'
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
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 11, 'Net Amount Excl. VAT In AED', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 12, 'Coordinator', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 13, 'Record Created By', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 14, 'Date', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 15, 'STATUS', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 16, 'Vessel No', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 17, 'Vessel Name', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 18, 'Job Number', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 19, 'Segment', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 20, 'Mubarak Supplier', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 21, 'Mubark Supplier Name', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 22, 'GRN Number', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 23, 'GRN Posting Date', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 24, 'Purchase Invoice No.', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 25, 'Type', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 26, 'G/L Account', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 27, 'Desciption', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 28, 'Quantity', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 29, 'Unit Cost', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 30, 'Unit of Measure', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 31, 'Project Code', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 32, 'Division Code', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 33, 'Location Code', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 34, 'Posting Group', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 35, 'Invoice Number', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 36, 'Voucher Number', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 37, 'Payment Terms', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 38, 'Purpose', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 39, 'BackCharge', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 40, 'BackCharge To', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 41, '', true, false, false);
    end;

    /*local procedure FillPurchaseOrderData(var TempExcelBuffer: Record "Excel Buffer"; RowNo: Integer; var PurchaseHeader: Record "Purchase Header")
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
    begin
        PurchaseHeader.CalcFields("Invoice Discount Amount", "Amount Including VAT");


        PurchRecpHeaderG.SetRange("Order No.", PurchaseHeader."No.");
        if PurchRecpHeaderG.FindSet() then begin
            repeat
                CLEAR(InvoiceNo);
                REcPurchline.Reset;
                REcPurchline.setrange("Document Type", REcPurchline."Document Type"::Invoice);
                REcPurchline.SetRange("Receipt No.", PurchRecpHeaderG."No.");
                if REcPurchline.findfirst then;

                RecPurchInvHeader.Reset;
                RecPurchInvHeader.SetRange("Receipt No.", PurchRecpHeaderG."No.");
                if RecPurchInvHeader.findfirst then begin
                    InvoiceNo := RecPurchInvHeader."Document No.";
                end;

                VendLedgEntry.Reset;
                VendLedgEntry.setrange("Document No.", InvoiceNo);
                if VendLedgEntry.findfirst then begin
                    VendLEdgEntry1.reset;
                    VendLEdgEntry1.setrange("Entry No.", VendLedgEntry."Closed by Entry No.");
                    if VendLedgEntry1.findfirst then;
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

                Recpurchrcptline.reset;
                RecpurchRcptLine.setrange("Document No.", PurchRecpHeaderG."No.");
                if RecpurchRcptLine.findset then begin
                    repeat
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
                        NetAmountExclVATAEDL := ExcahangeRateL * PurchaseHeader.Amount;
                        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 10, NetAmountExclVATAEDL, false, false, false);
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
                        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 21, PurchRecpHeaderG."No.", false, false, false);
                        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 22, PurchRecpHeaderG."Posting Date", false, false, false);
                        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 23, REcPurchline."Document No.", false, false, false);
                        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 24, RecPurchLine1.Type, false, false, false);
                        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 25, RecPurchLine1."No.", false, false, false);
                        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 26, InvoiceNo, false, false, false);
                        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 27, VendLEdgEntry1."Voucher No.", false, false, false);
                        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 28, PurchaseHeader."Payment Terms Code", false, false, false);
                        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 29, PurchaseHeader.Purpose, false, false, false);
                        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 30, PurchaseHeader.Backcharge, false, false, false);
                        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 31, PurchaseHeader."Backcharge To", false, false, false);
                        //TempExcelBuffer.Insert();
                        DiscountG := DiscountG + PurchaseHeader."Invoice Discount Amount";
                        NetAmountG := NetAmountG + PurchaseHeader."Amount Including VAT";
                        DiscountAEDG := DiscountAEDG + DiscountAEDL;
                        NetAmountAEDG := NetAmountAEDG + NetAmountAEDL;
                        NetAmountExclVATAEDG := NetAmountExclVATAEDG + NetAmountExclVATAEDL;
                        RowNo := RowNo + 1;
                    until recpurchrcptline.next = 0;
                end;
            until PurchRecpHeaderG.Next() = 0;
        end else begin
            //Message('1');

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
            NetAmountExclVATAEDL := ExcahangeRateL * PurchaseHeader.Amount;
            TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 11, NetAmountExclVATAEDL, false, false, false);
            RecCoordinator.Reset;
            if RecCoordinator.get(PurchaseHeader."Coordinator No.") then;
            TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 12, RecCoordinator."Coordinator Name", false, false, false);
            TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 13, PurchaseHeader."Record Created By", false, false, false);
            TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 14, Format(PurchaseHeader."Order Date"), false, false, false);
            TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 15, StatusL, false, false, false);
            TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 16, PurchaseHeader."Shortcut Dimension 1 Code", false, false, false);
            DimensionValueL.SetRange("Code", PurchaseHeader."Shortcut Dimension 1 Code");
            if DimensionValueL.FindFirst() then;
            TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 17, DimensionValueL.Name, false, false, false);
            TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 18, PurchaseHeader."Project Code", false, false, false);
            TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 19, PurchaseHeader."Shortcut Dimension 2 Code", false, false, false);
            TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 20, PurchaseHeader."Mubarak Supplier", false, false, false);
            TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 21, PurchaseHeader."Mubark Supplier Name", false, false, false);
            TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 22, '', false, false, false);
            TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 23, '', false, false, false);
            TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 24, '', false, false, false);
            TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 25, '', false, false, false);
            TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 26, '', false, false, false);
            TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 27, '', false, false, false);
            TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 28, '', false, false, false);
            TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 29, PurchaseHeader."Payment Terms Code", false, false, false);
            TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 30, PurchaseHeader.Purpose, false, false, false);
            TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 31, PurchaseHeader.Backcharge, false, false, false);
            TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 32, PurchaseHeader."Backcharge To", false, false, false);

            DiscountG := DiscountG + PurchaseHeader."Invoice Discount Amount";
            NetAmountG := NetAmountG + PurchaseHeader."Amount Including VAT";
            DiscountAEDG := DiscountAEDG + DiscountAEDL;
            NetAmountAEDG := NetAmountAEDG + NetAmountAEDL;
            RowNo := RowNo + 1;

        end;
    end;
*/


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
        TempExcelBuff: Record "excel buffer";
        RecpurchInvHeader1: Record "Purch. Inv. Header";
        NetAmountExclVATAEDL: Decimal;
        NetAmountExclVATAEDG: Decimal;
        RecPurchLine1: Record "Purchase Line";
        Preassignedno: Code[500];
        RecpurchRcptLine1: Record "Purch. Rcpt. Line";
}