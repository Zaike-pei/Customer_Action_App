<%@ Page Title="営業報告一覧" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="ActionList.aspx.cs" Inherits="customer_action.ActionList" %><%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="ajaxToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .auto-style5 {
            width: 74px;
            height: 23px;
            text-align: right;
        }
        .auto-style7 {
            height: 23px;
        }
        .auto-style8 {
            width: 74px;
            height: 16px;
        }
        .auto-style10 {
            height: 16px;
        }
        .auto-style11 {
            width: 147px;
            height: 16px;
        }
        .auto-style12 {
            width: 147px;
            height: 23px;
        }
        .auto-style14 {
            width: 13px;
            height: 16px;
        }
        .auto-style15 {
            width: 13px;
            height: 23px;
        }
        .auto-style17 {
            width: 119px;
            height: 16px;
        }
        .auto-style18 {
            width: 119px;
            height: 23px;
            text-align: right;
        }
        .auto-style19 {
            text-align: center;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:customer_actionConnectionString %>" SelectCommand="select act.action_date, st.staff_name, cust.customer_name, comp.company_name, act.action_content
from tbl_action as act
left join tbl_customer as cust
on cust.customerID = act.customerID
left join tbl_staff as st
on st.staffID = act.action_staffID
left join tbl_company as comp
on comp.companyID = cust.companyID
where act.action_date between @firstdate and @lastdate">
        <SelectParameters>
            <asp:ControlParameter ControlID="FirstDateTextBox" Name="firstdate" PropertyName="Text" />
            <asp:ControlParameter ControlID="LastDateTextBox" Name="lastdate" PropertyName="Text" />
        </SelectParameters>
    </asp:SqlDataSource>
    <br />
        <table class="auto-style1">
            <tr>
                <td class="auto-style8">営業報告一覧</td>
                <td class="auto-style17"></td>
                <td class="auto-style14"></td>
                <td class="auto-style11"></td>
                <td class="auto-style10"></td>
            </tr>
            <tr>
                <td class="auto-style5">期間：</td>
                <td class="auto-style18">&nbsp;<asp:TextBox ID="FirstDateTextBox" runat="server" Width="70px"></asp:TextBox>
                    <ajaxToolkit:CalendarExtender ID="FirstDateTextBox_CalendarExtender" runat="server" BehaviorID="TextBox1_CalendarExtender" DaysModeTitleFormat="yyyy/MM/dd" TargetControlID="FirstDateTextBox">
                    </ajaxToolkit:CalendarExtender>
                </td>
                <td class="auto-style15">～</td>
                <td class="auto-style12">
                    <asp:TextBox ID="LastDateTextBox" runat="server" Width="70px"></asp:TextBox>
                    <ajaxToolkit:CalendarExtender ID="LastDateTextBox_CalendarExtender" runat="server" BehaviorID="TextBox2_CalendarExtender" DaysModeTitleFormat="yyyy/MM/dd" TargetControlID="LastDateTextBox">
                    </ajaxToolkit:CalendarExtender>
                </td>
                <td class="auto-style7">
                    <asp:Button ID="FilterButton" runat="server" Text="フィルター実行" />
                </td>
            </tr>
            <tr>
                <td class="auto-style8"></td>
                <td class="auto-style17"></td>
                <td class="auto-style14"></td>
                <td class="auto-style11"></td>
                <td class="auto-style10"></td>
            </tr>
        </table>
        <div class="auto-style19">
            <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" BackColor="LightGoldenrodYellow" BorderColor="Tan" BorderWidth="1px" CellPadding="2" DataSourceID="SqlDataSource1" ForeColor="Black" GridLines="None" Width="800px">
                <AlternatingRowStyle BackColor="PaleGoldenrod" />
                <Columns>
                    <asp:BoundField DataField="action_date" DataFormatString="{0:yyyy/MM/dd}" HeaderText="日付" SortExpression="action_date">
                    <ItemStyle Width="100px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="staff_name" HeaderText="担当者" SortExpression="staff_name">
                    <ItemStyle Width="100px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="customer_name" HeaderText="顧客名" SortExpression="customer_name">
                    <ItemStyle Width="100px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="company_name" HeaderText="会社名" SortExpression="company_name">
                    <ItemStyle Width="150px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="action_content" HeaderText="対応内容" SortExpression="action_content">
                    <ItemStyle Width="200px" />
                    </asp:BoundField>
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
        </div>
    </asp:Content>
