page 60117 "Product Type List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Product Type";
    Caption = 'Product Type';
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Product Type Code"; Rec."Product Type Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}