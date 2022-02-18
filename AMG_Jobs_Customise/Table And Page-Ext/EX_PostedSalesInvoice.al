tableextension 50106 Ex_PosSalesHead extends "Sales Invoice Header"
{

    fields
    {
        Field(50000; "Invoice Period"; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(50001; "Bank Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account";
        }
        // field(50002; "Project Code"; Code[20])
        // {
        // }
        field(50100; "Project Code"; Code[20])
        {
        }
        field(50009; "Corresponding Bank"; Code[20])
        { }
        //field(50010; "Corresponding Bank SWIFT Code"; Code[20]) { }
        field(50160; "Vessel Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Value".Name where(Code = field("Shortcut Dimension 1 Code")));
        }
    }

    var
        myInt: Integer;
}

pageextension 50106 EX_PosSalesInvoiceHead extends "Posted Sales Invoice"
{
    layout
    {
        addafter("Due Date")
        {
            field("Invoice Period"; Rec."Invoice Period")
            {
                Editable = false;
                ApplicationArea = All;
            }
            field("Bank Account"; Rec."Bank Account")
            {
                Editable = false;
                ApplicationArea = All;
            }
        }
        addafter("Bank Account")
        {
            field("Corresponding Bank"; Rec."Corresponding Bank")
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'Correspondent';
            }
            /*   field("Corresponding Bank SWIFT Code"; "Corresponding Bank SWIFT Code")
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
            field("Project Code"; Rec."Project Code")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }

    actions
    {
        addafter(Print)
        {
            Action("Sales Invoice Report")
            {
                Visible = false;
                ApplicationArea = All;
                Caption = 'Sales Invoice Aramco';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;
                trigger OnAction();
                var
                    SalRep: Report "Sales Invoice Report";
                    PosSalInv: Record "Sales Invoice Header";
                begin
                    Clear(SalRep);
                    PosSalInv.SetRange("No.", Rec."No.");
                    SalRep.SetTableView(PosSalInv);
                    SalRep.RunModal();
                end;
            }
            Action("Sales Invoice Summary Report")
            {
                Visible = false;
                ApplicationArea = All;
                Caption = 'Sales Invoice Aramco Summary';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;
                trigger OnAction();
                var
                    SummRep: Report "Sales Invoice Summary Report";
                    PosSalInv: Record "Sales Invoice Header";
                begin
                    Clear(SummRep);
                    PosSalInv.SetRange("No.", Rec."No.");
                    SummRep.SetTableView(PosSalInv);
                    SummRep.RunModal();
                end;
            }
            /*Action("Export Invoice")
            {
                ApplicationArea = All;
                Caption = 'Export Invoice Report';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;
                trigger OnAction();
                var
                    ExpRep: Report "Export Invoice";
                    PosSalInv: Record "Sales Invoice Header";
                begin
                    Clear(ExpRep);
                    PosSalInv.SetRange("No.", "No.");
                    ExpRep.SetTableView(PosSalInv);
                    ExpRep.RunModal();
                end;
            }*/
            Action("Local Invoice")
            {
                ApplicationArea = All;
                Caption = 'Sales Invoice Invoice MLS';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;
                trigger OnAction();
                var
                    LocRep: Report "Sales Invoice Invoice MLS";
                    PosSalInv: Record "Sales Invoice Header";
                begin
                    Clear(LocRep);
                    PosSalInv.SetRange("No.", Rec."No.");
                    LocRep.SetTableView(PosSalInv);
                    LocRep.RunModal();
                end;
            }
            Action("Sales Invoice Invoice SRM")
            {
                ApplicationArea = All;
                Caption = 'Sales Invoice Invoice SRM';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;
                trigger OnAction();
                var
                    LocSRMRep: Report "Sales Invoice Invoice_Srm";
                    PosSalInv: Record "Sales Invoice Header";
                begin
                    Clear(LocSRMRep);
                    PosSalInv.SetRange("No.", Rec."No.");
                    LocSRMRep.SetTableView(PosSalInv);
                    LocSRMRep.RunModal();
                end;
            }
            Action("SalInvExcWitholdingTax")
            {
                ApplicationArea = All;
                Caption = 'Sales Invoice Excluding Witholding Tax';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;
                trigger OnAction();
                var
                    LocSRMRep: Report "SalInvExcWitholdingTax";
                    PosSalInv: Record "Sales Invoice Header";
                begin
                    Clear(LocSRMRep);
                    PosSalInv.SetRange("No.", Rec."No.");
                    LocSRMRep.SetTableView(PosSalInv);
                    LocSRMRep.RunModal();
                end;
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    var
        GLSetup: Record "General Ledger Setup";
        DimSetEntRec: Record "Dimension Set Entry";
    begin
        GLSetup.Get();
        DimSetEntRec.Reset();
        DimSetEntRec.SetRange("Dimension set ID", rEC."Dimension Set ID");
        DimSetEntRec.SetRange("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
        if DimSetEntRec.FindFirst() then begin
            //DimSetEntRec.CalcFields("Dimension Value Code");
            Rec."Project Code" := DimSetEntRec."Dimension Value Code"
        End;
    eND;

    trigger OnAfterGetRecord()
    var
        GLSetup: Record "General Ledger Setup";
        DimSetEntRec: Record "Dimension Set Entry";
    begin
        GLSetup.Get();
        DimSetEntRec.Reset();
        DimSetEntRec.SetRange("Dimension set ID", rEC."Dimension Set ID");
        DimSetEntRec.SetRange("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
        if DimSetEntRec.FindFirst() then begin
            //DimSetEntRec.CalcFields("Dimension Value Code");
            Rec."Project Code" := DimSetEntRec."Dimension Value Code"
        End;
    eND;

    trigger OnOpenPage()
    var
        GLSetup: Record "General Ledger Setup";
        DimSetEntRec: Record "Dimension Set Entry";
    begin
        GLSetup.Get();
        DimSetEntRec.Reset();
        DimSetEntRec.SetRange("Dimension set ID", rEC."Dimension Set ID");
        DimSetEntRec.SetRange("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
        if DimSetEntRec.FindFirst() then begin
            //DimSetEntRec.CalcFields("Dimension Value Code");
            Rec."Project Code" := DimSetEntRec."Dimension Value Code"
        End;
    eND;

    var
        myInt: Integer;
}
