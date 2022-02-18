codeunit 50103 "Create Document"
{
    trigger OnRun()
    begin

    end;

    procedure CreateJob(JobDimValue: Code[20]; Segment: Code[20])
    var
        RecJob: Record Job;
        GenledSetup: Record "General Ledger Setup";
        RecDimValue: Record "Dimension Value";
    begin
        Clear(RecJob);
        GenledSetup.GET;
        Clear(RecDimValue);
        if RecDimValue.FindFirst() then begin
            RecJob.Init();
            RecJob.Validate("No.", JobDimValue);
            RecJob.Insert(true);
        end;
        Message('Job %1 is created', JobDimValue);
    end;


    procedure CreateDefaultDimesnion(JobNoP: Code[20]): Integer
    var
        DefaultDimensionRecL: Record "Default Dimension";
        GenLedgSetup: Record "General Ledger Setup";
        DimensionValue: Record "Dimension Value";
    begin
        Clear(DimensionValue);
        GenLedgSetup.GET;
        DimensionValue.SetRange("Dimension Code", GenLedgSetup."Shortcut Dimension 3 Code");
        DimensionValue.SetRange(Code, JobNoP);
        if DimensionValue.FindFirst() then begin
            DimensionValue.TestField(Segment);

            DefaultDimensionRecL.Init();
            DefaultDimensionRecL.Validate("Table ID", Database::Job);
            DefaultDimensionRecL.Validate("No.", JobNoP);
            DefaultDimensionRecL.Validate("Dimension Code", GenLedgSetup."Shortcut Dimension 3 Code");
            DefaultDimensionRecL.Validate("Dimension Value Code", DimensionValue.Code);
            DefaultDimensionRecL.Validate("Value Posting", DefaultDimensionRecL."Value Posting"::"Same Code");
            DefaultDimensionRecL.Insert(true);

            DefaultDimensionRecL.Init();
            DefaultDimensionRecL.Validate("Table ID", Database::Job);
            DefaultDimensionRecL.Validate("No.", JobNoP);
            DefaultDimensionRecL.Validate("Dimension Code", GenLedgSetup."Shortcut Dimension 2 Code");
            DefaultDimensionRecL.Validate("Dimension Value Code", DimensionValue.Segment);
            DefaultDimensionRecL.Validate("Value Posting", DefaultDimensionRecL."Value Posting"::"Same Code");
            DefaultDimensionRecL.Insert(true);

        end;

    end;

    procedure CreareVessel(VesselCode: Code[20])
    var
        RecVessel: Record "VesselMaster Table";
    begin
        RecVessel.Init();
        RecVessel.Validate("Vessel No.", VesselCode);
        RecVessel.Validate("Project Dimention", VesselCode);
        RecVessel.Insert(true);
        Message('Vessel %1 is created', VesselCode);
    end;

    var
        myInt: Integer;
}