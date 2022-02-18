pageextension 50177 BankRecon extends "Bank Account Statement List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here

        addfirst(Reporting)
        {
            action(Print_AMG)

            {
                ApplicationArea = All;
                Image = PrintReport;
                Caption = 'Print';
                trigger OnAction()
                var
                    bankReport: Report "Bank Reconciliation Report";
                    BankRecon: Record "Bank Acc. Reconciliation";
                begin
                    Clear(BankRecon);
                    BankRecon.SetRange("Bank Account No.", Rec."Bank Account No.");
                    //BankRecon.SetRange("Statement Type", Rec."Statement Type");
                    BankRecon.SetRange("Statement No.", Rec."Statement No.");
                    if BankRecon.FindFirst() then begin
                        // bankReport.UseRequestPage := true;
                        bankReport.SetValues(BankRecon, Rec."Bank Account No.");
                        bankReport.Run();
                    end;
                end;
            }

            action("Print BRS")
            {
                ApplicationArea = All;
                Image = PrintReport;
                trigger OnAction()
                var
                    BRSReport: Report "BRS Report";
                    RecBankAcc: Record "Bank Account";
                begin
                    Clear(RecBankAcc);
                    BRSReport.SetValues(Rec."Bank Account No.", Rec."Statement No.");
                    BRSReport.Run();
                    //RecBankAcc.SetRange("Bank Account No.", Rec."Bank Account No.");
                    //if RecBankAcc.FindFirst() then begin
                    // BRSReport.SetTableView(RecBankAcc);
                    //   BRSReport.Run();
                    // end;
                end;
            }
            action(Review)
            {
                ApplicationArea = All;
                Visible = False;
                trigger OnAction()
                VAR
                    RecUsersetup: Record "User Setup";
                begin
                    RecUsersetup.Reset;
                    RecUsersetup.SetRange("User ID", UserId);
                    if RecUsersetup.findfirst then;

                    if not RecUsersetup."BRS Reviewer  " then
                        Error('Current user does not have rights to review');

                    Rec.VALIDATE("Reviewed By Date", Today);
                end;
            }
            action(Approve)
            {
                ApplicationArea = All;
                Visible = False;
                trigger OnAction()
                VAR
                    RecUsersetup: Record "User Setup";
                begin
                    RecUsersetup.Reset;
                    RecUsersetup.SetRange("User ID", UserId);
                    if RecUsersetup.findfirst then;

                    if not RecUsersetup."BRS Approver" then
                        Error('Current user does not have rights to approve');

                    Rec.VALIDATE("Approved By Date", Today);
                end;
            }

        }


    }

    var
        myInt: Integer;
}