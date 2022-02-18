pageextension 50549 "Ext Purchase Invoice" extends "Purchase Invoice"
{
    layout
    {
        modify("Purchaser Code") { Visible = false; }
        modify("Campaign No.") { Visible = false; }
        modify("Responsibility Center") { Visible = false; }
        modify("Assigned User ID") { Visible = false; }
        modify("Order Address Code") { Visible = false; }
        moveafter("Vendor Invoice No."; "Currency Code")
        moveafter("Vendor Invoice No."; "VAT Bus. Posting Group")
        moveafter("Vendor Invoice No."; "Payment Terms Code")
        moveafter("Vendor Invoice No."; "Shortcut Dimension 1 Code")
        moveafter("Vendor Invoice No."; "Shortcut Dimension 2 Code")
        moveafter("Vendor Invoice No."; "Location Code")
    }
    actions
    {
        modify(Post)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                Rec.TESTFIELD("Payment Terms Code");
                Rec.TESTFIELD("Document Date");
                Rec.TESTFIELD("Due Date");
            end;
        }

    }
}