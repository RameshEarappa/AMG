report 50123 "NBF Security"
{
    DefaultLayout = RDLC;
    //RDLCLayout = 'Report-rdlc-files/R_50110.rdl';
    Caption = 'NBF Security';
    PreviewMode = PrintLayout;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("Gen. Journal Line"; "Gen. Journal Line")
        {
            RequestFilterFields = "Document No.", "Posting Date", "Journal Template Name", "Journal Batch Name";
            DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
            column(Posting_Date; '') { }
            column(Description; UPPERCASE(Description)) { }
            column(Amount; ABs("Amount (LCY)")) { }
            column(AmountInWord; AmountInWord) { }
            trigger OnAfterGetRecord()

            begin
                /*iF ("Bal. Account Type" <> "Bal. Account Type"::"Bank Account") and ("Bal. Account No." <> '') then begin
                    TestField("Account Type", "Account Type"::"Bank Account");

                End ELSE
                    TestField("Bal. Account Type", "Bal. Account Type"::"Bank Account");*/

                CheckRep.FormatNoText(NoText, ABs("Amount (LCY)"), '');
                AmountInWord := NoText[1];
            end;

            trigger OnPostDataItem()
            begin
                /*     SetRange("Account No.", '<> %1', '');
                     if not find then
                         SetRange("Bal. Account No.", '<> %1', '');
     */

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
        Posting_Date: Date;
        Description: Text;


}