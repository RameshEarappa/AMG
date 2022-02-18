page 50155 "Coordinator List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Coordinator;
    Caption = 'Coordinator List';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Unique Coordinator Code';
                }
                field("Coordinator Name"; Rec."Coordinator Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Coordinator Name ';
                }
            }
        }
    }


    var
        myInt: Integer;
}