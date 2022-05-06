tableextension 50109 "Excel Buffer Ext" extends "Excel Buffer"
{
    fields
    {
        field(50000; "Cell Value as Text_LT"; Text[2048])
        {
            Caption = 'Cell Value as Text';
            DataClassification = ToBeClassified;
            ObsoleteState = Pending;
        }
    }
}
