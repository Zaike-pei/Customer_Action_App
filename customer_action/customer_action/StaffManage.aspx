<%@ Page Title="スタッフマスター管理" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="StaffManage.aspx.cs" Inherits="customer_action.StaffManage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:customer_actionConnectionString %>" DeleteCommand="DELETE FROM [tbl_staff] WHERE [staffID] = @staffID" InsertCommand="INSERT INTO [tbl_staff] ([staffID], [staff_name], [userID], [password], [admin_flag], [delete_flag]) VALUES (@staffID, @staff_name, @userID, @password, @admin_flag, @delete_flag)" SelectCommand="SELECT * FROM [tbl_staff]" UpdateCommand="UPDATE [tbl_staff] SET [staff_name] = @staff_name, [userID] = @userID, [password] = @password, [admin_flag] = @admin_flag, [delete_flag] = @delete_flag WHERE [staffID] = @staffID">
        <DeleteParameters>
            <asp:Parameter Name="staffID" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="staffID" Type="Int32" />
            <asp:Parameter Name="staff_name" Type="String" />
            <asp:Parameter Name="userID" Type="String" />
            <asp:Parameter Name="password" Type="String" />
            <asp:Parameter Name="admin_flag" Type="Boolean" />
            <asp:Parameter Name="delete_flag" Type="Boolean" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="staff_name" Type="String" />
            <asp:Parameter Name="userID" Type="String" />
            <asp:Parameter Name="password" Type="String" />
            <asp:Parameter Name="admin_flag" Type="Boolean" />
            <asp:Parameter Name="delete_flag" Type="Boolean" />
            <asp:Parameter Name="staffID" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <table class="auto-style1">
        <tr>
            <td>スタッフマスター管理</td>
            <td>&nbsp;</td>
        </tr>
    </table>
    <asp:Button ID="InsertButton" runat="server" OnClick="InsertButton_Click" Text="スタッフの追加" />
    <asp:Label ID="MessageLabel" runat="server" EnableViewState="False" ForeColor="Red"></asp:Label>
    <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" BackColor="LightGoldenrodYellow" BorderColor="Tan" BorderWidth="1px" CellPadding="2" DataKeyNames="staffID" DataSourceID="SqlDataSource1" ForeColor="Black" GridLines="None" OnRowUpdating="GridView1_RowUpdating">
        <AlternatingRowStyle BackColor="PaleGoldenrod" />
        <Columns>
            <asp:CommandField ButtonType="Button" ShowEditButton="True" />
            <asp:BoundField DataField="staffID" HeaderText="スタッフID" ReadOnly="True" SortExpression="staffID">
            <ItemStyle HorizontalAlign="Center" Width="80px" />
            </asp:BoundField>
            <asp:BoundField DataField="staff_name" HeaderText="スタッフ名" SortExpression="staff_name">
            <ControlStyle Width="100px" />
            <ItemStyle Width="100px" />
            </asp:BoundField>
            <asp:BoundField DataField="userID" HeaderText="ユーザーID" SortExpression="userID">
            <ControlStyle Width="80px" />
            <ItemStyle Width="100px" />
            </asp:BoundField>
            <asp:BoundField DataField="password" HeaderText="パスワード" SortExpression="password">
            <ControlStyle Width="80px" />
            <ItemStyle Width="100px" />
            </asp:BoundField>
            <asp:CheckBoxField DataField="admin_flag" HeaderText="管理者フラグ" SortExpression="admin_flag">
            <ItemStyle HorizontalAlign="Center" Width="100px" />
            </asp:CheckBoxField>
            <asp:CheckBoxField DataField="delete_flag" HeaderText="削除フラグ" SortExpression="delete_flag">
            <ItemStyle HorizontalAlign="Center" Width="100px" />
            </asp:CheckBoxField>
        </Columns>
        <FooterStyle BackColor="Tan" />
        <HeaderStyle BackColor="Tan" Font-Bold="True" />
        <PagerStyle BackColor="PaleGoldenrod" ForeColor="DarkSlateBlue" HorizontalAlign="Center" />
        <SelectedRowStyle BackColor="DarkSlateBlue" ForeColor="GhostWhite" />
        <SortedAscendingCellStyle BackColor="#FAFAE7" />
        <SortedAscendingHeaderStyle BackColor="#DAC09E" />
        <SortedDescendingCellStyle BackColor="#E1DB9C" />
        <SortedDescendingHeaderStyle BackColor="#C2A47B" />
    </asp:GridView>
</asp:Content>
