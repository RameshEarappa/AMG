tableextension 50110 JobTableExtension extends Job
{
    fields
    {
        field(50000; "Vessel No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Vessel Selection" where("Job No." = field("No."));// where(Running = const(true));
            trigger OnValidate()
            begin
                CreateDimesnionForVessel();
            end;
        }

        field(50003; "Vessel Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Value".Name where(Code = field("Global Dimension 1 Code")));
        }
        field(50001; "Contract No."; Code[50])
        {

        }
        field(50002; Loction; text[50])
        {

        }
    }


    procedure CreateDimesnionForVessel()
    var
        DefaultDimension: Record "Default Dimension";
        VesselMasterRec: Record "VesselMaster Table";
        InsertDefaultDimRec: Record "Default Dimension";
        ModifyDefaultDimRec: Record "Default Dimension";
        Jobtask: Record "Job Task";
        GenLEdSetup: Record "General Ledger Setup";
    begin
        if "Vessel No." <> '' then begin
            VesselMasterRec.Reset();
            GenLEdSetup.GET;
            VesselMasterRec.SetRange("Vessel No.", Rec."Vessel No.");
            if VesselMasterRec.FindFirst then;

            DefaultDimension.Reset();
            DefaultDimension.SetRange("Table ID", 167);
            DefaultDimension.SetRange("No.", Rec."No.");
            DefaultDimension.SetRange("Dimension Code", GenLEdSetup."Global Dimension 1 Code");//'VESSELS');
            if not DefaultDimension.FindFirst then begin

                InsertDefaultDimRec."Table ID" := 167;
                InsertDefaultDimRec."No." := Rec."No.";
                InsertDefaultDimRec."Dimension Code" := GenLEdSetup."Global Dimension 1 Code";//'VESSELS';
                InsertDefaultDimRec."Dimension Value Code" := VesselMasterRec."Project Dimention";
                //InsertDefaultDimRec."Dimension Value Code" := 
                InsertDefaultDimRec."Value Posting" := InsertDefaultDimRec."Value Posting"::"Same Code";
                InsertDefaultDimRec.Insert;
                "Global Dimension 1 Code" := VesselMasterRec."Project Dimention";

                Jobtask.Reset();
                Jobtask.SetRange("Job No.", "No.");
                if Jobtask.FindSet then
                    repeat
                        Jobtask.Validate("Global Dimension 1 Code", VesselMasterRec."Project Dimention");
                        Jobtask.Modify;
                    until Jobtask.Next = 0;
            end else begin
                ModifyDefaultDimRec.Reset();
                ModifyDefaultDimRec.SetRange("Table ID", 167);
                ModifyDefaultDimRec.SetRange("No.", Rec."No.");
                ModifyDefaultDimRec.SetRange("Dimension Code", GenLEdSetup."Global Dimension 1 Code");//'VESSELS');
                if ModifyDefaultDimRec.FindFirst then begin
                    ModifyDefaultDimRec."Dimension Value Code" := VesselMasterRec."Project Dimention";
                    ModifyDefaultDimRec.Modify;
                    "Global Dimension 1 Code" := VesselMasterRec."Project Dimention";

                    Jobtask.Reset();
                    Jobtask.SetRange("Job No.", "No.");
                    if Jobtask.FindSet then
                        Repeat
                            Jobtask.Validate("Global Dimension 1 Code", VesselMasterRec."Project Dimention");
                            Jobtask.Modify;
                        until Jobtask.Next = 0;
                end;
            end;
        end;


    end;


    var
        myInt: Integer;
        dhh: Codeunit "Job Create-Invoice";
}