tableextension 50105 Ex_SalesHead extends "Sales Header"
{

    fields
    {
        Field(50000; "Invoice Period"; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(50020; UserName; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50001; "Banck Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account";
            Caption = 'Bank Account';
        }

        field(50002; "Withholding Tax Percentage"; Option)
        {
            OptionMembers = "5","10","15";
        }

        field(50003; "Witholding Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Sales Line"."Unit Price" where("Document No." = field("No."), withholding = const(true)));
            Editable = false;
        }
        field(50004; Validity; Text[250]) { }
        field(50005; "Client Location"; Text[50]) { }
        field(50006; Exclusion; Text[250]) { }
        field(50007; Completion; Text[50]) { }
        field(50008; Location; Text[50]) { }
        field(50009; "Corresponding Bank"; Code[20])
        {
            TableRelation = "Bank Account";
            /*trigger OnValidate()
            begin
                If BankAC.Get("Corresponding Bank") then
                    "Corresponding Bank SWIFT Code" := BankAC."SWIFT Code";
                If "Corresponding Bank" = '' then
                    "Corresponding Bank SWIFT Code" := '';
            end;*/
        }
        field(50010; To_Customer_Name; Text[50])
        {
            Caption = 'To Customer';
        }
        field(50011; "SCOPE OF WORK"; TEXT[500])
        {
            Caption = 'Scope of Work';
        }

        field(50013; "QUOTATION STATUS"; Option)

        {
            Caption = 'Quotation Status';
            OptionMembers = "Approved","Awaiting for Reply","Not Approved";

        }
        field(50014; REMARKS; Text[100])
        {
            Caption = 'Remarks';
        }
        field(50015; "Invoice Text"; text[100]) { }
        field(50160; "Vessel Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Value".Name where(Code = field("Shortcut Dimension 1 Code")));
        }
        //field(50010; "Corresponding Bank SWIFT Code"; Code[20]) { }



    }
    var
        myInt: Integer;
        BankAC: Record "Bank Account";
}

