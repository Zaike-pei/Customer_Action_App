<%@ Page Title="ログオン" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Logon.aspx.cs" Inherits="customer_action.Logon" Trace="true" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
    .auto-style3 {
        width: 400px;
    }
    .auto-style4 {
        width: 102px;
    }
    .auto-style5 {
        width: 158px;
    }
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <table class="auto-style3">
    <tr>
        <td class="auto-style4">ユーザーID：</td>
        <td class="auto-style5">
            <asp:TextBox ID="UserIDTextBox" runat="server" CssClass="imeOff" TabIndex="1"></asp:TextBox>
        </td>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td class="auto-style4">パスワード：</td>
        <td class="auto-style5">
            <asp:TextBox ID="PasswordTextBox" runat="server" CssClass="imeOff" TabIndex="2" TextMode="Password"></asp:TextBox>
        </td>
        <td>
            <asp:Button ID="LogonButton" runat="server" OnClick="LogonButton_Click" TabIndex="3" Text="ログオン" />
        </td>
    </tr>
    <tr>
        <td colspan="3">
            <asp:Label ID="ErrorLabel" runat="server" ForeColor="Red"></asp:Label>
        </td>
    </tr>
</table>
</asp:Content>
