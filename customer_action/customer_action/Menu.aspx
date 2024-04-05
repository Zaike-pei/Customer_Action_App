<%@ Page Title="メニュー" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Menu.aspx.cs" Inherits="customer_action.Menu" Trace="true" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
    .auto-style5 {
        width: 800px;
        height: 220px;
    }
    .auto-style6 {
        height: 31px;
    }
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Panel ID="AdminPanel" runat="server" Height="240px" Width="800px">
    <table class="auto-style5">
        <tr>
            <td>メニュー（管理者用）</td>
            <td style="text-align: right">
                <asp:LinkButton ID="LinkButton1" runat="server" OnClick="LinkButton1_Click">ログオフ</asp:LinkButton>
            </td>
        </tr>
        <tr>
            <td>
                <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/CustomerList.aspx">顧客一覧</asp:HyperLink>
            </td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td class="auto-style6">
                <asp:HyperLink ID="HyperLink2" runat="server">営業報告一覧 </asp:HyperLink>
            </td>
            <td class="auto-style6"></td>
        </tr>
        <tr>
            <td>
                <asp:HyperLink ID="HyperLink3" runat="server">会社マスター管理</asp:HyperLink>
            </td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>
                <asp:HyperLink ID="HyperLink4" runat="server" NavigateUrl="~/CustomerExport.aspx">顧客データのエクスポート</asp:HyperLink>
            </td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>
                <asp:HyperLink ID="HyperLink5" runat="server" NavigateUrl="~/StaffReplace.aspx">営業担当者の置換</asp:HyperLink>
            </td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>
                <asp:HyperLink ID="HyperLink6" runat="server">スタッフマスター管理</asp:HyperLink>
            </td>
            <td>&nbsp;</td>
        </tr>
    </table>
</asp:Panel>
<asp:Panel ID="UserPanel" runat="server" Height="240px" Width="800px">
    <table class="auto-style5">
        <tr>
            <td>メニュー（ユーザー用）</td>
            <td style="text-align: right">
                <asp:LinkButton ID="LinkButton2" runat="server" OnClick="LinkButton2_Click">ログオフ</asp:LinkButton>
            </td>
        </tr>
        <tr>
            <td>
                <asp:HyperLink ID="HyperLink7" runat="server" NavigateUrl="~/CustomerList.aspx">顧客一覧</asp:HyperLink>
            </td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>
                <asp:HyperLink ID="HyperLink8" runat="server">営業報告一覧 </asp:HyperLink>
            </td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>
                <asp:HyperLink ID="HyperLink9" runat="server">会社マスター管理</asp:HyperLink>
            </td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
    </table>
</asp:Panel>
</asp:Content>
