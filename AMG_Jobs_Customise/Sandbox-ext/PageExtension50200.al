pageextension 50200 PageExtension50100 extends "Item Card"
{
    layout
    {
        addafter(Blocked)
        {
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = All;
            }
        }
        modify("No.")
        {
            ShowMandatory = true;
        }
        modify(Description)
        {
            ShowMandatory = true;
        }
        modify("Item Category Code")
        {
            ShowMandatory = true;
        }
        modify("Base Unit of Measure")
        {
            ShowMandatory = true;
        }
        modify("Costing Method")
        {
            ShowMandatory = true;
        }
        modify("Gen. Prod. Posting Group")
        {
            ShowMandatory = true;
        }
        modify("VAT Prod. Posting Group")
        {
            ShowMandatory = true;
        }
        modify("Inventory Posting Group")
        {
            ShowMandatory = true;
        }
        modify("Item Tracking Code")
        {
            ShowMandatory = true;
        }

    }
    actions
    {
        addafter(Comment)
        {
            action("Check Mandatory")
            {
                Image = SuggestField;
                Promoted = true;
                PromotedOnly = true;
                Caption = 'Check Mandatory';
                ApplicationArea = all;
                trigger OnAction()
                begin
                    Rec.Testfield("No.");
                    Rec.Testfield(Description);
                    Rec.Testfield("Item Category Code");
                    Rec.Testfield("Base Unit of Measure");
                    Rec.Testfield("Costing Method");
                    Rec.Testfield("Gen. Prod. Posting Group");
                    Rec.Testfield("VAT Prod. Posting Group");
                    Rec.Testfield("Inventory Posting Group");
                    Rec.Testfield("Item Tracking Code");
                end;
            }
        }
    }
    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        Recusersetup.reset;
        if Recusersetup.GET(UserId) then;

        if not recusersetup."Access Item Master" then
            CurrPage.Editable := False
        else
            Currpage.Editable := True;
    end;

    trigger OnModifyRecord(): Boolean
    var
        myInt: Integer;
    begin
        Recusersetup.reset;
        if Recusersetup.GET(UserId) then;

        if not recusersetup."Access Item Master" then
            Error('Current user does not have rights to modify the item master');
    end;

    var
        myInt: Integer;
        Recusersetup: Record "user setup";
}
