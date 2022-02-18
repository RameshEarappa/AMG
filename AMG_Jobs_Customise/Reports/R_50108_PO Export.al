report 50108 "PO Report Export"
{
    DefaultLayout = RDLC;
    //RDLCLayout = '50101_28_V2.rdl';
    Caption = 'Purchase Order Import';
    PreviewMode = PrintLayout;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = SORTING("No.")
                                ORDER(Ascending);
            RequestFilterFields = "No.";
            column(PrNo; AMG_InitSourceNo) { }
            column(CommentText; CommentText) { }
            column(Invoice_Discount_Amount; "Invoice Discount Amount") { }
            column(Ord_No; "No.") { }
            column(Coordinator_Name; "Coordinator Name") { }
            column(Order_Date; FORMAT("Order Date", 8, '<Day,2>/<Month,2>/<year,2>')) { }
            column(Posting_Date; FORMAT("Posting Date", 8, '<Day,2>/<Month,2>/<year,2>')) { }
            column(Payment_Terms_Code; "Payment Terms Code") { }
            column(Redyness_Date; FORMAT("Redyness Date", 8, '<Day,2>/<Month,2>/<year,2>')) { }
            column(Validity_Date; FORMAT("Validity Date", 8, '<Day,2>/<Month,2>/<year,2>')) { }
            column(No__of_Archived_Versions; "No. of Archived Versions") { }
            column(VessalNo; "Shortcut Dimension 1 Code") { }
            column(VessalName; VessalName) { }
            column(JobNo; JobNo) { }
            column(Divison; "Shortcut Dimension 2 Code") { }
            column(CompPcture; CompInfoRec.Picture) { }
            column(CompName; CompInfoRec.Name) { }
            column(CompAdd1; CompInfoRec.Address) { }
            column(CompAdd2; CompInfoRec."Address 2") { }
            column(compCity; CompInfoRec.City) { }
            column(CompCount; CompCount) { }
            column(compPosCode; CompInfoRec."Post Code") { }
            column(CompTel; CompInfoRec."Phone No.") { }
            column(CompFax; CompInfoRec."Fax No.") { }
            column(CompMail; CompInfoRec."E-Mail") { }
            column(CompWeb; CompInfoRec."Home Page") { }
            column(CompVatNo; CompInfoRec."VAT Registration No.") { }
            column(CompTRN; CompInfoRec."VAT Registration No.") { }
            column(Vend_VatNo; VendRec."VAT Registration No.") { }
            column(Vend_Vendor_No_; "Buy-from Vendor No.") { }
            column(Vend_Name; "Buy-from Vendor Name") { }
            column(Vend_Post_Code; "Buy-from Post Code") { }
            column(Vend_Address; "Buy-from Address") { }
            column(Vend_City; "Buy-from City") { }
            column(Vend_County; Vend_County) { }
            column(VendPhone; VendRec."Phone No.") { }
            column(VendFax; VendRec."Fax No.") { }
            column(Vend_Contact; "Buy-from Contact") { }
            column(VendEmail; VendRec."E-Mail") { }
            column(CompNameArb; CompNameArb) { }
            column(PosNoArb; PosNoArb) { }
            column(CityArb; CityArb) { }
            column(CountryArb; CountryArb) { }
            column(MailArb; MailArb) { }
            column(FaxArb; FaxArb) { }
            column(AmtWord; AmtWord) { }
            column(CurrCode; CurrCode) { }
            column(Packing_Instruction; "Packing Instruction") { }
            column(Port_of_Call_Delivery_Address; "Port of Call/Delivery Address") { }
            column(Warranty__if_any; "Warranty, if any") { }
            column(Certificate_s___if_required; "Certificate(s), if required") { }
            column(Backcharge; Backcharge) { }
            column(BoolBackCharge; BoolBackCharge) { }
            column(Now; (Format(Today, 8, '<Day,2>/<Month,2>/<year,2>')) + ' ' + (Format(Time, 8, '<hours24>:<minutes,2>:<seconds,2>'))) { }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                //DataItemTableView = WHERE(Type = FILTER(Item));
                column(Item_No; "No.") { }
                column(Description; Description) { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(Quantity; Quantity) { }
                column(Direct_Unit_Cost; "Direct Unit Cost") { }
                column(VatPer; "VAT %") { }
                column(Amount_Including_VAT; "Amount Including VAT") { }
                column(Line_Amount; "Line Amount") { }
                column(Blank; Blank) { }
                column(VisibCond; VisibCond) { }
                column(TotVatper; TotVatper) { }
                column(LocalCurr; LocalCurr) { }

                column(Amount; Amount)
                {

                }
                column(Inv__Discount_Amount; "Line Discount Amount") { }
                column(S_No; S_No) { }
                column(Type; Type) { }
                trigger OnPreDataItem();
                begin

                end;

                trigger OnAfterGetRecord();
                begin
                    Clear(JobNo);
                    Clear(Vessalname);
                    GLSetup.Get();
                    DimSetEntRec.Reset();
                    DimSetEntRec.SetRange("Dimension Set ID", "Dimension Set ID");
                    DimSetEntRec.SetRange("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
                    if DimSetEntRec.FindFirst() then
                        JobNo := DimSetEntRec."Dimension Value Code";

                    DimRec.Reset();
                    DimRec.SetRange("Code", "Shortcut Dimension 1 Code");
                    IF DimRec.FindFirst() then
                        Vessalname := DimRec.Name;
                    IF Type <> Type::" " then
                        Blank := true
                    Else
                        Blank := false;
                    Clear(TotAmt);
                    LineRec.Reset();
                    LineRec.SetRange("Document No.", "Document No.");
                    if LineRec.FindSet() then begin
                        repeat
                            TotAmt += LineRec."Amount Including VAT";
                        until LineRec.Next() = 0;
                    end;

                    CheckRep.FormatNoText(NoText, ABS(TotAmt), "Purchase Header"."Currency Code");
                    AmtWord := NoText[1];
                    IF "VAT %" <> 0 then begin
                        VatCount += 1;
                        IF VatCount = 1 then
                            FirstVat := "VAT %";
                        LastVatper += "VAT %";
                    End;

                    If (LastVatper <> 0) and (VatCount <> 0) then begin
                        VatResult := LastVatper / VatCount;
                        IF FirstVat <> VatResult then
                            TotVatPer := 0
                        Else
                            TotVatper := VatResult;
                    End;
                    Clear(LocalCurr);
                    if "Purchase Header"."Currency Factor" = 0 then
                        LocalCurr := 0
                    Else
                        LocalCurr := TotAmt * (1 / "Purchase Header"."Currency Factor");

                    IF Type <> Type::" " then
                        S_No += 1;
                end;
            }
            trigger OnPreDataItem();
            begin
            END;

            trigger OnAfterGetRecord();
            begin

                IF "Purchase Header".Backcharge = "Purchase Header".Backcharge::Yes THEN
                    BoolBackCharge := true
                ELSE
                    BoolBackCharge := false;
                If VendRec.get("Buy-from Vendor No.") then;
                //Arabic Hard Code
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
                If ContReion.Get("Buy-from Country/Region Code") then
                    Vend_County := ContReion.Name;
                If ContReion.Get(CompInfoRec."Country/Region Code") then
                    CompCount := ContReion.Name;

                IF "Currency Code" <> ' ' then
                    CurrCode := "Currency Code"
                else begin
                    GLSetup.Get();
                    CurrCode := GLSetup."LCY Code";
                end;

                Commentrec.Reset();
                Commentrec.SetRange("No.", "No.");
                if Commentrec.FindSet() then begin
                    repeat
                        CommentText += Commentrec.Comment + ' ';
                    until Commentrec.Next() = 0;
                end;
            end;
        }

    }
    trigger OnPreReport();
    begin
        CompInfoRec.GET;
        CompInfoRec.CALCFIELDS(Picture);
        CheckRep.InitTextVariable;
    end;

    var
        CompInfoRec: Record "Company Information";
        CheckRep: Codeunit "Amount In Word LT";
        JobNo: Text;
        VessalName: Text;
        GLSetup: Record "General Ledger Setup";
        DimSetEntRec: Record "Dimension Set Entry";
        DimRec: Record "Dimension Value";
        VendRec: Record Vendor;
        ArabRec: Record "Arabic description";
        CompNameArb: Text;
        PosNoArb: Text;
        CityArb: Text;
        CountryArb: Text;
        S_No: Integer;
        MailArb: Text;
        TelArb: Text;
        FaxArb: Text;
        Blank: Boolean;
        VisibCond: Boolean;
        NoText: array[1] of Text;
        TotAmt: Decimal;
        LineRec: Record "Purchase Line";
        AmtWord: Text;
        TotVatper: Decimal;
        LastVatper: Decimal;
        VatCount: Integer;
        FirstVat: Decimal;
        VatResult: Decimal;
        ContReion: Record "Country/Region";
        Vend_County: Text;
        CompCount: Text;
        CurrCode: Text;
        LocalCurr: Decimal;
        CommentText: Text;
        UserIdv: Code[50];

        Commentrec: Record "Purch. Comment Line";
        BoolBackCharge: Boolean;
}
