report 50411 "Posted Cash Voucher_Repor"
{
    DefaultLayout = RDLC;
    //RDLCLayout = '50101_28_V2.rdl';
    Caption = 'Cash Voucher Report';
    PreviewMode = PrintLayout;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            DataItemTableView = SORTING("Document No.") ORDER(Ascending);
            RequestFilterFields = "Document No.";
            column(Posting_Date; FORMAT("Posting Date", 8, '<Day,2>/<Month,2>/<year,2>')) { }
            column(Currency_Code; CurrCode) { }
            column(Voucher_No; "Document No.") { }
            column(Credit_Amount; "Credit Amount") { }
            column(Narration; Narration) { }
            column(ReportName; ReportName) { }
            // column(Journal_Template_Name; "Journal Template Name") { }
            column(CheckNo; "External Document No.") { }
            column(Org_Amt; Org_Amt) { }
            column(Check_Issued_Date; "Check Issued Date") { }
            //column(Amount; Amount) { } LCY going wrong //Lt_31Mar20
            column(Amount; Curr_Amount) { }
            column(Amounts; Amount_2) { }
            column(Debit_Amount; Debit_Amount) { }
            column(Account_No_; Ac_Nom) { }
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
            column(PaymentMod; PaymentMod) { }
            column(UserName; UserName) { }
            // column(Check_Printed; "Check Printed") { }

            trigger OnPreDataItem();
            begin

            eND;

            trigger OnAfterGetRecord();
            begin
                //Lt_31Mar20
                Clear(Curr_Amount);
                If "Currency Factor" <> 0 then
                    Curr_Amount := (1 / "Currency Factor") * Amount
                else
                    Curr_Amount := Amount;
                //Lt_31Mar20
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
                    Org_Amt := 0
                end else begin
                    Amount_2 := Curr_Amount;
                    Org_Amt := Amount;
                End;


                if "Journal Batch Name" = 'TT' then
                    PaymentMod := 'TT'
                else
                    IF "Journal Batch Name" = 'BR' then
                        PaymentMod := 'Cheque'
                    Else
                        If "Journal Batch Name" = 'CR' then
                            PaymentMod := 'Cash';

                /*   If "Journal Template Name" = 'PAYMENT' then
                       ReportName := 'PAYMENT VOUCHER'
                   Else
                       If "Journal Template Name" = 'CASH RCPT' then
                           ReportName := 'RECEIPT VOUCHER'
                       Else
                           If "Journal Template Name" = 'GENERAL' then
                               ReportName := 'JOURNAL VOUCHER';*/
                Clear(AccNo);
                IF "Source No." = '' THEN
                    AccNo := "G/L Account No."
                else
                    AccNo := "Source No.";
                Clear(AccDec);

                if "Source Type" = "Source Type"::"Bank Account" then begin
                    iF BankAccrec.Get(AccNo) then
                        AccDec := BankAccrec.Name;
                End;
                if "Source Type" = "Source Type"::Customer then begin
                    if CustRec.Get(AccNo) then
                        AccDec := CustRec.Name;
                End;
                if "Source Type" = "Source Type"::Employee then begin
                    if EmpRec.Get(AccNo) then
                        AccDec := EmpRec.FullName();
                End;
                if "Source Type" = "Source Type"::"Fixed Asset" then begin
                    if FaRec.Get(AccNo) then
                        AccDec := FaRec.Description
                End;
                if "Source Type" = "Source Type"::" " then begin
                    If GL_rec.get(AccNo) then
                        AccDec := GL_rec.Name;
                End;
                /*if "Source Type" = "Source Type"::"IC Partner" then begin
                    if IC_Rec.Get("Source No.") then
                        AccDec := IC_Rec.Name
                end;*/
                if "Source Type" = "Source Type"::Vendor then begin
                    if VenRec.Get(AccNo) then
                        AccDec := VenRec.Name;
                END;
                IF "Source No." <> '' then
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
                Clear(AmountTot);
                glRec2.Reset();
                glRec2.SetRange("Document No.", "Document No.");
                glRec2.SetFilter(Amount, '> %1', 0);
                If glRec2.FindSet() then begin
                    repeat
                        AmountTot += glRec2.Amount;
                    Until glRec2.Next() = 0;
                    If glRec2."Currency Factor" <> 0 then
                        AmountTot := 1 / glRec2."Currency Factor" * AmountTot;
                end;
                Clear(AmtWord);
                Clear(AmtWord);
                IF Amount > 0 then begin
                    //AmountTot += Amount;
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
                If "Source No." <> '' then
                    Ac_Nom := "Source No."
                Else
                    Ac_Nom := "G/L Account No.";
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
        PaymentMod: Text;
        Ac_Nom: Code[50];
        AccNo: code[50];
        glRec2: Record "G/L Entry";
        Curr_Amount: Decimal;
        Org_Amt: Decimal;
}
