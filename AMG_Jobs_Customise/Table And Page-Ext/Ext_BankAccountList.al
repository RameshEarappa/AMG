pageextension 50122 Ext_BankAccList extends "Bank Account List"
{
    layout
    {
        addafter(Contact)
        {
            field(Balance; Rec.Balance)
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Balance (LCY)"; Rec."Balance (LCY)")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Net Change"; Rec."Net Change")
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