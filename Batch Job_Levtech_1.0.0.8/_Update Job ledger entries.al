report 60003 "Update Job Ledger Entries"
{
    // UsageCategory = Administration;
    //ApplicationArea = All;
    UseRequestPage = false;
    ProcessingOnly = true;
    Permissions = TableData 17 = RIMD, TableData 32 = RIMD, TableData 5802 = RIMD, TableData 169 = RIMD, TableData 203 = RIMD, TableData 122 = RIMD, TableData 123 = RIMD, TableData 25 = RIMD;

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
        RecJLEntry: Record "Job Ledger Entry";
        RecILE: Record "Item Ledger Entry";
        RecVE: Record "Value Entry";
        RecVLE: Record "Vendor Ledger Entry";
        RecDVLE: Record "Detailed Vendor Ledg. Entry";
        RecCLE: Record "Cust. Ledger Entry";
        RecDCLE: Record "Detailed Cust. Ledg. Entry";
        RecBALE: Record "Bank Account Ledger Entry";
        RecDefaultDim: Record "Default Dimension";
        RecGlSetup: Record "General Ledger Setup";
        ProjectCode: Code[100];
        DimensionSetId: Integer;
        RecGLE: Record "G/L Entry";
        RecRLE: Record "Res. Ledger Entry";
        RecPurchInvHeader: Record "Purch. Inv. Header";
        RecPurchInvLine: Record "Purch. Inv. Line";
        RecGLEntry: Record "G/L Entry";
        //dlgProgress: Dialog;
        nRecNum: Integer;
        tcProgress: Label 'Parent Record Count #1\';
    begin
        Clear(RecJob);
        RecJob.SetRange("No.", JobNoG);
        if RecJob.FindFirst() then begin
            RecGlSetup.GET;
            Clear(RecDefaultDim);
            Clear(ProjectCode);
            Clear(DimensionSetId);
            RecDefaultDim.SetRange("Table ID", Database::Job);
            RecDefaultDim.SetRange("No.", RecJob."No.");
            RecDefaultDim.SetRange("Dimension Code", RecGlSetup."Shortcut Dimension 3 Code");
            if RecDefaultDim.FindFirst() then
                ProjectCode := RecDefaultDim."Dimension Value Code"
            else
                exit;
            Clear(CheckList);
            Clear(RecJLEntry);
            RecJLEntry.SetRange("Entry Type", RecJLEntry."Entry Type"::Usage);
            RecJLEntry.SetRange("Job No.", RecJob."No.");
            RecJLEntry.SetRange("Job Task No.", JobTaskNoG);
            if RecJLEntry.FindSet() then begin
                if not Confirm('Are you sure you want to update the Dimension set Ids of Ledger Entries?', false) then exit;
                repeat
                    RecJLEntry."Dimension Set ID" := CheckAndCreateDim(ProjectCode, RecJLEntry."Dimension Set ID");
                    RecJLEntry.Modify();
                    //dlgProgress.Update(2, nRecNum);
                    if not CheckList.Contains(RecJLEntry."Document No." + RecJLEntry."Job No.") then begin
                        CheckList.Add(RecJLEntry."Document No." + RecJLEntry."Job No.");
                        //GL entry
                        Clear(RecGLE);
                        RecGLE.SetRange("Document No.", RecJLEntry."Document No.");
                        RecGLE.SetRange("Job No.", RecJLEntry."Job No.");
                        //RecGLE.SetRange("Posting Date", RecJLEntry."Posting Date");
                        if RecGLE.FindSet() then begin
                            repeat
                                RecGLE."Dimension Set ID" := CheckAndCreateDim(ProjectCode, RecGLE."Dimension Set ID");
                                RecGLE.Modify();
                            until RecGLE.Next() = 0;
                        end;
                        //ILE
                        Clear(RecILE);
                        RecILE.SetRange("Document No.", RecJLEntry."Document No.");
                        RecILE.SetRange("Job No.", RecJLEntry."Job No.");
                        //RecILE.SetRange("Posting Date", RecJLEntry."Posting Date");
                        if RecILE.FindSet() then begin
                            repeat
                                RecILE."Dimension Set ID" := CheckAndCreateDim(ProjectCode, RecILE."Dimension Set ID");
                                RecILE.Modify();
                            until RecILE.Next() = 0;
                        end;
                        //VE
                        Clear(RecVE);
                        RecVE.SetRange("Document No.", RecJLEntry."Document No.");
                        //RecVE.SetRange("Posting Date", RecJLEntry."Posting Date");
                        RecVE.SetRange("Job No.", RecJLEntry."Job No.");
                        if RecVE.FindSet() then begin
                            repeat
                                RecVE."Dimension Set ID" := CheckAndCreateDim(ProjectCode, RecVE."Dimension Set ID");
                                RecVE.Modify();
                            until RecVE.Next() = 0;
                        end;
                        //RLE
                        Clear(RecRLE);
                        RecRLE.SetRange("Document No.", RecJLEntry."Document No.");
                        //RecRLE.SetRange("Posting Date", RecJLEntry."Posting Date");
                        RecRLE.SetRange("Job No.", RecJLEntry."Job No.");
                        if RecRLE.FindSet() then begin
                            repeat
                                RecRLE."Dimension Set ID" := CheckAndCreateDim(ProjectCode, RecRLE."Dimension Set ID");
                                RecRLE.Modify();
                            until RecRLE.Next() = 0;
                        end;
                        //VLE
                        Clear(RecVLE);
                        RecVLE.SetRange("Document No.", RecJLEntry."Document No.");
                        //RecVLE.SetRange("Posting Date", RecJLEntry."Posting Date");
                        if RecVLE.FindSet() then begin
                            repeat
                                RecVLE."Dimension Set ID" := CheckAndCreateDim(ProjectCode, RecVLE."Dimension Set ID");
                                RecVLE.Modify();
                            until RecVLE.Next() = 0;
                        end;
                        //Posted purchase Invoice
                        Clear(RecPurchInvHeader);
                        RecPurchInvHeader.SetRange("No.", RecJLEntry."Document No.");
                        if RecPurchInvHeader.FindFirst() then begin
                            RecPurchInvHeader."Dimension Set ID" := CheckAndCreateDim(ProjectCode, RecPurchInvHeader."Dimension Set ID");
                            RecPurchInvHeader.Modify();
                            Clear(RecPurchInvLine);
                            RecPurchInvLine.SetRange("Document No.", RecPurchInvHeader."No.");
                            if RecPurchInvLine.FindSet() then begin
                                repeat
                                    RecPurchInvLine."Dimension Set ID" := CheckAndCreateDim(ProjectCode, RecPurchInvLine."Dimension Set ID");
                                    RecPurchInvLine.Modify();
                                until RecPurchInvLine.Next() = 0;
                            end;
                        end;
                    end;
                until RecJLEntry.Next() = 0;
            end;
            Message('Process completed.');
        end;
    end;

    var
        RecJob: Record Job;
        CheckList: List of [Text];
        JobNoG: Code[20];
        JobTaskNoG: Code[20];

    procedure setJobNo(JobNoL: Code[20];
    JobTaskNoL: Code[20])
    begin
        Clear(JobNoG);
        JobNoG := JobNoL;
        Clear(JobTaskNoG);
        JobTaskNoG := JobTaskNoL;
    end;

    procedure CheckAndCreateDim(DimValL: Text[20];
    DimSetId: Integer): Integer
    var
        DimensionSetEntryRec: Record "Dimension Set Entry";
        DimensionManagementCU: Codeunit DimensionManagement;
        Dim: Record Dimension;
        DimValue: Record "Dimension Value";
        Dim2: Record Dimension;
        DimValue2: Record "Dimension Value";
        GenLedgSetup: Record "General Ledger Setup";
        DimensionSetEntryRecL: Record "Dimension Set Entry" temporary;
    begin
        if DimSetId = 0 then exit(0);
        GenLedgSetup.GET;
        Clear(DimValue);
        DimValue.SetRange("Dimension Code", GenLedgSetup."Shortcut Dimension 3 Code");
        DimValue.SetRange(Code, DimValL);
        If not DimValue.FindFirst() then begin
            DimValue.Init();
            DimValue.Validate("Dimension Code", GenLedgSetup."Shortcut Dimension 3 Code");
            DimValue.Validate(Code, DimValL);
            DimValue.Validate("Global Dimension No.", 3);
            DimValue.Validate(Name, DimValL);
            DimValue.Validate("Dimension Value Type", DimValue."Dimension Value Type"::Standard);
            DimValue.Insert;
        end;
        Clear(DimensionSetEntryRec);
        DimensionSetEntryRec.SetRange("Dimension Set ID", DimSetId);
        DimensionSetEntryRec.SetRange("Dimension Code", GenLedgSetup."Shortcut Dimension 3 Code");
        DimensionSetEntryRec.SetRange("Dimension Value Code", DimValL);
        if DimensionSetEntryRec.FindFirst() then exit(DimensionSetEntryRec."Dimension Set ID");
        Clear(DimensionSetEntryRec);
        DimensionSetEntryRec.SetRange("Dimension Set ID", DimSetId);
        if DimensionSetEntryRec.FindSet() then begin
            repeat
                DimensionSetEntryRecL.Init();
                DimensionSetEntryRecL.TransferFields(DimensionSetEntryRec);
                DimensionSetEntryRecL."Dimension Set ID" := 0;
                if DimensionSetEntryRec."Dimension Code" = GenLedgSetup."Shortcut Dimension 3 Code" then DimensionSetEntryRecL.Validate("Dimension Value Code", DimValL);
                DimensionSetEntryRecL.Insert();
            until DimensionSetEntryRec.Next() = 0;
        end;
        exit(DimensionManagementCU.GetDimensionSetID(DimensionSetEntryRecL));
    end;
}


