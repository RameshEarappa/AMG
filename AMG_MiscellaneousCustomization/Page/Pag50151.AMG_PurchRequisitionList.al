page 50151 AMG_PurchRequisitionList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = AMG_PurchRequisitionHeader;
    Caption = 'Purchase Requisition List';
    SourceTableView = sorting("No.") order(descending) where(Cancelled = filter(false));
    CardPageId = AMG_PurchRequisitionCard;
    DeleteAllowed = false;
    Editable = false;


    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the involved purchase requisition record, according to the specified number series.';
                }
                field("Requisition Date"; Rec."Requisition Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when purchase requisition is created.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }

                field("Vessel Name"; Rec."Vessel Name")
                {
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for Shortcut Dimension 3, which is codes that you set up in the General Ledger Setup window.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
                field(Cancelled; Rec.Cancelled)
                {
                    ApplicationArea = all;
                }
                field("Created Date"; Rec."Created Date")
                {

                    ApplicationArea = all;
                }
                field("Order Status"; Rec."Order Status")
                {
                    ApplicationArea = all;
                    Editable = false;
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Import Purchase Requsision")
            {
                RunObject = xmlport "Import CSV";
                Promoted = true;
                PromotedOnly = true;
                ApplicationArea = ALL;
                Image = ImportExcel;
                trigger OnAction()
                begin


                end;
            }
            action("Export Layout")
            {
                RunObject = xmlport "Export Layout Csv";
                Promoted = true;
                PromotedOnly = true;
                ApplicationArea = all;
                Image = ExportToExcel;
                trigger OnAction()
                begin


                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    Var
        LineRec: Record AMG_PurchRequisitionLine;
    begin
        LineRec.UpdateOrderStatus(Rec."No.");
    End;

    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
        LineRec: Record AMG_PurchRequisitionLine;
    begin
        LineRec.UpdateOrderStatus(rec."No.");
    end;

    trigger OnOpenPage()
    Var
        LineRec: Record AMG_PurchRequisitionLine;
    begin
        LineRec.UpdateOrderStatus(Rec."No.");
    End;

}