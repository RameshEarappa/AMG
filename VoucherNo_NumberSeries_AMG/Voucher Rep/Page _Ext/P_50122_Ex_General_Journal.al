pageextension 50416 Ex_General_Journal extends "General Journal"
{
    layout
    {
        addafter("Document No.")
        {
            field(Narration; Rec.Narration)
            { ApplicationArea = all; }
        }
        addbefore("Posting Date")
        {
            field(Select; Rec.Select)
            {
                ApplicationArea = All;
            }
            field("Amount(ABS)"; Rec."Amount(ABS)")
            {
                ApplicationArea = All;
                Visible = False;
            }
            field("Shortcut Dimension 3 Code"; Shortcutdimcode[3])
            {
                ApplicationArea = All;
                CaptionClass = '1,2,3';
                Visible = False;
            }
            field("Shortcut Dimension 4 Code"; Shortcutdimcode[4])
            {
                ApplicationArea = All;
                CaptionClass = '1,2,4';
                Visible = False;
            }
            field("Shortcut Dimension 5 Code"; Shortcutdimcode[5])
            {
                ApplicationArea = All;
                CaptionClass = '1,2,5';
                Visible = False;
            }
            field("Shortcut Dimension 6 Code"; Shortcutdimcode[6])
            {
                ApplicationArea = All;
                CaptionClass = '1,2,6';
                Visible = False;
            }
            field("Shortcut Dimension 7 Code"; Shortcutdimcode[7])
            {
                ApplicationArea = All;
                CaptionClass = '1,2,7';
                Visible = False;
            }
            field("Shortcut Dimension 8 Code"; Shortcutdimcode[8])
            {
                ApplicationArea = All;
                CaptionClass = '1,2,8';
                Visible = False;
            }
        }
    }

    actions
    {
        addafter("Apply Entries")
        {
            Action("Payment Voucher")
            {
                ApplicationArea = All;
                Caption = 'General Voucher';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;
                trigger OnAction();
                var
                    VouchRep: Report "Gen Journ Voucher_Report";
                    GJLRec2: Record "Gen. Journal Line";
                    GJLRec: Record "Gen. Journal Line";
                begin
                    Clear(VouchRep);
                    CurrPage.SetSelectionFilter(GJLRec);
                    if GJLRec.FindFirst() then;
                    GJLRec2.SetRange("Document No.", GJLRec."Document No.");
                    IF GJLRec2.FindFirst() then;
                    VouchRep.SetTableView(GJLRec2);
                    VouchRep.RunModal();
                end;
            }

            group(Approvalmul)
            {
                Caption = 'Approval - Multiple';

                action(Approvemul)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Approve-Lines';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;
                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        Genjournalline: record "Gen. Journal Line";
                        ApprEntry: Record "Approval Entry";
                        RecRestrictedRecord: record "Restricted Record";
                    begin
                        GenJournalLine.Reset;
                        GenJournalLine.SetRange(Select, True);
                        if GenJournalLine.Findfirst then begin
                            repeat
                                ApprovalsMgmt.ApproveGenJournalLineRequest(Genjournalline);
                            until GenJournalLine.next = 0;
                        end;

                        Genjournalline.Reset;
                        Genjournalline.SetRange("Journal Template Name", 'GENERAL');
                        if Genjournalline.findfirst then begin
                            repeat
                                RecRestrictedRecord.Reset;
                                RecRestrictedRecord.SetRange("Record ID", Genjournalline.RecordId);
                                if RecRestrictedRecord.findfirst then begin
                                    repeat
                                        ApprEntry.Reset;
                                        ApprEntry.SetRange("Record ID to Approve", RecRestrictedRecord."Record ID");
                                        ApprEntry.SetFILTER(Status, '%1|%2', ApprEntry.Status::Open, ApprEntry.Status::Created);
                                        if not Apprentry.findfirst then begin
                                            RecRestrictedRecord.DELETE(True);
                                            Commit;
                                        end;
                                    until RecRestrictedRecord.next = 0;
                                end;
                            until Genjournalline.next = 0;
                        end;

                    end;
                }
                action(Rejectmul)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Reject-Lines';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Reject the approval request.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        Genjournalline: record "Gen. Journal Line";
                    begin
                        GenJournalLine.Reset;
                        GenJournalLine.SetRange(Select, True);
                        if GenJournalLine.Findfirst then begin
                            repeat
                                ApprovalsMgmt.RejectGenJournalLineRequest(Genjournalline);
                            until GenJournalLine.next = 0;
                        end;
                    end;
                }
                action(Delegatemul)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Delegate-Lines';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    ToolTip = 'Delegate the approval to a substitute approver.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        Genjournalline: Record "Gen. Journal Line";
                    begin
                        GenJournalLine.Reset;
                        GenJournalLine.SetRange(Select, True);
                        if GenJournalLine.Findfirst then begin
                            repeat
                                ApprovalsMgmt.DelegateGenJournalLineRequest(Genjournalline);
                            until GenJournalLine.next = 0;
                        end;
                    end;
                }

            }
            group("Request Approval - Mutiple")
            {
                Caption = 'Request Approval- Multiple';
                action(SendApprovalRequestJournalLineMul)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send Approval Request-Lines';
                    Enabled = NOT OpenApprovalEntriesOnBatchOrCurrJnlLineExist AND CanRequestFlowApprovalForBatchAndCurrentLine;
                    Image = SendApprovalRequest;
                    ToolTip = 'Send selected journal lines for approval.';
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    //Visible = False;
                    trigger OnAction()
                    var
                        GenJournalLine: Record "Gen. Journal Line";
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        GenJournalLine.Reset;
                        GenJournalLine.SetRange(Select, True);
                        if GenJournalLine.Findfirst then begin
                            repeat
                                ApprovalsMgmt.TrySendJournalLineApprovalRequests(GenJournalLine);
                            until GenJournalLine.next = 0;
                        end;

                        SetControlAppearanceFromBatch;
                    end;
                }
                action(CancelApprovalRequestJournalLineMul)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel Approval Request-Lines ';
                    Enabled = CanCancelApprovalForJnlLine OR CanCancelFlowApprovalForLine;
                    Image = CancelApprovalRequest;
                    ToolTip = 'Cancel sending selected journal lines for approval.';
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    //Visible = False;
                    trigger OnAction()
                    var
                        GenJournalLine: Record "Gen. Journal Line";
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        GenJournalLine.Reset;
                        GenJournalLine.SetRange(Select, True);
                        if GenJournalLine.Findfirst then begin
                            repeat
                                ApprovalsMgmt.TryCancelJournalLineApprovalRequests(GenJournalLine);
                            until GenJournalLine.next = 0;
                        end;
                    end;
                }
                action(SelectALL)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Select All';
                    Image = SelectEntries;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    //Visible = False;
                    trigger OnAction()
                    var
                        GenJournalLine: Record "Gen. Journal Line";
                        Genjournalline1: Record "Gen. Journal Line";
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        //GenJournalLine.COPY(Rec);
                        //CurrPage.SETSELECTIONFILTER(GenJournalLine);
                        Genjournalline.Reset;
                        GenJournalLine.setrange(Select, true);
                        if GenJournalLine.findfirst then begin
                            Genjournalline1.Reset;
                            GenJournalLine1.SetRange("Document No.", Genjournalline."Document No.");
                            if GenJournalLine1.FindSet() then begin
                                repeat
                                    GenJournalLine1.Select := True;
                                    GenJournalLine1.Modify;
                                //Commit;
                                // Currpage.Update(true);
                                until GenJournalLine1.next = 0;
                                //Currpage.Update();
                            end;
                        end;

                    end;
                }
            }
        }
    }
    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WorkflowWebhookManagement: Codeunit "Workflow Webhook Management";
        CanRequestFlowApprovalForLine: Boolean;
    begin
        OpenApprovalEntriesExistForCurrUser :=
          OpenApprovalEntriesExistForCurrUser or
          ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);

        OpenApprovalEntriesOnJnlLineExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        OpenApprovalEntriesOnBatchOrCurrJnlLineExist := OpenApprovalEntriesOnJnlBatchExist or OpenApprovalEntriesOnJnlLineExist;

        ShowWorkflowStatusOnLine := CurrPage.WorkflowStatusLine.PAGE.SetFilterOnWorkflowRecord(Rec.RecordId);

        CanCancelApprovalForJnlLine := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);

        WorkflowWebhookManagement.GetCanRequestAndCanCancel(Rec.RecordId, CanRequestFlowApprovalForLine, CanCancelFlowApprovalForLine);
        CanRequestFlowApprovalForBatchAndCurrentLine := CanRequestFlowApprovalForBatch and CanRequestFlowApprovalForLine;
    end;

    local procedure SetControlAppearanceFromBatch()
    var
        GenJournalBatch: Record "Gen. Journal Batch";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WorkflowWebhookManagement: Codeunit "Workflow Webhook Management";
        CanRequestFlowApprovalForAllLines: Boolean;
    begin
        if (Rec."Journal Template Name" <> '') and (Rec."Journal Batch Name" <> '') then
            GenJournalBatch.Get(Rec."Journal Template Name", Rec."Journal Batch Name")
        else
            if not GenJournalBatch.Get(Rec.GetRangeMax("Journal Template Name"), Rec."Journal Batch Name") then
                exit;

        ShowWorkflowStatusOnBatch := CurrPage.WorkflowStatusBatch.PAGE.SetFilterOnWorkflowRecord(GenJournalBatch.RecordId);
        //OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(GenJournalBatch.RecordId);
        OpenApprovalEntriesOnJnlBatchExist := ApprovalsMgmt.HasOpenApprovalEntries(GenJournalBatch.RecordId);

        OpenApprovalEntriesOnBatchOrAnyJnlLineExist :=
          OpenApprovalEntriesOnJnlBatchExist or
          ApprovalsMgmt.HasAnyOpenJournalLineApprovalEntries(Rec."Journal Template Name", Rec."Journal Batch Name");

        CanCancelApprovalForJnlBatch := ApprovalsMgmt.CanCancelApprovalForRecord(GenJournalBatch.RecordId);

        WorkflowWebhookManagement.GetCanRequestAndCanCancelJournalBatch(
          GenJournalBatch, CanRequestFlowApprovalForBatch, CanCancelFlowApprovalForBatch, CanRequestFlowApprovalForAllLines);
        CanRequestFlowApprovalForBatchAndAllLines := CanRequestFlowApprovalForBatch and CanRequestFlowApprovalForAllLines;
    end;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin

        Rec.VALIDATE(Select, false);
        SetControlAppearance();
        SetControlAppearanceFromBatch();
    end;

    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
    begin

        Rec.VALIDATE(Select, false);
        SetControlAppearance();
        SetControlAppearanceFromBatch();
        Rec.ShowShortcutDimCode(Shortcutdimcode);

        CLEAR(TotalDebitamount);
        RecGenjnlline.Reset;
        RecGenjnlline.SetRange("Document No.", Rec."Document No.");
        RecGenjnlline.SetFilter("Amount (LCY)", '>%1', 0);
        if RecGenjnlline.FindFirst() then begin
            repeat
                TotalDebitamount += RecGenjnlline."Amount (LCY)";
            until Recgenjnlline.next = 0;
        end;
        CLEAR(TotalCreditamount);
        RecGenjnlline.Reset;
        RecGenjnlline.SetRange("Document No.", Rec."Document No.");
        RecGenjnlline.SetFilter("Amount (LCY)", '<%1', 0);
        if RecGenjnlline.FindFirst() then begin
            repeat
                TotalCreditamount += ABS(RecGenjnlline."Amount (LCY)");
            until Recgenjnlline.next = 0;
        end;
        RecGenjnlline.Reset;
        RecGenjnlline.SetRange("Document No.", Rec."Document No.");
        RecGenjnlline.SetFilter("Amount (LCY)", '>%1', 0);
        if RecGenjnlline.FindFirst() then begin
            repeat
                Rec.VALIDATE("Amount(ABS)", TotalDebitamount);
            until Recgenjnlline.next = 0;
        end;

        RecGenjnlline.Reset;
        RecGenjnlline.SetRange("Document No.", Rec."Document No.");
        RecGenjnlline.SetFilter("Amount (LCY)", '<%1', 0);
        if RecGenjnlline.FindFirst() then begin
            repeat
                Rec.VALIDATE("Amount(ABS)", TotalDebitamount);
            until Recgenjnlline.next = 0;
        end;
        Genjournalline.Reset;
        Genjournalline.SetRange("Journal Template Name", 'GENERAL');
        if Genjournalline.findfirst then begin
            repeat
                RecRestrictedRecord.Reset;
                RecRestrictedRecord.SetRange("Record ID", Genjournalline.RecordId);
                if RecRestrictedRecord.findfirst then begin
                    repeat
                        ApprEntry.Reset;
                        ApprEntry.SetRange("Record ID to Approve", RecRestrictedRecord."Record ID");
                        ApprEntry.SetFILTER(Status, '%1|%2', ApprEntry.Status::Open, ApprEntry.Status::Created);
                        if not Apprentry.findfirst then begin
                            RecRestrictedRecord.DELETE(True);
                            Commit;
                        end;
                    until RecRestrictedRecord.next = 0;
                end;
            until Genjournalline.next = 0;
        end;
        //VALIDATE("Amount(ABS)", ABS("Amount (LCY)"));
    end;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin

        Rec.VALIDATE(Select, False);
        SetControlAppearance();
        SetControlAppearanceFromBatch();
        Rec.ShowShortcutDimCode(Shortcutdimcode);
        CLEAR(TotalDebitamount);
        RecGenjnlline.Reset;
        RecGenjnlline.SetRange("Document No.", Rec."Document No.");
        RecGenjnlline.SetFilter("Amount (LCY)", '>%1', 0);
        if RecGenjnlline.FindFirst() then begin
            repeat
                TotalDebitamount += RecGenjnlline."Amount (LCY)";
            until Recgenjnlline.next = 0;
        end;
        CLEAR(TotalCreditamount);
        RecGenjnlline.Reset;
        RecGenjnlline.SetRange("Document No.", Rec."Document No.");
        RecGenjnlline.SetFilter("Amount (LCY)", '<%1', 0);
        if RecGenjnlline.FindFirst() then begin
            repeat
                TotalCreditamount += ABS(RecGenjnlline."Amount (LCY)");
            until Recgenjnlline.next = 0;
        end;
        RecGenjnlline.Reset;
        RecGenjnlline.SetRange("Document No.", Rec."Document No.");
        RecGenjnlline.SetFilter("Amount (LCY)", '>%1', 0);
        if RecGenjnlline.FindFirst() then begin
            repeat
                Rec.VALIDATE("Amount(ABS)", TotalDebitamount);
            until Recgenjnlline.next = 0;
        end;

        RecGenjnlline.Reset;
        RecGenjnlline.SetRange("Document No.", Rec."Document No.");
        RecGenjnlline.SetFilter("Amount (LCY)", '<%1', 0);
        if RecGenjnlline.FindFirst() then begin
            repeat
                Rec.VALIDATE("Amount(ABS)", TotalDebitamount);
            until Recgenjnlline.next = 0;
        end;

        //VALIDATE("Amount(ABS)", ABS("Amount (LCY)"));
        Genjournalline.Reset;
        Genjournalline.SetRange("Journal Template Name", 'GENERAL');
        if Genjournalline.findfirst then begin
            repeat
                RecRestrictedRecord.Reset;
                RecRestrictedRecord.SetRange("Record ID", Genjournalline.RecordId);
                if RecRestrictedRecord.findfirst then begin
                    repeat
                        ApprEntry.Reset;
                        ApprEntry.SetRange("Record ID to Approve", RecRestrictedRecord."Record ID");
                        ApprEntry.SetFILTER(Status, '%1|%2', ApprEntry.Status::Open, ApprEntry.Status::Created);
                        if not Apprentry.findfirst then begin
                            RecRestrictedRecord.DELETE(True);
                            Commit;
                        end;
                    until RecRestrictedRecord.next = 0;
                end;
            until Genjournalline.next = 0;
        end;
        Rec.VALIDATE("Shortcut Dimension 3 Code", Shortcutdimcode[3]);
        Rec.VALIDATE("Shortcut Dimension 4 Code", Shortcutdimcode[4]);
        Rec.VALIDATE("Shortcut Dimension 5 Code", Shortcutdimcode[5]);
        Rec.VALIDATE("Shortcut Dimension 6 Code", Shortcutdimcode[6]);
        Rec.VALIDATE("Shortcut Dimension 7 Code", Shortcutdimcode[7]);
        Rec.VALIDATE("Shortcut Dimension 8 Code", Shortcutdimcode[8]);
    end;

    var
        myInt: Integer;
        RecRestrictedRecord: record "Restricted Record";
        Genjournalline: Record "Gen. Journal Line";
        Bool: Boolean;
        ApprEntry: record "Approval Entry";
        TotalDebitamount: Decimal;
        TotalCreditAmount: Decimal;
        RecGenjnlline: Record "Gen. Journal Line";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesOnJnlBatchExist: Boolean;
        OpenApprovalEntriesOnJnlLineExist: Boolean;
        OpenApprovalEntriesOnBatchOrCurrJnlLineExist: Boolean;
        OpenApprovalEntriesOnBatchOrAnyJnlLineExist: Boolean;
        ShowWorkflowStatusOnBatch: Boolean;
        ShowWorkflowStatusOnLine: Boolean;
        CanCancelApprovalForJnlBatch: Boolean;
        CanCancelApprovalForJnlLine: Boolean;
        ImportPayrollTransactionsAvailable: Boolean;
        IsSaaSExcelAddinEnabled: Boolean;
        CanRequestFlowApprovalForBatch: Boolean;
        CanRequestFlowApprovalForBatchAndAllLines: Boolean;
        CanRequestFlowApprovalForBatchAndCurrentLine: Boolean;
        CanCancelFlowApprovalForBatch: Boolean;
        CanCancelFlowApprovalForLine: Boolean;
        Genjnlline4: Record "Gen. Journal Line";
        Shortcutdimcode: Array[8] of code[20];
}