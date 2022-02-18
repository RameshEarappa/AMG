pageextension 50402 "Ext Bank Acc Ledg Entr Preview" extends "Bank Acc. Ledg. Entr. Preview"
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
            field(Narration; Rec.Narration)
            {
                ApplicationArea = all;
                Editable = false;
            }
        }

    }
}

pageextension 50408 "Ext Bank Acc Ledg Entr" extends "Bank Account Ledger Entries"
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