pageextension 50159 pageextension50159 extends "Purchase Order List"
{
    layout
    {

        modify("Vendor Authorization No.")
        {
            Visible = false;
        }

        modify("Assigned User ID")
        {
            Visible = false;
        }
        addafter("Location Code")
        {
            field("Coordinator Name"; Rec."Coordinator Name")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Vessel Name"; Rec."Vessel Name")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field(AMG_InitSourceNo; Rec.AMG_InitSourceNo)
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Mubarak Supplier"; Rec."Mubarak Supplier")
            {
                ApplicationArea = ALL;
            }
            field("Mubark Supplier Name"; Rec."Mubark Supplier Name")
            {
                ApplicationArea = ALL;
            }
            field(Agency; Rec.Agency)
            {
                ApplicationArea = All;

            }
            field("Record Created By"; Rec."Record Created By")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Approved By"; Rec."Approved By")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }

    actions
    {
        addafter("Request Approval")
        {
            action("Import Excel Purchase Order")
            {
                ApplicationArea = All;
                trigger OnAction()
                var
                    myInt: Integer;
                begin
                    //   Report.Run(Report::"Import Excel Purchase Order");
                end;
            }
            group(Update)
            {
                action("Update Status")
                {
                    ApplicationArea = All;
                    Image = UpdateDescription;
                    trigger OnAction()
                    var
                        UpdateStatus: Report "Update PO Status";
                    begin
                        UpdateStatus.RunModal();
                    end;
                }
            }
        }

    }
    // actions
    // {
    //     addafter(Print)
    //     {
    //         action("Import CSV")
    //         {
    //             ApplicationArea = All;
    //             RunObject = xmlport "Import CSV";
    //         }
    //     }
    // }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
        GLSetup: Record "General Ledger Setup";
        DimSetEntRec: Record "Dimension Set Entry";
    begin
        Rec.SetAscending("No.", false);
        GLSetup.Get();
        DimSetEntRec.Reset();
        DimSetEntRec.SetRange("Dimension set ID", rEC."Dimension Set ID");
        DimSetEntRec.SetRange("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
        if DimSetEntRec.FindFirst() then begin
            //DimSetEntRec.CalcFields("Dimension Value Code");
            Rec."Project Code" := DimSetEntRec."Dimension Value Code"
        End;
    end;

    trigger OnOpenPage()
    begin
        Rec.FindLast();
        Rec.FilterGroup(2);
        Rec.SetRange(AMG_ShortClosedOrCancelled, false);
    end;
}

pageextension 50163 pageextension501593 extends "Purchase Quotes"
{
    layout
    {
        addafter("Location Code")
        {
            field("Vessel Name"; Rec."Vessel Name")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Responsibility Center"; Rec."Responsibility Center")
            {
                ApplicationArea = All;

            }
            field("Mubarak Supplier"; Rec."Mubarak Supplier")
            {
                ApplicationArea = all;
            }
            field("Mubark Supplier Name"; Rec."Mubark Supplier Name")
            {
                ApplicationArea = all;
            }
        }
    }
}