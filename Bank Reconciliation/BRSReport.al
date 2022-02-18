report 50196 "BRS Report"
{
    // Version       Ticket No.    Developer     Date
    // ------------------------------------------------
    // ABS.v.005      9322623     Sujith PS   19-Nov-2014
    DefaultLayout = RDLC;
    RDLCLayout = 'Bank Reconciliation\BRSReport.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Bank Account"; "Bank Account")
        {
            DataItemTableView = SORTING("No.")
                                ORDER(Ascending);
            RequestFilterFields = "No.";
            column(No_BankAccount; "Bank Account"."No.")
            {
            }
            column(Name_BankAccount; "Bank Account".Name)
            {
            }
            column(Bank_Account_No_; "Bank Account No.")
            {
            }
            column(Currency_Code; "Currency Code")
            {
            }
            column(CompInfo_Name; CompInfo.Name)
            {
            }
            column(CompInfo_Address; CompInfo.Address)
            {
            }
            column(CompInfo_Address2; CompInfo."Address 2")
            {
            }
            column(CompInfo_Picture; CompInfo.Picture)
            {
            }
            column(ReportName; ReportName)
            {
            }
            column(BankAccountNo; BankAccountNo)
            {
            }
            column(StatementNo; StatementNo)
            {
            }
            column(StatementDate; StatementDate)
            {
            }
            column(BankAccEndingBal; BankAccEndingBal)
            {
            }
            column(BankAccountName; BankAccountName)
            {
            }
            column(AsOnMonthYear; AsOnMonthYear)
            {
            }
            column(StatemenTEndBal; StatemenTEndBal)
            {
            }
            column(Preparedby; preparerid)
            {
            }
            column(Preparedbysign; Recsignature.image)
            {
            }
            column(Preparedbydate; PrepDate)
            {
            }
            column(Reviewedbydate; RevDate)
            {
            }
            column(Approvedbydate; AppDate)
            {
            }
            column(ReviewedBy; RecSig.image)
            {
            }
            column(ApprovedBy; RecSign.image)
            {
            }
            column(ReviewedByTitle; Usersetup.Title)
            {
            }
            column(PrepeatedbyTitle; UserSet.Title)
            {
            }
            column(PrepeatedbyDesig; UserSet.Designation)
            {
            }
            column(ApprovedByTitle; Recusersetup.Title)
            {
            }
            column(ApprovedbyUserid; Approverid)
            {
            }
            column(ApprovedbyDesignation; RecUsersetup.Designation)
            {
            }
            column(ReviewedByDesignation; Usersetup.Designation)
            {
            }
            column(GLAccNo; RecBankAccPosGrp."G/L Account No.")
            {
            }
            column(GLAccName; RecGL.Name)
            {
            }
            column(ReviewedbyUserId; Reviewerid)
            {
            }
            column(AmountsIn_Text; AmountsIn_Text)
            {
            }
            column(CurrencyCodeG; CurrencyCodeG)
            {
            }
            dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
            {
                DataItemLink = "Bank Account No." = FIELD("No.");
                DataItemTableView = SORTING("Entry No.")
                                    ORDER(Ascending)
                                    WHERE(Amount = FILTER(< 0),
                                          Reversed = FILTER(false),
                                          "Document No." = FILTER(<> 'BP/1718/2868|BP/1718/3192'));
                column(BankAccLedEntry_Amt; BankAccLedEntry_Amt)
                {
                }
                column(BankAccountNo_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Bank Account No.")
                {
                }
                column(PostingDate_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Posting Date")
                {
                }
                column(DocumentNo_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Entry No.")
                {
                }
                column(Amount_BankAccountLedgerEntry; "Bank Account Ledger Entry".Amount)
                {
                }
                column(ChequeNo_BankAccountLedgerEntry; 'Cheque No.')// "Bank Account Ledger Entry"."Cheque No.")
                {
                }
                column(ChequeDate_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Check Issued Date") //'Cheque Date')//"Bank Account Ledger Entry"."Cheque Date")
                {
                }
                column(Description_BankAccountLedgerEntry; "Bank Account Ledger Entry".Description)
                {
                }
                column(AmountLCY_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Amount (LCY)")
                {
                }
                column(DocumentNo; "Bank Account Ledger Entry"."Document No.")
                {
                }
                column(VoucherNo; "Bank Account Ledger Entry"."Voucher No.")
                {
                }
                column(Amount; "Bank Account Ledger Entry".Amount)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    GLSetup.Get;


                    BankAccountStatement.RESET;
                    BankAccountStatement.SETRANGE("Bank Account No.", "Bank Account No.");
                    BankAccountStatement.SETRANGE("Statement No.", "Statement No.");
                    IF BankAccountStatement.FINDFIRST THEN
                        IF NOT (StatementDate < BankAccountStatement."Statement Date") THEN
                            CurrReport.SKIP;

                    BankAccLedEntry_Amt := 0;
                    BankAccLedEntry.RESET;
                    BankAccLedEntry.SETRANGE("Document No.", "Document No.");
                    BankAccLedEntry.SETRANGE("Entry No.", "Entry No.");
                    BankAccLedEntry.SETRANGE("Bank Account No.", BankAccountNo);
                    BankAccLedEntry.SETFILTER("Statement No.", '<>%1', StatementNo);
                    BankAccLedEntry.SETFILTER("Posting Date", '<=%1', StatementDate);
                    IF BankAccLedEntry.FINDSET THEN
                        REPEAT
                            IF AmtsInLCY THEN
                                BankAccLedEntry_Amt += BankAccLedEntry."Amount (LCY)"
                            ELSE
                                BankAccLedEntry_Amt += BankAccLedEntry.Amount;
                        UNTIL BankAccLedEntry.NEXT = 0;

                    ApprovalEntries.Reset;
                    ApprovalEntries.SetCurrentKey("Sequence No.");
                    ApprovalEntries.SetRange("Document No.", "Bank Account"."No.");
                    if ApprovalEntries.findlast then;
                end;

                trigger OnPreDataItem()
                begin

                    SETRANGE("Bank Account No.", BankAccountNo);
                    SETFILTER("Statement No.", '<>%1', StatementNo);
                    SETFILTER("Posting Date", '<=%1', StatementDate);
                end;
            }
            dataitem("Bank Account Ledger Entry1"; "Bank Account Ledger Entry")
            {
                DataItemLink = "Bank Account No." = FIELD("No.");
                DataItemTableView = SORTING("Entry No.")
                                    ORDER(Ascending)
                                    WHERE(Amount = FILTER(> 0),
                                          Reversed = FILTER(false));
                column(BankAccountNo_BankAccountLedgerEntry1; "Bank Account Ledger Entry1"."Bank Account No.")
                {
                }
                column(PostingDate_BankAccountLedgerEntry1; "Bank Account Ledger Entry1"."Posting Date")
                {
                }
                column(DocumentNo_BankAccountLedgerEntry1; "Bank Account Ledger Entry1"."Entry No.")
                {
                }
                column(AmountLCY_BankAccountLedgerEntry1; "Bank Account Ledger Entry1"."Amount (LCY)")
                {
                }
                column(ChequeNo_BankAccountLedgerEntry1; "Voucher No.") //'Cheque No.')//"Bank Account Ledger Entry1"."Cheque No.")
                {
                }
                column(ChequeDate_BankAccountLedgerEntry1; "Bank Account Ledger Entry1"."Check Issued Date") //'Cheque Date')//"Bank Account Ledger Entry1"."Cheque Date")
                {
                }
                column(CustomerBankAccount_BankAccountLedgerEntry1; '')
                {
                }
                column(VendorBankAccount_BankAccountLedgerEntry1; '')
                {
                }
                column(Description_BankAccountLedgerEntry1; "Bank Account Ledger Entry1".Description)
                {
                }
                column(BankAccLedEntry_Amt1; BankAccLedEntry_Amt1)
                {
                }
                column(DocumentNo1; "Bank Account Ledger Entry1"."Document No.")
                {
                }
                trigger OnAfterGetRecord()
                begin

                    BankAccountStatement1.RESET;
                    BankAccountStatement1.SETFILTER("Bank Account No.", '%1', "Bank Account No.");
                    BankAccountStatement1.SETFILTER("Statement No.", '%1', "Statement No.");
                    IF BankAccountStatement1.FINDFIRST THEN BEGIN
                        IF NOT (StatementDate < BankAccountStatement1."Statement Date") THEN
                            CurrReport.SKIP;
                    END;

                    BankAccLedEntry_Amt1 := 0;
                    BankAccLedEntry.RESET;
                    BankAccLedEntry.SETRANGE("Bank Account No.", BankAccountNo);
                    BankAccLedEntry.SETRANGE("Entry No.", "Entry No.");
                    BankAccLedEntry.SETFILTER("Statement No.", '<>%1', StatementNo);
                    BankAccLedEntry.SETFILTER("Posting Date", '<=%1', StatementDate);
                    BankAccLedEntry.SETRANGE("Document No.", "Document No.");
                    IF BankAccLedEntry.FINDSET THEN
                        REPEAT
                            IF AmtsInLCY THEN
                                BankAccLedEntry_Amt1 += BankAccLedEntry."Amount (LCY)"
                            ELSE
                                BankAccLedEntry_Amt1 += BankAccLedEntry.Amount;
                        UNTIL BankAccLedEntry.NEXT = 0;
                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE("Bank Account No.", BankAccountNo);
                    SETFILTER("Posting Date", '<=%1', StatementDate);
                    SETFILTER("Statement No.", '<>%1', StatementNo);
                end;
            }

            trigger OnPreDataItem()
            var
            begin
                CompInfo.GET();
                CompInfo.CALCFIELDS(Picture);

                StatementDate := 0D;
                StatemenTEndBal := 0;
                BankAccountStatement.RESET;
                BankAccountStatement.SETRANGE("Bank Account No.", BankAccountNo);
                BankAccountStatement.SETRANGE("Statement No.", StatementNo);
                IF BankAccountStatement.FINDFIRST THEN BEGIN
                    StatementDate := BankAccountStatement."Statement Date";
                    StatemenTEndBal := BankAccountStatement."Statement Ending Balance";
                END;

                Usersetup.Reset;
                usersetup.SetRange("BRS Reviewer  ", True);
                if usersetup.findfirst then;

                RecUsersetup.Reset;
                Recusersetup.SetRange("BRS Approver", True);
                if Recusersetup.findfirst then;

                UserSet.Reset;
                UserSet.SetRange("User ID", BankAccountStatement."Prepared By");
                if UserSet.findfirst then;

                if BankAccountStatement."Reviewer id" <> '' then begin
                    Reviewerid := BankAccountStatement."Reviewer id";
                    RevDate := BankAccountStatement."Reviewed By Date";
                    Recsig.reset;
                    if recsig.GET(BankAccountStatement."Reviewer id") then;
                    RecSig.CalcFields(image);
                end else begin
                    Reviewerid := 'VIDYA';

                    Recsig.reset;
                    if recsig.GET('VIDYA') then;
                    RecSig.CalcFields(image);
                end;
                if BankAccountStatement."Approver id" <> '' then begin
                    Approverid := BankAccountStatement."Approver id";
                    Appdate := Bankaccountstatement."Approved By Date";
                    RecSign.Reset;
                    if recsign.GET(BankAccountStatement."Approver id") then;
                    RecSign.CalcFields(image);
                end else begin
                    Approverid := Bankaccountstatement."Approver id";
                    RecSign.Reset;
                    if recsign.GET('SOKLENG') then;
                    RecSign.CalcFields(image);
                end;
                if BankAccountStatement."Prepared By" <> '' then begin
                    Preparerid := BankAccountStatement."Prepared By";
                    PRepDate := BankAccountStatement."Prepared By Date";
                    RecSignature.Reset;
                    if recsignature.GET(BankAccountStatement."Prepared By") then;
                    RecSignature.CalcFields(image);
                end;

                BankAccEndingBal := 0;
                BankAccountName := '';
                AmountsIn_Text := '';
                BankAccount.RESET;
                BankAccount.SETRANGE("No.", BankAccountNo);
                BankAccount.SETRANGE("Date Filter", 0D, StatementDate);
                IF BankAccount.FINDFIRST THEN BEGIN
                    IF BankAccount."Currency Code" = '' THEN BEGIN
                        AmtsInLCY := TRUE;
                        AmountsIn_Text := 'Amounts in LCY.';
                    END ELSE
                        IF BankAccount."Currency Code" <> '' THEN BEGIN
                            AmtsInLCY := FALSE;
                            AmountsIn_Text := 'Amounts in ' + FORMAT(BankAccount."Currency Code");
                        END;

                    BankAccountName := BankAccount.Name;

                    BankAccount.CALCFIELDS("Balance (LCY)", "Net Change (LCY)", "Net Change");
                    IF AmtsInLCY THEN
                        BankAccEndingBal := BankAccount."Net Change (LCY)"
                    ELSE
                        BankAccEndingBal := BankAccount."Net Change";
                END;

                AsOnMonthYear := FORMAT(DATE2DMY(StatementDate, 2)) + ' ' + FORMAT(DATE2DMY(StatementDate, 3));

                SETRANGE("No.", BankAccountNo); //Bank No. Filter
            end;

            trigger OnAfterGetRecord()
            var
                GLsetupL: Record "General Ledger Setup";
            begin
                GLsetupL.Get();
                if "Bank Account"."Currency Code" = '' then
                    CurrencyCodeG := GLsetupL."LCY Code"
                else
                    CurrencyCodeG := "Bank Account"."Currency Code";

                RecBankAccPosGrp.Reset;
                RecBankAccPosGrp.SetRange(Code, "Bank Account"."Bank Acc. Posting Group");
                if RecBankAccPosGrp.FindFirst() then;

                RecGL.Reset;
                RecGL.SetRange("No.", RecBankAccPosGrp."G/L Account No.");
                if recgl.findfirst then;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Bank Account No."; BankAccountNo)
                {
                    TableRelation = "Bank Account";
                    ApplicationArea = All;
                    //Visible = false;
                }
                field("Statement No."; StatementNo)
                {
                    ApplicationArea = All;
                    // Visible = false;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        AmtsInLCY := TRUE;
    end;

    procedure SetValues(PBankAccNo: Code[20]; PStatementNo: Code[20])
    begin
        BankAccountNo := PBankAccNo;
        StatementNo := PStatementNo;
    end;

    var
        BankAccountStatementG: Record "Bank Account Statement";
        CurrencyCodeG: Text;
        StatementNo: Code[20];
        BankAccountStatement: Record 275;
        BankAccountNo: Code[20];
        StatementDate: Date;
        StatemenTEndBal: Decimal;
        CompInfo: Record 79;
        ReportName: Label 'Bank Account Reconciliation Report';
        AsOnMonthYear: Text;
        BankAccountStatement1: Record 275;
        BankAccount: Record 270;
        BankAccEndingBal: Decimal;
        BankAccountName: Text[50];
        BankAccLedEntry: Record 271;
        BankAccLedEntry_Amt: Decimal;
        BankAccLedEntry_Amt1: Decimal;
        AmtsInLCY: Boolean;
        AmountsIn_Text: Text[30];
        GLSetup: record "General ledger setup";
        ApprovalEntries: Record "Approval Entry";
        USersetup: Record "User Setup";
        RecUsersetup: Record "User Setup";
        RecSig: Record SignatureTable;
        RecSign: Record SignatureTable;
        RecBankAccPosGrp: Record "Bank Account Posting Group";
        RecGL: record "G/L Account";
        UserSet: Record "User Setup";
        RecSignature: record SignatureTable;
        Reviewerid: text[100];
        Approverid: text[100];
        Preparerid: Text[100];
        Appdate: Date;
        RevDate: date;
        PRepDate: date;
}

