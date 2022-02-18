page 50113 "Vessel Selection List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Vessel Selection";
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Vessel No."; Rec."Vessel No.") { ApplicationArea = All; }
                field(Running; Rec.Running) { ApplicationArea = All; }
                field("Contract Durtion from date"; Rec."Contract Durtion from date") { ApplicationArea = All; }

                field("Contract Durtion to date"; Rec."Contract Durtion to date") { ApplicationArea = All; }

                field("Contract Durtion from Time"; Rec."Contract Durtion from Time") { ApplicationArea = All; }

                field("Contract Durtion to Time"; Rec."Contract Durtion to Time") { ApplicationArea = All; }
                field("Extension from date"; Rec."Extension from date") { ApplicationArea = All; }

                field("Extension to date"; Rec."Extension to date") { ApplicationArea = All; }
                field("Extension from time"; Rec."Extension from time") { ApplicationArea = all; }

                field("Extension to time"; Rec."Extension to time") { ApplicationArea = all; }
                field("Vessel Delivery Date "; Rec."Vessel Delivery Date ") { ApplicationArea = All; }

                field("Vessel Delivery Time"; Rec."Vessel Delivery Time") { ApplicationArea = all; }

                field("Returned Date"; Rec."Returned Date") { ApplicationArea = All; }

                field("Returned Time"; Rec."Returned Time") { ApplicationArea = all; }
                field("Substitute Date"; Rec."Substitute Date") { ApplicationArea = All; Editable = Rec.Substituted = true; }

                field("Substitute time"; Rec."Substitute time") { ApplicationArea = all; Editable = Rec.Substituted = true; }
                field(Substituted; Rec.Substituted) { ApplicationArea = All; }

                field("Job No."; Rec."Job No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {

    }
}