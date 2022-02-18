tableextension 50126 "Ex_Sales Cr.Memo Line" extends "Sales Cr.Memo Line"
{
    fields
    {

        field(50005; "withholding"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50006; "Withholding Tax"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
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
    }

    var
        myInt: Integer;
}
pageextension 50134 "eX_Posted Sales Cr.MemoSubform" extends "Posted Sales Cr. Memo Subform"
{
    layout
    {
        addafter("Deferral Code")
        {
            field(withholding; Rec.withholding)
            {
                ApplicationArea = ALL;
            }
            field("Withholding Tax"; Rec."Withholding Tax")
            {
                ApplicationArea = ALL;
            }
            field("From Date"; Rec."From Date")
            {
                ApplicationArea = ALL;
            }
            field("To Date"; Rec."To Date")
            {
                ApplicationArea = ALL;
            }
            field("From Time"; Rec."From Time")
            {
                ApplicationArea = ALL;
            }
            field("To Time"; Rec."To Time")
            {
                ApplicationArea = ALL;
            }
        }
    }

    actions
    {

    }

    var
        myInt: Integer;
}
