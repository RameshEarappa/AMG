report 60001 "Item Tracking Update"
{
    // UsageCategory = Administration;
    //ApplicationArea = All;
    ProcessingOnly = true;
    Permissions = TableData 27 = RIMD;

    dataset
    {
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(General)
                {
                    field("Item No."; FilterText)
                    {
                        ApplicationArea = All;
                        TableRelation = Item."No.";
                    }
                    field("Item Tracking Code"; TrackingCode)
                    {
                        ApplicationArea = All;
                        TableRelation = "Item Tracking Code".Code;
                    }
                }
            }
        }
        trigger OnQueryClosePage(CloseAction: Action): Boolean
        var
            RecItemL: Record Item;
        begin
            If CloseAction IN [ACTION::OK, ACTION::LookupOK] then begin
                if (FilterText <> '') AND (TrackingCode <> '') then begin
                    Clear(RecItemL);
                    RecItemL.SetFilter("No.", FilterText);
                    if RecItemL.FindSet() then
                        repeat
                            RecItemL."Item Tracking Code" := TrackingCode;
                            RecItemL.Modify;
                        until RecItemL.Next() = 0;
                    Message('Updated Successfully.');
                end
                else
                    Error('Please Select Item No. and Tracking Code.');
            end;
        end;
    }
    trigger OnPostReport()
    var
    begin
    end;

    var
        FilterText: Text;
        TrackingCode: code[20];
        RecItem: Record Item;
}
