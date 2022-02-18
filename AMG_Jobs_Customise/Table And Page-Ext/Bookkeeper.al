pageextension 50126 Ext_OrderProcessorRoleCenter extends "Order Processor Role Center"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("Purchase Quotes")
        {
            action(purchase_requsition)
            {
                ApplicationArea = all;
                Caption = 'Purchase Requsition';
                Image = ListPage;
                RunObject = page AMG_PurchRequisitionList;

            }
        }
        addafter("Purchase Orders")
        {
            action("Admin Purchase Order Line")
            {
                Caption = 'Admin Purchase Order Line';
                ApplicationArea = All;
                RunObject = page "Purchase Order Subform";
            }
        }
    }

    var
        myInt: Integer;
}
pageextension 50127 Ext_BookkeeperRC extends "Bookkeeper Role Center"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("EC &Sales List")
        {
            action(purchase_requsition)
            {
                ApplicationArea = all;
                Caption = 'Purchase Requsition';
                Image = ListPage;
                RunObject = page AMG_PurchRequisitionList;

            }
        }
    }

    var
        myInt: Integer;
}
//
pageextension 50129 "Ext_PurcAgent_Role_Center" extends "Purchasing Agent Role Center"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("Inventory - &Vendor Purchases")
        {
            action(purchase_requsition)
            {
                ApplicationArea = all;
                Caption = 'Purchase Requsition';
                Image = ListPage;
                RunObject = page AMG_PurchRequisitionList;

            }
        }
    }

    var
        myInt: Integer;
}
