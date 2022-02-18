pageextension 60114 VATEntryExtension extends "VAT Entries"
{
    layout
    {
        addafter("Bill-to/Pay-to No.")
        {
            field("Bill-To/Pay-to Name"; Rec."Bill-To/Pay-to Name")
            {
                ApplicationArea = All;
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        myInt: Integer;
        RecVendor: Record Vendor;
        RecCust: Record customer;
    begin
        recvendor.reset;
        if recvendor.GET(Rec."Bill-to/Pay-to No.") then
            Rec.VALIDATE("Bill-To/Pay-to Name", RecVendor.Name);

        Reccust.Reset;
        if RecCust.GET(Rec."Bill-to/Pay-to No.") then
            Rec.VALIDATE("Bill-To/Pay-to Name", RecCust.Name);

    end;



    var
        myInt: Integer;
}