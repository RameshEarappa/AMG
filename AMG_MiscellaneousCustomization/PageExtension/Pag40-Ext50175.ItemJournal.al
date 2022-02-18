pageextension 50175 "Ext - Item Journal" extends "Item Journal"
{
    layout
    {
        // Add changes to page layout here
        addafter(Quantity)
        {
            field("OB Lot No."; Rec."OB Lot No.")
            {
                ApplicationArea = all;
                Editable = true;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(ItemTrackingLines)
        {
            action("Update Lot/Serial")
            {
                ApplicationArea = all;
                Caption = 'Update Lot/Serial';
                Image = Reserve;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    UpdateLot: Report "Update Lot No.";
                begin
                    IF NOT CONFIRM('Do you want to Update the Lot No.') THEN
                        EXIT;
                    UpdateLot.UseRequestPage := false;
                    UpdateLot.RunModal();

                end;
            }
        }
    }

    var
        myInt: Integer;
}