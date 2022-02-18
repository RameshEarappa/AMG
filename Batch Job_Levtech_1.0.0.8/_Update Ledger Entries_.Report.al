report 60000 "Update Ledger Entries"
{
    // UsageCategory = Administration;
    //ApplicationArea = All;
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
                group(General)
                {
                    field("G/L Acc Filter"; FilterText)
                    {
                        ApplicationArea = All;
                        Caption = 'G/L Acc Filter';
                        TableRelation = "G/L Account"."No.";
                    }
                    field(PostingDate; PostingDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Posting Date';
                    }
                }
            }
        }
        trigger OnQueryClosePage(CloseAction: Action): Boolean
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
            If CloseAction IN [ACTION::OK, ACTION::LookupOK] then begin
                if (FilterText <> '') AND (PostingDate <> 0D) then begin
                    Clear(RecGLEntry);
                    RecGLEntry.SetFilter("G/L Account No.", '=%1', FilterText);
                    if RecGLEntry.FindSet() then begin
                        if not Confirm('Are you sure you want to update the Ledger Entries?', false) then exit;
                        repeat
                            Clear(RecGLEntry2);
                            RecGLEntry2.SetRange("Document No.", RecGLEntry."Document No.");
                            if RecGLEntry2.FindSet() then begin
                                repeat
                                    Clear(RecILE);
                                    RecILE.SetRange("Document No.", RecGLEntry2."Document No.");
                                    //RecILE.SetRange("Posting Date", RecGLEntry2."Posting Date");
                                    if RecILE.FindSet() then RecILE.ModifyAll("Posting Date", PostingDate);
                                    Clear(RecVE);
                                    RecVE.SetRange("Document No.", RecGLEntry2."Document No.");
                                    //RecVE.SetRange("Posting Date", RecGLEntry2."Posting Date");
                                    if RecVE.FindSet() then RecVE.ModifyAll("Posting Date", PostingDate);
                                    //
                                    Clear(RecVLE);
                                    RecVLE.SetRange("Document No.", RecGLEntry2."Document No.");
                                    //RecVLE.SetRange("Posting Date", RecGLEntry2."Posting Date");
                                    if RecVLE.FindSet() then RecVLE.ModifyAll("Posting Date", PostingDate);
                                    Clear(RecDVLE);
                                    RecDVLE.SetRange("Document No.", RecGLEntry2."Document No.");
                                    // RecDVLE.SetRange("Posting Date", RecGLEntry2."Posting Date");
                                    if RecDVLE.FindSet() then RecDVLE.ModifyAll("Posting Date", PostingDate);
                                    Clear(RecCLE);
                                    RecCLE.SetRange("Document No.", RecGLEntry2."Document No.");
                                    //RecCLE.SetRange("Posting Date", RecGLEntry2."Posting Date");
                                    if RecCLE.FindSet() then RecCLE.ModifyAll("Posting Date", PostingDate);
                                    Clear(RecDCLE);
                                    RecDCLE.SetRange("Document No.", RecGLEntry2."Document No.");
                                    //RecDCLE.SetRange("Posting Date", RecGLEntry2."Posting Date");
                                    if RecDCLE.FindSet() then RecDCLE.ModifyAll("Posting Date", PostingDate);
                                    Clear(RecBALE);
                                    RecBALE.SetRange("Document No.", RecGLEntry2."Document No.");
                                    //RecBALE.SetRange("Posting Date", RecGLEntry2."Posting Date");
                                    if RecBALE.FindSet() then RecBALE.ModifyAll("Posting Date", PostingDate);
                                    //////
                                    Clear(RecGLEntry3);
                                    RecGLEntry3.SetRange("Document No.", RecGLEntry2."Document No.");
                                    //RecGLEntry3.SetRange("Posting Date", RecGLEntry2."Posting Date");
                                    if RecGLEntry3.FindSet() then RecGLEntry3.ModifyAll("Posting Date", PostingDate);
                                until RecGLEntry2.Next() = 0;
                            end;
                        until RecGLEntry.Next() = 0;
                    end;
                    Message('Updated Successfully.');
                end
                else
                    Error('Please Select GL and Posting Date.');
            end;
        end;
    }
    trigger OnPostReport()
    var
    begin
    end;

    var
        FilterText: Code[20];
        PostingDate: Date;
        RecGLEntry3: Record "G/L Entry";
        RecGLEntry2: Record "G/L Entry";
}
