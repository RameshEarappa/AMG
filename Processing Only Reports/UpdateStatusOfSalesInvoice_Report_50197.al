report 50195 "Update SI Status"
{
    //UsageCategory = Administration;
    //ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {

    }


    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(DocumentNos; DocumentNos)
                    {
                        ApplicationArea = All;
                        Caption = 'Document No.';
                    }
                }
            }
        }

        actions
        {
        }
    }


    trigger OnPostReport()
    var
        SHeader: Record "Sales Header";
        ReleaseDoc: Codeunit "Release Sales Document";
        RestrictionMgmt: Codeunit "Record Restriction Mgt.";
    begin
        if DocumentNos = '' then
            exit;
        if DocumentNos <> '' then begin
            Clear(SHeader);
            SHeader.SetRange("Document Type", SHeader."Document Type"::Invoice);
            SHeader.SetFilter("No.", DocumentNos);
            if SHeader.FindSet() then begin
                repeat
                    RestrictionMgmt.AllowRecordUsage(SHeader);
                    SHeader.SetHideValidationDialog(true);
                    ReleaseDoc.PerformManualRelease(SHeader);
                    SHeader.Modify();
                until SHeader.Next() = 0;
            end;
        end;
    end;

    var
        DocumentNos: Text;
}