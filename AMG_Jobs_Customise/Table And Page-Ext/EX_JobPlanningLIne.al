tableextension 50102 EX_JobPlaningLine extends "Job Planning Line"
{
    fields
    {
        // Add changes to table fields here
        field(50001; "Line Number"; Text[50])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                InitJobPlanningLine();
            end;

        }
        field(50002; "Contract No"; Text[50])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                InitJobPlanningLine();
            end;

        }
        field(50003; "Cost of Revenue"; Boolean)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                InitJobPlanningLine();
            end;

        }
        field(50004; Retention; Boolean)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                InitJobPlanningLine();
            end;
        }
        field(50005; Hire; Boolean)
        {
            trigger OnValidate()
            var
                VesselSelection: Record "Vessel Selection";
                JobMaster: Record Job;
            begin

                IF NOT Hire THEN begin
                    "From Date" := 0D;
                    "To Date" := 0D;
                END
                ELSE BEGIN
                    IF JobMaster.Get(Rec."Job No.") THEN BEGIN
                        IF VesselSelection.Get(JobMaster."Vessel No.", JobMaster."No.") THEN BEGIN
                            "From Date" := VesselSelection."Vessel Delivery Date ";
                        END;
                    END;
                END;
            end;
        }
        field(50006; "From Date"; Date)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                IF "To Date" <> 0D THEN begin
                    IF "To Date" < "From Date" THEN
                        Error('To Date Cannot be Before From Date');
                    IF "To Time" <> 0T THEN
                        Validate("To Time");
                    if "To Date" <> 0D THEN
                        Validate("To Date");
                    IF "Total Hrs" <> 0 THEN
                        Validate(Quantity, Round("Total Hrs" / 24, 0.01, '='));
                END;
            end;
        }
        field(50007; "To Date"; Date)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                IF "From Date" <> 0D THEN
                    IF "To Date" < "From Date" THEN
                        Error('To Date Cannot be Before From Date');
                IF ("From Date" <> 0D) AND ("To Date" <> 0D) THEN begin
                    "Total Days" := "To Date" - "From Date";
                    Validate("To Time");
                end;
                IF "Total Hrs" <> 0 THEN
                    Validate(Quantity, Round("Total Hrs" / 24, 0.01, '='));
            end;
        }
        // field(50008; "From Time"; Decimal)
        // {
        //     DataClassification = ToBeClassified;
        //     DecimalPlaces = 2 : 2;
        //     trigger OnValidate()
        //     begin
        //         IF "From Time" > 24 THEN
        //             Error('From Time is not Valid');
        //         if ("To Time" <> 0) then
        //             Validate("To Time");
        //         IF "Total Hrs" <> 0 THEN
        //             Validate(Quantity, Round("Total Hrs" / 24, 0.01, '='));
        //     end;
        // }
        // field(50009; "To Time"; Decimal)
        // {
        //     DataClassification = ToBeClassified;
        //     DecimalPlaces = 2 : 2;
        //     trigger OnValidate()
        //     begin
        //         IF "From Time" > 24 THEN
        //             Error('To Time is not Valid');

        //         IF "To Time" <> 0 THEN
        //             IF ("From Date" = "To Date") AND ("To Time" < "From Time") then
        //                 Error('To Time cannot be less than from time');
        //         IF "From Time" > "To Time" THEN
        //             "Total Hrs" := ("Total Days" * 24) - ("From Time" - "To Time")
        //         ELSE
        //             IF "From Time" <= "To Time" then
        //                 "Total Hrs" := ("Total Days" * 24) + ("To Time" - "From Time");

        //         IF "Total Hrs" <> 0 THEN
        //             Validate(Quantity, Round("Total Hrs" / 24, 0.01, '='));
        //     end;
        // }

        field(50008; "From Time"; Time)
        {
            DataClassification = ToBeClassified;
            //DecimalPlaces = 2 : 2;
            trigger OnValidate()
            begin
                // IF "From Time" > 24 THEN
                //     Error('From Time is not Valid');
                if ("To Time" <> 0T) then
                    Validate("To Time");
                IF "Total Hrs" <> 0 THEN
                    Validate(Quantity, Round("Total Hrs" / 24, 0.01, '='));
            end;
        }
        field(50009; "To Time"; Time)
        {

            DataClassification = ToBeClassified;
            //DecimalPlaces = 2 : 2;
            trigger OnValidate()
            begin
                // IF "From Time" > 24 THEN
                //     Error('To Time is not Valid');

                IF "To Time" <> 0T THEN
                    IF ("From Date" = "To Date") AND ("To Time" < "From Time") then
                        Error('To Time cannot be less than from time');
                IF "From Time" > "To Time" THEN
                    "Total Hrs" := ("Total Days" * 24) - (("From Time" - "To Time") / 3600000)
                ELSE
                    IF "From Time" <= "To Time" then
                        "Total Hrs" := ("Total Days" * 24) + (("To Time" - "From Time") / 3600000);

                IF "Total Hrs" <> 0 THEN
                    Validate(Quantity, Round("Total Hrs" / 24, 0.01, '='));
            end;
        }

        field(50010; "Total Days"; Decimal)
        {
            DecimalPlaces = 1 : 5;
        }

        field(50011; "Total Hrs"; Decimal)
        {

        }


    }


    trigger OnAfterInsert()
    begin
        InitJobPlanningLine();
    end;


    var
        myInt: Integer;
        TotalToTime: Duration;
        "to time in text": Text[11];
        "from time in text": Text[11];
        "to time in decimal": Decimal;
        "from time in decimal": Decimal;
        CalculatedTime: Decimal;


}
//Page 

