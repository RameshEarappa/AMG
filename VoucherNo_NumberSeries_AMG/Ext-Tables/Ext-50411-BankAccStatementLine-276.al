tableextension 50411 "Ext Bank Acc Statement Line" extends "Bank Account Statement Line"
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