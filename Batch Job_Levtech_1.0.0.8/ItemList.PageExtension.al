pageextension 60001 ItemList extends "Item List"
{
    actions
    {
        // Add changes to page actions here
        // Add changes to page actions here
        addafter("Adjust Item Cost/Price")
        {
            action("Update Item Tracking")
            {
                ApplicationArea = All;
                Image = UpdateDescription;

                trigger OnAction()
                begin
                    Report.Run(60001, true, false);
                end;
            }
        }
    }
    var
        myInt: Integer;
}
