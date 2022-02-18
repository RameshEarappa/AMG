tableextension 50415 "Ext CV Ledger Entry Buffer" extends "CV Ledger Entry Buffer"
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