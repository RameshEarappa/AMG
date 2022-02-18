tableextension 50112 "Ex_Table Purch. Rcpt. Header" extends "Purch. Rcpt. Header"
{
    fields
    {
        field(50000; "Received by"; Text[30])
        { }
        field(50160; "Vessel Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Value".Name where(Code = field("Shortcut Dimension 1 Code")));
        }
        field(50155; "Backcharge"; Option)
        {
            OptionMembers = " ",Yes,No;
            Editable = false;
            // Start 22.01.2020
            trigger
            OnValidate()
            var
                AMG_PurchLineG: Record "Purchase Line";

            begin
                /*if ("Document Type" = "Document Type"::Quote) OR ("Document Type" = "Document Type"::Order) then begin
                    if Backcharge = Backcharge::Yes then begin
                        AMG_PurchLineG.Reset();
                        AMG_PurchLineG.SetRange("Document No.", "No.");
                        AMG_PurchLineG.SetFilter(Type, '%1|%2|%3', AMG_PurchLineG.Type::"Fixed Asset", AMG_PurchLineG.Type::"Charge (Item)", AMG_PurchLineG.Type::Item);
                        if AMG_PurchLineG.FindFirst() then
                            Error('Back Charge only Applicable for GL Account.');
                    end;
                end;*/
            end;
            // Stop 22.01.2020
        }
        field(50156; "Backcharge To"; Text[100])
        {
            Editable = false;
        }
        field(50007; "Coordinator No."; Code[20])
        {
            Editable = false;
            Caption = 'Coordinator No';
            DataClassification = CustomerContent;
            TableRelation = Coordinator;
            trigger OnValidate()
            var
                Coordinator: Record Coordinator;
            begin
                IF Coordinator.Get("Coordinator No.") THEN
                    "Coordinator Name" := Coordinator."Coordinator Name"
                ELSE
                    "Coordinator Name" := '';
            end;
        }
        field(50008; "Coordinator Name"; Text[50])
        {
            Caption = 'Coordinator Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
    var
        myInt: Integer;
}
pageextension 50112 "Ex_Page Posted Purchase Rec" extends "Posted Purchase Receipt"
{
    layout
    {
        addafter("Responsibility Center")
        {
            field("Received by"; Rec."Received by")
            {
                Editable = false;
                ApplicationArea = All;
            }
        }
        addafter("Shortcut Dimension 1 Code")
        {
            field("Vessel Name"; Rec."Vessel Name")
            {
                ApplicationArea = all;
            }
            field("Coordinator No."; Rec."Coordinator No.")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Coordinator Name"; Rec."Coordinator Name")
            {
                ApplicationArea = all;
                Visible = false;

            }
            field("User ID"; Rec."User ID")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field(Backcharge; Rec.Backcharge)
            {
                ApplicationArea = all;
            }
            field("Backcharge To"; Rec."Backcharge To")
            {
                ApplicationArea = all;
            }

        }
    }

    actions
    {
        addafter(Statistics)
        {
            Action("Sales Invoice Summary Report")
            {
                ApplicationArea = All;
                Caption = 'MRN Report';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;
                trigger OnAction();
                var
                    GRNRep: Report "MRN Report";
                    PosPurRec: Record "Purch. Rcpt. Header";
                begin
                    Clear(GRNRep);
                    PosPurRec.SetRange("No.", Rec."No.");
                    GRNRep.SetTableView(PosPurRec);
                    GRNRep.RunModal();
                end;
            }
            Action("Delivery Journal Entries")
            {
                ApplicationArea = All;
                Caption = 'Delivery Journal Entries';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;
                trigger OnAction();
                var
                    DJERep: Report "Delivery Journal Entries";
                    PosPurRec: Record "Purch. Rcpt. Header";
                begin
                    Clear(DJERep);
                    PosPurRec.SetRange("No.", Rec."No.");
                    DJERep.SetTableView(PosPurRec);
                    DJERep.RunModal();
                end;
            }
        }

    }
}