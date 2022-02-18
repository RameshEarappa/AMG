report 50128 "Delivery Journal Entries"
{
    DefaultLayout = RDLC;
    //RDLCLayout = 'Report-rdlc-files/R_50110.rdl';
    Caption = 'Delivery Journal Entries';
    PreviewMode = PrintLayout;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("Purch. Rcpt. Header"; "Purch. Rcpt. Header")
        {
            RequestFilterFields = "No.";
            DataItemTableView = SORTING();
            column(No_; "No.") { }
            dataitem("G/L Entry"; "G/L Entry")
            {
                DataItemLink = "Document No." = FIELD("No.");

                column(Posting_Date; FORMAT("Posting Date", 8, '<Day,2>/<Month,2>/<year,2>')) { }
                column(G_L_Account_No_; "G/L Account No.") { }
                column(G_L_Account_Name; "G/L Account Name") { }
                column(Debit_Amount; "Debit Amount") { }
                column(Credit_Amount; "Credit Amount") { }
                column(VesselName; VesselName) { }
                column(Segments; "Global Dimension 2 Code") { }
                column(ProjectName; ProjectName) { }
                column(ProJectCode; ProJectCode) { }
                column(DivisionCode; DivisionCode) { }
                column(DivisionName; DivisionName) { }
                trigger OnAfterGetRecord()
                begin
                    GLSetup.Get();
                    DimSetEntRec.Reset();
                    DimSetEntRec.SetRange(DimSetEntRec."Dimension set ID", "G/L Entry"."Dimension Set ID");
                    DimSetEntRec.SetRange("Dimension Code", GLSetup."Shortcut Dimension 1 Code");
                    if DimSetEntRec.FindFirst() then begin
                        DimSetEntRec.CalcFields("Dimension Value Name");
                        VesselName := DimSetEntRec."Dimension Value Name";
                    ENd;

                    DimSetEntRec2.Reset();
                    DimSetEntRec2.SetRange(DimSetEntRec2."Dimension set ID", "G/L Entry"."Dimension Set ID");
                    DimSetEntRec2.SetRange(DimSetEntRec2."Dimension Code", GLSetup."Shortcut Dimension 3 Code");
                    if DimSetEntRec2.FindFirst() then begin
                        DimSetEntRec2.CalcFields("Dimension Value Name");
                        ProjectName := DimSetEntRec2."Dimension Value Name";
                        ProJectCode := DimSetEntRec2."Dimension Value Code";
                    End;

                    DimSetEntRec3.Reset();
                    DimSetEntRec3.SetRange(DimSetEntRec3."Dimension set ID", "G/L Entry"."Dimension Set ID");
                    DimSetEntRec3.SetRange(DimSetEntRec3."Dimension Code", GLSetup."Shortcut Dimension 6 Code");
                    if DimSetEntRec3.FindFirst() then begin
                        DimSetEntRec3.CalcFields("Dimension Value Name");
                        DivisionName := DimSetEntRec3."Dimension Value Name";
                        DivisionCode := DimSetEntRec3."Dimension Value Code";
                    End;

                end;

                trigger OnPostDataItem()
                begin
                    //Message('D6', DivisionCode);

                end;
            }
        }

    }
    trigger OnPreReport()
    begin
    end;

    var
        VesselName: Text;
        ProJectCode: Code[50];
        ProjectName: Text;
        DivisionCode: code[20];
        DivisionName: Text;
        GLSetup: Record "General Ledger Setup";
        DimSetEntRec: Record "Dimension Set Entry";
        DimSetEntRec2: Record "Dimension Set Entry";
        DimSetEntRec3: Record "Dimension Set Entry";
}