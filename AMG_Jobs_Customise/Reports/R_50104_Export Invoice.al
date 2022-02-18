report 50104 "Export Invoice"
{
    DefaultLayout = RDLC;
    //RDLCLayout = '50101_28_V2.rdl';
    Caption = 'Export Invoice';
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
            column(InvNo; "No.")
            { }
            column(Bank_Account; "Bank Account")
            { }
            column(Sell_to_Customer_No_; "Sell-to Customer No.")
            { }
            column(Sell_to_Customer_Name; "Sell-to Customer Name")
            { }
            column(Sell_to_Address; "Sell-to Address")
            { }
            column(Sell_to_Address_2; "Sell-to Address 2")
            { }
            column(Bill_to_City; "Bill-to City")
            { }
            column(Bill_to_Post_Code; "Bill-to Post Code")
            { }
            column(Sell_to_Country_Region_Code; Cust_County)
            { }
            column(Sell_to_Contact; "Sell-to Contact")
            { }
            column(Cust_Phone; CustRec."Phone No.")
            { }
            column(Cust_Fax; CustRec."Fax No.")
            { }
            column(Cust_TRN; CustRec."VAT Registration No.")
            { }
            column(Doc_No; "No.")
            { }
            column(Posting_Date; FORMAT("Posting Date", 8, '<Day,2>/<Month,2>/<year,2>'))
            { }
            column(Invoice_Period; FORMAT("Invoice Period", 6, '<Month Text,3> <year,2>'))
            { }
            column(Currency_Code; CurrCode)
            { }
            column(Comp_Logo; CompInfoRec.Picture)
            { }
            column(Comp_Name; CompInfoRec.Name)
            { }
            column(Shortcut_Dimension_1_Code; "Shortcut Dimension 1 Code")
            { }
            column(Vessalname; Vessalname)
            { }
            column(Comp_Add1; CompInfoRec.Address)
            { }
            column(Comp_Add2; CompInfoRec."Address 2")
            { }
            column(Comp_City; CompInfoRec.City)
            { }
            column(Comp_Country; CompCount)
            { }
            column(Comp_Phone; CompInfoRec."Phone No.")
            { }
            column(Comp_Phone2; CompInfoRec."Phone No. 2")
            { }
            column(Comp_Fax; CompInfoRec."Fax No.")
            { }
            column(Comp_mail; CompInfoRec."E-Mail")
            { }
            column(Comp_TRN; compInfoRec."VAT Registration No.")
            { }
            column(Comp_PosCode; CompInfoRec."Post Code")
            { }
            column(Shortcut_Dimension_2_Code; "Shortcut Dimension 2 Code")
            { }
            //Arabic
            column(CompNameArb; CompNameArb)
            { }
            column(PosNoArb; PosNoArb)
            { }
            column(CityArb; CityArb)
            { }
            column(CountryArb; CountryArb)
            { }
            column(MailArb; MailArb)
            { }
            column(BankName; BankName)
            { }
            column(BankNo; BankNo)
            { }
            column(BankSwitCode; BankSwitCode)
            { }
            column(BankIbnNo; BankIbnNo)
            { }
            column(Currency_Factor; "Currency Factor")
            { }
            column(Division; Division)
            { }
            column(Your_Reference; "Your Reference")
            { }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                column(No_; "No.")
                { }
                column(Description; Description)
                { }
                column(Quantity; Quantity)
                { }
                column(Unit_Price; "Unit Price")
                { }
                column("Vat_Amount"; "AmtVat")
                { }
                column(AmtWord; AmtWord)
                { }
                column(FaxArb; FaxArb)
                { }
                column(TelArb; TelArb)
                { }
                column(Amount_Including_VAT; "Amount Including VAT")
                { }
                column(TotVAT_Per; "VAT %")
                { }
                column(Line_No_; "Line No.")
                { }
                column(SL_No; SL_No)
                { }
                column(VATPersantage; "VAT %")
                { }
                column(TotAmtIncVat; TotAmtIncVat)
                { }
                column(LocalCurr; LocalCurr)
                { }
                column(Type1; Type1)
                { }
                trigger OnPreDataItem();
                begin
                    CheckRep.InitTextVariable;
                end;

                trigger OnAfterGetRecord();
                begin
                    //SL_No += 1;
                    Clear(TotAmtIncVat);
                    SalInvRec2.Reset();
                    SalInvRec2.SetRange("Document No.", "Sales Invoice Line"."Document No.");
                    If SalInvRec2.FindSet() then begin
                        repeat
                            TotAmtIncVat += (SalInvRec2."Amount Including VAT");
                        Until SalInvRec2.Next() = 0;
                    End;
                    if "Sales Invoice Header"."Currency Factor" <> 0 then
                        LocalCurr := TotAmtIncVat * (1 / "Sales Invoice Header"."Currency Factor")
                    else
                        LocalCurr := TotalAmt;

                    //Message('%1', TotAmtIncVat);
                    CheckRep.FormatNoText(NoText, TotAmtIncVat, CurrCode);
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
                end;

            }
            trigger OnPreDataItem();
            begin
            eND;

            trigger OnAfterGetRecord();
            begin
                if "Currency Code" = '' then begin
                    GLSetup.Get();
                    //GLSetup.CalcFields("LCY Code");
                    CurrCode := GLSetup."LCY Code";
                end Else
                    CurrCode := "Currency Code";
                if BankAccRec.Get("Bank Account") then;
                BankNo := BankAccRec."No.";
                BankName := BankAccRec.name;
                BankIbnNo := BankAccRec.IBAN;
                BankSwitCode := BankAccRec."SWIFT Code";
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
                if ContReion.Get("Bill-to Country/Region Code") then
                    Cust_County := ContReion.Name;
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
        AmtWord: Text[100];
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
        BankAccRec: Record "Bank Account";
        BankNo: Code[50];
        BankSwitCode: Code[50];
        BankIbnNo: Code[50];
        TotAmtIncVat: Decimal;
        LocalCurr: Decimal;
        Division: Text;
        ContReion: Record "Country/Region";
        Cust_County: Text;
        CompCount: Text;
}
