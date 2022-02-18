codeunit 50400 "Voucher No Transfer"
{
    Permissions = TableData 17 = RIMD;

    var
        Voucher: Code[20];
        Voucher2: Code[20];


    // Start 
    // Copy Voucher No. From Gen. Journal Line to G/L Entry Table 81 -> 17
    [EventSubscriber(ObjectType::Table, 17, 'OnAfterCopyGLEntryFromGenJnlLine', '', false, false)]
    procedure OnAfterCopyGLEntryFromGenJnlLine_LT(VAR GLEntry: Record "G/L Entry"; VAR GenJournalLine: Record "Gen. Journal Line")
    begin
        GLEntry."Voucher No." := GenJournalLine."Voucher No.";
        GLEntry.Narration := GenJournalLine.Narration;
        GLEntry."Currency Code" := GenJournalLine."Currency Code";
        GLEntry."Amount From GJnl" := GenJournalLine.Amount;
        GLEntry."Currency Factor" := GenJournalLine."Currency Factor";
        GLEntry."Check Issued Date" := GenJournalLine."Check Issued Date";
        //02.11.2020
        GLEntry."Shortcut Dimension 1 Code" := GenJournalLine."Shortcut Dimension 1 Code";
        GLEntry."Shortcut Dimension 2 Code" := GenJournalLine."Shortcut Dimension 2 Code";
        //02.11.2020


    end;
    // Stop

    // Start 
    // Copy Voucher No. From Gen. Journal Line to Cust. Ledger Entry Table 81 -> 21
    [EventSubscriber(ObjectType::Table, 21, 'OnAfterCopyCustLedgerEntryFromGenJnlLine', '', false, false)]
    procedure OnAfterCopyCustLedgerEntryFromGenJnlLine(VAR CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        CustLedgerEntry."Voucher No." := GenJournalLine."Voucher No.";
        CustLedgerEntry.Narration := GenJournalLine."Voucher No.";
    end;
    // Stop

    // Start 
    // Copy Voucher No. From Gen. Journal Line to Vendor Ledger Entry Table 81 -> 25
    [EventSubscriber(ObjectType::Table, 25, 'OnAfterCopyVendLedgerEntryFromGenJnlLine', '', false, false)]
    procedure OnAfterCopyVendLedgerEntryFromGenJnlLine(VAR VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        VendorLedgerEntry."Voucher No." := GenJournalLine."Voucher No.";
        VendorLedgerEntry.Narration := GenJournalLine.Narration;
        VendorLedgerEntry."PO No." := GenJournalLine."PO No.";
    end;
    // Stop

    // Start 
    // Copy Voucher No. From Gen. Journal Line to VAT Entry Table 81 -> 254
    [EventSubscriber(ObjectType::Table, 254, 'OnAfterCopyFromGenJnlLine', '', false, false)]
    procedure OnAfterCopyFromGenJnlLine(VAR VATEntry: Record "VAT Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        VATEntry."Voucher No." := GenJournalLine."Voucher No.";
    end;
    // Stop

    // Start 
    // Copy Voucher No. From Gen. Journal Line to Bank Account Ledger Entry Table 81 -> 271
    [EventSubscriber(ObjectType::Table, 271, 'OnAfterCopyFromGenJnlLine', '', false, false)]
    procedure OnAfterCopyFromGenJnlLine_LT(VAR BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        BankAccountLedgerEntry."Voucher No." := GenJournalLine."Voucher No.";
        BankAccountLedgerEntry."Check Prepared Date" := GenJournalLine."Check Prepared Date";
        BankAccountLedgerEntry."Check Issued Date" := GenJournalLine."Check Issued Date";
        BankAccountLedgerEntry.Narration := GenJournalLine.Narration;
    end;
    // Stop


    // Start 
    // Copy Voucher No. From 
    [EventSubscriber(ObjectType::Table, 81, 'OnAfterCopyGenJnlLineFromCustLedgEntry', '', false, false)]
    procedure OnAfterCopyGenJnlLineFromCustLedgEntry(CustLedgerEntry: Record "Cust. Ledger Entry"; VAR GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine.VALIDATE("Voucher No.", CustLedgerEntry."Voucher No.");

    end;
    // Stop



    // Start 
    // Copy Voucher No. From 
    [EventSubscriber(ObjectType::Table, 382, 'OnAfterCopyFromVendLedgerEntry', '', false, false)]
    procedure OnAfterCopyFromVendLedgerEntry(VAR CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; VendorLedgerEntry: Record "Vendor Ledger Entry")

    begin
        CVLedgerEntryBuffer."Voucher No." := VendorLedgerEntry."Voucher No.";

        //CVLedgerEntryBuffer.ModifyAll("Voucher No.", VendorLedgerEntry."Voucher No.");
    end;
    // Stop

    // Start 
    // Copy Voucher No. From 
    [EventSubscriber(ObjectType::Table, 383, 'OnAfterCopyFromGenJnlLine', '', false, false)]
    procedure OnAfterCopyFromGenJnlLine_LT1(VAR DtldCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; GenJnlLine: Record "Gen. Journal Line")
    begin
        DtldCVLedgEntryBuffer."Voucher No." := GenJnlLine."Voucher No.";
        //DtldCVLedgEntryBuffer.ModifyAll("Voucher No.", GenJnlLine."Voucher No.");
    end;
    // Stop

    // Start 
    // Copy Voucher No. From 
    [EventSubscriber(ObjectType::Table, 25, 'OnAfterCopyVendLedgerEntryFromCVLedgEntryBuffer', '', false, false)]
    procedure OnAfterCopyVendLedgerEntryFromCVLedgEntryBuffer(VAR VendorLedgerEntry: Record "Vendor Ledger Entry"; CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer")
    begin
        VendorLedgerEntry."Voucher No." := CVLedgerEntryBuffer."Voucher No.";
        //DtldCVLedgEntryBuffer.ModifyAll("Voucher No.", GenJnlLine."Voucher No.");
    end;
    // Stop
    [EventSubscriber(ObjectType::Table, 271, 'OnAfterInsertEvent', '', false, false)]
    procedure OnAfterInsertBankLedger(var Rec: Record "Bank Account Ledger Entry")
    var
        CheckLedgEntry: Record "Check Ledger Entry";
    BEGIN
        CheckLedgEntry.RESET;
        CheckLedgEntry.SETCURRENTKEY("Bank Account No.", "Entry Status", "Check No.");
        CheckLedgEntry.SETRANGE("Bank Account No.", Rec."Bank Account No.");
        //CheckLedgEntry.SETRANGE("Entry Status", CheckLedgEntry."Entry Status"::Printed);
        CheckLedgEntry.SETRANGE("Check No.", Rec."Document No.");
        IF CheckLedgEntry.FindFirst() then
            repeat
                IF CheckLedgEntry."Voucher No." = '' THEN BEGIN
                    CheckLedgEntry."Voucher No." := Rec."Voucher No.";
                    CheckLedgEntry."Check Prepared Date" := Rec."Check Prepared Date";
                    CheckLedgEntry."Check Issued Date" := Rec."Check Issued Date";
                    CheckLedgEntry.Modify();
                END;
            until CheckLedgEntry.next = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, 367, 'OnFinancialVoidCheckOnBeforePostBalAccLine', '', false, false)]
    procedure OnFinancialVoidCheckOnBeforePostBalAccLine(VAR GenJournalLine: Record "Gen. Journal Line"; CheckLedgerEntry: Record "Check Ledger Entry")
    begin
        GenJournalLine."Voucher No." := CheckLedgerEntry."Voucher No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, 367, 'OnFinancialVoidCheckOnBeforePostVoidCheckLine', '', false, false)]
    procedure OnFinancialVoidCheckOnBeforePostVoidCheckLine(VAR GenJournalLine: Record "Gen. Journal Line")
    var
        CheckLedgEntry: Record "Check Ledger Entry";
    begin
        CheckLedgEntry.Reset();
        CheckLedgEntry.SetRange("Check No.", GenJournalLine."Document No.");
        IF CheckLedgEntry.FindFirst() THEN
            GenJournalLine."Voucher No." := CheckLedgEntry."Voucher No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, 227, 'OnBeforePostApplyVendLedgEntry', '', false, false)]
    procedure OnBeforePostApplyVendLedgEntry(VAR GenJournalLine: Record "Gen. Journal Line"; VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        GenJournalLine."Voucher No." := VendorLedgerEntry."Voucher No.";

    end;

    [EventSubscriber(ObjectType::Codeunit, 227, 'OnBeforePostUnApplyVendLedgEntry', '', false, false)]
    procedure OnBeforePostApplyUnVendLedgEntry(VAR GenJournalLine: Record "Gen. Journal Line"; VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        GenJournalLine."Voucher No." := VendorLedgerEntry."Voucher No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnBeforeInsertDtldVendLedgEntry', '', false, false)]
    procedure OnBeforeInsertDtldVendLedgEntry(VAR DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry"; GenJournalLine: Record "Gen. Journal Line"; DtldCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer")
    begin
        DtldVendLedgEntry."Voucher No." := GenJournalLine."Voucher No.";
    end;
    //

    //Too insert currency code from sales invoice to genjln line
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeDeleteAfterPosting', '', false, false)]
    local procedure OnBeforeDeleteAfterPosting(VAR SalesHeader: Record "Sales Header"; VAR SalesInvoiceHeader: Record "Sales Invoice Header"; VAR SalesCrMemoHeader: Record "Sales Cr.Memo Header"; VAR SkipDelete: Boolean; CommitIsSuppressed: Boolean)
    Var
        RecGlEntry: Record "G/L Entry";
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then begin
            Clear(RecGlEntry);
            RecGlEntry.SetRange("Document No.", SalesInvoiceHeader."No.");
            RecGlEntry.SetRange("Posting Date", SalesInvoiceHeader."Posting Date");
            if RecGlEntry.FindSet() then begin
                RecGlEntry.ModifyAll("Currency Code", SalesInvoiceHeader."Currency Code");
                RecGlEntry.ModifyAll("Currency Factor", SalesInvoiceHeader."Currency Factor");
            end;
        end else begin
            if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then begin
                Clear(RecGlEntry);
                RecGlEntry.SetRange("Document No.", SalesCrMemoHeader."No.");
                RecGlEntry.SetRange("Posting Date", SalesCrMemoHeader."Posting Date");
                if RecGlEntry.FindSet() then begin
                    RecGlEntry.ModifyAll("Currency Code", SalesCrMemoHeader."Currency Code");
                    RecGlEntry.ModifyAll("Currency Factor", SalesCrMemoHeader."Currency Factor");
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeDeleteAfterPosting', '', false, false)]
    local procedure OnBeforeDeleteAfterPostingPO(VAR PurchaseHeader: Record "Purchase Header"; VAR PurchInvHeader: Record "Purch. Inv. Header"; VAR PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; VAR SkipDelete: Boolean; CommitIsSupressed: Boolean)
    Var
        RecGlEntry: Record "G/L Entry";
    begin
        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice then begin
            Clear(RecGlEntry);
            RecGlEntry.SetRange("Document No.", PurchInvHeader."No.");
            RecGlEntry.SetRange("Posting Date", PurchInvHeader."Posting Date");
            if RecGlEntry.FindSet() then begin
                RecGlEntry.ModifyAll("Currency Code", PurchInvHeader."Currency Code");
                RecGlEntry.ModifyAll("Currency Factor", PurchInvHeader."Currency Factor");
            end;
        end else begin
            if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Credit Memo" then begin
                Clear(RecGlEntry);
                RecGlEntry.SetRange("Document No.", PurchCrMemoHdr."No.");
                RecGlEntry.SetRange("Posting Date", PurchCrMemoHdr."Posting Date");
                if RecGlEntry.FindSet() then begin
                    RecGlEntry.ModifyAll("Currency Code", PurchCrMemoHdr."Currency Code");
                    RecGlEntry.ModifyAll("Currency Factor", PurchCrMemoHdr."Currency Factor");
                end;
            end;
        end;
    end;
}
