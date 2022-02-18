pageextension 50114 "Customer List Ext" extends "Customer List"
{
    layout
    {
        addafter("Location Code")
        {
            field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
            {
                ApplicationArea = all;
                Caption = 'Segments';
            }
        }
    }
    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        Recusersetup.reset;
        if Recusersetup.GET(UserId) then;

        if not recusersetup."Access Customer Master" then
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

        if not recusersetup."Access Customer Master" then
            Error('Current user does not have rights to modify the Customer master');
    end;

    var
        Recusersetup: Record "User Setup";
}