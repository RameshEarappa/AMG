codeunit 50401 "Validate Voucher No."
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", 'OnBeforeCode', '', false, false)]
    procedure OnBeforeCode(VAR GenJournalLine: Record "Gen. Journal Line"; PreviewMode: Boolean; CommitIsSuppressed: Boolean)
    var
        SourceCodeSetup: Record "Source Code Setup";
    begin
        SourceCodeSetup.Get();
        GenJnlLine2.Reset();
        GenJnlLine2.SetRange("Document No.", GenJournalLine."Document No.");
        GenJnlLine2.SetRange("Source Code", SourceCodeSetup."Payment Journal");
        GenJnlLine2.SetRange("Voucher No.", ' ');
        IF GenJnlLine2.FindFirst() THEN
            Error('Voucher No. should not be blank, Please assign Voucher No.');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document-Print", 'OnBeforePrintCheck', '', false, false)]
    procedure OnBeforePrintCheck(VAR GenJournalLine: Record "Gen. Journal Line"; VAR IsPrinted: Boolean)
    var
        SourceCodeSetup: Record "Source Code Setup";
    begin
        SourceCodeSetup.Get();
        GenJnlLine2.Reset();
        GenJnlLine2.SetRange("Document No.", GenJournalLine."Document No.");
        GenJnlLine2.SetRange("Source Code", SourceCodeSetup."Payment Journal");
        GenJnlLine2.SetRange("Voucher No.", '');
        IF GenJnlLine2.FindFirst() THEN
            Error('Voucher No. should not be blank, Please assign Voucher No.');
    end;

    //flow Back Charge and Back Charge to from Purchase Header to GL Entry
    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromPurchHeader', '', false, false)]
    local procedure OnAfterCopyGenJnlLineFromPurchHeader(PurchaseHeader: Record "Purchase Header";
    var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine.Backcharge := Format(PurchaseHeader.Backcharge);
        GenJournalLine."Backcharge To" := PurchaseHeader."Backcharge To";
    end;

    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnAfterCopyGLEntryFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyGLEntryFromGenJnlLine(var GenJournalLine: Record "Gen. Journal Line";
    var GLEntry: Record "G/L Entry")
    begin
        GLEntry.Backcharge := GenJournalLine.Backcharge;
        GLEntry."Backcharge To" := GenJournalLine."Backcharge To";
    end;

    var
        GenJnlLine2: Record "Gen. Journal Line";
}