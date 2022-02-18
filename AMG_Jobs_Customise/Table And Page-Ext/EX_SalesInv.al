tableextension 50103 Ex_SalesLine extends "Sales Line"
{
    fields
    {
        field(50001; "Line Number"; Text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(50002; "Contract No"; Text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(50003; "Cost of Revenue"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50004; Retention; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(50005; "withholding"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Withholding Tax"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50007; Bold; Boolean)
        {

        }
        field(50008; Underline; Boolean) { }

        field(50009; "From Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;

        }
        field(50010; "To Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        // field(50011; "From Time"; Decimal)
        // {
        //     DataClassification = ToBeClassified;
        //     Editable = false;
        // }
        // field(50012; "To Time"; Decimal)
        // {
        //     DataClassification = ToBeClassified;
        //     Editable = false;
        // }
        field(50011; "From Time"; Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50012; "To Time"; Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50013; Hide; Boolean)
        {

        }
    }

    var
        myInt: Integer;
}
pageextension 50103 "Ex_SaleInv" extends "Sales Invoice Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field("Line Number"; Rec."Line Number")
            { ApplicationArea = All; Visible = false; }
            field("Contract No"; Rec."Contract No")
            { ApplicationArea = All; Visible = false; }
            field("Cost of Revenue"; Rec."Cost of Revenue")
            { ApplicationArea = All; Visible = false; }
            Field(Retention; Rec.Retention)
            { ApplicationArea = All; Visible = false; }
            field(withholding; Rec.withholding)
            {
                Visible = false;
                Editable = false;
                ApplicationArea = All;
            }


            field(FromTime; FromTime)
            {
                Visible = false;
                Caption = 'From Time';
                ApplicationArea = All;
                Enabled = false;
                trigger OnValidate()
                var
                    fromT: Time;
                begin
                    IF FromTime <> '' THEN
                        Evaluate(fromT, FromTime);
                    Rec.Validate("From Time", fromT);
                    FromTime := Format(Rec."From Time", 0, '<Hours24>:<Minutes,2>');
                end;
            }

            field("To Date"; Rec."To Date")
            {
                Visible = false;
                ApplicationArea = All;
            }
            // field("To Time"; "To Time") { ApplicationArea = All; }
            field(ToTime; ToTime)
            {
                Visible = false;
                ApplicationArea = All;
                Caption = 'To Time';
                Enabled = false;
                trigger OnValidate()
                var
                    TimeT: Time;
                begin
                    if "ToTime" <> '' then
                        Evaluate(TimeT, ToTime);
                    Rec.Validate("To Time", TimeT);
                    ToTime := Format(Rec."To Time", 0, '<Hours24>:<Minutes,2>');
                end;
            }


        }
        addafter(ShortcutDimCode6)
        {
            field("Withholding Tax"; Rec."Withholding Tax")
            {
                ApplicationArea = All;
            }
            field(Hide; Rec.Hide)
            {
                ApplicationArea = all;

            }
        }


    }
    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        ToTime := Format(Rec."To Time", 0, '<Hours24>:<Minutes,2>');
        FromTime := Format(Rec."From Time", 0, '<Hours24>:<Minutes,2>');
    end;

    var
        FromTime: Text;
        ToTime: Text;
}

pageextension 50219 SalesInvList extends "Sales Invoice List"
{
    layout
    {
        // Add changes to page layout here
        modify("Posting Description")
        {
            Visible = false;
        }
        addafter("Sell-to Customer Name")
        {
            field("Posting Description_"; Rec."Posting Description")
            {
                Caption = 'Posting Description';
                ApplicationArea = All;
            }
            field(UserName; Rec.UserName)
            {

                ApplicationArea = All;
            }
        }

    }

    actions
    {
        // Add changes to page actions here
        addafter("Request Approval")
        {
            group(Update)
            {
                action("Update Status")
                {
                    ApplicationArea = All;
                    Image = UpdateDescription;
                    trigger OnAction()
                    var
                        UpdateStatus: Report "Update SI Status";
                    begin
                        UpdateStatus.RunModal();
                    end;
                }
            }
        }
    }

    var
        myInt: Integer;
}