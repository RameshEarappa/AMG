pageextension 50157 pageextension50157 extends "Purchase Quote"
{
    layout
    {
        addlast(General)
        {
            field(AMG_InitSourceNo; Rec.AMG_InitSourceNo)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the purchase requisition number.';
            }
            field(Backcharge; Rec.Backcharge)
            {
                ApplicationArea = all;
            }
            field("Backcharge To"; Rec."Backcharge To")
            {
                ApplicationArea = all;
                Editable = Rec.Backcharge = Rec.Backcharge::YES;
            }
            field("Mubarak Supplier"; Rec."Mubarak Supplier")
            {
                ApplicationArea = all;
            }
            field("Mubark Supplier Name"; Rec."Mubark Supplier Name")
            {
                ApplicationArea = all;
            }

        }
        modify("Vendor Shipment No.") { Visible = false; }
        modify("Purchaser Code") { Visible = false; }
        modify("Campaign No.") { Visible = false; }
        moveafter("Area"; "Responsibility Center")
        modify("Assigned User ID") { Visible = false; }
        moveafter(Status; "Currency Code")
        moveafter(Status; "VAT Bus. Posting Group")
        moveafter(Status; "Payment Terms Code")
        moveafter(Status; "Shortcut Dimension 1 Code")
        moveafter(Status; "Shortcut Dimension 2 Code")
        moveafter(Status; "Location Code")
        addafter("Shortcut Dimension 1 Code")
        {
            field("Vessel Name"; Rec."Vessel Name")
            {
                ApplicationArea = all;
            }

        }
        modify("Shortcut Dimension 1 Code")
        {
            trigger OnAfterValidate()
            begin
                CurrPage.Update();
            end;
        }
        addafter(Status)
        {
            field("Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = all;

            }
        }


    }
    actions
    {
        modify(MakeOrder)
        {
            trigger
            OnBeforeAction()
            begin
                IF Rec.Backcharge = Rec.Backcharge::" " THEN
                    Error('Please select Backcharge');
            end;
        }
    }

}

