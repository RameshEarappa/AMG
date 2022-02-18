report 50109 "Sales Quote"
{
    // version MSBM
    DefaultLayout = RDLC;
    //RDLCLayout = '50101_28_V2.rdl';
    Caption = 'Sales Quote';
    PreviewMode = PrintLayout;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING("No.")
                                ORDER(Ascending);
            RequestFilterFields = "No.";
            column(InvNo; "No.") { }
            column(Sell_to_Customer_No_; "Sell-to Customer No.") { }
            column(Your_Reference; "Your Reference") { }
            column(Sell_to_Customer_Name; To_Customer_Name) { }
            column(Sell_to_Contact; "Sell-to Contact") { }
            column(Vessalname; Vessalname) { }
            column(Cust_TRN; CustRec."VAT Registration No.") { }
            column(No__of_Archived_Versions; "No. of Archived Versions") { }
            column(Doc_Date; FORMAT("Document Date", 8, '<Day,2>/<Month,2>/<year,2>')) { }
            //column(Invoice_Period; FORMAT("Invoice Period", 8, '<Day,2>/<Month,2>/<year,2>')) { }
            column(Currency_Code; CurrCode) { }
            column(Exclusion; Exclusion) { }
            column(Payment_Terms_Code; "Payment Terms Code") { }
            column(Validity; Validity) { }
            column(Location; Location) { }
            column(Client_Location; "Client Location") { }
            column(Location_Code; "Location Code") { }
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
            column(Comp_TRN; compInfoRec."VAT Registration No.") { }
            column(Comp_PosCode; CompInfoRec."Post Code") { }
            column(Shortcut_Dimension_1_Code; "Shortcut Dimension 1 Code") { }
            column(ScopeofWork; ScopeofWork) { }
            column(Completion; Completion) { }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                column(Document_No_; "Document No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(Unit_Price; "Unit Price") { }
                column(Total_Line; Total_Line) { }
                column(SlNo; SlNo) { }
                column(LineGap; LineGap) { }
                column(Bold; Bold) { }
                column(Line_Amount; "Line Amount") { }
                column(Amount_Including_VAT; "Amount Including VAT") { }
                column(Underline; Underline) { }
                column(TotVatAmt; TotVatAmt) { }
                trigger OnPreDataItem();
                begin
                    Clear(TotVatAmt);
                end;

                trigger OnAfterGetRecord();
                begin
                    Total_Line := Quantity * "Unit Price";

                    TotVatAmt := "Amount Including VAT" - "Line Amount";
                    /* If Type = Type::" " then begin
                         TypeLoop += 1;
                         If TypeLoop = 1 then
                             SlNo += 1
                         Else
                             Clear(TypeLoop);
                     end;*/
                    /*LineGap := false;
                    If Type <> type::" " then begin
                        SlNo += 1;
                        iF SlNo <> 1 then
                            LineGap := true
                    END;*/
                END;
            }
            trigger OnPreDataItem();
            begin
            eND;

            trigger OnAfterGetRecord();
            begin
                DimRec.SetRange(Code, "Shortcut Dimension 1 Code");
                IF DimRec.FindFirst() then
                    Vessalname := DimRec.Name;

                If "Currency Code" = '' then begin
                    GLSetup.Get();
                    CurrCode := GLSetup."LCY Code";
                end else
                    CurrCode := "Currency Code";
                CalcFields("Work Description");
                "Work Description".Createinstream(Stream);
                Stream.Read(ScopeofWork);

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


        CheckRep: Codeunit "Amount In Word LT";
        NoText: array[1] of Text;
        AmtWord: Text[100];

        CustRec: Record Customer;
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
        CurrCode: Code[30];
        Total_Line: Decimal;
        TypeLoop: Integer;
        Typeloop2: Integer;
        SlNo: Integer;
        LineGap: Boolean;
        ScopeofWork: Text;
        Stream: inStream;
        TotVatAmt: Decimal;
}