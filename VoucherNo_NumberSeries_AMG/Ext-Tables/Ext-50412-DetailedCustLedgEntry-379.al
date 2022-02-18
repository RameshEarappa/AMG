tableextension 50412 "Ext Detailed Cust. Ledg. Entry" extends "Detailed Cust. Ledg. Entry"
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