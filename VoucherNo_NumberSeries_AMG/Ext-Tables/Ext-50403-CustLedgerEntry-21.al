tableextension 50403 "Ext Cust. Ledger Entry" extends "Cust. Ledger Entry"
{
    fields
    {
        field(50400; "Voucher No."; Code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
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
                    "Project Code" := DimSetEntRec."Dimension Value Code"
                End;
            eND;
        }
        field(50410; "Vessel Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Value".Name where(Code = field("Global Dimension 1 Code")));

        }

        field(50430; Narration; Text[250])
        {
        }
        field(50440; "Project Code"; Code[20])
        {
        }
        modify("Document Type")
        {
            trigger OnAfterValidate()
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
                    "Project Code" := DimSetEntRec."Dimension Value Code"
                End;
            eND;
        }


    }
}