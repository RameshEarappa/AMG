report 50129 "SalInvExcWitholdingTax"
{

    DefaultLayout = RDLC;
    //RDLCLayout = '50101_28_V2.rdl';
    Caption = 'Sales Invoice Excluding Withholding Tax';
    PreviewMode = PrintLayout;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.")
                                ORDER(Ascending);
            RequestFilterFields = "No.", "Sell-to Customer No.";
            column(InvNo; "No.") { }
            column(Due_Date; "Due Date") { }
            column(Payment_Terms_Code; "Payment Terms Code") { }
            column(Bank_Account; "Bank Account") { }
            column(External_Document_No_; "External Document No.") { }
            column(Sell_to_Customer_No_; "Sell-to Customer No.") { }
            column(Sell_to_Customer_Name; Cust_Name) { }
            column(Sell_to_Address; CustAdd) { }
            column(Sell_to_Address_2; CustAdd2) { }
            column(Shortcut_Dimension_1_Code; "Shortcut Dimension 1 Code") { }
            column(Bill_to_City; Cust_City) { }
            column(Bill_to_Post_Code; Cust_PoCod) { }
            column(Sell_to_Country_Region_Code; Cust_County) { }
            column(Sell_to_Contact; CustContact) { }
            column(Contact; CustRec.Contact) { }
            column(Cust_Phone; CustRec."Phone No.") { }
            column(Cust_Fax; CustRec."Fax No.") { }
            column(Cust_TRN; CustRec."VAT Registration No.") { }
            column(Doc_No; "No.") { }
            column(Posting_Date; FORMAT("Posting Date", 10, '<Day,2>/<Month,2>/2<year,3>')) { }
            column(Invoice_Period; FORMAT("Invoice Period", 8, '<Month Text,3> 20<year,2>')) { }
            column(Currency_Code; CurrCode) { }
            column(Comp_Logo; CompInfoRec.Picture) { }
            column(Comp_Name; CompInfoRec.Name) { }
            column(Comp_Add1; CompInfoRec.Address) { }
            column(Comp_Add2; CompInfoRec."Address 2") { }
            column(Comp_City; CompInfoRec.City) { }
            column(Comp_Country; CompCount) { }
            column(Comp_Phone; CompInfoRec."Phone No.") { }
            column(Comp_Phone2; CompInfoRec."Phone No. 2") { }
            column(Comp_Fax; CompInfoRec."Fax No.") { }
            column(Comp_mail; CompInfoRec."E-Mail") { }
            column(compHomepage; compInfoRec."Home Page") { }
            column(Comp_TRN; compInfoRec."VAT Registration No.") { }
            column(SD3; SD3) { }
            column(Comp_PosCode; CompInfoRec."Post Code") { }
            column(Shortcut_Dimension_2_Code; "Shortcut Dimension 2 Code") { }
            column(Division; Division) { }
            //Arabic
            column(CompNameArb; CompNameArb) { }
            column(PosNoArb; PosNoArb) { }
            column(CityArb; CityArb) { }
            column(CountryArb; CountryArb) { }
            column(MailArb; MailArb) { }
            column(BankName; BankName) { }
            column(BankAdd; BankAdd) { }
            column(CB_BankAdd; CB_BankAdd) { }
            column(BankNo; BankNo) { }
            column(BankSwitCode; BankSwitCode) { }
            column(BankIbnNo; BankIbnNo) { }
            column(Your_Reference; "Your Reference") { }
            column(Currency_Factor; Currency_Factor) { }
            column(Vessalname; Vessalname) { }
            column(Corresponding_Bank; CB_BankName) { }
            column(Corresponding_Bank_SWIFT_Code; CB_SwitCode) { }
            column(Pre_Assigned_No_; "Pre-Assigned No.") { }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = where(Hide = Const(false));
                column(No_; "No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(Unit_Price; V_UnitPrice) { }
                column("Vat_Amount"; "AmtVat") { }
                column(AmtWord; AmtWord) { }
                column(FaxArb; FaxArb) { }
                column(TelArb; TelArb) { }
                column(Amount_Including_VAT; AMT_IncVat) { }
                column(TotVAT_Per; "VAT %") { }
                column(Line_No_; "Line No.") { }
                column(SL_No; SL_No) { }
                column(VATPersantage; "VAT %") { }
                column(TotAmtIncVat; TotAmtIncVat) { }
                column(LocalCurr; LocalCurr) { }
                column(Type1; Type1) { }
                column(Type; Type) { }
                column(From_Date; FromDateTime) { }
                column(To_Date; ToDateTime) { }
                column(LineNo; LineNo) { }
                column(TaxAmt; TaxAmt2) { }
                column(Type_Sno; Type) { }
                column(S_No; S_No) { }
                column(TotLineAmt_; TotLineAmt) { }
                column(DivQty_; DivQty) { }
                column(ResultTot_; ResultTot) { }
                trigger OnPreDataItem();
                begin
                    CheckRep.InitTextVariable;
                end;

                trigger OnAfterGetRecord();
                begin
                    If Type <> Type::" " then
                        S_No += 1;
                    FromDateTime := '';
                    ToDateTime := '';
                    IF "From Date" <> 0D THEN
                        FromDateTime := FORMAT("From Date", 0, '<Day,2>/<Month,2>/<year4>') + ' - ' + FORMAT("From Time", 5, '<Hours24>.<Minutes,2>') + ' HRS';
                    IF "To Date" <> 0D THEN
                        ToDateTime := FORMAT("To Date", 0, '<Day,2>/<Month,2>/<year4>') + ' - ' + FORMAT("To Time", 5, '<Hours24>.<Minutes,2>') + ' HRS';

                    Clear(AMT_IncVat);
                    If "Withholding Tax" <> 0 then
                        AMT_IncVat := "Withholding Tax" + "Amount Including VAT"

                    Else
                        AMT_IncVat := "Amount Including VAT";
                    Clear(AMT_IncVat2);
                    If "Withholding Tax" <> 0 then
                        AMT_IncVat2 := "Withholding Tax" + "Amount Including VAT"

                    Else
                        AMT_IncVat2 := "Amount Including VAT";
                    Clear(V_UnitPrice);

                    if "Withholding Tax" <> 0 then begin
                        If Quantity <> 0 then
                            V_UnitPrice := AMT_IncVat2 / Quantity
                        Else
                            V_UnitPrice := 0;


                    end else
                        V_UnitPrice := "Unit Price";
                    Clear(TotAmtIncVat);
                    SalInvRec2.Reset();
                    SalInvRec2.SetRange("Document No.", "Sales Invoice Line"."Document No.");
                    If SalInvRec2.FindSet() then begin
                        repeat
                            IF SalInvRec2."Withholding Tax" <> 0 then
                                TotAmtIncVat += (AMT_IncVat + "Withholding Tax")
                            else
                                TotAmtIncVat += AMT_IncVat
                        Until SalInvRec2.Next() = 0;
                    End;
                    if "Sales Invoice Header"."Currency Factor" <> 0 then
                        LocalCurr := TotAmtIncVat * (1 / "Sales Invoice Header"."Currency Factor")
                    else
                        LocalCurr := TotalAmt;
                    Amt_Tot_Word += AMT_IncVat;
                    //Message('%1', TotAmtIncVat);
                    Clear(TotLineAmt);
                    LineRec2.Reset();
                    LineRec2.SetRange("Document No.", "Document No.");
                    If LineRec2.FindSet() then begin
                        repeat
                            TotLineAmt += LineRec2."Line Amount";
                        until LineRec2.Next() = 0;
                    end;
                    Clear(DivQty);
                    LineRec2.Reset();
                    LineRec2.SetRange("Document No.", "Document No.");
                    LineRec2.SetRange(Hide, false);
                    LineRec2.SetFilter(Type, '<> %1', LineRec2.Type::" ");
                    If LineRec2.FindFirst() then
                        DivQty := LineRec2.Quantity;
                    Clear(ResultTot);
                    IF DivQty <> 0 then
                        ResultTot := TotLineAmt / DivQty;
                    CheckRep.FormatNoText(NoText, ResultTot * DivQty, CurrCode);
                    AmtWord := CurrCode + ' ' + NoText[1];
                    if ("Sales Invoice Line".Type <> "Sales Invoice Line".Type::" ") then begin
                        SL_No += 1;
                        if SL_No <> 1 then
                            Type1 := true
                        else
                            Type1 := false;
                    end
                    Else
                        Type1 := false;
                    if Vat_Per <> 0 then begin
                        Vat_Per := "VAT %";
                        If (Vat_Per = "VAT %") then
                            Vat_Per := "VAT %"
                        else
                            Vat_Per := 0;
                    end;
                    If "Withholding Tax" = 0 then begin
                        TaxAmt2 := "Amount Including VAT" - "Line Amount";
                    end else
                        TaxAmt2 := 0;

                    //Message('Amt Inc Vat%1- %1 \Line Amount %2', "Amount Including VAT", "Line Amount");
                end;

            }
            trigger OnPreDataItem();
            begin
            eND;

            trigger OnAfterGetRecord();
            begin
                If ("Ship-to Code" <> ' ') then begin
                    Cust_Name := "Ship-to Name";
                    CustAdd := "Ship-to Address";
                    CustAdd2 := "Ship-to Address 2";
                    Cust_City := "Ship-to City";
                    Cust_PoCod := "Ship-to Post Code";
                    Cust_Country_Region_Code := "Ship-to Country/Region Code";
                    CustContact := "Ship-to Contact";
                End else begin
                    Cust_Name := "Sell-to Customer Name";
                    CustAdd := "Sell-to Address";
                    CustAdd2 := "Sell-to Address 2";
                    Cust_City := "Sell-to City";
                    Cust_PoCod := "Sell-to Post Code";
                    Cust_Country_Region_Code := "Sell-to Country/Region Code";
                    CustContact := "Sell-to Contact";
                End;
                if "Currency Code" = '' then begin
                    GLSetup.Get();
                    //GLSetup.CalcFields("LCY Code");
                    CurrCode := GLSetup."LCY Code";
                end Else
                    CurrCode := "Currency Code";

                if BankAccRec.Get("Bank Account") then begin
                    BankNo := BankAccRec."Bank Account No.";
                    BankName := BankAccRec.name;
                    BankIbnNo := BankAccRec.IBAN;
                    BankSwitCode := BankAccRec."SWIFT Code";
                    BankAdd := BankAccRec.Address;
                End;
                if CustRec.Get("Sell-to Customer No.") then;
                if ArabRec.Get('Company Name') then
                    CompNameArb := ArabRec."Arabic description";
                if ArabRec.Get('P O No.') then
                    PosNoArb := ArabRec."Arabic description";
                IF ArabRec.Get('City') then
                    CityArb := ArabRec."Arabic description";
                IF ArabRec.Get('Country') then
                    CountryArb := ArabRec."Arabic description";
                IF ArabRec.Get('Email') then
                    MailArb := ArabRec."Arabic description";
                if ArabRec.get('Tel') then
                    TelArb := ArabRec."Arabic description";
                if ArabRec.get('Fax') then
                    FaxArb := ArabRec."Arabic description";
                DimRec.Reset();
                DimRec.SetRange(Code, "Shortcut Dimension 1 Code");
                IF DimRec.FindFirst() then
                    Vessalname := DimRec.Name;
                DimRec.Reset();
                DimRec.SetRange(Code, "Shortcut Dimension 2 Code");
                IF DimRec.FindFirst() then
                    Division := DimRec.Name;

                IF ContReion.get(CompInfoRec."Country/Region Code") then
                    CompCount := ContReion.Name;
                if ContReion.Get(Cust_Country_Region_Code) then
                    Cust_County := ContReion.Name;
                IF "Currency Factor" <> 0 then begin
                    Currency_Factor := 1 / "Currency Factor"
                End else begin
                    Currency_Factor := 0
                end;
                If BankAccRec.Get("Corresponding Bank") then begin
                    CB_SwitCode := BankAccRec."SWIFT Code";
                    CB_BankName := BankAccRec.Name;
                    CB_BankAdd := BankAccRec.Address;
                End;
                If GLSetup.get() then
                    // SD3 := GLSetup."Shortcut Dimension 3 Code";
                    DimSetEntRec2.Reset();
                DimSetEntRec2.SetRange(DimSetEntRec2."Dimension set ID", "Dimension Set ID");
                DimSetEntRec2.SetRange(DimSetEntRec2."Dimension Code", GLSetup."Shortcut Dimension 3 Code");
                if DimSetEntRec2.FindFirst() then begin
                    DimSetEntRec2.CalcFields("Dimension Value Name");
                    // ProjectName := DimSetEntRec2."Dimension Value Name";
                    SD3 := DimSetEntRec2."Dimension Value Code";
                End;


            end;

        }

    }
    trigger OnPreReport();
    begin
        CompInfoRec.GET;
        CompInfoRec.CALCFIELDS(Picture);
    end;

    var
        CompInfoRec: Record "Company Information";
        ItemRec: Record Item;
        VendRec: Record Vendor;
        SL_No: Integer;
        TotalAmt: Decimal;
        CheckRep: Codeunit "Amount In Word LT";
        NoText: array[1] of Text;
        AmtWord: Text;
        AmtVat: Decimal;
        CustRec: Record Customer;
        ROE: Decimal;
        CurrCode: Code[10];
        ArabRec: Record "Arabic description";
        CompNameArb: Text;
        PosNoArb: Text;
        CityArb: Text;
        CountryArb: Text;
        MailArb: Text;
        TelArb: Text;
        FaxArb: Text;
        SubTotal1: Decimal;
        SubTotal2: Decimal;
        SubTotal3: Decimal;
        SubTotal4: Decimal;
        SubTotal5: Decimal;
        TotSubTotal: Decimal;
        SalInvRec2: Record "Sales Invoice Line";
        TaxAmt: Decimal;
        FinalTotAmt: Decimal;
        FinalTotAmt1: Decimal;
        GLSetup: Record "General Ledger Setup";
        LineNo: Integer;
        Blank: Boolean;
        Type1: Boolean;
        DimRec: Record "Dimension Value";
        Vessalname: Text;
        TableVisb2: Boolean;
        TableVisb3: Boolean;
        AmtIncVAT: Decimal;
        TaxableAmt: Decimal;
        NetAmount: Decimal;
        Vat_Per: Integer;
        BankName: Text;
        BankAdd: Text;
        BankAccRec: Record "Bank Account";
        BankNo: Code[50];
        BankSwitCode: Code[50];
        BankIbnNo: Code[50];
        Division: Text;
        TotAmtIncVat: Decimal;
        LocalCurr: Decimal;
        ContReion: Record "Country/Region";
        CompCount: Text;
        AMT_IncVat: Decimal;
        AMT_IncVat2: Decimal;
        Cust_County: Text;
        V_UnitPrice: Decimal;
        Currency_Factor: Decimal;
        TaxAmt2: Decimal;
        FromDateTime: Text[100];
        ToDateTime: Text[100];
        SD3: Code[50];
        Amt_Tot_Word: Decimal;
        CB_SwitCode: Code[20];
        CB_BankName: Text;
        BankAcRec: Record "Bank Account";
        CB_BankAdd: Text;
        CustName: Text;
        CustAdd: text;
        CustAdd2: Text;
        Cust_Country_Region_Code: Text;
        Cust_City: Text;
        Cust_PoCod: text;
        CustContact: Text;
        S_No: Integer;
        DimSetEntRec2: Record "Dimension Set Entry";
        LineRec2: Record "Sales Invoice Line";
        TotLineAmt: Decimal;
        DivQty: Decimal;
        ResultTot: Decimal;
        Cust_Name: Text;

}
