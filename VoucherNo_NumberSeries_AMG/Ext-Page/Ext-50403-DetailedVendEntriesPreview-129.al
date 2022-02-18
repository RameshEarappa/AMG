pageextension 50403 "Ext Detd Vend Entries Preview" extends "Detailed Vend. Entries Preview"
{
    layout
    {
        addafter("Document No.")
        {
            field("Voucher No."; Rec."Voucher No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }

    }
}

pageextension 50410 "Ext Detd Vend Entries" extends "Detailed Vendor Ledg. Entries"
{
    layout
    {
        addafter("Document No.")
        {
            field("Voucher No."; Rec."Voucher No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }

    }
}