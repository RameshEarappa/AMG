tableextension 50108 DimValue extends "Dimension Value"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Segment"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('SEGEMENTS'));
        }
    }

    var
        myInt: Integer;
}