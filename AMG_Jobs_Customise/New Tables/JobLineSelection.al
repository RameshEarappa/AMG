table 50101 "Job Line Selection"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Job Line selection";
    fields
    {
        /*field(1; "Job No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Job;

        }
        field(2; "Job Task No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Job Task"."Job Task No." WHERE ("Job No." = FIELD ("Job No."));

        }
        */
        field(1; "Entry No"; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Type"; Option)
        {
            OptionMembers = Resource,Item,"G/L Account","Text";
            DataClassification = ToBeClassified;

        }
        field(3; "Line Number"; Text[30])
        {
            DataClassification = ToBeClassified;

        }
        field(4; "S No."; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Contract No"; Text[30])
        {
            DataClassification = ToBeClassified;

        }
        field(6; "No."; Text[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF (Type = CONST(Resource)) Resource ELSE
            IF (Type = CONST(Item)) Item ELSE
            IF (Type = CONST("G/L Account")) "G/L Account" ELSE
            IF (Type = CONST(Text)) "Standard Text";
            trigger OnValidate()
            begin
                if Type = Type::Item then begin
                    If ItemRec.Get("No.") then
                        "Description " := ItemRec.Description;
                end;
                if Type = Type::"G/L Account" then begin
                    if GlAcc.Get("No.") then
                        "Description " := GlAcc.Name;
                end;
                if Type = Type::Text then begin
                    if StdTxtRec.Get("No.") then
                        "Description " := StdTxtRec.Description;
                end;
                if Type = Type::Resource then begin
                    if ResourceRec.Get("No.") then
                        "Description " := ResourceRec.Name;
                end;


            end;


        }
        field(7; "Description "; Text[250])
        {
            DataClassification = ToBeClassified;

        }
        field(50003; "Cost of Revenue"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50004; Retention; Boolean)
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(PK; "Entry No")
        {
            Clustered = true;
        }
        key(PK2; "S No.")
        {

        }

    }

    var
        myInt: Integer;
        ResourceRec: Record Resource;
        ItemRec: Record Item;
        GlAcc: Record "G/L Account";
        StdTxtRec: Record "Standard Text";

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