report 50197 PopulateDimension
{
    //UsageCategory = Administration;
    // ApplicationArea = All;
    ProcessingOnly = true;
    Permissions = tabledata 169 = RIMD;
    dataset
    {
    }

    trigger OnPostReport()
    VAR
        RecDimSetEntry: Record "Dimension Set Entry";
        RecGLSetup: Record "General Ledger Setup";
        RecJobLedger: Record "Job Ledger Entry";
    begin
        Clear(RecJobLedger);
        RecJobLedger.SetFilter("Entry No.", '<>%1', 0);
        RecJobLedger.SetFilter("Dimension Set ID", '<>%1', 0);
        if RecJobLedger.FindSet() then begin
            if not Confirm('Are you sure you want to update the Shortcut Dimension 3 and 6 for all job Ledger Entries?', false) then
                exit;
            RecGLSetup.GET;
            repeat
                Clear(RecDimSetEntry);
                RecDimSetEntry.SetRange("Dimension Set ID", RecJobLedger."Dimension Set ID");
                RecDimSetEntry.SetRange("Dimension Code", RecGLSetup."Shortcut Dimension 3 Code");
                if RecDimSetEntry.FindFirst() then
                    RecJobLedger."Shortcut Dimension 3 Code" := RecDimSetEntry."Dimension Value Code";
                Clear(RecDimSetEntry);
                RecDimSetEntry.SetRange("Dimension Set ID", RecJobLedger."Dimension Set ID");
                RecDimSetEntry.SetRange("Dimension Code", RecGLSetup."Shortcut Dimension 6 Code");
                if RecDimSetEntry.FindFirst() then
                    RecJobLedger."Shortcut Dimension 6 Code" := RecDimSetEntry."Dimension Value Code";
                RecJobLedger.Modify();
            until RecJobLedger.Next() = 0;
            Message('Process completed.');
        end;
    end;

    var
        myInt: Integer;
}