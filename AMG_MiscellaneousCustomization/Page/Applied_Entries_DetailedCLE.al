report 60120 AppliedEntries
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(CustLedgEntry; "Cust. Ledger Entry")
        {
            RequestFilterFields = "Document Type", "Document No.", "Posting Date", "Customer No.";
            column(CustomerNo; "Customer No.") { }
            column(Posting_Date; "Posting Date") { }
            column(Document_Type; "Document Type") { }
            column(Document_No_; "Document No.") { }
            column(Currency_Code; "Currency Code") { }
            column(Original_Amount; "Original Amount") { }
            column(Remaining_Amount; "Remaining Amount") { }

            trigger OnAfterGetRecord()
            begin
                CalcFields(Amount, "Amount (LCY)");
                ExcelBuffer.NewRow;
                ExcelBuffer.AddColumn('Initial Entry', FALSE, '', TRUE, FALSE, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn("Posting Date", FALSE, '', TRUE, FALSE, false, '', ExcelBuffer."Cell Type"::Date);
                ExcelBuffer.AddColumn("Document Type", FALSE, '', TRUE, FALSE, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn("Document No.", FALSE, '', TRUE, FALSE, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn("Customer No.", FALSE, '', TRUE, FALSE, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn("Currency Code", FALSE, '', TRUE, FALSE, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Amount, FALSE, '', TRUE, FALSE, false, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn("Amount (LCY)", FALSE, '', TRUE, FALSE, false, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn("Entry No.", FALSE, '', TRUE, FALSE, false, '', ExcelBuffer."Cell Type"::Number);

                CLEAR(Cust2);
                CLEAR(AppliedCLE);
                CLEAR(AppliedCLE2);
                CLEAR(AppliedCLE3);
                CLEAR(PaymentDate);
                IF Cust2.GET(CustLedgEntry."Customer No.") THEN;

                DtldCustLedgEntry1.SETCURRENTKEY("Cust. Ledger Entry No.");
                DtldCustLedgEntry1.SETRANGE("Cust. Ledger Entry No.", CustLedgEntry."Entry No.");
                DtldCustLedgEntry1.SETRANGE(Unapplied, FALSE);
                IF DtldCustLedgEntry1.FIND('-') THEN
                    REPEAT
                        IF DtldCustLedgEntry1."Cust. Ledger Entry No." = DtldCustLedgEntry1."Applied Cust. Ledger Entry No." THEN BEGIN
                            DtldCustLedgEntry2.INIT;
                            DtldCustLedgEntry2.SETCURRENTKEY("Applied Cust. Ledger Entry No.", "Entry Type");
                            DtldCustLedgEntry2.SETRANGE(
                              "Applied Cust. Ledger Entry No.", DtldCustLedgEntry1."Applied Cust. Ledger Entry No.");
                            DtldCustLedgEntry2.SETRANGE("Entry Type", DtldCustLedgEntry2."Entry Type"::Application);
                            DtldCustLedgEntry2.SETRANGE(Unapplied, FALSE);
                            IF DtldCustLedgEntry2.FIND('-') THEN
                                REPEAT
                                    IF DtldCustLedgEntry2."Cust. Ledger Entry No." <>
                                       DtldCustLedgEntry2."Applied Cust. Ledger Entry No."
                                    THEN BEGIN
                                        AppliedCLE2.SETCURRENTKEY("Entry No.");
                                        AppliedCLE2.SETRANGE("Entry No.", DtldCustLedgEntry2."Cust. Ledger Entry No.");

                                        IF AppliedCLE2.FIND('-') THEN BEGIN
                                            AppliedCLE2.CalcFields(Amount, "Amount (LCY)");
                                            ExcelBuffer.NewRow;
                                            ExcelBuffer.AddColumn('Application Entry', FALSE, '', TRUE, FALSE, false, '', ExcelBuffer."Cell Type"::Text);
                                            ExcelBuffer.AddColumn(AppliedCLE2."Posting Date", FALSE, '', TRUE, FALSE, false, '', ExcelBuffer."Cell Type"::Date);
                                            ExcelBuffer.AddColumn(AppliedCLE2."Document Type", FALSE, '', TRUE, FALSE, false, '', ExcelBuffer."Cell Type"::Text);
                                            ExcelBuffer.AddColumn(AppliedCLE2."Document No.", FALSE, '', TRUE, FALSE, false, '', ExcelBuffer."Cell Type"::Text);
                                            ExcelBuffer.AddColumn(AppliedCLE2."Customer No.", FALSE, '', TRUE, FALSE, false, '', ExcelBuffer."Cell Type"::Text);
                                            ExcelBuffer.AddColumn(AppliedCLE2."Currency Code", FALSE, '', TRUE, FALSE, false, '', ExcelBuffer."Cell Type"::Text);
                                            ExcelBuffer.AddColumn(AppliedCLE2.Amount, FALSE, '', TRUE, FALSE, false, '', ExcelBuffer."Cell Type"::Number);
                                            ExcelBuffer.AddColumn(AppliedCLE2."Amount (LCY)", FALSE, '', TRUE, FALSE, false, '', ExcelBuffer."Cell Type"::Number);
                                            ExcelBuffer.AddColumn(AppliedCLE2."Entry No.", FALSE, '', TRUE, FALSE, false, '', ExcelBuffer."Cell Type"::Number);

                                        END;
                                    END;
                                UNTIL DtldCustLedgEntry2.NEXT = 0;
                        END ELSE BEGIN
                            AppliedCLE3.SETCURRENTKEY("Entry No.");
                            AppliedCLE3.SETRANGE("Entry No.", DtldCustLedgEntry1."Applied Cust. Ledger Entry No.");
                            IF AppliedCLE3.FIND('-') THEN BEGIN
                                AppliedCLE3.CalcFields(Amount, "Amount (LCY)");
                                ExcelBuffer.NewRow;
                                ExcelBuffer.AddColumn('Application Entry', FALSE, '', TRUE, FALSE, false, '', ExcelBuffer."Cell Type"::text);
                                ExcelBuffer.AddColumn(AppliedCLE3."Posting Date", FALSE, '', TRUE, FALSE, false, '', ExcelBuffer."Cell Type"::Date);
                                ExcelBuffer.AddColumn(AppliedCLE3."Document Type", FALSE, '', TRUE, FALSE, false, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(AppliedCLE3."Document No.", FALSE, '', TRUE, FALSE, false, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(AppliedCLE3."Customer No.", FALSE, '', TRUE, FALSE, false, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(AppliedCLE3."Currency Code", FALSE, '', TRUE, FALSE, false, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(AppliedCLE3.Amount, FALSE, '', TRUE, FALSE, false, '', ExcelBuffer."Cell Type"::Number);
                                ExcelBuffer.AddColumn(AppliedCLE3."Amount (LCY)", FALSE, '', TRUE, FALSE, false, '', ExcelBuffer."Cell Type"::Number);
                                ExcelBuffer.AddColumn(AppliedCLE3."Entry No.", FALSE, '', TRUE, FALSE, false, '', ExcelBuffer."Cell Type"::Number);
                            END;
                        END;
                    UNTIL DtldCustLedgEntry1.NEXT = 0;

            end;


        }


    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(General)
                {
                }
            }

        }




    }

    var
        myInt: Integer;

        Cust2: Record Customer;
        AppliedCLE: Record "Cust. Ledger Entry";
        DtldCustLedgEntry1: Record "Detailed Cust. Ledg. Entry";
        DtldCustLedgEntry2: Record "Detailed Cust. Ledg. Entry";
        AppliedCLE2: Record "Cust. Ledger Entry";
        AppliedCLE3: Record "Cust. Ledger Entry";
        PaymentDate: Date;
        ExcelBuffer: Record "Excel Buffer";

    trigger OnPreReport()
    begin
        ExcelBuffer.DeleteAll();
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('Entry Type', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Posting Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Document Type', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Document No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Customer No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Currency Code', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Amount', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Amount (LCY)', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Entry No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);

    end;

    trigger OnPostReport()
    begin

        ExcelBuffer.CreateNewBook('Applied Entries');
        ExcelBuffer.WriteSheet('Applied Entries', CompanyName(), UserId());
        ExcelBuffer.CloseBook();
        ExcelBuffer.OpenExcel();
    end;

}
