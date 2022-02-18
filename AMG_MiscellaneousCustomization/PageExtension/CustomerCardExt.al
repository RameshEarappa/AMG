pageextension 50137 "Customer Card Ext" extends "Customer Card"
{
    layout
    {
        addafter("Last Date Modified")
        {
            field("Shortcut Dimension 7 Code_Dim"; Rec."Shortcut Dimension 7 Code_Dim")
            {
                ApplicationArea = all;
            }
            field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
            {
                ApplicationArea = all;
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

    trigger OnAfterGetRecord()
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

    trigger OnAfterGetCurrRecord()
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


    var
        Recusersetup: Record "user setup";

    var
        myInt: Integer;
}