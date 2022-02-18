/*codeunit 50105 "Check_Report_Action"
{
    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document-Print", 'OnBeforePrintCheck', '', false, false)]
    procedure GetTheReportIdAndPrint(VAR GenJournalLine: Record "Gen. Journal Line"; VAR IsPrinted: Boolean)
    var
        BankAcc: Record "Bank Account";
        ReportSelections: Record 77;
    begin
        if GenJournalLine."Bal. Account Type" = GenJournalLine."Bal. Account Type"::"Bank Account" then begin
            Clear(BankAcc);
            BankAcc.SetRange("No.", GenJournalLine."Bal. Account No.");
            if BankAcc.FindFirst() then begin
                if BankAcc."Check Report ID" <> 0 then begin
                    Report.Run(BankAcc."Check Report ID", TRUE, false, GenJournalLine);
                    IsPrinted := true;
                    //  ReportSelections.Print(BankAcc."Check Report ID", GenJournalLine, 0);
                end;
            end;
        end;
    end;
}*/