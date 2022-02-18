pageextension 60104 VendorListExt extends "Vendor List"
{
    layout
    {
        //03.11.2020
        addafter("Payments (LCY)")
        {
            field("Product/ Service Type"; Rec."Product/ Service Type")
            {
                ApplicationArea = All;
            }
            field("Sub. Category"; Rec."Sub. Category")
            {
                ApplicationArea = All;
            }
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = All;
            }
            field("ICV/ IKTVA"; Rec."ICV/ IKTVA")
            {
                ApplicationArea = All;
            }
            field("ICV/ IKTVA Expiry Date"; Rec."ICV/ IKTVA Expiry Date")
            {
                ApplicationArea = All;
            }
            field(Score; Rec.Score)
            {
                ApplicationArea = All;
            }
            field("Commercial License No."; Rec."Commercial License No.")
            {
                ApplicationArea = All;
            }
            field("Commercial License Expiry Date"; Rec."Commercial License Expiry Date")
            {
                ApplicationArea = All;
            }
        }
        //03.11.2020
    }

    actions
    {

    }

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        Recusersetup.reset;
        if Recusersetup.GET(UserId) then;

        if not recusersetup."Access Vendor Master" then
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

        if not recusersetup."Access Vendor Master" then
            Error('Current user does not have rights to modify the vendor master');
    end;



    var
        myInt: Integer;
        Recusersetup: Record "User Setup";
}