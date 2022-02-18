pageextension 60105 BankReconcillation extends "Bank Acc. Reconciliation"
{
    layout
    {
        addafter(StatementDate)
        {
            field(Reviewed; Rec.Reviewed)
            {
                ApplicationArea = All;

            }
            field(Approved; Rec.Approved)
            {
                ApplicationArea = All;

            }
            field("Reviewer id"; Rec."Reviewer id")
            {
                ApplicationArea = All;

            }
            field("Approver id"; Rec."Approver id")
            {
                ApplicationArea = All;

            }
            field("Reviewed By Date"; Rec."Reviewed By Date")
            {
                ApplicationArea = All;

            }
            field("Approved By Date"; Rec."Approved By Date")
            {
                ApplicationArea = All;

            }
            field("Preparer id"; Rec."Prepared By")
            {
                ApplicationArea = All;

            }
            field("Prepared by date"; Rec."Prepared By Date")
            {
                ApplicationArea = All;

            }
        }
    }

    actions
    {
        modify(Post)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                //if Rec."Prepared By" = '' then begin
                Rec."Prepared By" := UserId;
                Rec."Prepared By Date" := today;
                //end;
                if not (Rec.Reviewed and Rec.Approved) then
                    Error('Please review and approve before posting the document');
            end;
        }
        addafter("F&unctions")
        {
            action(Approve)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if RecUsersetup.get(UserId) then;
                    if recusersetup."BRS Approver" then begin
                        Rec.VALIDATE(Approved, true);
                        Rec.VALIDATE("Approved By Date", TODAY);
                        Rec.VALIDATE("Approver id", UserId);
                    end else
                        Error('Current user does not have rights to Approve');
                end;
            }
            action(Review)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if RecUsersetup.get(UserId) then;
                    if recusersetup."BRS Reviewer  " then begin
                        Rec.VALIDATE(Reviewed, true);
                        Rec.VALIDATE("Reviewed By Date", TODAY);
                        Rec.validate("Reviewer id", UserId);
                    end else
                        Error('Current user does not have rights to Review');
                end;
            }
            action(UndoReview)
            {
                ApplicationArea = All;
                Caption = 'Undo Review';
                trigger OnAction()
                VAR
                    RecUsersetup: Record "User Setup";
                begin
                    RecUsersetup.Reset;
                    RecUsersetup.SetRange("User ID", UserId);
                    if RecUsersetup.findfirst then;

                    if not RecUsersetup.UndoBRSReview then
                        Error('Current user does not have rights to undo the reviewed document');

                    Rec.VALIDATE(Reviewed, false);
                end;
            }
            action(ValidatePreparer)
            {
                ApplicationArea = All;
                Caption = 'Validate Preparer';
                trigger OnAction()
                VAR

                begin
                    Rec.VALIDATE("Prepared By", UserId);
                    Rec.validate("Prepared By Date", TODAY);
                end;
            }
            action(UndoApprove)
            {
                ApplicationArea = All;
                Caption = 'Undo Approve';
                trigger OnAction()
                VAR
                    RecUsersetup: Record "User Setup";
                begin
                    RecUsersetup.Reset;
                    RecUsersetup.SetRange("User ID", UserId);
                    if RecUsersetup.findfirst then;

                    if not RecUsersetup.UndoBRSApprove then
                        Error('Current user does not have rights to undo the Approved document');

                    Rec.VALIDATE(Approved, false);
                end;
            }
        }
    }

    var
        myInt: Integer;
        RecUsersetup: Record "User Setup";
}