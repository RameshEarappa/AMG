/*codeunit 50179 TestCde
{
    trigger OnRun()
    begin

    end;

    procedure RunExcel(FromDateL: Date; ToDateL: Date)
    Begin
        FromDatG := FromDateL;
        ToDaateG := ToDaateG;

        TempExcelBuf.CreateNewBook('Sheet1');//Sheet Name
                                             //   FillExcelBuffer(JobRec);
        TempExcelBuf.CloseBook();
        TempExcelBuf.SetFriendlyFilename('Job Cost Aanalisis');//Excel File Name
        TempExcelBuf.OpenExcel();

    End;

    local procedure FillExcelBuffer(var JoRec: Record Job)
    var
        TempExcelBufferSheet: Record "Excel Buffer" temporary;
        RowNoL: Integer;
        JobRec2: Record job;

    begin
        FillHeaderData(1, JoRec);//First Row
                                 // RowNoL := 2;//Second Row
        JobRec2.Reset();
        JobRec2.SetFilter("Creation Date", '%1..%2', FromDatG, ToDaateG);
        if JobRec2.FindSet() then
            repeat
                LineNo += 1;
                FillPurchaseOrderData(TempExcelBufferSheet, RowNoL, JobRec2);
                RowNoL := RowNoL + 1;
            until JobRec2.Next() = 0;
        TempExcelBuffer.WriteAllToCurrentSheet(TempExcelBufferSheet);
    end;


    local procedure FillHeaderData(RowNo: Integer; var JobRec: Record Job)
    var

    begin
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 1, 'SL No.', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 2, 'Ceation Date', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 3, 'Vessel No.', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 4, 'Vessel Name', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 5, 'Job No.', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 6, 'Client No.', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 7, 'Client Name', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 8, 'Estimated Cost Total', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 9, 'Cost Occured Total', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 10, 'Revenue (AED)', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 11, 'Profit (AED)', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 12, '% OF PROFIT', true, false, false);
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 13, 'REMAINING AMOUNT', true, false, false);
    end;

    local procedure FillPurchaseOrderData(var TempExcelBuffer: Record "Excel Buffer"; RowNo: Integer; var JobRec: Record Job)

    vaR
    begin

        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 1, LineNo, false, false, false);//
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 2, Format(jobrec."Creation Date"), false, false, false);//
        GLSetup.Get();
        DefDimRec.Reset();
        DefDimRec.SetRange("No.", JobRec."No.");
        DefDimRec.SetRange("Dimension Code", GLSetup."Global Dimension 1 Code");
        If DefDimRec.FindFirst() then
            TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 3, DefDimRec."Dimension Value Code", false, false, false);//

        DimValRec.Reset();
        DimValRec.SetRange("Dimension Code", GLSetup."Global Dimension 1 Code");
        DimValRec.SetRange(Code, DefDimRec."Dimension Value Code");
        If DimValRec.FindFirst() then
            TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 4, DimValRec.Name, false, false, false);//

        GLSetup.Get();
        DefDimRec2.Reset();
        DefDimRec2.SetRange("No.", JobRec."No.");
        DefDimRec2.SetRange("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
        If DefDimRec2.FindFirst() then
            TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 5, DefDimRec2."Dimension Value Code", false, false, false)//
        else
            TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 6, JobRec."Bill-to Customer No.", false, false, false);//
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 7, JobRec."Bill-to Name", false, false, false);//

        Clear(EC_Total);
        JobTaskRec.Reset();
        JobTaskRec.SetRange("Job No.", JobRec."No.");
        JobTaskRec.SetRange("Job Task Type", JobTaskRec."Job Task Type"::"End-Total");
        If JobTaskRec.FindSet() then begin
            repeat
                EC_Total += JobTaskRec."Schedule (Total Cost)";
            until JobTaskRec.next = 0;
        End;
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 8, EC_Total, false, false, false);//

        Clear(CostAmtAct);
        IleRec.Reset();
        IleRec.SetRange("Project Code", DefDimRec2."Dimension Value Code");
        IleRec.SetFilter("Posting Date", '%1..%2', FromDatG, ToDaateG);
        If IleRec.FindSet() then begin
            repeat
                CostAmtAct += IleRec."Cost Amount (Actual)" + IleRec."Cost Amount (Expected)";
            until IleRec.Next() = 0;
        End;
        Clear(TotCostLcy);
        RleRec.Reset();
        RleRec.SetRange("Project Code", DefDimRec2."Dimension Value Code");
        RleRec.SetFilter("Posting Date", '%1..%2', FromDatG, ToDaateG);
        If RleRec.FindSet() then begin
            repeat
                TotCostLcy += RleRec."Total Cost";
            until RleRec.Next() = 0;
        End;

        CO_Total := TotCostLcy + CostAmtAct;

        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 9, CO_Total, false, false, false);//

        Clear(RevenueAmt);
        CleRec.Reset();
        CleRec.SetRange("Project Code", DefDimRec2."Dimension Value Code");
        CleRec.SetFilter("Posting Date", '%1..%2', FromDatG, ToDaateG);
        If CleRec.FindSet() then begin
            repeat
                RevenueAmt += CleRec."Sales (LCY)";
            until CleRec.Next() = 0;
        end;
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 10, RevenueAmt, false, false, false);//

        Clear(Profit);
        Profit := RevenueAmt - CO_Total;

        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 11, Profit, false, false, false);//

        Clear(ProFitPer);
        IF RevenueAmt <> 0 then
            ProFitPer := Profit / RevenueAmt;
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 12, ProFitPer, false, false, false);//
    end;

    var
        myInt: Integer;
        JobRec: Record job;
        TempExcelBuf: Record "Excel Buffer" temporary;
        TempExcelBuffer: Record "Excel Buffer" temporary;
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
        RevenueAmt: Decimal;
        Profit: Decimal;
        ProFitPer: Decimal;
        FromDatG: Date;
        ToDaateG: Date;
}*/