pageextension 50132 Pos_Purch_RecList extends "Posted Purchase Receipts"
{
    layout
    {
        addbefore("Location Code")
        {
            field("Coordinator Name "; Rec."Coordinator Name")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        addafter("No. Printed")
        {
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Posting Date "; Rec."Posting Date")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Coordinator No."; Rec."Coordinator No.")
            {
                ApplicationArea = all;
                Editable = false;
                Visible = false;
            }
            field("Coordinator Name"; Rec."Coordinator Name")
            {
                ApplicationArea = all;
                Editable = false;
                Visible = false;
            }
            field("User ID"; Rec."User ID")
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