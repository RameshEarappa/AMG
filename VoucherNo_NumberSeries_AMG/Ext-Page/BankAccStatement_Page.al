pageextension 60100 BankStatement extends "Bank Account Statement"
{
    layout
    {
        addafter("Statement Date")
        {
            field("Reviewed By Date"; Rec."Reviewed By Date")
            {
                ApplicationArea = All;
                //FieldPropertyName = FieldPropertyValue;
            }
            field("approved By Date"; Rec."Approved By Date")
            {
                ApplicationArea = All;
                //FieldPropertyName = FieldPropertyValue;
            }
            field("Reviewer ID"; Rec."Reviewer id")
            {
                ApplicationArea = All;
                //FieldPropertyName = FieldPropertyValue;
            }
            field("Approver ID"; Rec."Approver id")
            {
                ApplicationArea = All;
                //FieldPropertyName = FieldPropertyValue;
            }
        }
    }

    actions
    {
        addafter("St&atement")
        {
            action(Review)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.Validate("Reviewed By Date", Today);
                end;
            }
            action(Approve)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.Validate("Approved By Date", Today);
                end;
            }
        }
    }

    var
        myInt: Integer;
}