tableextension 50150 "Extend Order Address" extends "Order Address"
{
    fields
    {
        field(50000; "VAT Reg. No"; Code[20]) { }
    }

    var
        myInt: Integer;
}

pageextension 50150 "Extend Order Addresses" extends "Order Address"
{
    layout
    {
        addafter(County)
        {
            field("VAT Reg. No"; Rec."VAT Reg. No")
            {
                ApplicationArea = all;
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