report 60004 "Update GRN In GL"
{
    // UsageCategory = Administration;
    //ApplicationArea = All;
    UseRequestPage = false;
    ProcessingOnly = true;
    Permissions = TableData 17 = RIMD, TableData 32 = RIMD, TableData 5802 = RIMD, TableData 169 = RIMD, TableData 203 = RIMD, TableData 121 = RIMD, TableData 120 = RIMD, TableData 25 = RIMD;

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
        RecJLEntry: Record "Job Ledger Entry";
        RecILE: Record "Item Ledger Entry";
        RecVE: Record "Value Entry";
        RecVLE: Record "Vendor Ledger Entry";
        RecDVLE: Record "Detailed Vendor Ledg. Entry";
        RecCLE: Record "Cust. Ledger Entry";
        RecDCLE: Record "Detailed Cust. Ledg. Entry";
        RecBALE: Record "Bank Account Ledger Entry";
        RecDefaultDim: Record "Default Dimension";
        RecGlSetup: Record "General Ledger Setup";
        ProjectCode: Code[100];
        DimensionSetId: Integer;
        RecGLE: Record "G/L Entry";
        RecRLE: Record "Res. Ledger Entry";
        RecPurchRcptHeader: Record "Purch. Rcpt. Header";
        RecPurchRcptLine: Record "Purch. Rcpt. Line";
        RecGLEntry: Record "G/L Entry";
        //dlgProgress: Dialog;
        nRecNum: Integer;
        tcProgress: Label 'Parent Record Count #1\';
    begin
        Clear(RecJob);
        RecJob.SetRange("No.", JobNoG);
        if RecJob.FindFirst() then begin
            RecGlSetup.GET;
            Clear(RecDefaultDim);
            Clear(ProjectCode);
            Clear(DimensionSetId);
            RecDefaultDim.SetRange("Table ID", Database::Job);
            RecDefaultDim.SetRange("No.", RecJob."No.");
            RecDefaultDim.SetRange("Dimension Code", RecGlSetup."Shortcut Dimension 3 Code");
            if RecDefaultDim.FindFirst() then
                ProjectCode := RecDefaultDim."Dimension Value Code"
            else
                exit;
            Clear(CheckList);
            Clear(RecGLE);
            RecGLE.SetRange("Job No.", JobNoG);
            RecGLE.SetFilter("Document No.", '@*GRN*');
            if RecGLE.FindSet() then begin
                if not Confirm('Are you sure you want to update the Dimension set Ids of GL and other related entries?', false) then exit;
                repeat
                    RecGLE."Dimension Set ID" := CheckAndCreateDim(ProjectCode, RecGLE."Dimension Set ID");
                    RecGLE.Modify();
                    if not CheckList.Contains(RecGLE."Document No.") then begin
                        CheckList.Add(RecGLE."Document No.");
                        //Posted purchase Receipt
                        Clear(RecPurchRcptHeader);
                        RecPurchRcptHeader.SetRange("No.", RecGLE."Document No.");
                        if RecPurchRcptHeader.FindFirst() then begin
                            RecPurchRcptHeader."Dimension Set ID" := CheckAndCreateDim(ProjectCode, RecPurchRcptHeader."Dimension Set ID");
                            RecPurchRcptHeader.Modify();
                            Clear(RecPurchRcptLine);
                            RecPurchRcptLine.SetRange("Document No.", RecPurchRcptHeader."No.");
                            if RecPurchRcptLine.FindSet() then begin
                                repeat
                                    RecPurchRcptLine."Dimension Set ID" := CheckAndCreateDim(ProjectCode, RecPurchRcptLine."Dimension Set ID");
                                    RecPurchRcptLine.Modify();
                                until RecPurchRcptLine.Next() = 0;
                            end;
                        end;
                        //ILE
                        Clear(RecILE);
                        RecILE.SetRange("Document No.", RecGLE."Document No.");
                        RecILE.SetRange("Job No.", RecGLE."Job No.");
                        if RecILE.FindSet() then begin
                            repeat
                                RecILE."Dimension Set ID" := CheckAndCreateDim(ProjectCode, RecILE."Dimension Set ID");
                                RecILE.Modify();
                            until RecILE.Next() = 0;
                        end;
                        //VE
                        Clear(RecVE);
                        RecVE.SetRange("Document No.", RecGLE."Document No.");
                        RecVE.SetRange("Job No.", RecGLE."Job No.");
                        if RecVE.FindSet() then begin
                            repeat
                                RecVE."Dimension Set ID" := CheckAndCreateDim(ProjectCode, RecVE."Dimension Set ID");
                                RecVE.Modify();
                            until RecVE.Next() = 0;
                        end;
                    end;
                until RecGLE.Next() = 0;
            end;
            Message('Process completed.');
        end;
    end;

    var
        RecJob: Record Job;
        CheckList: List of [Text];
        JobNoG: Code[20];
        JobTaskNoG: Code[20];

    procedure setJobNo(JobNoL: Code[20];
    JobTaskNoL: Code[20])
    begin
        Clear(JobNoG);
        JobNoG := JobNoL;
        Clear(JobTaskNoG);
        JobTaskNoG := JobTaskNoL;
    end;

    procedure CheckAndCreateDim(DimValL: Text[20];
    DimSetId: Integer): Integer
    var
        DimensionSetEntryRec: Record "Dimension Set Entry";
        DimensionManagementCU: Codeunit DimensionManagement;
        Dim: Record Dimension;
        DimValue: Record "Dimension Value";
        Dim2: Record Dimension;
        DimValue2: Record "Dimension Value";
        GenLedgSetup: Record "General Ledger Setup";
        DimensionSetEntryRecL: Record "Dimension Set Entry" temporary;
    begin
        if DimSetId = 0 then exit(0);
        GenLedgSetup.GET;
        Clear(DimValue);
        DimValue.SetRange("Dimension Code", GenLedgSetup."Shortcut Dimension 3 Code");
        DimValue.SetRange(Code, DimValL);
        If not DimValue.FindFirst() then begin
            DimValue.Init();
            DimValue.Validate("Dimension Code", GenLedgSetup."Shortcut Dimension 3 Code");
            DimValue.Validate(Code, DimValL);
            DimValue.Validate("Global Dimension No.", 3);
            DimValue.Validate(Name, DimValL);
            DimValue.Validate("Dimension Value Type", DimValue."Dimension Value Type"::Standard);
            DimValue.Insert;
        end;
        Clear(DimensionSetEntryRec);
        DimensionSetEntryRec.SetRange("Dimension Set ID", DimSetId);
        DimensionSetEntryRec.SetRange("Dimension Code", GenLedgSetup."Shortcut Dimension 3 Code");
        DimensionSetEntryRec.SetRange("Dimension Value Code", DimValL);
        if DimensionSetEntryRec.FindFirst() then exit(DimensionSetEntryRec."Dimension Set ID");
        Clear(DimensionSetEntryRec);
        DimensionSetEntryRec.SetRange("Dimension Set ID", DimSetId);
        if DimensionSetEntryRec.FindSet() then begin
            repeat
                DimensionSetEntryRecL.Init();
                DimensionSetEntryRecL.TransferFields(DimensionSetEntryRec);
                DimensionSetEntryRecL."Dimension Set ID" := 0;
                if DimensionSetEntryRec."Dimension Code" = GenLedgSetup."Shortcut Dimension 3 Code" then DimensionSetEntryRecL.Validate("Dimension Value Code", DimValL);
                DimensionSetEntryRecL.Insert();
            until DimensionSetEntryRec.Next() = 0;
        end;
        exit(DimensionManagementCU.GetDimensionSetID(DimensionSetEntryRecL));
    end;
}
pageextension 50189 jobplaningLine extends "Job Task Lines Subform"
{
    actions
    {
        // Add changes to page actions here
        addafter(JobPlanningLines)
        {
            action("Update Ledger Entries")
            {
                ApplicationArea = All;
                Image = UpdateDescription;
                Visible = false;

                trigger OnAction()
                var
                    UpdateReport: Report "Update Job Ledger Entries";
                begin
                    Clear(UpdateReport);
                    UpdateReport.UseRequestPage(false);
                    UpdateReport.setJobNo(Rec."Job No.", Rec."Job Task No.");
                    UpdateReport.RunModal();
                end;
            }
            action("Update GRN Entries In GL")
            {
                ApplicationArea = All;
                Image = UpdateDescription;
                Visible = false;

                trigger OnAction()
                var
                    UpdateReport: Report "Update GRN In GL";
                begin
                    Clear(UpdateReport);
                    UpdateReport.UseRequestPage(false);
                    UpdateReport.setJobNo(Rec."Job No.", Rec."Job Task No.");
                    UpdateReport.RunModal();
                end;
            }
        }
    }
    var
        myInt: Integer;
}
