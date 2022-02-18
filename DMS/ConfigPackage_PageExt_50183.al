pageextension 50547 ConfigPack1 extends "Config. Packages"
{
    layout
    {
        // Add changes to page layout here
        modify(Code)
        {
            Width = 22;
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("F&unctions")
        {
            group(Import)
            {
                action("DMS Universal Import")
                {
                    ApplicationArea = All;
                    Image = Import;
                    trigger OnAction()
                    Var
                        DMSXmlport: XmlPort "DMS Universal XMLport";
                    begin
                        DMSXmlport.Run();
                    end;
                }
            }
        }
    }

    var
        myInt: Integer;
}