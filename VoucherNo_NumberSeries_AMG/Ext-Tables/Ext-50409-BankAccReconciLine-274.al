tableextension 50409 "Ext Bank Acc. Reconcil Line" extends "Bank Acc. Reconciliation Line"
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