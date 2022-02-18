xmlport 50152 "Import CSV"
{
    Caption = 'Import CSV';

    Direction = Import;
    Format = VariableText;
    UseRequestPage = false;
    TextEncoding = WINDOWS;
    FieldDelimiter = '<TAB>';

    schema
    {
        textelement(Root)
        {

            tableelement(IntegerS; Integer)
            {
                AutoSave = false;
                MinOccurs = Zero;
                XmlName = 'UserRole';
                textelement(PrNo)
                {
                    trigger OnBeforePassVariable()
                    begin
                        If PrNo = Prno2 then
                            PrNo := '';
                    End;

                }
                textelement(VesselNo) { }
                textelement(Segment) { }
                textelement(Types) { }
                textelement(IMPA) { }
                textelement(remarks2)
                {
                    trigger OnAfterAssignVariable()
                    begin
                        ClearSpecialCharacter();
                    end;
                }

                textelement(Quantity) { }
                textelement(UOM) { }
                textelement(ROB) { }
                textelement(Remarks) { }
                textelement(Location_TE)
                {
                    trigger OnAfterAssignVariable()
                    var
                        i: Integer;
                    begin
                        /*   i += 1;
                           Message(Location_TE + '%1', i + 1);*/
                    end;
                }
                textelement(ReqBy) { }
                textelement(ReqDate) { }

                //textelement(Dates){}


                trigger OnBeforeInsertRecord()
                var

                    CommentLineNo: Integer;
                    LineNo: Integer;

                begin
                    // Start Skip First Line
                    IF FirstLine THEN BEGIN
                        FirstLine := FALSE;
                        currXMLport.SKIP;
                        CommentLineNo := 1000;
                    END;
                    // Stop Skip First Line

                    // Start Header Information Insert
                    IF (PrNo <> '') THEN BEGIN
                        If (PrNo <> Prno2) then begin
                            If VesselNo = '' then
                                VesselNo := VesselTemp;
                            //MESSAGE('this is Header')
                            //LineNo := 10000;
                            InsertHeaderDetails(PrNo, VesselNo, Segment, ReqBy, ReqDate);//,Dates);
                                                                                         //InsertLineDetails(PrNo, Types, IMPA, Quantity, UOM, ROB, Remarks, LineNo);
                                                                                         // Commit();//krishna
                        end;

                    END;
                    //MESSAGE('this is line %1', RecCOunt);
                    //LineNo += 10000;
                    LineNo += 10000;
                    InsertLineDetails(PrNo, VesselNo, Segment, Types, IMPA, Quantity, UOM, ROB, Remarks, LineNo, remarks2);
                    //   Commit();//krishna

                    //END;
                    //VesselTemp := VesselNo;
                    Prno2 := PrNo;
                    // Stop Header Information Insert
                    // Start Progress Bar
                    SLEEP(100);
                    RecCOunt += 1;
                    IF RecCOunt <> 0 THEN
                        RecDialog.UPDATE(1, ROUND(10000 / RecCOunt * index, 1));
                    index += 1;
                    // Stop Progress Bar
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPostXmlPort()
    begin
        RecDialog.CLOSE;
    end;

    trigger OnPreXmlPort()
    begin
        FirstLine := TRUE;
        RecDialog.OPEN('@1@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\')
    end;

    var
        FirstLine: Boolean;
        RecDialog: Dialog;
        RecCOunt: Integer;
        index: Integer;
        PurchAndPayableSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        HeaderRec: Record AMG_PurchRequisitionHeader;
        LineRec: Record AMG_PurchRequisitionLine;
        LineRec2: Record AMG_PurchRequisitionLine;
        DocNo: Code[20];
        V_VessalNo: Code[20];
        LineNo: Integer;
        V_IMPA: Code[20];
        V_Qty: Decimal;
        V_UOm: Code[20];
        V_ROB: Decimal;
        GlSetup: Record "General Ledger Setup";
        DimValRec: Record "Dimension Value";
        Date_V: Date;
        Prno2: text[20];
        VesselTemp: Text;
        V_ReqDate: Date;
        RowNo: Integer;
        LocationRec: Record Location;

    procedure InsertHeaderDetails(PrNo_p: Text[50]; VesselNo_P: Text[50]; Segment_P: Text[50]; p_ReqBy: Text[50]; P_ReqDate: Text[20])//;Date_p:Text[10])
    begin
        GlSetup.Get();
        DimValRec.Reset();
        DimValRec.SetRange("Dimension Code", GlSetup."Global Dimension 2 Code");
        If DimValRec.FindFirst() then;
        PurchAndPayableSetup.Reset();
        PurchAndPayableSetup.Get();
        PurchAndPayableSetup.TestField(AMG_PurchReqNos);
        HeaderRec.Init();
        //DocNo := NoSeriesMgt.GetNextNo(PurchAndPayableSetup.AMG_PurchReqNos, Today, true);
        //HeaderRec."No." := DocNo;
        HeaderRec."No." := PrNo_p;
        HeaderRec.Insert();
        HeaderRec.Validate("Shortcut Dimension 1 Code", VesselNo_P);
        HeaderRec.Validate("Shortcut Dimension 2 Code", Segment_P);
        HeaderRec.Validate("Requisition Date", WorkDate());
        HeaderRec.Validate("Requested By", p_ReqBy);
        //Evaluate(V_ReqDate, P_ReqDate);
        HeaderRec.Validate("Requested Date", Today);
        //Evaluate(Date_V,Date_V);
        HeaderRec.Modify();


    end;

    procedure InsertLineDetails(PrNo_p: Text[20]; VesselNo_P: Text[50]; Segment_P: Text[50]; Type_p: Text[20]; IMPA_P: Text[20]; Qty_P: Text[20]; Uom_P: Text[20]; ROB_P: Text[20]; Remarks_p: Text[250]; lineNo_P: Integer; Remarks2_P: Text[100])
    var
        Item: Record Item;
        GLSetup: Record "General Ledger Setup";
        GLAccount: Record "G/L Account";
        FA: Record "Fixed Asset";
        Var_Location: Code[50];

    begin
        RowNo += 1;
        LineRec2.Reset();
        LineRec2.SetRange("Document No.", DocNo);
        if LineRec2.FindLast() then;
        LineRec.Init();
        LineRec.Validate("Document No.", PrNo_p);
        LineRec."Line No." += 10000;
        GLSetup.Get();
        If Not DimValRec.Get(GLSetup."Global Dimension 1 Code", VesselNo_P) then
            Error('Vessel No. %1 is not Valid at Row No %2', VesselNo_P, RowNo + 1);
        LineRec.Validate("Shortcut Dimension 1 Code", VesselNo_P);
        GLSetup.Get();
        If Not DimValRec.Get(GLSetup."Global Dimension 2 Code", Segment_P) then
            Error('Segment %1 is not Valid at Row No %2', Segment_P, RowNo + 1);
        LineRec.Validate("Shortcut Dimension 2 Code", Segment_P);
        Clear(Var_Location);

        //Evaluate(Var_Location, Location_TE);

        // Message(Location_TE);
        /* IF Var_Location = '' then
             Message('Blank Value Location %1', RowNo + 1);*/
        /*If Not LocationRec.get(Var_Location) then begin
            Error('Location %1 is not Valid at Row No %2', Location, RowNo + 1);
        End;*/
        LocationRec.Reset();
        LocationRec.SetRange(Code, Location_TE);
        If not LocationRec.FindFirst() then begin
            Error('Location %1 is not Valid at Row No %2', Location_TE, RowNo + 1)
        End;
        if Location_TE <> '' then begin
            LineRec.Validate("Location Code", Location_TE);
        end;
        LineRec.Insert();
        /*If Type_P = '' then
            lineRec.Type := LineRec.Type::" "
        else*/
        If NOT ((Type_P = 'G/L Account') or (Type_P = 'Item') or (Type_P = 'Fixed Asset') or (Type_P = '')) Then
            Error('Type %1 is not Valid at Row No %2', Type_P, RowNo + 1);
        Evaluate(LineRec.Type, Type_p);

        Evaluate(V_IMPA, IMPA_P);

        IF Type_p = 'G/L Account' then begin
            IF GLAccount.Get(IMPA_P) THEN begin
                IF GLAccount.Blocked then
                    Error('IMPA Code %1 is upgraded, Kindly select new one in Row No %2', GLAccount."No.", RowNo + 1);
            END

            ELSE begin
                Error('IMPA %1 is not Valid at row no. %2', IMPA_P, RowNo + 1);
            END;
        end;

        IF Type_p = 'Item' then begin
            IF Item.Get(IMPA_P) THEN begin
                IF Item.Blocked then
                    Error('IMPA Code %1 is upgraded, Kindly select new one in Row No %2', Item."No.", RowNo + 1);
            END
            ELSE begin
                Error('IMPA %1 is not Valid at row no. %2', IMPA_P, RowNo + 1);
            END;
        end;

        IF Type_p = 'Fixed Asset' then begin
            IF FA.Get(IMPA_P) THEN begin
                IF FA.Blocked then
                    Error('IMPA Code %1 is upgraded, Kindly select new one in Row No %2', FA."No.", RowNo + 1);
            END
            ELSE begin
                Error('IMPA %1 is not Valid at row no. %2', IMPA_P, RowNo + 1);
            END;
        end;
        LineRec.Validate("No.", V_IMPA);
        Evaluate(V_Qty, Qty_P);
        LineRec.Validate(Quantity, V_Qty);
        Evaluate(v_UOM, Uom_P);
        LineRec.Validate("Unit of Measure Code", V_UOm);
        LineRec.Validate("Remarks 2", Remarks2_P);

        if ROB_P <> '' then begin
            Evaluate(V_ROB, ROB_P);
            LineRec.Validate(ROB, V_ROB);
        End;
        if Remarks_p <> '' then
            Evaluate(LineRec.Remarks, Remarks_p);
        LineRec.Validate("Shortcut Dimension 1 Code", VesselNo_P);
        LineRec.Validate("Shortcut Dimension 2 Code", Segment_P);
        /*if Loc_p <> '' then
            LineRec.Validate("Location Code", Location_P);*/
        LineRec.Modify();
    end;

    local procedure ClearSpecialCharacter()
    var
        RemarksL: Text[250];
    begin
        RemarksL := remarks2;
        remarks2 := DelChr(remarks2, '<>', '"');
        if RemarksL.EndsWith('""') then
            remarks2 := remarks2 + '"';
        if RemarksL.StartsWith('""') then
            remarks2 := '"' + remarks2;
        remarks2 := remarks2.Replace('""', '"');
    end;
}

