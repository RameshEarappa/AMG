page 50101 "Job Line selection"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Job Line Selection";
    AutoSplitKey = true;
    layout
    {
        area(Content)
        {
            repeater(Group)
            //group("GroupName")
            {
                /*field("Job No."; "Job No.")
                {
                    ApplicationArea = All;
                }
                field("Job Task No."; "Job Task No.")
                {
                    ApplicationArea = All;
                }*/
                field("Entry No"; Rec."Entry No")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("Line Number"; Rec."Line Number")
                {
                    ApplicationArea = All;
                }
                field("S No."; Rec."S No.")
                {
                    ApplicationArea = All;
                }
                field("Contract No"; Rec."Contract No")
                {
                    ApplicationArea = All;
                }
                field("G/L Account "; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field("Description "; Rec."Description ")
                {
                    ApplicationArea = all;
                }
                field("Cost of Revenue"; Rec."Cost of Revenue")
                {
                    ApplicationArea = All;
                }
                field(Retention; Rec.Retention)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Create Line")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedOnly = true;
                Image = GetLines;

                trigger OnAction()
                begin
                    jobNoL := SingInsCU.GetJobNO();
                    JobTaskNoL := SingInsCU.GetJobTaskNO();

                    if Rec."S No." <> 0 then begin
                        JobPlanLineRec.Reset();
                        JobPlanLineRec.SetRange("Job No.", jobNoL);
                        JobPlanLineRec.SetRange("Job Task No.", JobTaskNoL);
                        IF JobPlanLineRec.FindLast() then
                            NewLNo := JobPlanLineRec."Line No.";

                        CurrPage.SetSelectionFilter(Rec3);
                        Rec3.SetCurrentKey("S No.");
                        IF Rec3.FindFirst() then
                            repeat
                                IF Rec3."S No." <> SrNo THEN begin
                                    SrNo := Rec3."S No.";
                                    Rec2.Reset();
                                    Rec2.SetCurrentKey("S No.");
                                    Rec2.SetRange("S No.", Rec3."S No.");
                                    if Rec2.FindSet() then begin
                                        repeat

                                            JobPlanLineRec2.Init();
                                            JobPlanLineRec2.Validate("Job No.", jobNoL);
                                            JobPlanLineRec2.Validate("Job Task No.", JobTaskNoL);

                                            JobPlanLineRec.Reset();
                                            JobPlanLineRec.SetRange("Job No.", jobNoL);
                                            JobPlanLineRec.SetRange("Job Task No.", JobTaskNoL);
                                            IF JobPlanLineRec.FindLast() then
                                                JobPlanLineRec2."Line No." := JobPlanLineRec."Line No." + 10000
                                            ELSE
                                                JobPlanLineRec2."Line No." := 10000;
                                            JobPlanLineRec2.Validate(Type, Rec2.Type);
                                            JobPlanLineRec2.Validate("Line Number", Rec2."Line Number");
                                            JobPlanLineRec2.Validate("Line Type", JobPlanLineRec2."Line Type"::Billable);
                                            JobPlanLineRec2.Validate("Contract No", Rec2."Contract No");
                                            JobPlanLineRec2.Validate("No.", Rec2."No.");
                                            JobPlanLineRec2.Validate(Description, Rec2."Description ");
                                            JobPlanLineRec2.Validate(Retention, Rec2.Retention);
                                            JobPlanLineRec2.Validate("Cost of Revenue", Rec2."Cost of Revenue");
                                            JobPlanLineRec2.Insert();
                                        until rec2.Next() = 0;
                                    END;
                                End;
                            until Rec3.Next() = 0;
                    end;
                    CurrPage.Close();
                end;
            }
        }
    }
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    Begin
        //Code moved to acton Button

        /*jobNoL := SingInsCU.GetJobNO();
        JobTaskNoL := SingInsCU.GetJobTaskNO();

        if Rec."S No." <> 0 then begin
            JobPlanLineRec.Reset();
            JobPlanLineRec.SetRange("Job No.", jobNoL);
            JobPlanLineRec.SetRange("Job Task No.", JobTaskNoL);
            IF JobPlanLineRec.FindLast() then
                NewLNo := JobPlanLineRec."Line No.";

            CurrPage.SetSelectionFilter(Rec3);
            Rec3.SetCurrentKey("S No.");
            IF Rec3.FindFirst() then
                repeat
                    IF Rec3."S No." <> SrNo THEN begin
                        SrNo := Rec3."S No.";
                        Rec2.Reset();
                        Rec2.SetCurrentKey("S No.");
                        Rec2.SetRange("S No.", Rec3."S No.");
                        if Rec2.FindSet() then begin
                            repeat

                                JobPlanLineRec2.Init();
                                JobPlanLineRec2.Validate("Job No.", jobNoL);
                                JobPlanLineRec2.Validate("Job Task No.", JobTaskNoL);

                                JobPlanLineRec.Reset();
                                JobPlanLineRec.SetRange("Job No.", jobNoL);
                                JobPlanLineRec.SetRange("Job Task No.", JobTaskNoL);
                                IF JobPlanLineRec.FindLast() then
                                    JobPlanLineRec2."Line No." := JobPlanLineRec."Line No." + 10000;

                                JobPlanLineRec2.Validate(Type, Rec2.Type);
                                JobPlanLineRec2.Validate("Line Number", Rec2."Line Number");
                                JobPlanLineRec2.Validate("Line Type", JobPlanLineRec2."Line Type"::Billable);
                                JobPlanLineRec2.Validate("Contract No", Rec2."Contract No");
                                JobPlanLineRec2.Validate("No.", Rec2."No.");
                                JobPlanLineRec2.Validate(Description, Rec2."Description ");
                                JobPlanLineRec2.Validate(Retention, Rec2.Retention);
                                JobPlanLineRec2.Validate("Cost of Revenue", Rec2."Cost of Revenue");
                                JobPlanLineRec2.Insert();
                            until rec2.Next() = 0;
                        END;
                    End;
                until Rec3.Next() = 0; 
                
        end; */
        //Code moved to acton Button
        //JobPlanLine.Update(false);
    End;

    var
        JobPlanLineRec: Record "Job Planning Line";
        SingInsCU: Codeunit "Single Instant Codeunit";
        jobNoL: Code[20];
        JobTaskNoL: Code[20];
        JobPlanLineRec2: Record "Job Planning Line";
        Rec2: Record "Job Line Selection";
        Rec3: Record "Job Line Selection";
        NewLNo: Integer;
        JobPlanLine: Page "Job Planning Lines";
        SrNo: Integer;
}