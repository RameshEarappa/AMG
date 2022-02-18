table 50108 "VesselMaster Table"
{
    DataClassification = ToBeClassified;
    Caption = 'Vessel Master';
    LookupPageId = "Vessel Master List";

    fields
    {
        field(5; "Vessel No."; Code[20]) { DataClassification = ToBeClassified; }
        field(6; "Project Dimention"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vessel Dimension';
            //TableRelation = Dimension;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1), Blocked = CONST(false));
            /*  trigger OnLookup()
              begin
                  IF GlSetupRec.get then begin
                      DimValRec.Reset();
                      DimValRec.SetRange("Dimension Code", GlSetupRec."Global Dimension 1 Code");
                      DimValRec.SetRange(Code, "Project Dimention");
                      if page.RunModal(Page::"Dimension Values", DimValRec) = Action::LookupOK then
                          "Project Dimention" := DimValRec.Code;
                  end;
              End;
              */
        }
        field(7; "Vessels Name"; Text[50]) { }
        field(8; "Vessels Image"; Blob)
        {
            Subtype = Bitmap;
        }
        field(9; IMO; Code[20]) { }
        field(10; "Ship Owner"; Text[50]) { }
        field(11; Flag; Code[30]) { }
        field(12; "Mortgagee Bank"; Text[50]) { }
        field(13; "Year of Built"; Date) { }
        field(14; "Purchase Date"; Date) { }
        field(15; "Vessel type"; Option)
        {
            OptionMembers = ,AHTS,TUG,Barge;
        }
        field(16; Size; Decimal) { }
        field(17; "Deck Area"; Text[50]) { }
        field(18; "Crane Capacity"; Text[50]) { }
        field(19; "Other Description"; Text[50]) { }
    }

    keys
    {
        key(PK; "Vessel No.", "Project Dimention") { Clustered = true; }
    }
    var
        GlSetupRec: Record "General Ledger Setup";
        DimValRec: Record "Dimension Value";
        DimValPage: Page "Dimension Values";

}