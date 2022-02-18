tableextension 50104 Ex_PosSaleInvLine extends "Sales Invoice Line"
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
        field(50005; "Withholding"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Withholding Tax"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

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
pageextension 50104 "Ex_PosSaleInv" extends "Posted Sales Invoice Subform"
{
    layout
    {
        addafter("Job Task No.")
        {
            field("Line Number"; Rec."Line Number")
            { ApplicationArea = All; Visible = false; }
            field("Contract No"; Rec."Contract No")
            { ApplicationArea = All; Visible = false; }
            field("Cost of Revenue"; Rec."Cost of Revenue")
            { ApplicationArea = All; Visible = false; }
            field(Retention; Rec.Retention)
            { ApplicationArea = All; Visible = false; }


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

            field("To Date"; Rec."To Date") { ApplicationArea = All; Visible = false; }
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
        addafter("ShortcutDimCode[6]")
        {
            field("Withholding Tax"; Rec."Withholding Tax") { ApplicationArea = All; }
            field(Hide; Rec.Hide) { ApplicationArea = all; }
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

