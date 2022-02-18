tableextension 50407 "Ext Check Ledger Entry" extends "Check Ledger Entry"
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
        field(50410; "Check Prepared Date"; Date)
        {
        }
        field(50420; "Check Issued Date"; Date)
        {
        }
    }
}