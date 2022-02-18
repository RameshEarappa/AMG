pageextension 50417 Ext_Ile extends "Item Ledger Entries"
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
        Ile2: Record "Item Ledger Entry";
    begin
        GLSetup.Get();
        DimSetEntRec.Reset();
        DimSetEntRec.SetRange("Dimension set ID", rEC."Dimension Set ID");
        DimSetEntRec.SetRange("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
        if DimSetEntRec.FindFirst() then begin
            //DimSetEntRec.CalcFields("Dimension Value Code");
            Rec."Project Code" := DimSetEntRec."Dimension Value Code";
            /*If Ile2.Get(Rec."Entry No.") then begin
                Ile2.Init();
                Ile2."Project Code" := DimSetEntRec."Dimension Value Code";
                Ile2.Insert();
            end;*/
            // Modify();
        End;
    eND;

    trigger OnAfterGetRecord()
    var
        GLSetup: Record "General Ledger Setup";
        DimSetEntRec: Record "Dimension Set Entry";
        Ile2: Record "Item Ledger Entry";
    begin
        GLSetup.Get();
        DimSetEntRec.Reset();
        DimSetEntRec.SetRange("Dimension set ID", rEC."Dimension Set ID");
        DimSetEntRec.SetRange("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
        if DimSetEntRec.FindFirst() then begin
            Rec."Project Code" := DimSetEntRec."Dimension Value Code";
            /*If Ile2.Get(Rec."Entry No.") then begin
                Ile2.init;
                Ile2."Project Code" := DimSetEntRec."Dimension Value Code";
                Ile2.Insert();
            end;*/
        End;
    eND;

    trigger OnAfterGetCurrRecord()
    var
        GLSetup: Record "General Ledger Setup";
        DimSetEntRec: Record "Dimension Set Entry";
        Ile2: Record "Item Ledger Entry";
    begin
        GLSetup.Get();
        DimSetEntRec.Reset();
        DimSetEntRec.SetRange("Dimension set ID", rEC."Dimension Set ID");
        DimSetEntRec.SetRange("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
        if DimSetEntRec.FindFirst() then begin
            Rec."Project Code" := DimSetEntRec."Dimension Value Code";
            /*If Ile2.Get(Rec."Entry No.") then begin
                Ile2.init;
                Ile2."Project Code" := DimSetEntRec."Dimension Value Code";
                Ile2.Insert();
            end;*/
        End;
    eND;


    var
        myInt: Integer;
}