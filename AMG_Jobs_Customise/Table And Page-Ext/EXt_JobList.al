pageextension 50124 Job_Ext extends "Job List"
{
    layout
    {
        addafter(Status)
        {
            field("Vessel Name"; Rec."Vessel Name")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Bill-to Name"; Rec."Bill-to Name")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Creation Date"; Rec."Creation Date")
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

    var
        myInt: Integer;
}