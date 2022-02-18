pageextension 50128 "Sales Stat Ext" extends "Sales Statistics"
{
    layout
    {
        // Add changes to page layout here
        addafter(VATAmount)
        {
            field("Witholding Amount"; Rec."Witholding Amount")
            {
                ApplicationArea = All;
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