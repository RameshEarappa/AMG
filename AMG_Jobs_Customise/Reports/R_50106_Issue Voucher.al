report 50106 "Issue Voucher"
{
    DefaultLayout = RDLC;
    //RDLCLayout = '50101_28_V2.rdl';
    Caption = 'Issue Voucher';
    PreviewMode = PrintLayout;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Job Ledger Entry"; "Job Ledger Entry")
        {
            DataItemTableView = WHERE(Type = FILTER(Item));
            //SORTING("Document No.", "Posting Date")
            RequestFilterFields = "Document No.";
            column(DocNo; "Document No.") { }
            column(Posting_Date; FORMAT("Posting Date", 8, '<Day,2>/<Month,2>/<year,2>')) { }
            column(Job_No; "Global Dimension 1 Code") { }
            column(JobName; JobName) { }
            column(No_; "No.") { }
            column(ItemDec; ItemRec."Description") { }
            column(Unit_of_Measure_Code; "Unit of Measure Code") { }
            column(Quantity; Quantity) { }
            column(ComName; CompInfoRec.Name) { }
            column(CompAdd1; CompInfoRec.Address) { }
            column(CompMail; CompInfoRec."E-Mail") { }
            column(HomePage; CompInfoRec."Home Page") { }
            column(CompAdd2; CompInfoRec.Address) { }
            column(CompPostCode; CompInfoRec."Post Code") { }
            column(CompCity; CompInfoRec.City) { }
            column(CompCountry; CompCount) { }
            column(CompPhone; CompInfoRec."Phone No.") { }
            column(Logo; CompInfoRec.Picture) { }
            column(CompFax; CompInfoRec."Fax No.") { }
            column(VesalNo; "Global Dimension 1 Code") { }
            column(DivisionName; DivisionName) { }
            column(Vessalname; Vessalname) { }
            column(Job_ProjectNo; Job_ProjectNo) { }
            column(Sd6; Sd6) { }

            //dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
            /*{
                DataItemLink = "Document No." = FIELD("No.");
                //DataItemTableView = WHERE(Type = FILTER(Item));
                column(Document_No_; "Document No.") { }

                trigger OnPreDataItem();
                begin

                end;

                trigger OnAfterGetRecord();
                begin
                end;
            }*/
            trigger OnPreDataItem();
            begin
            eND;

            trigger OnAfterGetRecord();
            begin
                Clear(Job_ProjectNo);
                Clear(JobName);
                GLSetup.Get();
                DimSetEntRec.Reset();
                DimSetEntRec.SetRange("Dimension Set ID", "Dimension Set ID");
                DimSetEntRec.SetRange("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
                if DimSetEntRec.FindFirst() then begin
                    Job_ProjectNo := DimSetEntRec."Dimension Value Code";
                End;
                Clear(Vessalname);
                DimRec.Reset();
                //DimSetEntRec.SetRange("Dimension Set ID", "Dimension Set ID");
                DimRec.SetRange("Code", "Global Dimension 1 Code");
                IF DimRec.FindFirst() then
                    Vessalname := DimRec.Name;

                DimRec.SetRange("Code", "Global Dimension 2 Code");
                IF DimRec.FindFirst() then
                    DivisionName := DimRec.Name;
                if ItemRec.get("No.") then;
                IF ContReion.get(CompInfoRec."Country/Region Code") then
                    CompCount := ContReion.Name;

                GLSetup.get();
                Clear(Sd6);
                DimSetEntry.Reset();
                DimSetEntry.SetRange("Dimension Set ID", "Job Ledger Entry"."Dimension Set ID");
                DimSetEntry.SetRange("Dimension Code", GLSetup."Shortcut Dimension 6 Code");
                IF DimSetEntry.FindFirst() THEN
                    Sd6 := DimSetEntry."Dimension Value Code";
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
        Sd6: Code[20];
        DimSetEntry: Record "Dimension Set Entry";
        TotalAmt: Decimal;
        CheckRep: Codeunit "Amount In Word LT";
        NoText: array[1] of Text;
        AmtWord: Text[100];
        AmtVat: Decimal;
        CurrCode: Code[10];
        GLSetup: Record "General Ledger Setup";
        DimRec: Record "Dimension Value";
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
        Job_ProjectNo: Text;
        JobName: Text;
        DivisionName: Text;
        ContReion: Record "Country/Region";
        CompCount: Text;
}

