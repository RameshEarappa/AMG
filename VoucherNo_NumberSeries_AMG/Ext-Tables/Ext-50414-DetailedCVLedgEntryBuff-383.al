tableextension 50414 "Ext Detd CV Ledg. Entry Buffer" extends "Detailed CV Ledg. Entry Buffer"
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