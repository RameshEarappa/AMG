tableextension 50161 tableextension50161 extends "Job Ledger Entry"
{
    fields
    {
        field(50151; AMG_JobPlanningLineNo; Integer)
        {
            Caption = 'Job Planning Line No.';
            Editable = false;
        }
        /*field(50152; "Shortcut Dimension 3 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(3));
            CaptionClass = '1,2,3';
            DataClassification = ToBeClassified;
            ObsoleteState = Removed;
        }
        field(50153; "Shortcut Dimension 6 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(6));
            CaptionClass = '1,2,6';
            DataClassification = ToBeClassified;
            ObsoleteState = Removed;
        }
*/
        modify("Dimension Set ID")
        {
            trigger OnAfterValidate()
            VAR
                RecDimSetEntry: Record "Dimension Set Entry";
                RecGLSetup: Record "General Ledger Setup";
            begin
                if Rec."Dimension Set ID" = 0 then begin
                    //Rec."Shortcut Dimension 3 Code" := '';
                    //Rec."Shortcut Dimension 6 Code" := '';
                    exit;
                end;
                RecGLSetup.GET;
                Clear(RecDimSetEntry);
                RecDimSetEntry.SetRange("Dimension Set ID", Rec."Dimension Set ID");
                RecDimSetEntry.SetRange("Dimension Code", RecGLSetup."Shortcut Dimension 3 Code");
                if RecDimSetEntry.FindFirst() then
                    //Rec."Shortcut Dimension 3 Code" := RecDimSetEntry."Dimension Value Code";
                Clear(RecDimSetEntry);
                RecDimSetEntry.SetRange("Dimension Set ID", Rec."Dimension Set ID");
                RecDimSetEntry.SetRange("Dimension Code", RecGLSetup."Shortcut Dimension 6 Code");
                if RecDimSetEntry.FindFirst() then;
                // Rec."Shortcut Dimension 6 Code" := RecDimSetEntry."Dimension Value Code";
            end;
        }
    }


}
