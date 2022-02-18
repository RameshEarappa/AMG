pageextension 60115 VendorCardExt extends "Vendor Card"
{
    layout
    {
        modify("No.")
        {
            ShowMandatory = true;
        }
        modify(Name)
        {
            ShowMandatory = true;
        }
        modify("Location Code")
        {
            ShowMandatory = true;
        }
        modify("Phone No.")
        {
            ShowMandatory = true;
        }
        modify("Search Name")
        {
            ShowMandatory = true;
        }
        modify(Address)
        {
            ShowMandatory = true;
        }
        modify("Address 2")
        {
            ShowMandatory = true;
        }
        modify("Country/Region Code")
        {
            ShowMandatory = true;
        }

        modify("E-Mail")
        {
            ShowMandatory = true;
        }
        modify("VAT Registration No.")
        {
            ShowMandatory = true;
        }
        modify("Payment Terms Code")
        {
            ShowMandatory = true;
        }

        addlast(General)
        {

            field("Product/ Service Type"; Rec."Product/ Service Type")
            {
                ApplicationArea = all;
                ShowMandatory = true;
            }
            field("Sub. Category"; Rec."Sub. Category")
            {
                ApplicationArea = all;
                ShowMandatory = true;
            }

        }
        addlast("Address & Contact")
        {
            field(Mobile_No; Rec.Mobile_No)
            {
                ApplicationArea = all;
            }
            field("E-mail 2"; Rec."E-mail 2")
            {
                ApplicationArea = all;
            }
        }
        addlast(Invoicing)
        {
            field("ICV/ IKTVA"; Rec."ICV/ IKTVA")
            {
                ApplicationArea = all;
                ShowMandatory = true;

                trigger onvalidate()
                var
                    myInt: Integer;
                begin
                    ExpiryDateEdit := True;
                    if Rec."ICV/ IKTVA" = Rec."ICV/ IKTVA"::NO then
                        ExpiryDateEdit := false;
                end;
            }
            field("ICV/ IKTVA Expiry Date"; Rec."ICV/ IKTVA Expiry Date")
            {
                ApplicationArea = all;
                ShowMandatory = true;
                Editable = ExpiryDateEdit;
            }
            field(Score; Rec.Score)
            {
                ApplicationArea = all;
                ShowMandatory = true;
            }
            field("Commercial License No."; Rec."Commercial License No.")
            {
                ApplicationArea = all;
                ShowMandatory = true;
            }
            field("Commercial License Expiry Date"; Rec."Commercial License Expiry Date")
            {
                ApplicationArea = all;
                ShowMandatory = true;
            }
        }
        //28.10.2020
        modify("Our Account No.")
        {
            Visible = false;
        }
        addafter("Home Page")
        {
            field("Our Account No"; Rec."Our Account No")
            {
                ApplicationArea = All;
            }
        }
        //28.10.2020

    }

    actions
    {
        modify(Approve)
        {
            trigger OnBeforeAction()
            begin
                Recusersetup.Reset;
                if Recusersetup.GET(UserId) then;

                if not Recusersetup."Approve Vendor" then begin
                    Error('Current user does not have rights to approve');
                end;
            end;
        }

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

        ExpiryDateEdit := True;
        if Rec."ICV/ IKTVA" = Rec."ICV/ IKTVA"::NO then
            ExpiryDateEdit := false;

    end;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        Recusersetup.reset;
        if Recusersetup.GET(UserId) then;

        if not recusersetup."Access Vendor Master" then
            CurrPage.Editable := False
        else
            Currpage.Editable := True;

        ExpiryDateEdit := True;
        if Rec."ICV/ IKTVA" = Rec."ICV/ IKTVA"::NO then
            ExpiryDateEdit := false;

    end;

    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
    begin
        Recusersetup.reset;
        if Recusersetup.GET(UserId) then;

        if not recusersetup."Access Vendor Master" then
            CurrPage.Editable := False
        else
            Currpage.Editable := True;

        ExpiryDateEdit := True;
        if Rec."ICV/ IKTVA" = Rec."ICV/ IKTVA"::NO then
            ExpiryDateEdit := false;

    end;

    trigger OnModifyRecord(): Boolean
    var
        myInt: Integer;
    begin
        Recusersetup.reset;
        if Recusersetup.GET(UserId) then;

        if not recusersetup."Access Vendor Master" then
            Error('Current user does not have rights to modify the vendor master');

        ExpiryDateEdit := True;
        if Rec."ICV/ IKTVA" = Rec."ICV/ IKTVA"::NO then
            ExpiryDateEdit := false;
    end;


    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        myInt: Integer;

    begin
        Bool := Dialog.Confirm('Do you want to exit');
        if not bool then begin
            Rec.TestField("No.");
            Rec.TestField(Name);
            Rec.TestField("Location Code");
            Rec.TestField("Phone No.");
            Rec.TestField("Search Name");
            Rec.TestField(Address);
            Rec.TestField("Address 2");
            Rec.TestField("Country/Region Code");
            Rec.TestField("E-Mail");
            Rec.TestField("VAT Registration No.");
            Rec.TestField("Payment Terms Code");
            //if "ICV/ IKTVA" <> 
            //TestField("ICV/ IKTVA");
            if ExpiryDateEdit = True then
                Rec.TESTFIELD("ICV/ IKTVA Expiry Date");
            Rec.TestField(Score);
            Rec.TestField("Commercial License No.");
            Rec.TestField("Commercial License Expiry Date");
            Rec.TestField("Product/ Service Type");
            Rec.TestField("Sub. Category");
        end;

    end;

    var
        myInt: Integer;
        Recusersetup: Record "user setup";
        ExpiryDateEdit: Boolean;
        Bool: Boolean;
}