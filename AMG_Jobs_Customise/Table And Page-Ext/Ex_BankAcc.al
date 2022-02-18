pageextension 50119 BankACC extends "Bank Account Card"
{
    layout
    {
        addafter("Bank Acc. Posting Group")
        {
            field("Check Report ID"; Rec."Check Report ID")
            {
                ApplicationArea = ALL;
            }
        }
    }

    actions
    {
        addafter(Dimensions)
        {

        }

    }

    var
        myInt: Integer;
}