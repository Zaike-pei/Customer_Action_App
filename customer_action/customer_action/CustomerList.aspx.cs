using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace customer_action
{
    public partial class CustomerList : System.Web.UI.Page
    {

        protected void Page_Init(object sender, EventArgs e)
        {
            if (Session["StaffID"] == null)
            {
                // ユーザー認証されていない場合ログオン画面に遷移
                Response.Redirect("Logon.aspx", false);
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // webページをキャッシュしないように設定
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
        }

        protected void FilterButton_Click(object sender, EventArgs e)
        {
            if (MyCustomerCheckBox.Checked)
            {
                GridView1.DataSourceID = SqlDataSource2.ID;
            }
            else
            {
                GridView1.DataSourceID = SqlDataSource1.ID;
            }
        }

        protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}