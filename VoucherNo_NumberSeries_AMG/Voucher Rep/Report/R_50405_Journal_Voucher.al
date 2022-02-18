report 50405 "Journal Voucher"
{
    DefaultLayout = RDLC;
    //RDLCLayout = '50101_28_V2.rdl';
    Caption = 'Voucher Report';
    PreviewMode = PrintLayout;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {

            DataItemTableView = ORDER(descending) WHERE("Source Code" = FILTER('GENJNL' | 'REVERSAL'));
            RequestFilterFields = "Voucher No.", "Document No.";//, "Journal Template Name";
            column(Posting_Date; FORMAT("Posting Date", 8, '<Day,2>/<Month,2>/<year,2>')) { }
            column(Currency_Code; "Currency Code") { }
            column(Voucher_No; "Voucher No.") { }
            column(Narration; Narration) { }
            column(G_L_Account_No_; "G/L Account No.") { }
            column(G_L_Account_Name; "G/L Account Name")
            {

            }
            column(ReportName; ReportName) { }
            //column(Journal_Template_Name; "Journal Template Name") { }
            column(Document_No_; "Document No.") { }
            column(Amount; CalcuatedAmount)//"Amount From GJnl") 
            { }
            column(Amount3; Amount3) { }
            //column(Amount_2; Amount) { }
            column(Amounts; Amount) { }
            column(Credit_Amount; "Credit Amount") { }
            column(Debit_Amount; "Debit Amount") { }
            column(Account_No_; AccNo) { }
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
            column(AmtWord2; AmtWord2) { }
            column(UserName; UserName) { }
            column(Amount_2; Amount_2) { }
            column(wholepart; wholepart) { }
            column(DecPart; DecPart) { }
            column(EntryNo; "Entry No.") { }
            column(External_Document_No_; "External Document No.") { }
            column(Check_Issued_Date; "Check Issued Date") { }
            column(Global_Dimension_1_Code; "Global Dimension 1 Code") { }


            trigger OnPreDataItem();
            begin
            eND;

            trigger OnAfterGetRecord();
            begin
                CalcFields("G/L Account Name");
                Clear(CalcuatedAmount);
                if ("Currency Code" <> '') AND ("Currency Factor" <> 0) then begin
                    CalcuatedAmount := Amount / (1 / "Currency Factor");
                end else begin
                    CalcuatedAmount := Amount;
                end;
                /*if "Currency Code" = '' then begin
                    GLSetup.Get();
                    CurrCode := GLSetup."LCY Code";
                end Else
                    CurrCode := "Currency Code";

                if "Currency Factor" <> 0 then
                    CurrFactor := 1 / "Currency Factor"
                else
                    CurrFactor := 0;*/
                /* If "Bal. Account No." <> '' then
                     Debit_Amount := "Debit Amount"
                 else
                     Debit_Amount := 0;*/

                Clear(Amount_2);
                If Amount < 0 then begin
                    Amount_2 := 0;
                END else begin
                    Amount_2 := CalcuatedAmount;//"Amount From GJnl";

                END;
                Amount3 := "Debit Amount";
                /* If "Journal Template Name" = 'PAYMENT' then
                     ReportName := 'PAYMENT VOUCHER'
                 Else
                     If "Journal Template Name" = 'CASHRCPT' then
                         ReportName := 'RECEIPT VOUCHER'
                     Else
                         If "Journal Template Name" = 'GENERAL' then
                             ReportName := 'JOURNAL VOUCHER';
 */
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
                    AmountTot += CalcuatedAmount;//"Amount From GJnl";
                    CheckRep.FormatNoText(NoText, ABS(AmountTot), "Currency Code");
                    IF "Currency Code" <> '' THEN
                        AmtWord2 := "Currency Code" + ' ' + NoText[1]
                    ELSE
                        AmtWord2 := 'AED' + ' ' + NoText[1];
                    If AmtWord2 <> '' then
                        AmtWord := AmtWord2;
                End;
                //End;
            end;

        }
        dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
        {
            DataItemLinkReference = "G/L Entry";
            DataItemLink = "Applies-to ID" = FIELD("Document No.");
            column(Entry_No_; Format("Document No.")) { }
            column(Applies_to_ID; "Applies-to ID") { }


            trigger OnPreDataItem()
            begin
                "Vendor Ledger Entry".Reset();
                "Vendor Ledger Entry".SetRange("Applies-to ID", "G/L Entry"."Document No.");
                If "Vendor Ledger Entry".FindSet() then; //begin
                                                         // "Vendor Ledger Entry".Reset();
                                                         //"Vendor Ledger Entry".SetRange("Document No.", "G/L Entry"."Applies-to Doc. No.");

            End;
            //  end;
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
        NoText1: array[1] of Text;
        Rec2: Record "Gen. Journal Line";
        AmountTot: Decimal;
        UserName: Text;
        ReportName: Text;

        AmtWord2: Text;
        Voucher_No: Code[20];
        Debit_Amount: Decimal;
        Amount_2: Decimal;
        AmountInAED: Decimal;
        wholepart: Integer;
        DecPart: Integer;
        Amount3: Decimal;
        AccNo: Code[20];
        CalcuatedAmount: Decimal;

}
