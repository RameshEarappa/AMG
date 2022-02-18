pageextension 50401 "Ext Payment Journal" extends "Payment Journal"
{

    layout
    {
        addbefore("Posting Date")
        {
            field(Select; Rec.Select)
            {
                ApplicationArea = All;
                Visible = False;
            }
            field("Amount(ABS)"; Rec."Amount(ABS)")
            {
                ApplicationArea = All;
                Visible = False;
            }
        }
        addafter("Document No.")
        {
            field("Voucher No."; Rec."Voucher No.")
            {
                ApplicationArea = All;
                Editable = false;

            }
            field("Add Charges"; Rec."Add Charges")
            {
                ApplicationArea = All;


            }
            field("Void Check"; Rec."Void Check")
            {
                ApplicationArea = all;
                trigger OnValidate()
                begin
                    CurrPage.Update();
                end;
            }
            field("Check Prepared Date"; Rec."Check Prepared Date")
            {
                ApplicationArea = All;
            }
            field("Check Issued Date"; Rec."Check Issued Date")
            {
                ApplicationArea = All;
            }
            field(Narration; Rec.Narration)
            {
                ApplicationArea = all;
            }
            field("PO No."; Rec."PO No.")
            { ApplicationArea = all; }
        }

    }

    actions
    {
        addafter(Post)
        {
            action("Assign Voucher No")
            {
                Promoted = True;
                ApplicationArea = All;
                Image = UpdateDescription;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    Genjnlline5.Reset;
                    Genjnlline5.SetRange("Document No.", Rec."Document No.");
                    Genjnlline5.SetRange("Add Charges", false);
                    Genjnlline5.SetRange("Voucher No.", '');
                    if Genjnlline5.findfirst then begin
                        repeat
                            Genjnlline4.Reset;
                            Genjnlline4.SetRange("Document No.", Genjnlline5."Document No.");
                            Genjnlline4.SetFilter("Voucher No.", '<>%1', '');
                            if Genjnlline4.findfirst then begin
                                Error('Document no. Already Exists in Gen. Journal Line with Line no. %1', Genjnlline4."Line No.");
                            end;
                        until genjnlline5.next = 0;
                    end;
                    //Error('Document no. Already Exists in Gen. Journal Line with Line no. %1', Genjnlline5."Line No.");


                    GenJnlLine2.Reset();
                    GenJnlLine2.SetRange("Journal Template Name", Rec."Journal Template Name");
                    GenJnlLine2.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    Genjnlline2.SetRange("Document No.", Rec."Document No.");
                    GenJnlLine2.SetRange("Voucher No.", '');
                    IF GenJnlLine2.FindFirst() THEN
                        REPEAT
                            RecGLEntry.Reset;
                            RecGLEntry.SetRange("Document No.", GenJnlLine2."Document No.");
                            if not RecGLEntry.findfirst then begin
                                GenJnlTemplate.GET(Rec."Journal Template Name");
                                GenJnlBatch.GET(Rec."Journal Template Name", Rec."Journal Batch Name");
                                GenJnlLine3.Reset();
                                GenJnlLine3.SetRange("Journal Template Name", Rec."Journal Template Name");
                                GenJnlLine3.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                                GenJnlLine3.SetRange("Document No.", GenJnlLine2."Document No.");
                                GenJnlLine3.SetFilter("Voucher No.", '<>%1', '');
                                IF GenJnlLine3.FindFirst() THEN begin
                                    GenJnlLine2."Voucher No." := GenJnlLine3."Voucher No.";
                                end ELSE
                                    GenJnlLine2."Voucher No." := NoSeriesMgt.GetNextNo(GenJnlBatch."Voucher No.", Rec."Posting Date", true);
                                GenJnlLine2.Modify();
                            end else
                                Error('Document No. already Exists');
                        UNTIL GenJnlLine2.NEXT = 0;
                end;
            }
            Action("Payment Voucher")
            {
                ApplicationArea = All;
                Caption = 'Payment Voucher';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;
                trigger OnAction();
                var
                    VouchRep: Report "Voucher_Report";
                    GJLRec2: Record "Gen. Journal Line";
                    GJLRec: Record "Gen. Journal Line";
                begin
                    Clear(VouchRep);
                    GJLRec.copy(Rec);
                    CurrPage.SetSelectionFilter(GJLRec);
                    if GJLRec.FindFirst() then;
                    GJLRec2.SetRange("Voucher No.", GJLRec."Voucher No.");
                    IF GJLRec2.FindFirst() then;
                    VouchRep.SetTableView(GJLRec2);
                    VouchRep.RunModal();
                end;
            }

            Action("Check NBF")
            {
                ApplicationArea = All;
                Caption = 'NBF Bearer Check';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;
                trigger OnAction();
                var
                    CheckRep: Report "NBF Bearer Check";
                    GenJnline: Record "Gen. Journal Line";
                    GenJnline2: Record "Gen. Journal Line";
                    GenJnline3: Record "Gen. Journal Line";
                    JnTemName: Code[20];
                    LineNum: Integer;
                    Found: Boolean;

                begin
                    Clear(CheckRep);
                    SetSelectionFilter(GenJnline);
                    If GenJnline.FindFirst() then;
                    GenJnline2.SetRange("Document No.", Rec."Document No.");
                    GenJnline2.SetRange("Voucher No.", Rec."Voucher No.");
                    IF GenJnline2.FindSet() then begin
                        repeat
                            If (GenJnline2."Account Type" = GenJnline2."Account Type"::"Bank Account") and (GenJnline2."Account No." <> '') then begin
                                JnTemName := GenJnline2."Journal Template Name";
                                LineNum := GenJnline2."Line No.";
                            end Else
                                If (GenJnline2."Bal. Account Type" = GenJnline2."Bal. Account Type"::"Bank Account") and (GenJnline2."Bal. Account No." <> '') then begin
                                    JnTemName := GenJnline2."Journal Template Name";
                                    LineNum := GenJnline2."Line No.";
                                End;
                        Until GenJnline2.Next() = 0;
                        GenJnline3.SetRange("Journal Template Name", JnTemName);
                        GenJnline3.SetRange("Line No.", LineNum);
                        GenJnline3.SetRange("Document No.", GenJnline."Document No.");
                        GenJnline3.SetRange("Voucher No.", GenJnline."Voucher No.");
                    end;
                    CheckRep.SetTableView(GenJnline3);
                    CheckRep.RunModal();

                eND;
            }
            Action("NBF A/C Payee only")
            {
                ApplicationArea = All;
                Caption = 'NBF A/C Payee only';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;
                trigger OnAction();
                var
                    CheckRep: Report "NBF A/C Payee only";
                    GenJnline: Record "Gen. Journal Line";
                    GenJnline2: Record "Gen. Journal Line";
                    GenJnline3: Record "Gen. Journal Line";
                    JnTemName: Code[20];
                    LineNum: Integer;
                    Found: Boolean;

                begin
                    Clear(CheckRep);
                    SetSelectionFilter(GenJnline);
                    If GenJnline.FindFirst() then;
                    GenJnline2.SetRange("Document No.", Rec."Document No.");
                    GenJnline2.SetRange("Voucher No.", Rec."Voucher No.");
                    IF GenJnline2.FindSet() then begin
                        repeat
                            If (GenJnline2."Account Type" = GenJnline2."Account Type"::"Bank Account") and (GenJnline2."Account No." <> '') then begin
                                JnTemName := GenJnline2."Journal Template Name";
                                LineNum := GenJnline2."Line No.";
                            end Else
                                If (GenJnline2."Bal. Account Type" = GenJnline2."Bal. Account Type"::"Bank Account") and (GenJnline2."Bal. Account No." <> '') then begin
                                    JnTemName := GenJnline2."Journal Template Name";
                                    LineNum := GenJnline2."Line No.";
                                End;
                        Until GenJnline2.Next() = 0;
                        GenJnline3.SetRange("Journal Template Name", JnTemName);
                        GenJnline3.SetRange("Line No.", LineNum);
                        GenJnline3.SetRange("Document No.", GenJnline."Document No.");
                        GenJnline3.SetRange("Voucher No.", GenJnline."Voucher No.");

                    end;
                    CheckRep.SetTableView(GenJnline3);
                    CheckRep.RunModal();

                eND;
            }
            Action("NBF Security")
            {
                ApplicationArea = All;
                Caption = 'NBF Security';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;
                trigger OnAction();
                var
                    CheckRep: Report "NBF Security";
                    GenJnline: Record "Gen. Journal Line";
                    GenJnline2: Record "Gen. Journal Line";
                    GenJnline3: Record "Gen. Journal Line";
                    JnTemName: Code[20];
                    LineNum: Integer;
                    Found: Boolean;

                begin
                    Clear(CheckRep);
                    SetSelectionFilter(GenJnline);
                    If GenJnline.FindFirst() then;
                    GenJnline2.SetRange("Document No.", Rec."Document No.");
                    GenJnline2.SetRange("Voucher No.", Rec."Voucher No.");
                    IF GenJnline2.FindSet() then begin
                        repeat
                            If (GenJnline2."Account Type" = GenJnline2."Account Type"::"Bank Account") and (GenJnline2."Account No." <> '') then begin
                                JnTemName := GenJnline2."Journal Template Name";
                                LineNum := GenJnline2."Line No.";
                            end Else
                                If (GenJnline2."Bal. Account Type" = GenJnline2."Bal. Account Type"::"Bank Account") and (GenJnline2."Bal. Account No." <> '') then begin
                                    JnTemName := GenJnline2."Journal Template Name";
                                    LineNum := GenJnline2."Line No.";
                                End;
                        Until GenJnline2.Next() = 0;
                        GenJnline3.SetRange("Journal Template Name", JnTemName);
                        GenJnline3.SetRange("Line No.", LineNum);
                        GenJnline3.SetRange("Document No.", GenJnline."Document No.");
                        GenJnline3.SetRange("Voucher No.", GenJnline."Voucher No.");
                    end;
                    CheckRep.SetTableView(GenJnline3);
                    CheckRep.RunModal();

                eND;
            }
            Action("NBF Blank")
            {
                ApplicationArea = All;
                Caption = 'NBF Blank';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;
                trigger OnAction();
                var
                    CheckRep: Report "NBF Blank";
                    GenJnline: Record "Gen. Journal Line";
                    GenJnline2: Record "Gen. Journal Line";
                    GenJnline3: Record "Gen. Journal Line";
                    JnTemName: Code[20];
                    LineNum: Integer;
                    Found: Boolean;

                begin
                    Clear(CheckRep);
                    SetSelectionFilter(GenJnline);
                    If GenJnline.FindFirst() then;
                    GenJnline2.SetRange("Document No.", Rec."Document No.");
                    GenJnline2.SetRange("Voucher No.", Rec."Voucher No.");
                    IF GenJnline2.FindSet() then begin
                        repeat
                            If (GenJnline2."Account Type" = GenJnline2."Account Type"::"Bank Account") and (GenJnline2."Account No." <> '') then begin
                                JnTemName := GenJnline2."Journal Template Name";
                                LineNum := GenJnline2."Line No.";
                            end Else
                                If (GenJnline2."Bal. Account Type" = GenJnline2."Bal. Account Type"::"Bank Account") and (GenJnline2."Bal. Account No." <> '') then begin
                                    JnTemName := GenJnline2."Journal Template Name";
                                    LineNum := GenJnline2."Line No.";
                                End;
                        Until GenJnline2.Next() = 0;
                        GenJnline3.SetRange("Journal Template Name", JnTemName);
                        GenJnline3.SetRange("Line No.", LineNum);
                        GenJnline3.SetRange("Document No.", GenJnline."Document No.");
                        GenJnline3.SetRange("Voucher No.", GenJnline."Voucher No.");
                    end;
                    CheckRep.SetTableView(GenJnline3);
                    CheckRep.RunModal();

                eND;
            }

            Action("ADCB Bearer Check")
            {
                ApplicationArea = All;
                Caption = 'ADCB Bearer Check';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;
                trigger OnAction();
                var
                    CheckRep: Report "ADCB Bearer Check";
                    GenJnline: Record "Gen. Journal Line";
                    GenJnline2: Record "Gen. Journal Line";
                    GenJnline3: Record "Gen. Journal Line";
                    JnTemName: Code[20];
                    LineNum: Integer;

                begin
                    Clear(CheckRep);
                    SetSelectionFilter(GenJnline);
                    If GenJnline.FindFirst() then;
                    GenJnline2.SetRange("Document No.", Rec."Document No.");
                    GenJnline2.SetRange("Voucher No.", Rec."Voucher No.");
                    IF GenJnline2.FindSet() then begin
                        repeat
                            If (GenJnline2."Account Type" = GenJnline2."Account Type"::"Bank Account") and (GenJnline2."Account No." <> '') then begin
                                JnTemName := GenJnline2."Journal Template Name";
                                LineNum := GenJnline2."Line No.";
                            end Else
                                If (GenJnline2."Bal. Account Type" = GenJnline2."Bal. Account Type"::"Bank Account") and (GenJnline2."Bal. Account No." <> '') then begin
                                    JnTemName := GenJnline2."Journal Template Name";
                                    LineNum := GenJnline2."Line No.";
                                End;
                        Until GenJnline2.Next() = 0;
                        GenJnline3.SetRange("Journal Template Name", JnTemName);
                        GenJnline3.SetRange("Line No.", LineNum);
                        GenJnline3.SetRange("Document No.", GenJnline."Document No.");
                        GenJnline3.SetRange("Voucher No.", GenJnline."Voucher No.");
                    end;
                    CheckRep.SetTableView(GenJnline3);
                    CheckRep.RunModal();

                eND;
            }
            Action("ADCB A/C Payee Only")
            {
                ApplicationArea = All;
                Caption = 'ADCB A/C Payee Only';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;
                trigger OnAction();
                var
                    CheckRep: Report "ADCB A/C Payee Only";
                    GenJnline: Record "Gen. Journal Line";
                    GenJnline2: Record "Gen. Journal Line";
                    GenJnline3: Record "Gen. Journal Line";
                    JnTemName: Code[20];
                    LineNum: Integer;

                begin
                    Clear(CheckRep);
                    SetSelectionFilter(GenJnline);
                    If GenJnline.FindFirst() then;
                    GenJnline2.SetRange("Document No.", Rec."Document No.");
                    GenJnline2.SetRange("Voucher No.", Rec."Voucher No.");
                    IF GenJnline2.FindSet() then begin
                        repeat
                            If (GenJnline2."Account Type" = GenJnline2."Account Type"::"Bank Account") and (GenJnline2."Account No." <> '') then begin
                                JnTemName := GenJnline2."Journal Template Name";
                                LineNum := GenJnline2."Line No.";
                            end Else
                                If (GenJnline2."Bal. Account Type" = GenJnline2."Bal. Account Type"::"Bank Account") and (GenJnline2."Bal. Account No." <> '') then begin
                                    JnTemName := GenJnline2."Journal Template Name";
                                    LineNum := GenJnline2."Line No.";
                                End;
                        Until GenJnline2.Next() = 0;
                        GenJnline3.SetRange("Journal Template Name", JnTemName);
                        GenJnline3.SetRange("Line No.", LineNum);
                        GenJnline3.SetRange("Document No.", GenJnline."Document No.");
                        GenJnline3.SetRange("Voucher No.", GenJnline."Voucher No.");
                    end;
                    CheckRep.SetTableView(GenJnline3);
                    CheckRep.RunModal();

                eND;
            }
            Action("ADCB A/C Payee Only New")
            {
                ApplicationArea = All;
                Caption = 'ADCB A/C Payee Only New';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;
                trigger OnAction();
                var
                    CheckRep: Report "ADCB A/C Payee Only New";
                    GenJnline: Record "Gen. Journal Line";
                    GenJnline2: Record "Gen. Journal Line";
                    GenJnline3: Record "Gen. Journal Line";
                    JnTemName: Code[20];
                    LineNum: Integer;

                begin
                    Clear(CheckRep);
                    SetSelectionFilter(GenJnline);
                    If GenJnline.FindFirst() then;
                    GenJnline2.SetRange("Document No.", Rec."Document No.");
                    GenJnline2.SetRange("Voucher No.", Rec."Voucher No.");
                    IF GenJnline2.FindSet() then begin
                        repeat
                            If (GenJnline2."Account Type" = GenJnline2."Account Type"::"Bank Account") and (GenJnline2."Account No." <> '') then begin
                                JnTemName := GenJnline2."Journal Template Name";
                                LineNum := GenJnline2."Line No.";
                            end Else
                                If (GenJnline2."Bal. Account Type" = GenJnline2."Bal. Account Type"::"Bank Account") and (GenJnline2."Bal. Account No." <> '') then begin
                                    JnTemName := GenJnline2."Journal Template Name";
                                    LineNum := GenJnline2."Line No.";
                                End;
                        Until GenJnline2.Next() = 0;
                        GenJnline3.SetRange("Journal Template Name", JnTemName);
                        GenJnline3.SetRange("Line No.", LineNum);
                        GenJnline3.SetRange("Document No.", GenJnline."Document No.");
                        GenJnline3.SetRange("Voucher No.", GenJnline."Voucher No.");
                    end;
                    CheckRep.SetTableView(GenJnline3);
                    CheckRep.RunModal();

                eND;
            }
            Action("ADCB Security")
            {
                ApplicationArea = All;
                Caption = 'ADCB Security';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;
                trigger OnAction();
                var
                    CheckRep: Report "ADCB Security";
                    GenJnline: Record "Gen. Journal Line";
                    GenJnline2: Record "Gen. Journal Line";
                    GenJnline3: Record "Gen. Journal Line";
                    JnTemName: Code[20];
                    LineNum: Integer;

                begin
                    Clear(CheckRep);
                    SetSelectionFilter(GenJnline);
                    If GenJnline.FindFirst() then;
                    GenJnline2.SetRange("Document No.", Rec."Document No.");
                    GenJnline2.SetRange("Voucher No.", Rec."Voucher No.");
                    IF GenJnline2.FindSet() then begin
                        repeat
                            If (GenJnline2."Account Type" = GenJnline2."Account Type"::"Bank Account") and (GenJnline2."Account No." <> '') then begin
                                JnTemName := GenJnline2."Journal Template Name";
                                LineNum := GenJnline2."Line No.";
                            end Else
                                If (GenJnline2."Bal. Account Type" = GenJnline2."Bal. Account Type"::"Bank Account") and (GenJnline2."Bal. Account No." <> '') then begin
                                    JnTemName := GenJnline2."Journal Template Name";
                                    LineNum := GenJnline2."Line No.";
                                End;
                        Until GenJnline2.Next() = 0;
                        GenJnline3.SetRange("Journal Template Name", JnTemName);
                        GenJnline3.SetRange("Line No.", LineNum);
                        GenJnline3.SetRange("Document No.", GenJnline."Document No.");
                        GenJnline3.SetRange("Voucher No.", GenJnline."Voucher No.");
                    end;
                    CheckRep.SetTableView(GenJnline3);
                    CheckRep.RunModal();

                eND;
            }

            Action("ADCB Blank")
            {
                ApplicationArea = All;
                Caption = 'ADCB Blank';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;
                trigger OnAction();
                var
                    CheckRep: Report "ADCB Blank";
                    GenJnline: Record "Gen. Journal Line";
                    GenJnline2: Record "Gen. Journal Line";
                    GenJnline3: Record "Gen. Journal Line";
                    JnTemName: Code[20];
                    LineNum: Integer;

                begin
                    Clear(CheckRep);
                    SetSelectionFilter(GenJnline);
                    If GenJnline.FindFirst() then;
                    GenJnline2.SetRange("Document No.", Rec."Document No.");
                    GenJnline2.SetRange("Voucher No.", Rec."Voucher No.");
                    IF GenJnline2.FindSet() then begin
                        repeat
                            If (GenJnline2."Account Type" = GenJnline2."Account Type"::"Bank Account") and (GenJnline2."Account No." <> '') then begin
                                JnTemName := GenJnline2."Journal Template Name";
                                LineNum := GenJnline2."Line No.";
                            end Else
                                If (GenJnline2."Bal. Account Type" = GenJnline2."Bal. Account Type"::"Bank Account") and (GenJnline2."Bal. Account No." <> '') then begin
                                    JnTemName := GenJnline2."Journal Template Name";
                                    LineNum := GenJnline2."Line No.";
                                End;
                        Until GenJnline2.Next() = 0;
                        GenJnline3.SetRange("Journal Template Name", JnTemName);
                        GenJnline3.SetRange("Line No.", LineNum);
                        GenJnline3.SetRange("Document No.", GenJnline."Document No.");
                        GenJnline3.SetRange("Voucher No.", GenJnline."Voucher No.");
                    end;
                    CheckRep.SetTableView(GenJnline3);
                    CheckRep.RunModal();

                eND;
            }

            /*action(VoidCheck)
            {
                ApplicationArea = All;
                Caption = 'Void Check';
                Promoted = true;
                PromotedOnly = true;
                Image = Journals;
                trigger OnAction()
                var
                    Void_CheckPage: Page "Payment Journal Voicd Check";
                begin
                    Void_CheckPage.run;
                End;
            }*/

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
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(GenJournalBatch.RecordId);
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
        Rec.SetRange("Void Check", false);
        Rec.VALIDATE(Select, false);
        SetControlAppearance();
        SetControlAppearanceFromBatch();
    end;

    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
    begin
        Rec.SetRange("Void Check", false);
        Rec.VALIDATE(Select, false);
        SetControlAppearance();
        SetControlAppearanceFromBatch();
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
    end;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        Rec.SetRange("Void Check", false);
        Rec.VALIDATE(Select, False);
        SetControlAppearance();
        SetControlAppearanceFromBatch();
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
    end;

    var
        TotalDebitamount: Decimal;
        TotalCreditAmount: Decimal;
        RecGenjnlline: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        GenJnlLine3: Record "Gen. Journal Line";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        RecGLEntry: record "G/L Entry";
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
        Genjnlline5: Record "Gen. Journal Line";
}


