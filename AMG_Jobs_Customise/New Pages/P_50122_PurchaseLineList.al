page 50122 "Purchase Order Line List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Purchase Line";
    SourceTableView = SORTING("Document Type", "Document No.", "Line No.") ORDER(Ascending) WHERE("Document Type" = FILTER(Order));
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ShowFilter = false;
    Caption = 'Purchase Order Line';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document No."; Rec."Document No.") { ApplicationArea = all; }
                field("Line No."; Rec."Line No.") { ApplicationArea = all; }
                field("No."; Rec."No.") { ApplicationArea = all; }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group") { ApplicationArea = all; }
                field(Description; Rec.Description) { ApplicationArea = all; }
                field("Item Category Code"; Rec."Item Category Code") { ApplicationArea = all; }
                field("Location Code"; Rec."Location Code") { ApplicationArea = all; }
                //      field("Bin Code"; "Bin Code") { ApplicationArea = all; }
                field(Quantity; Rec.Quantity) { ApplicationArea = all; }
                field("Qty. to Receive"; Rec."Qty. to Receive") { ApplicationArea = all; }
                field("Quantity Received"; Rec."Quantity Received") { ApplicationArea = all; }
                field("Unit of Measure Code"; Rec."Unit of Measure Code") { ApplicationArea = all; }
                field("Direct Unit Cost"; Rec."Direct Unit Cost") { ApplicationArea = all; }
                field("Line Amount"; Rec."Line Amount") { ApplicationArea = all; }
                field("Quantity Invoiced"; Rec."Quantity Invoiced") { ApplicationArea = all; }
                //field("Qty. Assigned"; "Qty. Assigned") { ApplicationArea = all; }
                //    field("Promised Receipt Date"; "Promised Receipt Date") { ApplicationArea = all; }
                //  field("Planned Receipt Date"; "Planned Receipt Date") { ApplicationArea = all; }
                //field("Expected Receipt Date"; "Expected Receipt Date") { ApplicationArea = all; }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code") { ApplicationArea = all; }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code") { ApplicationArea = all; }
                field(AMG_ShortClosed; Rec.AMG_ShortClosed) { ApplicationArea = All; }
                field(AMG_ShortClosedQty; Rec.AMG_ShortClosedQty) { ApplicationArea = All; }
                field(AMG_Cancelled; Rec.AMG_Cancelled) { ApplicationArea = All; }
                field(AMG_CancelledQty; Rec.AMG_CancelledQty) { ApplicationArea = All; }
                field(AMG_InitSourceNo; Rec.AMG_InitSourceNo) { ApplicationArea = All; }
                field(AMG_InitSourceLineNo; Rec.AMG_InitSourceLineNo) { ApplicationArea = All; }
                //field(Backcharge; Backcharge) { ApplicationArea = All; }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group") { ApplicationArea = All; }
                field("Line No"; Rec."Line No.") { ApplicationArea = All; }
                //field("Qty to Receive"; "Qty. to Receive") { ApplicationArea = All; }
                //field("Document Type"; "Document Type") { ApplicationArea = All; }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.") { ApplicationArea = All; }
                field("Posting Group"; Rec."Posting Group") { ApplicationArea = All; }
                //field("Description 2"; "Description 2") { ApplicationArea = All; }
                //field("Unit of Measure"; "Unit of Measure") { ApplicationArea = All; }
                field("Outstanding Quantity"; Rec."Outstanding Quantity") { ApplicationArea = All; }
                field("Qty. to Invoice"; Rec."Qty. to Invoice") { ApplicationArea = All; }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)") { ApplicationArea = All; }
                field("VAT %"; Rec."VAT %") { ApplicationArea = All; }
                field("Line Discount %"; Rec."Line Discount %") { ApplicationArea = All; }
                field("Line Discount Amount"; Rec."Line Discount Amount") { ApplicationArea = All; }
                field(Amount; Rec.Amount) { ApplicationArea = All; }
                field("Amount Including VAT"; Rec."Amount Including VAT") { ApplicationArea = All; }
                field("Outstanding Amount"; Rec."Outstanding Amount") { ApplicationArea = All; }
                field("Qty. Rcd. Not Invoiced"; Rec."Qty. Rcd. Not Invoiced") { ApplicationArea = All; }
                field("Amt. Rcd. Not Invoiced"; Rec."Amt. Rcd. Not Invoiced") { ApplicationArea = All; }
                field("Inv. Discount Amount"; Rec."Inv. Discount Amount") { ApplicationArea = All; }
                field("Currency Code"; Rec."Currency Code") { ApplicationArea = All; }
                field("Outstanding Amount (LCY)"; Rec."Outstanding Amount (LCY)") { ApplicationArea = All; }
                field("Amt. Rcd. Not Invoiced (LCY)"; Rec."Amt. Rcd. Not Invoiced (LCY)") { ApplicationArea = All; }
                field("Unit Cost"; Rec."Unit Cost") { ApplicationArea = All; }
                field("Outstanding Amt. Ex. VAT (LCY)"; Rec."Outstanding Amt. Ex. VAT (LCY)") { ApplicationArea = All; }
                field("A. Rcd. Not Inv. Ex. VAT (LCY)"; Rec."A. Rcd. Not Inv. Ex. VAT (LCY)") { ApplicationArea = All; }
                //field("Unit Price (LCY)"; "Unit Price (LCY)") { ApplicationArea = All; }
                //field("Allow Invoice Disc."; "Allow Invoice Disc.") { ApplicationArea = All; }
                //field("Gross Weight"; "Gross Weight") { ApplicationArea = All; }
                //field("Net Weight"; "Net Weight") { ApplicationArea = All; }
                //field("Units per Parcel"; "Units per Parcel") { ApplicationArea = All; }
                //field("Unit Volume"; "Unit Volume") { ApplicationArea = All; }
                //0field("Appl.-to Item Entry"; "Appl.-to Item Entry") { ApplicationArea = All; }
                //field("Job No."; "Job No.") { ApplicationArea = All; }
                //field("Indirect Cost %"; "Indirect Cost %") { ApplicationArea = All; }
                //field("Recalculate Invoice Disc."; "Recalculate Invoice Disc.") { ApplicationArea = All; }

                //field("Receipt No."; "Receipt No.") { ApplicationArea = All; }
                //field("Receipt Line No."; "Receipt Line No.") { ApplicationArea = All; }
                //field("Order No."; "Order No.") { ApplicationArea = All; }
                //field("Order Line No."; "Order Line No.") { ApplicationArea = All; }
                //field("Profit %"; "Profit %") { ApplicationArea = All; }
                //field("Pay-to Vendor No."; "Pay-to Vendor No.") { ApplicationArea = All; }

                //field("Vendor Item No."; "Vendor Item No.") { ApplicationArea = All; }
                //field("Sales Order No."; "Sales Order No.") { ApplicationArea = All; }
                //field("Sales Order Line No."; "Sales Order Line No.") { ApplicationArea = All; }
                //field("Drop Shipment"; "Drop Shipment") { ApplicationArea = All; }
                //field("VAT Calculation Type"; "VAT Calculation Type") { ApplicationArea = All; }
                //field("Transaction Type"; "Transaction Type") { ApplicationArea = All; }
                //field("Transport Method"; "Transport Method") { ApplicationArea = All; }
                /*field("Attached to Line No."; "Attached to Line No.") { ApplicationArea = All; }
                field("Entry Point"; "Entry Point") { ApplicationArea = All; }
                field("Area"; "Area") { ApplicationArea = All; }
                field("Transaction Specification"; "Transaction Specification") { ApplicationArea = All; }
                field("Tax Area Code"; "Tax Area Code") { ApplicationArea = All; }
                field("Tax Liable"; "Tax Liable") { ApplicationArea = All; }
                field("Tax Group Code"; "Tax Group Code") { ApplicationArea = All; }
                field("Use Tax"; "Use Tax") { ApplicationArea = All; }
                field("VAT Bus. Posting Group"; "VAT Bus. Posting Group") { ApplicationArea = All; }
                field("VAT Prod. Posting Group"; "VAT Prod. Posting Group") { ApplicationArea = All; }*/

                /*field("Reserved Quantity"; "Reserved Quantity") { ApplicationArea = All; }
                field("Blanket Order No."; "Blanket Order No.") { ApplicationArea = All; }
                field("Blanket Order Line No."; "Blanket Order Line No.") { ApplicationArea = All; }
                field("VAT Base Amount"; "VAT Base Amount") { ApplicationArea = All; }*/

                /*field("System-Created Entry"; "System-Created Entry") { ApplicationArea = All; }
                field("VAT Difference"; "VAT Difference") { ApplicationArea = All; }
                field("Inv. Disc. Amount to Invoice"; "Inv. Disc. Amount to Invoice") { ApplicationArea = All; }
                field("IC Partner Ref. Type"; "IC Partner Ref. Type") { ApplicationArea = All; }
                field("IC Partner Reference"; "IC Partner Reference") { ApplicationArea = All; }
                field("Prepayment %"; "Prepayment %") { ApplicationArea = All; }
                field("Prepmt. Line Amount"; "Prepmt. Line Amount") { ApplicationArea = All; }
                field("Prepmt. Amt. Inv."; "Prepmt. Amt. Inv.") { ApplicationArea = All; }
                field("Prepmt. Amt. Incl. VAT"; "Prepmt. Amt. Incl. VAT") { ApplicationArea = All; }
                field("Prepayment Amount"; "Prepayment Amount") { ApplicationArea = All; }
                field("Prepmt. VAT Base Amt."; "Prepmt. VAT Base Amt.") { ApplicationArea = All; }
                field("Prepayment VAT %"; "Prepayment VAT %") { ApplicationArea = All; }
                field("Prepmt. VAT Calc. Type"; "Prepmt. VAT Calc. Type") { ApplicationArea = All; }
                field("Prepayment VAT Identifier"; "Prepayment VAT Identifier") { ApplicationArea = All; }
                field("Prepayment Tax Area Code"; "Prepayment Tax Area Code") { ApplicationArea = All; }
                field("Prepayment Tax Liable"; "Prepayment Tax Liable") { ApplicationArea = All; }
                field("Prepayment Tax Group Code"; "Prepayment Tax Group Code") { ApplicationArea = All; }
                field("Prepmt Amt to Deduct"; "Prepmt Amt to Deduct") { ApplicationArea = All; }
                field("Prepmt Amt Deducted"; "Prepmt Amt Deducted") { ApplicationArea = All; }
                field("Prepayment Line"; "Prepayment Line") { ApplicationArea = All; }
                field("Prepmt. Amount Inv. Incl. VAT"; "Prepmt. Amount Inv. Incl. VAT") { ApplicationArea = All; }

                field("Prepmt. Amount Inv. (LCY)"; "Prepmt. Amount Inv. (LCY)") { ApplicationArea = All; }
                field("IC Partner Code"; "IC Partner Code") { ApplicationArea = All; }
                field("Prepmt. VAT Amount Inv. (LCY)"; "Prepmt. VAT Amount Inv. (LCY)") { ApplicationArea = All; }
                field("Prepayment VAT Difference"; "Prepayment VAT Difference") { ApplicationArea = All; }
                field("Prepmt VAT Diff. to Deduct"; "Prepmt VAT Diff. to Deduct") { ApplicationArea = All; }
                field("Prepmt VAT Diff. Deducted"; "Prepmt VAT Diff. Deducted") { ApplicationArea = All; }*/

                /*field("Pmt. Discount Amount"; "Pmt. Discount Amount") { ApplicationArea = All; }
                field("Dimension Set ID"; "Dimension Set ID") { ApplicationArea = All; }
                field("Job Task No."; "Job Task No.") { ApplicationArea = All; }
                field("Job Line Type"; "Job Line Type") { ApplicationArea = All; }
                field("Job Unit Price"; "Job Unit Price") { ApplicationArea = All; }
                field("Job Total Price (LCY)"; "Job Total Price (LCY)") { ApplicationArea = All; }
                field("Job Line Amount (LCY)"; "Job Line Amount (LCY)") { ApplicationArea = All; }
                field("Job Line Disc. Amount (LCY)"; "Job Line Disc. Amount (LCY)") { ApplicationArea = All; }
                field("Job Currency Factor"; "Job Currency Factor") { ApplicationArea = All; }
                field("Job Currency Code"; "Job Currency Code") { ApplicationArea = All; }
                field("Job Planning Line No."; "Job Planning Line No.") { ApplicationArea = All; }
                field("Job Remaining Qty."; "Job Remaining Qty.") { ApplicationArea = All; }
                field("Job Remaining Qty. (Base)"; "Job Remaining Qty. (Base)") { ApplicationArea = All; }
                field("Deferral Code"; "Deferral Code") { ApplicationArea = All; }
                field("Returns Deferral Start Date"; "Returns Deferral Start Date") { ApplicationArea = All; }
                field("Prod. Order No."; "Prod. Order No.") { ApplicationArea = All; }
                field("Variant Code"; "Variant Code") { ApplicationArea = All; }
                field("Qty. per Unit of Measure"; "Qty. per Unit of Measure") { ApplicationArea = All; }
                field("Quantity (Base)"; "Quantity (Base)") { ApplicationArea = All; }
                field("Outstanding Qty. (Base)"; "Outstanding Qty. (Base)") { ApplicationArea = All; }
                field("Qty. to Invoice (Base)"; "Qty. to Invoice (Base)") { ApplicationArea = All; }
                field("Qty. to Receive (Base)"; "Qty. to Receive (Base)") { ApplicationArea = All; }
                field("Qty. Rcd. Not Invoiced (Base)"; "Qty. Rcd. Not Invoiced (Base)") { ApplicationArea = All; }
                field("Qty. Received (Base)"; "Qty. Received (Base)") { ApplicationArea = All; }
                field("Qty. Invoiced (Base)"; "Qty. Invoiced (Base)") { ApplicationArea = All; }
                field("Reserved Qty. (Base)"; "Reserved Qty. (Base)") { ApplicationArea = All; }
                field("FA Posting Date"; "FA Posting Date") { ApplicationArea = All; }
                field("FA Posting Type"; "FA Posting Type") { ApplicationArea = All; }
                field("Depreciation Book Code"; "Depreciation Book Code") { ApplicationArea = All; }
                field("Salvage Value"; "Salvage Value") { ApplicationArea = All; }
                field("Depr. until FA Posting Date"; "Depr. until FA Posting Date") { ApplicationArea = All; }
                field("Depr. Acquisition Cost"; "Depr. Acquisition Cost") { ApplicationArea = All; }
                field("Maintenance Code"; "Maintenance Code") { ApplicationArea = All; }
                field("Insurance No."; "Insurance No.") { ApplicationArea = All; }
                field("Budgeted FA No."; "Budgeted FA No.") { ApplicationArea = All; }
                field("Duplicate in Depreciation Book"; "Duplicate in Depreciation Book") { ApplicationArea = All; }
                field("Use Duplication List"; "Use Duplication List") { ApplicationArea = All; }
                field("Responsibility Center"; "Responsibility Center") { ApplicationArea = All; }
                field("Cross-Reference No."; "Cross-Reference No.") { ApplicationArea = All; }
                field("Unit of Measure (Cross Ref.)"; "Unit of Measure (Cross Ref.)") { ApplicationArea = All; }
                field("Cross-Reference Type"; "Cross-Reference Type") { ApplicationArea = All; }
                field("Cross-Reference Type No."; "Cross-Reference Type No.") { ApplicationArea = All; }*/
                /*field("Item Category Code"; "Item Category Code") { ApplicationArea = All; }
                field(Nonstock; Nonstock) { ApplicationArea = All; }
                field("Purchasing Code"; "Purchasing Code") { ApplicationArea = All; }

                field("Special Order"; "Special Order") { ApplicationArea = All; }
                field("Special Order Sales No."; "Special Order Sales No.") { ApplicationArea = All; }
                field("Special Order Sales Line No."; "Special Order Sales Line No.") { ApplicationArea = All; }
                field("Whse. Outstanding Qty. (Base)"; "Whse. Outstanding Qty. (Base)") { ApplicationArea = All; }
                field("Completely Received"; "Completely Received") { ApplicationArea = All; }
                field("Requested Receipt Date"; "Requested Receipt Date") { ApplicationArea = All; }
                field("Lead Time Calculation"; "Lead Time Calculation") { ApplicationArea = All; }
                field("Inbound Whse. Handling Time"; "Inbound Whse. Handling Time") { ApplicationArea = All; }
                field("Order Date"; "Order Date") { ApplicationArea = All; }
                field("Allow Item Charge Assignment"; "Allow Item Charge Assignment") { ApplicationArea = All; }
                field("Qty. to Assign"; "Qty. to Assign") { ApplicationArea = All; }
                field("Return Qty. to Ship"; "Return Qty. to Ship") { ApplicationArea = All; }
                field("Return Qty. to Ship (Base)"; "Return Qty. to Ship (Base)") { ApplicationArea = All; }
                field("Return Qty. Shipped Not Invd."; "Return Qty. Shipped Not Invd.") { ApplicationArea = All; }
                field("Ret. Qty. Shpd Not Invd.(Base)"; "Ret. Qty. Shpd Not Invd.(Base)") { ApplicationArea = All; }
                field("Return Shpd. Not Invd."; "Return Shpd. Not Invd.") { ApplicationArea = All; }
                field("Return Shpd. Not Invd. (LCY)"; "Return Shpd. Not Invd. (LCY)") { ApplicationArea = All; }
                field("Return Qty. Shipped"; "Return Qty. Shipped") { ApplicationArea = All; }
                field("Return Qty. Shipped (Base)"; "Return Qty. Shipped (Base)") { ApplicationArea = All; }
                field("Return Shipment No."; "Return Shipment No.") { ApplicationArea = All; }
                field("Return Shipment Line No."; "Return Shipment Line No.") { ApplicationArea = All; }
                field("Return Reason Code"; "Return Reason Code") { ApplicationArea = All; }
                field(Subtype; Subtype) { ApplicationArea = All; }
                field("Copied From Posted Doc."; "Copied From Posted Doc.") { ApplicationArea = All; }
                field("Attached Doc Count"; "Attached Doc Count") { ApplicationArea = All; }
                field("Routing No."; "Routing No.") { ApplicationArea = All; }
                field("Operation No."; "Operation No.") { ApplicationArea = All; }
                field("Work Center No."; "Work Center No.") { ApplicationArea = All; }
                field(Finished; Finished) { ApplicationArea = All; }
                field("Overhead Rate"; "Overhead Rate") { ApplicationArea = All; }
                field("MPS Order"; "MPS Order") { ApplicationArea = All; }
                field("Planning Flexibility"; "Planning Flexibility") { ApplicationArea = All; }
                field("Safety Lead Time"; "Safety Lead Time") { ApplicationArea = All; }
                field("Routing Reference No."; "Routing Reference No.") { ApplicationArea = All; }*/
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    Rec2: Record "Purchase Line";
                begin
                    Rec2.Reset();
                end;
            }
        }
    }

    var
        myInt: Integer;
}