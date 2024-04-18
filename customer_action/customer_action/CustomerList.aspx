<%@ Page Title="顧客一覧" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="CustomerList.aspx.cs" Inherits="customer_action.CustomerList" Trace="false" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .auto-style3 {
            width: 65px;
        }
        .auto-style4 {
            width: 40px;
        }
        .auto-style5 {
            width: 160px;
        }
        .auto-style6 {
            width: 130px;
        }
        .auto-style7 {
            width: 115px;
        }
        .auto-style8 {
            width: 55px;
        }
        .auto-style9 {
            width: 65px;
            height: 16px;
        }
        .auto-style10 {
            width: 40px;
            height: 16px;
        }
        .auto-style11 {
            width: 160px;
            height: 16px;
        }
        .auto-style12 {
            width: 130px;
            height: 16px;
        }
        .auto-style13 {
            width: 115px;
            height: 16px;
        }
        .auto-style14 {
            width: 55px;
            height: 16px;
        }
        .auto-style15 {
            text-align: center;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:customer_actionConnectionString %>" SelectCommand="SELECT [customerID], [customer_name], [customer_kana], [section], [post], [staff_name], [company_name] FROM [vw_customer_view] WHERE (([customer_name] LIKE '%' + @customer_name + '%') AND ([company_name] LIKE '%' + @company_name + '%'))">
        <SelectParameters>
            <asp:ControlParameter ControlID="CustomerNameTextBox" DefaultValue="%" Name="customer_name" PropertyName="Text" Type="String" />
            <asp:ControlParameter ControlID="CompanyNameTextBox" DefaultValue="%" Name="company_name" PropertyName="Text" Type="String" />
        </SelectParameters>
    </asp:SqlDataSource>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:customer_actionConnectionString %>" SelectCommand="SELECT [customerID], [customer_name], [customer_kana], [section], [post], [company_name], [staff_name] FROM [vw_customer_view] WHERE (([customer_name] LIKE '%' + @customer_name + '%') AND ([company_name] LIKE '%' + @company_name + '%') AND ([staffID] = @staffid))">
        <SelectParameters>
            <asp:ControlParameter ControlID="CustomerNameTextBox" DefaultValue="%" Name="customer_name" PropertyName="Text" Type="String" />
            <asp:ControlParameter ControlID="CompanyNameTextBox" DefaultValue="%" Name="company_name" PropertyName="Text" Type="String" />
            <asp:SessionParameter Name="staffid" SessionField="StaffID" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table class="auto-style1">
                <tr>
                    <td class="auto-style9">顧客一覧</td>
                    <td class="auto-style10"></td>
                    <td class="auto-style11"></td>
                    <td class="auto-style10"></td>
                    <td class="auto-style11"></td>
                    <td class="auto-style12"></td>
                    <td class="auto-style13">&nbsp;</td>
                    <td class="auto-style14"></td>
                </tr>
                <tr>
                    <td class="auto-style3">検索条件</td>
                    <td class="auto-style4">顧客名</td>
                    <td class="auto-style5">
                        <asp:TextBox ID="CustomerNameTextBox" runat="server" CssClass="imeOn"></asp:TextBox>
                    </td>
                    <td class="auto-style4">会社名</td>
                    <td class="auto-style5">
                        <asp:TextBox ID="CompanyNameTextBox" runat="server" CssClass="imeOn"></asp:TextBox>
                    </td>
                    <td class="auto-style6">
                        <asp:CheckBox ID="MyCustomerCheckBox" runat="server" Text="自分の顧客のみ" />
                    </td>
                    <td class="auto-style7">
                        <asp:Button ID="FilterButton" runat="server" Text="フィルター実行" Width="110px" OnClick="FilterButton_Click" />
                    </td>
                    <td class="auto-style8">
                        <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/CustomerCard.aspx">新規作成</asp:HyperLink>
                    </td>
                </tr>
                <tr>
                    <td class="auto-style3">&nbsp;</td>
                    <td class="auto-style4">&nbsp;</td>
                    <td class="auto-style5">&nbsp;</td>
                    <td class="auto-style4">&nbsp;</td>
                    <td class="auto-style5">&nbsp;</td>
                    <td class="auto-style6">&nbsp;</td>
                    <td class="auto-style7">&nbsp;</td>
                    <td class="auto-style8">&nbsp;</td>
                </tr>
            </table>
            <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" BackColor="LightGoldenrodYellow" BorderColor="Tan" BorderWidth="1px" CellPadding="2" DataKeyNames="customerID" DataSourceID="SqlDataSource1" ForeColor="Black" GridLines="None" OnSelectedIndexChanged="GridView1_SelectedIndexChanged">
                <AlternatingRowStyle BackColor="PaleGoldenrod" />
                <Columns>
                    <asp:BoundField DataField="customerID" HeaderText="顧客ID" ReadOnly="True" SortExpression="customerID">
                    <ItemStyle Width="70px" Wrap="True" />
                    </asp:BoundField>
                    <asp:HyperLinkField DataNavigateUrlFields="customerID" DataNavigateUrlFormatString="CustomerCard.aspx?id={0}" DataTextField="customer_name" HeaderText="顧客名" SortExpression="customer_name">
                    <ItemStyle Width="100px" />
                    </asp:HyperLinkField>
                    <asp:BoundField DataField="customer_kana" HeaderText="顧客名カナ" SortExpression="customer_kana">
                    <ItemStyle Width="120px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="section" HeaderText="部署名" SortExpression="section">
                    <ItemStyle Width="120px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="post" HeaderText="役職" SortExpression="post">
                    <ItemStyle Width="100px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="company_name" HeaderText="会社名" ReadOnly="True" SortExpression="company_name">
                    <ItemStyle Width="160px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="staff_name" HeaderText="営業担当者" SortExpression="staff_name">
                    <ItemStyle Width="100px" />
                    </asp:BoundField>
                </Columns>
                <EmptyDataTemplate>
                    該当するデータがありません。<br /> 抽出条件を変更してから【フィルター実行】ボタンをクリックして下さい。
                </EmptyDataTemplate>
                <FooterStyle BackColor="Tan" />
                <HeaderStyle BackColor="Tan" Font-Bold="True" />
                <PagerStyle BackColor="PaleGoldenrod" ForeColor="DarkSlateBlue" HorizontalAlign="Center" />
                <SelectedRowStyle BackColor="DarkSlateBlue" ForeColor="GhostWhite" />
                <SortedAscendingCellStyle BackColor="#FAFAE7" />
                <SortedAscendingHeaderStyle BackColor="#DAC09E" />
                <SortedDescendingCellStyle BackColor="#E1DB9C" />
                <SortedDescendingHeaderStyle BackColor="#C2A47B" />
            </asp:GridView>
        </ContentTemplate>
    </asp:UpdatePanel>
    <div class="auto-style15">
    </div>
</asp:Content>
