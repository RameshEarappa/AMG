tableextension 50404 "Ext Vendor Ledger Entry" extends "Vendor Ledger Entry"
{
    fields
    {
        field(50400; "Voucher No."; Code[20])
        {
            DataClassification = ToBeClassified;
            trigger
            OnValidate()
            begin

            end;
        }
        field(50430; Narration; Text[250])
        {
        }
        field(50440; "PO No."; Code[20])
        {
            TableRelation = "Purchase Header";
        }
    }
}