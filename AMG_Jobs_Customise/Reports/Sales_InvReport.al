report 50101 "Sales Invoice Report"
{
    // version MSBM
    DefaultLayout = RDLC;
    //RDLCLayout = '50101_28_V2.rdl';
    Caption = 'Sales Invoice';
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
            column(Sell_to_Customer_No_; "Sell-to Customer No.")
            { }
            column(Your_Reference; "Your Reference") { }
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
            column(Vend_PostCode; VendRec."Post Code")
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
            column(Invoice_Period; FORMAT("Invoice Period", 8, '<Day,2>/<Month,2>/<year,2>'))
            { }
            column(Currency_Code; CurrCode)
            { }
            column(Location_Code; "Location Code")
            { }
            column(Comp_Logo; CompInfoRec.Picture)
            { }
            column(Comp_Name; CompInfoRec.Name)
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
            column(Shortcut_Dimension_1_Code; "Shortcut Dimension 1 Code")
            { }
            column(Vessalname; Vessalname)
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
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                column(Contract_No; "Contract No")
                { }
                column(Line_Number; "Line Number")
                { }
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
                column(Cost_of_Revenue; "Cost of Revenue")
                { }
                column(Retention; Retention)
                { }
                column(SubTotal1; SubTotal1)
                { }
                column(SubTotal2; SubTotal3)
                { }
                column(SubTotal3; SubTotal3)
                { }
                column(TotSubTotal; TotSubTotal)
                { }
                column(Amount_Including_VAT; "Amount Including VAT")
                { }
                column(AmtVat; AmtVat)
                { }
                column(AmtWord; AmtWord)
                { }
                column(FaxArb; FaxArb)
                { }
                column(TelArb; TelArb)
                { }
                column(Blank; Blank)
                { }
                column(Type; Type1)
                { }
                column(TableVisb3; TableVisb3)
                { }
                column(TableVisb2; TableVisb2)
                { }
                column(TaxableAmt; TaxableAmt)
                { }
                column(WithHoldAmt; WithHoldAmt) { }
                column(WithHoldBool; WithHoldBool) { }
                column(Withholding; Withholding) { }
                column(Row_visb; Row_visb) { }
                trigger OnPreDataItem();
                begin
                    Clear(AmtVat);
                    CLEAR(SL_No);
                    CheckRep.InitTextVariable;
                    Clear(SubTotal1);
                    Clear(SubTotal2);
                    Clear(SubTotal3);
                    Clear(TotSubTotal);

                end;

                trigger OnAfterGetRecord();
                begin
                    if (Withholding = true) AND (("Cost of Revenue" = false) Or (Retention = false)) then
                        Row_visb := false
                    else
                        Row_visb := true;

                    Clear(SubTotal1);
                    SalInvRec2.Reset();
                    SalInvRec2.SetRange("Document No.", "Document No.");
                    SalInvRec2.SetRange("Cost of Revenue", false);
                    SalInvRec2.SetRange(Retention, false);
                    SalInvRec2.SetRange(Withholding, false);
                    if SalInvRec2.FindSet() then begin
                        repeat
                            SubTotal1 += SalInvRec2."Unit Price" * SalInvRec2.Quantity;
                        until SalInvRec2.Next() = 0;
                    End;
                    Clear(SubTotal2);
                    SalInvRec2.Reset();
                    SalInvRec2.SetRange("Document No.", "Document No.");
                    SalInvRec2.SetRange("Cost of Revenue", true);
                    SalInvRec2.SetRange(Retention, false);
                    SalInvRec2.SetRange(Withholding, false);
                    if SalInvRec2.FindSet() then begin
                        repeat
                            SubTotal2 += SalInvRec2."Unit Price" * SalInvRec2.Quantity;
                        until SalInvRec2.Next() = 0;
                        SubTotal4 := SubTotal2 + SubTotal1;
                        TableVisb2 := true;

                    End;
                    TaxableAmt := SubTotal1 + SubTotal2;
                    SalInvRec2.Reset();
                    SalInvRec2.SetRange("Document No.", "Document No.");
                    SalInvRec2.SetRange("Cost of Revenue", false);
                    SalInvRec2.SetRange(Retention, true);
                    SalInvRec2.SetRange(Withholding, false);
                    if SalInvRec2.FindSet() then begin
                        repeat
                            SubTotal3 += SalInvRec2."Unit Price" * SalInvRec2.Quantity;
                        until SalInvRec2.Next() = 0;
                        SubTotal5 := SubTotal3 + SubTotal2;
                        TableVisb3 := true;
                    End;
                    TotSubTotal := SubTotal1 + SubTotal2 + SubTotal3;
                    SalInvRec2.Reset();
                    SalInvRec2.SetRange("Document No.", "Document No.");
                    if SalInvRec2.FindFirst() then begin
                        repeat
                            TaxAmt += SalInvRec2."Amount Including VAT";
                        until SalInvRec2.Next() = 0;
                    end;
                    SalInvRec2.Reset();
                    SalInvRec2.SetRange("Document No.", "Document No.");
                    SalInvRec2.SetRange(Withholding, true);
                    if SalInvRec2.FindFirst() then begin
                        WithHoldAmt := SalInvRec2."Line Amount";
                        WithHoldBool := true;
                    end;
                    FinalTotAmt := TaxAmt - TotSubTotal;

                    If WithHoldBool = false then
                        FinalTotAmt1 := FinalTotAmt + TotSubTotal
                    else
                        FinalTotAmt1 := TotSubTotal + WithHoldAmt;



                    CheckRep.FormatNoText(NoText, ABS(FinalTotAmt1), CurrCode);
                    AmtWord := CurrCode + ' ' + NoText[1];
                    if ("Sales Invoice Line".Type <> "Sales Invoice Line".Type::" ") And ("Sales Invoice Line"."Cost of Revenue" = false) and ("Sales Invoice Line".Retention = false) then begin
                        LineNo += 1;
                        if LineNo <> 1 then
                            Type1 := true
                        else
                            Type1 := false;
                    end
                    Else
                        Type1 := false;


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
                end;

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
                if CustRec.Get("Bill-to Customer No.") then;
                If "Currency Code" = ' ' then begin
                    GLSetup.Get();
                    CurrCode := GLSetup."LCY Code"
                End Else
                    CurrCode := "Currency Code";
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
        TaxableAmt: Decimal;
        ContReion: Record "Country/Region";
        CompCount: Text;
        Cust_County: Text;
        WithHoldAmt: Decimal;
        WithHoldBool: Boolean;
        Row_visb: Boolean;
}