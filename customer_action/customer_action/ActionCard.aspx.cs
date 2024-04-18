using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;

namespace customer_action
{
    public partial class ActionCard : System.Web.UI.Page
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            if (Session["StaffID"] == null)
            {
                // ユーザー認証されていない場合ログオン画面に遷移
                Response.Redirect("Logon.aspx", false);
            }

            FormView1.DefaultMode = FormViewMode.Edit;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // webページをキャッシュしないように設定
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
        }





        protected void FormView1_ItemCommand(object sender, FormViewCommandEventArgs e)
        {
            // 実行するコマンド名と現在のモードを判定
            if(e.CommandName == "Cancel" && FormView1.CurrentMode == FormViewMode.Insert)
            {
                // コマンドモードがキャンセルでかつ挿入モードの時はCustomerListフォームの戻る
                Response.Redirect("CustomerList.aspx", false);
            }
        }

        protected void CancelButton_Click(object sender, EventArgs e)
        {
            // 顧客フォームに戻る
            Response.Redirect("CustomerCard.aspx?id=" + Request.QueryString["customerID"], false);
        }

        protected void FormView1_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
        {
            // 顧客フォームに戻る
            Response.Redirect("CustomerCard.aspx?id=" + Request.QueryString["customerID"], false);
        }
    }
}