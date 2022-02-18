/*pageextension 50108 ArabiLanguage extends Languages
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addlast(Creation)
        {
            Action("Arabic Description")
            {
                ApplicationArea = All;
                Caption = 'Arabic Description';
                Promoted = true;
                PromotedOnly = true;
                Image = CreateForm;
                trigger OnAction();
                var
                    JobLineSelRec: Page "Arabic description";

                begin
                    JobLineSelRec.Run();
                end;
            }
        }
    }

    var
        myInt: Integer;
}
*/