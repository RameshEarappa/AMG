report 60002 "Update Currency Code of GLE"
{
    // UsageCategory = Administration;
    //ApplicationArea = All;
    UseRequestPage = false;
    ProcessingOnly = true;
    Permissions = TableData 17 = RIMD, TableData 32 = RIMD, TableData 5802 = RIMD, TableData 25 = RIMD, TableData 380 = RIMD, TableData 271 = RIMD, TableData 21 = RIMD, TableData 379 = RIMD;

    dataset
    {
    }
    requestpage
    {
        layout
        {
            area(Content)
            {

            }
        }

    }
    trigger OnPostReport()
    var
        RecGLEntry: Record "G/L Entry";
        RecILE: Record "Item Ledger Entry";
        RecVE: Record "Value Entry";
        RecVLE: Record "Vendor Ledger Entry";
        RecDVLE: Record "Detailed Vendor Ledg. Entry";
        RecCLE: Record "Cust. Ledger Entry";
        RecDCLE: Record "Detailed Cust. Ledg. Entry";
        RecBALE: Record "Bank Account Ledger Entry";
    begin
        Clear(RecGLEntry);
        RecGLEntry.SetFilter("Entry No.", '<>%1', 0);
        if RecGLEntry.FindSet() then begin
            if not Confirm('Are you sure you want to update the Currency Code of GL Entries?', false) then exit;
            repeat
                Clear(RecVLE);
                RecVLE.SetRange("Document No.", RecGLEntry."Document No.");
                RecVLE.SetRange("Transaction No.", RecGLEntry."Transaction No.");
                if RecVLE.FindFirst() then begin
                    RecGLEntry."Currency Code" := RecVLE."Currency Code";
                    RecGLEntry.Modify();
                end else begin
                    Clear(RecCLE);
                    RecCLE.SetRange("Document No.", RecGLEntry."Document No.");
                    RecCLE.SetRange("Transaction No.", RecGLEntry."Transaction No.");
                    if RecCLE.FindFirst() then begin
                        RecGLEntry."Currency Code" := RecCLE."Currency Code";
                        RecGLEntry.Modify();
                    end;
                end;
            until RecGLEntry.Next() = 0;
        end;
        Message('Process completed.');
    end;

    // var
    //     RecGLEntry3: Record "G/L Entry";
    //     RecGLEntry2: Record "G/L Entry";
}
