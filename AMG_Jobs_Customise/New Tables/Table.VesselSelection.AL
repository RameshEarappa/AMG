table 50109 "Vessel Selection"
{
    DataClassification = ToBeClassified;
    Caption = 'Vessel Selection';
    LookupPageId = "Vessel Selection List";
    fields
    {
        field(24; "Job No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Vessel No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "VesselMaster Table";
        }
        field(6; Running; Boolean) { DataClassification = ToBeClassified; }
        field(7; "Contract Durtion from date"; Date) { DataClassification = ToBeClassified; }

        field(13; "Contract Durtion to date"; Date) { DataClassification = ToBeClassified; }

        field(14; "Contract Durtion from Time"; Time) { DataClassification = ToBeClassified; }

        field(15; "Contract Durtion to Time"; Time) { DataClassification = ToBeClassified; }


        field(8; "Extension from date"; Date) { DataClassification = ToBeClassified; }

        field(16; "Extension to date"; Date) { DataClassification = ToBeClassified; }

        field(17; "Extension from time"; Time) { DataClassification = ToBeClassified; }

        field(18; "Extension to time"; Time) { DataClassification = ToBeClassified; }
        field(9; "Vessel Delivery Date "; Date) { DataClassification = ToBeClassified; }

        field(19; "Vessel Delivery Time"; Time) { DataClassification = ToBeClassified; }
        field(10; "Returned Date"; Date) { DataClassification = ToBeClassified; }

        field(20; "Returned Time"; Time) { DataClassification = ToBeClassified; }
        field(11; "Substitute Date"; Date) { DataClassification = ToBeClassified; }

        field(21; "Substitute time"; Time) { DataClassification = ToBeClassified; }
        field(12; "Substituted"; Boolean) { DataClassification = ToBeClassified; }


    }

    keys
    {
        key(PK; "Vessel No.", "Job No.") { Clustered = true; }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Vessel No.", "Job No.")
        {

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