pageextension 50102 "Ex_PlaningLine" extends "Job Planning Lines"
{
    layout
    {
        addafter("Invoiced Amount (LCY)")
        {
            field("Line Number"; Rec."Line Number")
            { ApplicationArea = All; }
            field("Contract No"; Rec."Contract No")
            { ApplicationArea = All; }
            field("Cost of Revenue"; Rec."Cost of Revenue")
            { ApplicationArea = All; }
            field(Retention; Rec.Retention)
            { ApplicationArea = All; }
            field(Hire; Rec.Hire) { ApplicationArea = All; }
            field("From Date"; Rec."From Date") { ApplicationArea = All; }
            //  field("From Time"; "From Time") { ApplicationArea = All; }
            field(FromTime; FromTime)
            {
                Caption = 'From Time';
                ApplicationArea = All;
                trigger OnValidate()
                var
                    fromT: Time;
                begin
                    IF FromTime <> '' THEN
                        Evaluate(fromT, FromTime);
                    Rec.Validate("From Time", fromT);
                    FromTime := Format(Rec."From Time", 0, '<Hours24>:<Minutes,2>');
                end;
            }

            field("To Date"; Rec."To Date") { ApplicationArea = All; }
            // field("To Time"; "To Time") { ApplicationArea = All; }
            field(ToTime; ToTime)
            {
                Visible = false;
                ApplicationArea = All;
                Caption = 'To Time';
                trigger OnValidate()
                var
                    TimeT: Time;
                begin
                    if "ToTime" <> '' then
                        Evaluate(TimeT, ToTime);
                    Rec.Validate("To Time", TimeT);
                    ToTime := Format(Rec."To Time", 0, '<Hours24>:<Minutes,2>');
                end;
            }
            field("Total Days"; Rec."Total Days")
            {
                Visible = false;
                ApplicationArea = All;
            }

        }
    }

    actions
    {

        addlast(Creation)
        {
            Action("Create Lines")
            {
                ApplicationArea = All;
                Caption = 'Aramco Template';
                Promoted = true;
                PromotedOnly = true;
                Image = CreateForm;
                trigger OnAction();
                var
                    JobLineSelRec: Record "Job Line Selection";
                    JobLienPage: Page "Job Line selection";
                    jobPlanLine: Record "Job Planning Line";
                    SingInsCodeUnit: Codeunit "Single Instant Codeunit";

                begin
                    JobPlanLine.Reset();
                    SingInsCodeUnit.SetJobNo(Rec."Job No.");
                    SingInsCodeUnit.SetJobTaskNo(Rec."Job Task No.");
                    JobLineSelRec.Reset();
                    JobLienPage.SetTableView(JobLineSelRec);
                    JobLienPage.RunModal();
                    CurrPage.Update(true);
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        ToTime := Format(Rec."To Time", 0, '<Hours24>:<Minutes,2>');
        FromTime := Format(Rec."From Time", 0, '<Hours24>:<Minutes,2>');
    end;

    var
        t: Integer;
        ToTime: Text;
        FromTime: Text;

    procedure UpdatePage()
    begin
        CurrPage.Update(true);
    end;
}
