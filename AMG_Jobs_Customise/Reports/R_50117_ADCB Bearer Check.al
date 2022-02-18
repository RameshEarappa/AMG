report 50117 "ADCB Bearer Check"
{
    DefaultLayout = RDLC;
    //RDLCLayout = 'Report-rdlc-files/R_50110.rdl';
    Caption = 'ADCB Bearer Check';
    PreviewMode = PrintLayout;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("Gen. Journal Line"; "Gen. Journal Line")
        {
            RequestFilterFields = "Document No.", "Posting Date", "Journal Template Name", "Journal Batch Name";
            DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
            column(Posting_Date; "Posting Date") { }
            column(Description; UPPERCASE(Description)) { }
            column(Amount; ABs("Amount (LCY)")) { }
            column(AmountInWord; AmountInWord) { }
            trigger OnAfterGetRecord()

            begin

                CheckRep.FormatNoText(NoText, Abs("Amount (LCY)"), "Currency Code");
                AmountInWord := NoText[1];
            end;

            trigger OnPostDataItem()
            begin


            end;
        }
    }
    trigger OnPreReport()
    begin
        CheckRep.InitTextVariable;
        //if ("Gen. Journal Line"."Account Type" <> "Gen. Journal Line"."Account Type"::"Bank Account") or ("Gen. Journal Line"."Bal. Account Type"<> "Gen. Journal Line"."Bal. Account Type"::"Bank Account" ) then
        //  exit();
    end;

    var
        CheckRep: Codeunit "Amount In Word LT";
        AmountInWord: Text;
        NoText: array[1] of Text;
        Rec2: Record "Gen. Journal Line";
        AmtLCY: Decimal;
}