pageextension 50418 Ext_RLE extends "Resource Ledger Entries"
{
    layout
    {
        addafter("Global Dimension 2 Code")
        {
            field("Project Code"; Rec."Project Code")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }
    trigger OnOpenPage()
    var
        GLSetup: Record "General Ledger Setup";
        DimSetEntRec: Record "Dimension Set Entry";
    begin
        GLSetup.Get();
        DimSetEntRec.Reset();
        DimSetEntRec.SetRange("Dimension set ID", rEC."Dimension Set ID");
        DimSetEntRec.SetRange("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
        if DimSetEntRec.FindFirst() then begin
            //DimSetEntRec.CalcFields("Dimension Value Code");
            Rec."Project Code" := DimSetEntRec."Dimension Value Code";
            //Modify();
        End;
    eND;

    trigger OnAfterGetRecord()
    var
        GLSetup: Record "General Ledger Setup";
        DimSetEntRec: Record "Dimension Set Entry";
    begin
        GLSetup.Get();
        DimSetEntRec.Reset();
        DimSetEntRec.SetRange("Dimension set ID", rEC."Dimension Set ID");
        DimSetEntRec.SetRange("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
        if DimSetEntRec.FindFirst() then begin
            //DimSetEntRec.CalcFields("Dimension Value Code");
            Rec."Project Code" := DimSetEntRec."Dimension Value Code";
            //   Modify();
        End;
    eND;

    trigger OnAfterGetCurrRecord()
    var
        GLSetup: Record "General Ledger Setup";
        DimSetEntRec: Record "Dimension Set Entry";
    begin
        GLSetup.Get();
        DimSetEntRec.Reset();
        DimSetEntRec.SetRange("Dimension set ID", rEC."Dimension Set ID");
        DimSetEntRec.SetRange("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
        if DimSetEntRec.FindFirst() then begin
            //DimSetEntRec.CalcFields("Dimension Value Code");
            Rec."Project Code" := DimSetEntRec."Dimension Value Code";
            //    Modify();

        End;
    eND;


    var
        myInt: Integer;
}