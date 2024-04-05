using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace customer_action
{
    public partial class Menu : System.Web.UI.Page
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

            // ユーザーレベルによって画面表示を切り替える
            switch (GetUserLevel())
            {
                case 1:
                    AdminPanel.Visible = true;
                    UserPanel.Visible = false;
                    break;
                case 2:
                    AdminPanel.Visible = false;
                    UserPanel.Visible= true;
                    break;
                default:
                    Response.Redirect("Logon.aspx", false);
                    break;
            }
        }

        // セッション変数を参照して、ユーザーレベルを返す
        int GetUserLevel()
        {
            if (Session["AdminFlag"] == null)
            {
                return 0;
            }
            else if (Convert.ToBoolean(Session["AdminFlag"]))
            {
                return 1;
            } 
            else
            {
                return 2;
            }
        }

        protected void LinkButton1_Click(object sender, EventArgs e)
        {
            // セッション変数をクリア
            Session.Clear();
            // ログオン画面に遷移
            Response.Redirect("Logon.aspx", false);
        }

        protected void LinkButton2_Click(object sender, EventArgs e)
        {
            // セッション変数をクリア
            Session.Clear();
            // ログオン画面に遷移
            Response.Redirect("Logon.aspx", false);
        }
    }
}