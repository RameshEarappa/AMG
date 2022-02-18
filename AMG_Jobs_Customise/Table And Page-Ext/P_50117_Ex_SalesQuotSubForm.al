pageextension 50117 Ex_SaleQuote_Subform extends "Sales Quote Subform"
{
    layout
    {
        addafter(Description)
        {
            field(Bold; Rec.Bold) { ApplicationArea = all; }
            field(Underline; Rec.Underline) { ApplicationArea = all; }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
