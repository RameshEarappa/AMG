pageextension 60121 AccscheExt extends "Account Schedule Names"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        RecUsersetup.Reset;
        if RecUsersetup.GET(UserId) then;

        if not RecUsersetup."Access Account Schedules" then
            ERROR('There is no permission for the current user');
    end;

    var
        myInt: Integer;
        RecUsersetup: record "User Setup";
}