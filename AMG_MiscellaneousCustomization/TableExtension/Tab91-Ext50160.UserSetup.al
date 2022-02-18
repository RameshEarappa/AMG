tableextension 50160 "Ext-UserSetup" extends "User Setup"
{
    fields
    {
        field(50000; Create; Boolean)
        {

        }
        field(50001; "PR Release"; Boolean)
        {

        }
        field(50002; "Enable PR"; Boolean)
        {

        }
        field(50003; "Access Vendor Master"; Boolean)
        {

        }
        field(50004; "Approve Vendor"; Boolean)
        {

        }
        field(50005; "Access Item Master"; Boolean)
        {

        }
        //28.10.2020
        field(50006; "Access Customer Master"; Boolean)
        {

        }
        //28.10.2020
        //02.11.2020
        field(50007; "Access PO Master"; Boolean)
        {

        }
        field(50010; "BRS Reviewer  "; Boolean)
        {

        }
        field(50009; "BRS Approver"; Boolean)
        {

        }
        field(50011; "Access Account Schedules"; Boolean)
        {

        }
        field(50012; Designation; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50013; Title; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50014; UndoBRSReview; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Undo BRS Review';
        }
        field(50015; UndoBRSApprove; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Undo BRS Approve';
        }
        field(50016; EnablePO; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Enable PO';
        }
        field(50017; EnablePODescription; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Enable PO Description';
        }
        field(50018; EnablePRDescription; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Enable PR Description';
        }
        field(50019; EnablePQDescription; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Enable PQ Description';
        }
        //02.11.2020


    }

    var
        myInt: Integer;


}