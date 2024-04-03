<%@ Page Title="営業担当者の置換" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="StaffReplace.aspx.cs" Inherits="customer_action.StaffReplace" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .auto-style3 {
            width: 300px;
        }
        .auto-style4 {
            width: 100px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <table class="auto-style3">
        <tr>
            <td class="auto-style4">営業担当者の置換</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style4">変更前の担当者：</td>
            <td>
                <asp:DropDownList ID="BeforeDropDownList" runat="server" AppendDataBoundItems="True" DataSourceID="SqlDataSource_staff_tbl" DataTextField="staff_name" DataValueField="staffID">
                    <asp:ListItem Value="-1">（選択してください）</asp:ListItem>
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td class="auto-style4">変更後の担当者：</td>
            <td>
                <asp:DropDownList ID="AfterDropDownList" runat="server" AppendDataBoundItems="True" DataSourceID="SqlDataSource_staff_tbl" DataTextField="staff_name" DataValueField="staffID">
                    <asp:ListItem Value="-1">（選択してください）</asp:ListItem>
                </asp:DropDownList>
            </td>
        </tr>
    </table>
    <asp:Button ID="ExecuteButton" runat="server" OnClick="ExecuteButton_Click" Text="置換処理の実行" />
    <asp:SqlDataSource ID="SqlDataSource_staff_tbl" runat="server" ConnectionString="<%$ ConnectionStrings:customer_actionConnectionString %>" SelectCommand="SELECT * FROM [tbl_staff]"></asp:SqlDataSource>
    <asp:Label ID="MessageLabel" runat="server" EnableViewState="False"></asp:Label>
</asp:Content>
