pageextension 50405 "Ext Vend Ledg Entries Preview" extends "Vend. Ledg. Entries Preview"
{
    layout
    {
        addafter("Document No.")
        {
            field("Voucher No."; Rec."Voucher No.")
            {
                ApplicationArea = All;
            }
            field(Narration; Rec.Narration)
            { ApplicationArea = all; }
            //field("PO No."; "PO No.")
            //{ ApplicationArea = all; }
        }
    }
}

pageextension 50414 "Ext Vend Ledg Entries" extends "Vendor Ledger Entries"
{
    layout
    {
        addafter("Document No.")
        {
            field("Voucher No."; Rec."Voucher No.")
            {
                ApplicationArea = All;
            }
            field("PO No."; Rec."PO No.")
            { ApplicationArea = all; }
            field("Vendor Posting Group"; Rec."Vendor Posting Group")
            {
                ApplicationArea = All;
            }
        }
    }
}

pageextension 50415 "Ext Check Ledger Entries" extends "Check Ledger Entries"
{
    layout
    {
        addafter("Document No.")
        {
            field("Voucher No."; Rec."Voucher No.")
            {
                ApplicationArea = All;
            }

        }
    }

}