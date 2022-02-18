tableextension 50115 FA_Ex_Table extends "Fixed Asset"
{
    fields
    {
        field(50000; "Vessel No."; Code[20]) { }
        field(50001; "Vessels Name"; Text[50]) { }
        field(50002; "Vessels Image"; Blob)
        {
            Subtype = Bitmap;
        }
        field(50003; IMO; Code[20]) { }
        field(50004; "Ship Owner"; Text[50]) { }
        field(50005; Flag; Code[30]) { }
        field(50006; "Mortgagee Bank"; Text[50]) { }
        field(50007; "Year of Built"; Date) { }
        field(50008; "Purchase Date"; Date) { }
        field(50009; "Vessel type"; Option)
        {
            OptionMembers = ,AHTS,TUG,Barge;
        }
        field(50010; Size; Decimal) { }
        field(50011; "Deck Area"; Text[50]) { }
        field(50012; "Crane Capacity"; Text[50]) { }
        field(50013; "Other Description"; Text[50]) { }

    }

    var
        myInt: Integer;
}