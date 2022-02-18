tableextension 50120 "VAT Bus. Extension" extends "VAT Business Posting Group"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Withholding"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}

pageextension 50121 "Vat bus, Extension Page" extends "VAT Business Posting Groups"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field(Withholding; Rec.Withholding)
            {
                ApplicationArea = All;
                Visible = false;
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

tableextension 50122 "Vat Prod. Ext" extends "VAT Product Posting Group"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Withholding"; Boolean)
        {

        }
    }

    var
        myInt: Integer;
}

pageextension 50123 "Vat Prod Page" extends "VAT Product Posting Groups"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field(Withholding; Rec.Withholding)
            {
                ApplicationArea = all;
                Visible = false;
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