pageextension 50105 EX_SalesInvoice extends "Sales Invoice"
{
    layout
    {

        addafter("Due Date")
        {
            field("Invoice Period"; Rec."Invoice Period")
            {
                ApplicationArea = All;
            }
            field("Banck Account"; Rec."Banck Account")
            {
                ApplicationArea = All;
            }
            field("Withholding Tax Percentage"; Rec."Withholding Tax Percentage")
            {
                ApplicationArea = All;
            }
            field("Shipping No. Series"; Rec."Shipping No. Series")
            {
                ApplicationArea = all;
            }
        }
        addafter("Banck Account")
        {
            field("Corresponding Bank"; Rec."Corresponding Bank")
            {
                ApplicationArea = all;
                Caption = 'Correspondent';
            }
            /*            field("Corresponding Bank SWIFT Code"; "Corresponding Bank SWIFT Code")
                        {
                            ApplicationArea = all;
                        }*/
        }
        addafter("Shortcut Dimension 1 Code")
        {
            field("Vessel Name"; Rec."Vessel Name")
            {
                ApplicationArea = all;
            }


        }


        modify("Shortcut Dimension 1 Code")
        {
            trigger OnAfterValidate()
            begin
                CurrPage.Update();
            end;
        }
        modify("Salesperson Code") { Visible = false; }
        modify("Campaign No.") { Visible = false; }
        modify("Responsibility Center") { Visible = false; }
        modify("Assigned User ID") { Visible = false; }
        modify("Work Description") { Visible = false; }
        moveafter("External Document No."; "Currency Code")
        moveafter("External Document No."; "VAT Bus. Posting Group")
        moveafter("External Document No."; "Payment Terms Code")
        moveafter("External Document No."; "Shortcut Dimension 2 Code")
        moveafter("External Document No."; "Shortcut Dimension 1 Code")

    }

    actions
    {

        modify(Post)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                Rec.TESTFIELD("Document Date");
                Rec.TestField("Payment Terms Code");
                Rec.TESTFIELD("Due Date");
            end;
        }

        addafter(Statistics)
        {
            Action("Sales Invoice MLS")
            {
                ApplicationArea = All;
                Caption = 'Sales Draft Invoice MLS';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;
                trigger OnAction();
                var
                    SlRep: Report "Draft_Sales Invoice MLS";
                    SlRec: Record "Sales Header";
                begin
                    Clear(SlRep);
                    SlRec.SetRange("No.", Rec."No.");
                    SlRep.SetTableView(SlRec);
                    SlRep.RunModal();
                end;
            }
            Action("Sales Invoice Withholding Tax")
            {
                ApplicationArea = All;
                Caption = 'Sales Draft Invoice Withholding Tax';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;
                trigger OnAction();
                var
                    SlRep: Report Draft_SalInvExcWitholdingTax;
                    SlRec: Record "Sales Header";
                begin
                    Clear(SlRep);
                    SlRec.SetRange("No.", Rec."No.");
                    SlRep.SetTableView(SlRec);
                    SlRep.RunModal();
                end;
            }
            Action("Proforma Invoice")
            {
                ApplicationArea = All;
                Caption = 'Proforma Invoice';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;
                trigger OnAction();
                var
                    SlRep: Report "Draft_Sales Proforma Invoice";
                    SlRec: Record "Sales Header";
                begin
                    Clear(SlRep);
                    SlRec.SetRange("No.", Rec."No.");
                    SlRep.SetTableView(SlRec);
                    SlRep.RunModal();
                end;
            }


            action("Update Witholding tax")
            {
                Promoted = true;
                PromotedCategory = Process;
                Image = UpdateXML;
                ApplicationArea = All;

                trigger OnAction();
                var
                    saleslinerec: Record "Sales Line";
                    salesinvLinerec: Record "Sales Line";
                    salesRecset: Record "Sales & Receivables Setup";
                    totalval: Decimal;
                    percent: Decimal;
                begin
                    clear(totalval);
                    salesRecset.Get();
                    if not salesRecset."Withholding Tax Customisation" then
                        exit;

                    salesRecset.TestField("Withholding Tax Acoount");
                    saleslinerec.Reset();
                    saleslinerec.SetRange("Document Type", saleslinerec."Document Type"::Invoice);
                    saleslinerec.SetRange("Document No.", Rec."No.");
                    if saleslinerec.FindSet then
                        repeat
                            totalval += saleslinerec.Amount;
                        until saleslinerec.Next = 0;


                    saleslinerec.Reset();
                    saleslinerec.SetRange("Document Type", saleslinerec."Document Type"::Invoice);
                    saleslinerec.SetRange("Document No.", Rec."No.");
                    if saleslinerec.FindLast then;

                    Evaluate(percent, FORMAT(Rec."Withholding Tax Percentage"));

                    salesinvLinerec.Reset();
                    salesinvLinerec.SetRange("Document Type", salesinvLinerec."Document Type"::Invoice);
                    salesinvLinerec.SetRange("Document No.", Rec."No.");
                    salesinvLinerec.SetRange(withholding, true);
                    if not salesinvLinerec.FindFirst() then begin

                        salesinvLinerec.Validate("Document Type", saleslinerec."Document Type");
                        salesinvLinerec.Validate("Document No.", saleslinerec."Document No.");
                        salesinvLinerec.Validate("Line No.", saleslinerec."Line No." + 10000);
                        salesinvLinerec.Validate(Type, salesinvLinerec.Type::"G/L Account");
                        salesinvLinerec.Validate("No.", salesRecset."Withholding Tax Acoount");
                        salesinvLinerec.Validate(Quantity, 1);
                        salesinvLinerec.validate("Unit Price", -totalval * (percent / 100));
                        //salesinvLinerec.Amount := -totalval * (Rec."Withholding Tax Percentage" / 100);
                        salesinvLinerec.withholding := true;
                        salesinvLinerec.Insert;
                    end else
                        Error('Already a line for witholding tax exists');
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        SalAndRecSetup.Get();
        If Rec."Banck Account" = '' then
            Rec."Banck Account" := SalAndRecSetup."bank Account";
        Rec."Withholding Tax Percentage" := SalAndRecSetup."Withholding Tax Percentage";

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Validate(UserName, UserId);
    end;

    var
        SalAndRecSetup: Record "Sales & Receivables Setup";


}
