<%@ Page Title="営業報告登録" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="ActionCard.aspx.cs" Inherits="customer_action.ActionCard" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="ajaxToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">


    <style type="text/css">
        .TableStyle1 {
            background-color: tan;
            border: 1px solid Black;
            width: 130px;
        }
        .TableStyle2 {
            background-color: LightGoldenrodYellow;
            border: 1px solid Black;
            width: 267px;
        }
        .auto-style3 {
            width: 800px;
            border-collapse: collapse;
        }
        .auto-style4 {
            background-color: tan;
            border: 1px solid Black;
            width: 40px;
            height: 15px;
        }
        .auto-style5 {
            background-color: LightGoldenrodYellow;
            border: 1px solid Black;
            width: 267px;
            height: 15px;
        }
        .auto-style7 {
            background-color: tan;
            border: 1px solid Black;
            width: 40px;
            height: 85px;
        }
        .auto-style8 {
            background-color: LightGoldenrodYellow;
            border: 1px solid Black;
            width: 267px;
            height: 85px;
        }
        .auto-style9 {
            background-color: tan;
            border: 1px solid Black;
            width: 40px;
        }
        .auto-style10 {
            background-color: tan;
            border: 1px solid Black;
            width: 40px;
            height: 16px;
        }
        .auto-style11 {
            background-color: LightGoldenrodYellow;
            border: 1px solid Black;
            width: 267px;
            height: 16px;
        }
    </style>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:customer_actionConnectionString %>" SelectCommand="SELECT cust.customer_name, act.ID, comp.company_name, act.action_date,
act.action_content, act.action_staffID, act.customerID
FROM tbl_customer AS cust
INNER JOIN tbl_action AS act
ON act.customerID = cust.customerID
LEFT JOIN tbl_company AS comp
ON comp.companyID = cust.companyID
WHERE id=@id" UpdateCommand="UPDATE [tbl_action] SET [customerID] = @customerID, [action_date] = @action_date, [action_content] = @action_content, [action_staffID] = @action_staffID WHERE [ID] = @ID">
        <SelectParameters>
            <asp:QueryStringParameter Name="id" QueryStringField="id" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="customerID" />
            <asp:Parameter Name="action_date" />
            <asp:Parameter Name="action_content" />
            <asp:Parameter Name="action_staffID" />
            <asp:Parameter Name="ID" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSource_staff" runat="server" ConnectionString="<%$ ConnectionStrings:customer_actionConnectionString %>" SelectCommand="SELECT * FROM [tbl_staff]"></asp:SqlDataSource>
    <asp:FormView ID="FormView1" runat="server" DataKeyNames="ID" DataSourceID="SqlDataSource1" OnItemUpdated="FormView1_ItemUpdated">
        <EditItemTemplate>
            <br />
            <table class="auto-style3">
                <tr>
                    <td class="auto-style10">ID</td>
                    <td class="auto-style11">
                        <asp:Label ID="IDLabel" runat="server" Text='<%# Eval("ID") %>' />
                    </td>
                </tr>
                <tr>
                    <td class="auto-style4">顧客名</td>
                    <td class="auto-style5">
                        <asp:Label ID="customer_nameLabel" runat="server" Text='<%# Eval("customer_name") %>' />
                        <br />
                        <asp:Label ID="customerIDLabel" runat="server" Text='<%# Bind("customerID") %>'></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="auto-style4">会社名</td>
                    <td class="auto-style5">
                        <asp:Label ID="company_nameLabel" runat="server" Text='<%# Eval("company_name") %>' />
                    </td>
                </tr>
                <tr>
                    <td class="auto-style4">日付</td>
                    <td class="auto-style5">
                        <asp:TextBox ID="action_dateTextBox" runat="server" Text='<%# Bind("action_date", "{0:yyyy/MM/dd}") %>' />
                        <ajaxToolkit:CalendarExtender ID="action_dateTextBox_CalendarExtender" runat="server" BehaviorID="action_dateTextBox_CalendarExtender" Format="yyyy/MM/dd" TargetControlID="action_dateTextBox" />
                        <br />
                    </td>
                </tr>
                <tr>
                    <td class="auto-style7">内容</td>
                    <td class="auto-style8">
                        <asp:TextBox ID="action_contentTextBox" runat="server" Height="100px" Text='<%# Bind("action_content") %>' Width="500px" />
                    </td>
                </tr>
                <tr>
                    <td class="auto-style9">対応者</td>
                    <td class="TableStyle2">
                        <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="SqlDataSource_staff" DataTextField="staff_name" DataValueField="staffID" SelectedValue='<%# Bind("action_staffID") %>'>
                        </asp:DropDownList>
                    </td>
                </tr>
            </table>
            <asp:Button ID="UpdateButton" runat="server" CommandName="Update" Text="登録" />
            <asp:Button ID="CancelButton" runat="server" CommandName="Cancel" OnClick="CancelButton_Click" Text="キャンセル" />
        </EditItemTemplate>
        <InsertItemTemplate>
            customer_name:
            <asp:TextBox ID="customer_nameTextBox" runat="server" Text='<%# Bind("customer_name") %>' />
            <br />
            ID:
            <asp:TextBox ID="IDTextBox" runat="server" Text='<%# Bind("ID") %>' />
            <br />
            company_name:
            <asp:TextBox ID="company_nameTextBox" runat="server" Text='<%# Bind("company_name") %>' />
            <br />
            action_date:
            <asp:TextBox ID="action_dateTextBox" runat="server" Text='<%# Bind("action_date") %>' />
            <br />
            action_content:
            <asp:TextBox ID="action_contentTextBox" runat="server" Text='<%# Bind("action_content") %>' />
            <br />
            action_staffID:
            <asp:TextBox ID="action_staffIDTextBox" runat="server" Text='<%# Bind("action_staffID") %>' />
            <br />
            customerID:
            <asp:TextBox ID="customerIDTextBox" runat="server" Text='<%# Bind("customerID") %>' />
            <br />
            <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" Text="挿入" />
            &nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="キャンセル" />
        </InsertItemTemplate>
        <ItemTemplate>
            customer_name:
            <asp:Label ID="customer_nameLabel" runat="server" Text='<%# Bind("customer_name") %>' />
            <br />
            ID:
            <asp:Label ID="IDLabel" runat="server" Text='<%# Eval("ID") %>' />
            <br />
            company_name:
            <asp:Label ID="company_nameLabel" runat="server" Text='<%# Bind("company_name") %>' />
            <br />
            action_date:
            <asp:Label ID="action_dateLabel" runat="server" Text='<%# Bind("action_date") %>' />
            <br />
            action_content:
            <asp:Label ID="action_contentLabel" runat="server" Text='<%# Bind("action_content") %>' />
            <br />
            action_staffID:
            <asp:Label ID="action_staffIDLabel" runat="server" Text='<%# Bind("action_staffID") %>' />
            <br />
            customerID:
            <asp:Label ID="customerIDLabel" runat="server" Text='<%# Bind("customerID") %>' />
            <br />

        </ItemTemplate>
    </asp:FormView>
</asp:Content>
