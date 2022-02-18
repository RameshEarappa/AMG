report 50105 "MRN Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'AMG_Jobs_Customise\Reports-rdlc-files\R_50105_Base.rdl';
    Caption = 'MATERIAL RECEIPT NOTE';
    PreviewMode = PrintLayout;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Purch. Rcpt. Header"; "Purch. Rcpt. Header")
        {
            DataItemTableView = SORTING("No.")
                                ORDER(Ascending);
            RequestFilterFields = "No.";
            column(DocNo; "No.") { }
            column(Posting_Date; FORMAT("Posting Date", 8, '<Day,2>/<Month,2>/<year,2>')) { }
            column(Received_by; "Received by") { }
            column(Division; Division) { }
            column(JobNo; JobNo) { }
            column(VesalNo; "Shortcut Dimension 1 Code") { }
            column(Order_No_; "Order No.") { }
            column(Buy_from_Vendor_No_; "Buy-from Vendor No.") { }
            column(Buy_from_Vendor_Name; "Buy-from Vendor Name") { }
            column(Buy_from_Post_Code; "Buy-from Post Code") { }
            column(Buy_from_City; "Buy-from City") { }
            column(Buy_from_Contact; "Buy-from Contact") { }
            column(Buy_from_County; Vend_County) { }
            column(SD6; SD6) { }
            column(VendPhone; VendRec."Phone No.") { }
            column(VendFax; VendRec."Fax No.") { }
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
            column(Vessalname; Vessalname) { }
            column(Vendor_Shipment_No_; "Vendor Shipment No.") { }
            column(Backcharge; Backcharge) { }
            column(Backcharge_To; "Backcharge To") { }

            dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
            {

                DataItemTableView = SORTING("Document No.")
                                ORDER(Ascending) where(Quantity = filter(<> 0));
                DataItemLink = "Document No." = FIELD("No.");
                //DataItemTableView = WHERE(Type = FILTER(Item | ' ' | 'G/L Account'));
                column(Document_No_; "Document No.") { }
                column(ItemNo; "No.") { }
                column(Unit_of_Measure; "Unit of Measure Code") { }
                column(Quantity; Quantity) { }
                column(UnitPrice; UnitPrice) { }
                column(Description; Description + '' + "Description 2") { }
                column(SNo; SNo) { }
                column(Blank; Blank) { }
                column(VisbCond; VisbCond) { }
                column(CurrCode; CurrCode) { }
                column(ExpBooked; ExpBooked) { }
                trigger OnPreDataItem();
                begin

                end;

                trigger OnAfterGetRecord();
                begin
                    if "Purch. Rcpt. Header"."Currency Code" = '' then begin
                        GLSetup.Get();
                        CurrCode := GLSetup."LCY Code";
                        UnitPrice := "Unit Cost";
                    end else begin
                        CurrCode := "Purch. Rcpt. Header"."Currency Code";
                        UnitPrice := "Unit Cost" * "Purch. Rcpt. Header"."Currency Factor";
                    end;
                    If ("Purch. Rcpt. Line".Type <> "Purch. Rcpt. Line".Type::Item) then begin
                        If Quantity <> 0 then
                            SNo += 1;
                    end else
                        if Type <> Type::" " then
                            SNo += 1;

                    Blank := false;
                    if ("Purch. Rcpt. Line".Type = "Purch. Rcpt. Line".Type::Item) And (SNo <> 1) then begin
                        Blank := true;
                    END;
                    VisbCond := false;
                    IF ("Purch. Rcpt. Line".Type = "Purch. Rcpt. Line".Type::Item) then begin
                        if Quantity <> 0 then
                            VisbCond := true;
                    End else
                        if ("Purch. Rcpt. Line".Type = "Purch. Rcpt. Line".Type::" ") and ("Purch. Rcpt. Line".Description <> ' ') then
                            VisbCond := true;
                    //if "Purch. Rcpt. Line".Type = "Purch. Rcpt. Line".Type::" " then
                    //  VisbCond := false;
                    /*
                    if ("Unit of Measure Code" = ' ') And ("Purch. Rcpt. Line".Description = ' ') then
                        VisbCond := false;
*/



                    ItemNoC := "Purch. Rcpt. Line"."No.";

                    Clear(JobNo);
                    GLSetup.Get();
                    DimSetEntRec.Reset();
                    DimSetEntRec.SetRange("Dimension Set ID", "Dimension Set ID");
                    DimSetEntRec.SetRange("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
                    if DimSetEntRec.FindFirst() then begin
                        JobNo := DimSetEntRec."Dimension Value Code";
                    End;

                    LineRec.Reset();
                    LineRec.SetRange("Document No.", "Document No.");
                    LineRec.SetFilter(Quantity, '<> %1', 0);
                    LineRec.SetRange(Type, LineRec.Type::Item);
                    LineRec.SetRange("Job Task No.", '');
                    IF LineRec.FindFirst() then
                        ExpBooked := false
                    Else
                        ExpBooked := true;


                end;

            }
            trigger OnPreDataItem();
            begin
            eND;

            trigger OnAfterGetRecord();
            begin
                If VendRec.Get("Buy-from Vendor No.") then;
                Clear(TotalAmt);
                LineRec.Reset();
                LineRec.SetRange("Document No.", "Purch. Rcpt. Header"."No.");
                If LineRec.FindFirst() then begin
                    repeat
                        TotAmt += LineRec.Quantity * LineRec."Unit Cost";
                    until LineRec.Next() = 0;
                end;
                IF "Currency Factor" <> 0 then
                    LocalCurr := TotalAmt * "Currency Factor"
                else
                    LocalCurr := TotalAmt;

                CheckRep.FormatNoText(NoText, LocalCurr, CurrCode);
                AmtWord := CurrCode + ' ' + NoText[1];
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
                if ContReion.Get("Buy-from Country/Region Code") then
                    Vend_County := ContReion.Name;


                //
                GLSetup.get();
                DimSetEntry.Reset();
                DimSetEntry.SetRange("Dimension Set ID", "Purch. Rcpt. Header"."Dimension Set ID");
                DimSetEntry.SetRange("Dimension Code", GLSetup."Shortcut Dimension 6 Code");
                IF DimSetEntry.FindFirst() THEN
                    Sd6 := DimSetEntry."Dimension Value Code";
                //
                /* If GLSetup.get() then begin
                     DimRec.SetRange("Dimension Code", GLSetup."Shortcut Dimension 6 Code");
                     IF DimRec.FindFirst() then
                         Sd6 := DimRec.Code;
                 end;*/
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
        ItemRec: Record Item;
        VendRec: Record Vendor;
        SL_No: Integer;
        TotalAmt: Decimal;
        CheckRep: Codeunit "Amount In Word LT";
        NoText: array[1] of Text;
        AmtWord: Text[100];
        AmtVat: Decimal;
        CurrCode: Code[10];
        GLSetup: Record "General Ledger Setup";
        DimRec: Record "Dimension Value";
        DimSetEntry: Record "Dimension Set Entry";
        LocalCurr: Decimal;
        Division: Text;
        JobNo: Text;
        VesalNo: Text;
        UnitPrice: Decimal;
        SNo: Integer;
        DecTex: Text;
        LineRec: Record "Purch. Rcpt. Line";
        TotAmt: Decimal;
        ItemNoC: Code[30];
        Vessalname: Text;
        DimSetEntRec: Record "Dimension Set Entry";
        Blank: Boolean;
        VisbCond: Boolean;
        ContReion: Record "Country/Region";
        CompCount: Text;
        Vend_County: Text;
        SD6: Text;
        ExpBooked: Boolean;
}
