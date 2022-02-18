report 50160 "Update Lot No."
{
    Caption = 'Update Lot/ Serial No.';
    ProcessingOnly = true;

    dataset
    {
        dataitem(ItemJnlLine; "Item Journal Line")
        {
            trigger OnPreDataItem()
            begin
            end;

            trigger OnAfterGetRecord()
            begin
                EntryNo := 0;
                ReservationEntry.RESET;
                IF ReservationEntry.FINDLAST THEN BEGIN
                    EntryNo := ReservationEntry."Entry No.";
                END;

                EntryNo1 := EntryNo + 1;


                ReservationEntry.RESET;
                ReservationEntry.SETRANGE("Entry No.", EntryNo1);
                IF NOT ReservationEntry.FINDLAST THEN BEGIN
                    ReservationEntry.INIT;
                    ReservationEntry."Entry No." := EntryNo1;

                    ReservationEntry."Item No." := ItemJnlLine."Item No.";
                    ReservationEntry."Location Code" := ItemJnlLine."Location Code";
                    ReservationEntry."Reservation Status" := ReservationEntry."Reservation Status"::Prospect;
                    ReservationEntry.Description := ItemJnlLine.Description;
                    ReservationEntry."Creation Date" := WORKDATE;
                    ReservationEntry."Source Type" := 83;

                    ReservationEntry."Source ID" := ItemJnlLine."Journal Template Name";
                    ReservationEntry."Source Batch Name" := ItemJnlLine."Journal Batch Name";
                    ReservationEntry."Source Ref. No." := ItemJnlLine."Line No.";
                    IF ItemJnlLine."Entry Type" = ItemJnlLine."Entry Type"::"Positive Adjmt." THEN BEGIN
                        ReservationEntry."Source Subtype" := 2;
                        ReservationEntry."Quantity (Base)" := ItemJnlLine."Quantity (Base)";
                        ReservationEntry."Qty. to Handle (Base)" := ItemJnlLine."Quantity (Base)";
                        ReservationEntry."Qty. to Invoice (Base)" := ItemJnlLine."Quantity (Base)";
                        ReservationEntry.Quantity := ItemJnlLine.Quantity;
                        ReservationEntry."Quantity Invoiced (Base)" := ItemJnlLine."Invoiced Qty. (Base)";
                        ReservationEntry.Positive := TRUE;
                    END ELSE
                        IF ItemJnlLine."Entry Type" = ItemJnlLine."Entry Type"::"Negative Adjmt." THEN BEGIN
                            ReservationEntry."Source Subtype" := 3;
                            ReservationEntry."Quantity (Base)" := -ItemJnlLine."Quantity (Base)";
                            ReservationEntry."Qty. to Handle (Base)" := -ItemJnlLine."Quantity (Base)";
                            ReservationEntry."Qty. to Invoice (Base)" := -ItemJnlLine."Quantity (Base)";
                            ReservationEntry.Quantity := -ItemJnlLine.Quantity;
                            ReservationEntry."Quantity Invoiced (Base)" := 0;
                            ReservationEntry.Positive := FALSE;
                        END;
                    ReservationEntry."Expected Receipt Date" := ItemJnlLine."Posting Date";

                    ReservationEntry."Created By" := USERID;
                    ReservationEntry."Changed By" := '';
                    ReservationEntry."Qty. per Unit of Measure" := ItemJnlLine."Qty. per Unit of Measure";
                    ReservationEntry."Warranty Date" := ItemJnlLine."Warranty Date";
                    ReservationEntry."Expiration Date" := ItemJnlLine."Expiration Date";
                    ReservationEntry."Lot No." := ItemJnlLine."OB Lot No.";
                    ReservationEntry."Variant Code" := ItemJnlLine."Variant Code";
                    ReservationEntry.Correction := ItemJnlLine.Correction;
                    ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Lot No.";
                    ReservationEntry.INSERT(TRUE);

                    //"Lot No./Serial No. Updated" := TRUE;
                    ItemJnlLine.MODIFY(TRUE);
                END;

            END;

            trigger OnPostDataItem()
            begin
                MESSAGE('Done...!!!!!!');
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        ReservationEntry: Record "Reservation Entry";
        EntryNo: Integer;
        EntryNo1: Integer;
}