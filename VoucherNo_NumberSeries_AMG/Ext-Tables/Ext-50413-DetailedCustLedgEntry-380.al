tableextension 50413 "Ext Detailed Vend Ledg. Entry" extends "Detailed Vendor Ledg. Entry"
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
    }
}