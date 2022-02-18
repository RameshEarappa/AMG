report 50194 "Update PO Status"
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
        Pheader: Record "Purchase Header";
        ReleaseDoc: Codeunit "Release Purchase Document";
        RestrictionMgmt: Codeunit "Record Restriction Mgt.";
    begin
        if DocumentNos = '' then
            exit;
        if DocumentNos <> '' then begin
            Clear(Pheader);
            Pheader.SetRange("Document Type", Pheader."Document Type"::Order);
            Pheader.SetFilter("No.", DocumentNos);
            if Pheader.FindSet() then begin
                repeat
                    RestrictionMgmt.AllowRecordUsage(Pheader);
                    Pheader.SetHideValidationDialog(true);
                    ReleaseDoc.PerformManualRelease(Pheader);
                    Pheader.Modify();
                until Pheader.Next() = 0;
            end;
        end;
    end;

    var
        DocumentNos: Text;
}
