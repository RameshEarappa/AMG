tableextension 50405 "Ext VAT Entry" extends "VAT Entry"
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
        field(60000; "Bill-To/Pay-to Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }
}