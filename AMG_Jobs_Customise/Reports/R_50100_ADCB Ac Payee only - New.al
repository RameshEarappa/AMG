report 50100 "ADCB A/C Payee Only New"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'AMG_Jobs_Customise\Reports-rdlc-files\R_50100.rdl';
    Caption = 'ADCB A/C Payee Only New';
    PreviewMode = PrintLayout;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("Gen. Journal Line"; "Gen. Journal Line")
        {
            RequestFilterFields = "Document No.", "Posting Date", "Journal Template Name", "Journal Batch Name";
            DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
            column(Amount; ABs("Amount (LCY)")) { }
            column(AmountInWord; AmountInWord) { }
            column(Vendor_Name; VendorG.Name) { }
            column(CompanyInfo_Picture; CompanyInfo.Picture) { }
            column(VarText1; VarText1) { }
            column(VarText2; VarText2) { }
            column(AccountPayeeText; AccountPayeeText) { }

            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemLink = "Applies-to ID" = field("Document No.");
                column(Invoice_Document_No_; "Document No.") { }
                column(Invoice_Posting_Date; Format("Posting Date", 0, '<Day,2>-<Month Text,3>-<Year,2>')) { }
                column(Invoice_Amount__LCY_; ABS("Amount to Apply")) { }
                column(AmountInWord1; AmountInWord1) { }

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    CheckRep.FormatNoText(NoText, Abs("Amount to Apply"), '');
                    AmountInWord1 := NoText[1];
                end;
            }
            trigger OnAfterGetRecord()

            begin
                if VendorG.Get("Account No.") then;
                CheckRep.FormatNoText(NoText, Abs("Amount (LCY)"), '');
                AmountInWord := NoText[1];
                PositionlL := FindLastSpace(AmountInWord, 50);
                if PositionlL = 0 then
                    VarText1 := CopyStr(AmountInWord, PositionlL + 1)
                else begin
                    VarText1 := CopyStr(AmountInWord, 1, PositionlL);
                    VarText2 := CopyStr(AmountInWord, PositionlL + 1);
                end;
                If AccountPayeeG then
                    AccountPayeeText := 'A/C Payee Only';
            end;
        }
    }
    requestpage
    {
        SaveValues = false;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field("A/c Payee"; AccountPayeeG)
                    {
                        ApplicationArea = All;
                        Caption = 'A/C Payee';
                    }

                }
            }
        }
    }
    trigger OnPreReport()
    begin
        CheckRep.InitTextVariable;
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;


    var
        CompanyInfo: Record "Company Information";
        CheckRep: Codeunit "Amount In Word LT";
        AmountInWord: Text;
        AmountInWord1: Text;
        NoText: array[1] of Text;
        AmtLCY: Decimal;
        VendorG: Record Vendor;
        PositionlL: Integer;
        VarText1: Text;
        VarText2: Text;
        AccountPayeeG: Boolean;
        AccountPayeeText: Text;

    local procedure FindLastSpace(AmountInWord: Text; n: Integer): Integer
    var
        TextL: Text;
        i: Integer;
    begin
        if PositionlL > 50 then
            for i := 0 to 10 do begin
                TextL := CopyStr(AmountInWord, i, n - i);
                if CopyStr(TextL, n - i) = ' ' then
                    exit(n - i);
            end;
    end;
}