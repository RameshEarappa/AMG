report 50408 "InterCompVoucher_Report"
{
    DefaultLayout = RDLC;
    //RDLCLayout = '50101_28_V2.rdl';
    Caption = 'INter Company Voucher Report';
    PreviewMode = PrintLayout;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("Gen. Journal Line"; "Gen. Journal Line")
        {
            DataItemTableView = SORTING("Line No.")
                                ORDER(Ascending);
            RequestFilterFields = "Document No.", "Journal Template Name";
            column(Issue_Date; FORMAT("Check Issued Date", 10, '<Day,2>/<Month,2>/<year,4>')) { }
            column(Posting_Date; FORMAT("Posting Date", 10, '<Day,2>/<Month,2>/<year,4>')) { }
            column(Currency_Code; CurrCode) { }
            column(Voucher_No; "Voucher No.") { }
            column(Credit_Amount; "Credit Amount") { }
            column(Narration; Narration) { }
            column(ReportName; ReportName) { }
            column(Journal_Template_Name; "Journal Template Name") { }
            column(Document_No_; "Document No.") { }
            column(Amount; Amount_2) { }
            column(Debit_Amount; Debit_Amount) { }
            column(Account_No_; "Account No.") { }
            column(Bal__Account_No_; "Bal. Account No.") { }
            column(BalAccDec; BalAccDec) { }
            column(AccDec; AccDec) { }
            column(Comp_Country; CompInfoRec.County) { }
            column(Comp_PoBox_No; CompInfoRec."Post Code") { }
            column(Comp_Logo; CompInfoRec.Picture) { }
            column(Comp_Name; CompInfoRec.Name) { }
            column(Comp_Add1; CompInfoRec.Address) { }
            column(Comp_Add2; CompInfoRec."Address 2") { }
            column(Comp_City; CompInfoRec.City) { }
            column(Comp_Phone; CompInfoRec."Phone No.") { }
            column(Comp_Phone2; CompInfoRec."Phone No. 2") { }
            column(Comp_Fax; CompInfoRec."Fax No.") { }
            column(Comp_mail; CompInfoRec."E-Mail") { }
            column(Comp_TRN; compInfoRec."VAT Registration No.") { }
            column(Currency_Factor; CurrFactor) { }
            column(AmtWord; AmtWord) { }
            column(UserName; UserName) { }
            column(Check_Printed; "Check Printed") { }
            trigger OnPreDataItem();
            begin

            eND;

            trigger OnAfterGetRecord();
            begin
                Clear(Amount_2);
                if "Currency Code" = '' then begin
                    GLSetup.Get();
                    CurrCode := GLSetup."LCY Code";
                end Else
                    CurrCode := "Currency Code";

                if "Currency Factor" <> 0 then
                    CurrFactor := 1 / "Currency Factor"
                else
                    CurrFactor := 0;
                If ("Bal. Account No." <> '') then
                    Debit_Amount := "Debit Amount"
                else
                    Debit_Amount := 0;
                If Amount < 0 then begin
                    //Debit_Amount := Amount;
                    Amount_2 := 0;
                end else
                    Amount_2 := Amount;
                If "Journal Template Name" = 'PAYMENTS' then
                    ReportName := 'PAYMENT VOUCHER'
                Else
                    If "Journal Template Name" = 'CASHRCPT' then
                        ReportName := 'RECEIPT VOUCHER'
                    Else
                        If "Journal Template Name" = 'GENERAL' then
                            ReportName := 'JOURNAL VOUCHER';

                Clear(AccDec);
                if "Account Type" = "Account Type"::"Bank Account" then begin
                    iF BankAccrec.Get("Account No.") then
                        AccDec := BankAccrec.Name;
                End;
                if "Account Type" = "Account Type"::Customer then begin
                    if CustRec.Get("Account No.") then
                        AccDec := CustRec.Name;
                End;
                if "Account Type" = "Account Type"::Employee then begin
                    if EmpRec.Get("Account No.") then
                        AccDec := EmpRec.FullName();
                End;
                if "Account Type" = "Account Type"::"Fixed Asset" then begin
                    if FaRec.Get("Account No.") then
                        AccDec := FaRec.Description
                End;
                if "Account Type" = "Account Type"::"G/L Account" then begin
                    If GL_rec.get("Account No.") then
                        AccDec := GL_rec.Name;
                End;
                if "Account Type" = "Account Type"::"IC Partner" then begin
                    if IC_Rec.Get("Account No.") then
                        AccDec := IC_Rec.Name
                end;
                if "Account Type" = "Account Type"::Vendor then begin
                    if VenRec.Get("Account No.") then
                        AccDec := VenRec.Name;
                END;
                Clear(BalAccDec);
                if "Bal. Account Type" = "Bal. Account Type"::"Bank Account" then begin
                    iF BankAccrec.Get("Bal. Account No.") then
                        BalAccDec := BankAccrec.Name;
                End;
                if "Bal. Account Type" = "Bal. Account Type"::Customer then begin
                    if CustRec.Get("Bal. Account No.") then
                        BalAccDec := CustRec.Name;
                End;
                if "Bal. Account Type" = "Bal. Account Type"::Employee then begin
                    if EmpRec.Get("Bal. Account No.") then
                        BalAccDec := EmpRec.FullName();
                End;
                if "Bal. Account Type" = "Bal. Account Type"::"Fixed Asset" then begin
                    if FaRec.Get("Bal. Account No.") then
                        BalAccDec := FaRec.Description
                End;
                if "Bal. Account Type" = "Bal. Account Type"::"G/L Account" then begin
                    If GL_rec.get("Bal. Account No.") then
                        BalAccDec := GL_rec.Name;
                End;
                if "Bal. Account Type" = "Bal. Account Type"::"IC Partner" then begin
                    if IC_Rec.Get("Bal. Account No.") then
                        BalAccDec := IC_Rec.Name
                end;
                if "Bal. Account Type" = "Bal. Account Type"::Vendor then begin
                    if VenRec.Get("Bal. Account No.") then
                        BalAccDec := VenRec.Name;
                END;
                Clear(AmtWord);
                IF Amount > 0 then begin
                    AmountTot += Amount;
                    CheckRep.FormatNoText(NoText, ABS(AmountTot), "Currency Code");
                    IF "Currency Code" <> '' THEN
                        AmtWord2 := "Currency Code" + ' ' + NoText[1]
                    ELSE
                        AmtWord2 := 'AED' + ' ' + NoText[1];
                    If AmtWord2 <> '' then
                        AmtWord := AmtWord2;
                End;
                If AmtWord2 <> '' then
                    AmtWord := AmtWord2;
            end;
        }
        dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
        {
            DataItemLinkReference = "Gen. Journal Line";
            DataItemLink = "Applies-to ID" = FIELD("Document No.");
            column(Entry_No_; Format("Document No.")) { }
            column(Applies_to_ID; "Applies-to ID") { }
            trigger OnPreDataItem()
            begin
                "Vendor Ledger Entry".Reset();
                "Vendor Ledger Entry".SetRange("Applies-to ID", "Gen. Journal Line"."Document No.");
                If "Vendor Ledger Entry".FindSet() then begin
                    "Vendor Ledger Entry".Reset();
                    "Vendor Ledger Entry".SetRange("Document No.", "Gen. Journal Line"."Applies-to Doc. No.");
                End;
            end;
        }
    }

    trigger OnPreReport();
    begin
        CompInfoRec.GET;
        CompInfoRec.CALCFIELDS(Picture);
        CheckRep.InitTextVariable;
        UserName := UserId;
    end;

    var
        CompInfoRec: Record "Company Information";
        CheckRep: Codeunit "Amount In Word LT";
        GlSetup: Record "General Ledger Setup";
        CurrCode: Code[20];
        BankAccrec: Record "Bank Account";
        AccDec: Text;
        BalAccDec: Text;
        EmpRec: Record Employee;
        CustRec: Record Customer;
        FaRec: Record "Fixed Asset";
        GL_rec: Record "G/L Account";
        IC_Rec: Record "IC Partner";
        VenRec: Record Vendor;
        VLErec: Record "Vendor Ledger Entry";
        CurrFactor: Decimal;
        AmtWord: Text;
        NoText: array[1] of Text;
        Rec2: Record "Gen. Journal Line";
        AmountTot: Decimal;
        UserName: Text;
        ReportName: Text;
        AmtWord2: Text;
        Voucher_No: Code[20];
        Debit_Amount: Decimal;
        Amount_2: Decimal;
}
