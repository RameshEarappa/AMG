pageextension 50100 "CompanyInformation Ext" extends "Company Information"
{
    layout
    {
        modify("E-Mail")
        {
            Caption = 'E-Mail 1';
        }
        addafter("E-Mail")
        {
            field("E-Mail 2"; Rec."E-Mail 2")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}