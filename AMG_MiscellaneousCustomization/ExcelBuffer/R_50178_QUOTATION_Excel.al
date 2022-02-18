report 50178 "Quotation Details"
{
    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Quotation Details';

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            trigger OnPreDataItem()
            var

            begin

            end;

            trigger OnAfterGetRecord()
            vAR

            begin
            end;

            trigger OnPostDataItem()
            begin
                Export2Excel();
            End;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Dates)
                {
                    field(FromDate; FromDate)
                    {
                        ApplicationArea = all;
                        Caption = 'From Date';
                    }
                    field(ToDate; ToDate)
                    {
                        ApplicationArea = all;
                        Caption = 'To Date';
                    }
                }
            }
        }
    }
    local procedure Export2Excel()
    var

        TempExcelBuf: Record "Excel Buffer" temporary;
    begin
        TempExcelBuf.CreateNewBook('Sheet1');//Sheet Name
        FillExcelBuffer(TempExcelBuf);
        TempExcelBuf.CloseBook();
        TempExcelBuf.SetFriendlyFilename('Quotation Details');//Excel File Name
        TempExcelBuf.OpenExcel();
    end;

    local procedure FillExcelBuffer(var TempExcelBuffer: Record "Excel Buffer" temporary)
    var
        SalHeadRec: Record "Sales Header";
        TempExcelBufferSheet: Record "Excel Buffer" temporary;
        RowNoL: Integer;
    begin
        FillHeaderData(TempExcelBufferSheet, 1, SalHeadRec);//First Row
        RowNoL := 2;//Second Row
        SalHeadRec.Reset();
        SalHeadRec.SetRange("Document Type", SalHeadRec."Document Type"::Quote);
        SalHeadRec.SetFilter("Document Date", '%1..%2', FromDate, ToDate);
        if SalHeadRec.FindSet() then
            repeat
                LineNo += 1;
                FillPurchaseOrderData(TempExcelBufferSheet, RowNoL, SalHeadRec);
                RowNoL := RowNoL + 1;
            until SalHeadRec.Next() = 0;
        TempExcelBuffer.WriteAllToCurrentSheet(TempExcelBufferSheet);
    end;


    local procedure FillHeaderData(var TempExcelBuffer: Record "Excel Buffer"; RowNo: Integer; var SalHeadRecL: Record "Sales Header")
    var
    begin
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 1, 'SL No.', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 2, 'DOCUMENT DATE', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 3, 'QUOTATION REF NO', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 4, 'VESSEL NAME.', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 5, 'CLIENT NAME', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 6, 'SCOPE OF WORK', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 7, 'QUOTED AMOUNT', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 8, 'QUOTATION STATUS', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 9, 'REMARKS ', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 10, 'INVOICE', true, false, false);
    end;

    local procedure FillPurchaseOrderData(var TempExcelBuffer: Record "Excel Buffer"; RowNo: Integer; SalHeadRecL: Record "Sales Header")

    vaR
        GLSetup: Record "General Ledger Setup";
        DimSetEntRec: Record "Dimension Set Entry";
        SaleLinerec: Record "Sales Line";
        Sd1ValueName: Text;
    begin

        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 1, LineNo, false, false, false);//
        tempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 2, SalHeadRecL."Document Date", false, false, false);
        tempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 3, SalHeadRecL."No.", false, false, false);
        SalHeadRecL.CalcFields("Vessel Name");
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 4, SalHeadRecL."Vessel Name", false, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 5, SalHeadRecL.To_Customer_Name, false, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 6, SalHeadRecL."SCOPE OF WORK", false, false, false);


        Clear(QAmt);
        SaleLinerec.Reset();
        SaleLinerec.SetRange("Document No.", SalHeadRecL."No.");
        If SaleLinerec.FindSet() then begin
            repeat
                QAmt += SaleLinerec."Line Amount";
            until SaleLinerec.Next() = 0;
        End;
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 7, QAmt, false, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 8, SalHeadRecL."QUOTATION STATUS", false, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 9, SalHeadRecL.REMARKS, false, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 10, SalHeadRecL."Invoice Text", false, false, false);

    end;


    var
        FromDate: Date;
        ToDate: Date;
        EC_Total: Decimal;
        LineNo: Integer;
        GLSetup: Record "General Ledger Setup";
        DefDimRec: Record "Default Dimension";
        DimValRec: Record "Dimension Value";
        DefDimRec2: Record "Default Dimension";
        JobTaskRec: Record "Job Task";
        IleRec: Record "Item Ledger Entry";
        CostAmtAct: Decimal;
        RleRec: Record "Res. Ledger Entry";
        TotCostLcy: Decimal;
        CO_Total: Decimal;
        CleRec: Record "Cust. Ledger Entry";
        QAmt: Decimal;


}