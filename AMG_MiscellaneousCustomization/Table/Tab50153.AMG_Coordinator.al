table 50153 "Coordinator"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Coordinator List";
    DrillDownPageId = "Coordinator List";

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;

        }
        field(2; "Coordinator Name"; Text[50])
        {
            Caption = 'Coordinator Name';
            DataClassification = CustomerContent;

        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}