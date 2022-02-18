page 50109 "Vessel Master List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Vessel Master List';
    SourceTable = "VesselMaster Table";
    CardPageId = 50115;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Vessel No."; Rec."Vessel No.") { ApplicationArea = All; }
                field("GD Value"; Rec."Project Dimention") { ApplicationArea = All; }
                field("Vessels Name"; Rec."Vessels Name") { ApplicationArea = All; }
                field("Vessels Image"; Rec."Vessels Image")
                {
                    StyleExpr = 'Picture';
                    ApplicationArea = All;
                }
                field(IMO; Rec.IMO) { ApplicationArea = All; }
                field("Ship Owner"; Rec."Ship Owner") { ApplicationArea = All; }
                field(Flag; Rec.Flag) { ApplicationArea = All; }
                field("Mortgagee Bank"; Rec."Mortgagee Bank") { ApplicationArea = All; }
                field("Year of Built"; Rec."Year of Built") { ApplicationArea = All; }
                field("Purchase Date"; Rec."Purchase Date") { ApplicationArea = All; }
                field("Vessel type"; Rec."Vessel type") { ApplicationArea = All; }
                field(Size; Rec.Size) { ApplicationArea = All; }
                field("Deck Area"; Rec."Deck Area") { ApplicationArea = All; }
                field("Crane Capacity"; Rec."Crane Capacity") { ApplicationArea = All; }
                field("Other Description"; Rec."Other Description") { ApplicationArea = All; }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}