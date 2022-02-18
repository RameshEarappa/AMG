report 50177 "Job Cost Analysis Excel"
{
    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Job Cost Analysis Excel';


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
                TempExcelBuf: Record "Excel Buffer" temporary;
            begin
                //FillExcelBuffer(TempExcelBuf);
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
        JobRec: Record Job;
        TempExcelBuf: Record "Excel Buffer" temporary;
    begin
        TempExcelBuf.CreateNewBook('Sheet1');//Sheet Name
        FillExcelBuffer(TempExcelBuf);
        TempExcelBuf.CloseBook();
        TempExcelBuf.SetFriendlyFilename('Job Cost Aanalisis');//Excel File Name
        TempExcelBuf.OpenExcel();
    end;

    local procedure FillExcelBuffer(var TempExcelBuffer: Record "Excel Buffer" temporary)
    var
        JoRec: Record Job;
        TempExcelBufferSheet: Record "Excel Buffer" temporary;
        RowNoL: Integer;
    begin
        FillHeaderData(TempExcelBufferSheet, 1, JoRec);//First Row
        RowNoL := 2;//Second Row
        JoRec.Reset();
        JoRec.SetFilter("Creation Date", '%1..%2', FromDate, ToDate);
        if JoRec.FindSet() then
            repeat
                GLSetup.Get();
                DefDimRec2.Reset();
                DefDimRec2.SetRange("No.", JoRec."No.");
                DefDimRec2.SetRange("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
                If DefDimRec2.FindFirst() then begin
                    VessCodeGV := DefDimRec2."Dimension Value Code";
                    LineNo += 1;
                    FillPurchaseOrderData(TempExcelBufferSheet, RowNoL, JoRec);
                    RowNoL := RowNoL + 1;
                end;
            until JoRec.Next() = 0;
        TempExcelBuffer.WriteAllToCurrentSheet(TempExcelBufferSheet);
    end;


    local procedure FillHeaderData(var TempExcelBuffer: Record "Excel Buffer"; RowNo: Integer; var JobRec: Record Job)
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
            TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 5, DefDimRec2."Dimension Value Code", false, false, false);//

        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 6, JobRec."Bill-to Customer No.", false, false, false);//
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 7, JobRec."Bill-to Name", false, false, false);//

        Clear(EC_Total);
        JobTaskRec.Reset();
        JobTaskRec.SetRange("Job No.", JobRec."No.");
        JobTaskRec.SetRange("Job Task Type", JobTaskRec."Job Task Type"::"End-Total");
        If JobTaskRec.FindSet() then begin
            repeat
                JobTaskRec.CalcFields("Schedule (Total Cost)");
                EC_Total += JobTaskRec."Schedule (Total Cost)";
            until JobTaskRec.next = 0;
        End;
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 8, EC_Total, false, false, false);//

        //Clear(CostAmtAct);
        /* Commented and directly taking from Job ledger enry
                GLSetup.Get();
                DefDimRec3.Reset();
                DefDimRec3.SetRange("No.", JobRec."No.");
                DefDimRec3.SetRange("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
                If DefDimRec3.FindFirst() then;

                IleRec.Reset();
                IleRec.SetRange("Entry Type", IleRec."Entry Type"::"Negative Adjmt.");
                //IleRec.SetRange("Project Code", VessCodeGV);
                // IleRec.SetRange("Project Code", DefDimRec3."Dimension Value Code");
                //IleRec.SetFilter("Posting Date", '%1..%2', FromDate, ToDate);
                If IleRec.FindSet() then begin
                    // Error('%1', IleRec.Count);

                    repeat
                        GLSetup.Get();
                        DimSetEntRec.Reset();
                        DimSetEntRec.SetRange("Dimension set ID", IleRec."Dimension Set ID");
                        DimSetEntRec.SetRange("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
                        if DimSetEntRec.FindFirst() then begin
                            iF DimSetEntRec."Dimension Value Code" = VessCodeGV then begin
                                Clear(Ile_CostAmtAct);
                                IleRec.CalcFields("Cost Amount (Actual)");
                                Ile_CostAmtAct := IleRec."Cost Amount (Actual)";

                                  Clear(Ile_CostAmtExp);
                                   IleRec.CalcFields("Cost Amount (Expected)");
                                   Ile_CostAmtExp := IleRec."Cost Amount (Expected)";
                            End;
                        End;
                        // CostAmtAct += IleRec."Cost Amount (Actual)" + IleRec."Cost Amount (Expected)";
                        CostAmtAct += Ile_CostAmtAct// (Ile_CostAmtAct + Ile_CostAmtExp);

                    until IleRec.Next() = 0;

                End;
                //Clear(TotCostLcy);
                RleRec.Reset();
                // RleRec.SetRange("Project Code", VessCodeGV);
                //RleRec.SetFilter("Posting Date", '%1..%2', fromDate, ToDate);
                If RleRec.FindSet() then begin
                    repeat
                        GLSetup.Get();
                        DimSetEntRec.Reset();
                        DimSetEntRec.SetRange("Dimension set ID", RleRec."Dimension Set ID");
                        DimSetEntRec.SetRange("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
                        if DimSetEntRec.FindFirst() then begin
                            iF DimSetEntRec."Dimension Value Code" = VessCodeGV then begin
                                TotCostLcy += RleRec."Total Cost";
                            End;
                        End;
                    until RleRec.Next() = 0;
                End;

                CO_Total := TotCostLcy + CostAmtAct;

                TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 9, CO_Total, false, false, false);
        */
        Clear(CO_Total);
        JobLedEntRec.Reset();
        JobLedEntRec.SetRange("Entry Type", JobLedEntRec."Entry Type"::Usage);
        If JobLedEntRec.FindSet() then begin
            repeat
                DimSetEntRec.Reset();
                DimSetEntRec.SetRange("Dimension set ID", JobLedEntRec."Dimension Set ID");
                DimSetEntRec.SetRange("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
                if DimSetEntRec.FindFirst() then begin
                    iF DimSetEntRec."Dimension Value Code" = VessCodeGV then
                        CO_Total += JobLedEntRec."Total Cost (LCY)";
                end;
            Until JobLedEntRec.Next() = 0;
        End;
        CO_Total := Abs(CO_Total);

        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 9, Round(CO_Total), false, false, false);

        Clear(RevenueAmt);
        CleRec.Reset();
        // CleRec.SetRange("Project Code", VessCodeGV);
        //CleRec.SetFilter("Posting Date", '%1..%2', FromDate, ToDate);
        If CleRec.FindSet() then begin
            repeat
                GLSetup.Get();
                DimSetEntRec.Reset();
                DimSetEntRec.SetRange("Dimension set ID", CleRec."Dimension Set ID");
                DimSetEntRec.SetRange("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
                if DimSetEntRec.FindFirst() then begin
                    iF DimSetEntRec."Dimension Value Code" = VessCodeGV then begin
                        //CleRec.CalcSums("Sales (LCY)");
                        RevenueAmt += CleRec."Sales (LCY)";
                    End;
                End;
            until CleRec.Next() = 0;
            RevenueAmt := Abs(RevenueAmt)
        end;
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 10, Round(RevenueAmt), false, false, false);//

        Clear(Profit);

        Profit := RevenueAmt - CO_Total;

        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 11, Profit, false, false, false);//

        Clear(ProFitPer);
        IF RevenueAmt <> 0 then begin
            ProFitPer := (Profit / RevenueAmt) * 100;
            ProFitPer := Round(ProFitPer);
        End;
        TempExcelBuffer.EnterCell(TempExcelBuffer, RowNo, 12, ProFitPer, false, false, false);//
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
        DefDimRec3: Record "Default Dimension";
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
        Ile_CostAmtAct: Decimal;
        Ile_CostAmtExp: Decimal;
        VessCodeGV: Code[50];
        DimSetEntRec: Record "Dimension Set Entry";
        JobLedEntRec: Record "Job Ledger Entry";


}