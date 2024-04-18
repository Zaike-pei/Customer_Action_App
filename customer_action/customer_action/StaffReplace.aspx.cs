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
    public partial class StaffReplace : System.Web.UI.Page
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            if (Session["StaffID"] == null)
            {
                // ユーザー認証されていない場合ログオン画面に遷移
                Response.Redirect("Logon.aspx", false);
            }
            // 管理者権限があるかのユーザー認証
            if (!Convert.ToBoolean(Session["AdminFlag"]))
            {
                Session.Clear();
                Response.Redirect("Logon.aspx", false);
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // webページをキャッシュしないように設定
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
        }

        protected void ExecuteButton_Click(object sender, EventArgs e)
        {
            string beforeID = BeforeDropDownList.SelectedValue;
            string afterID = AfterDropDownList.SelectedValue;

            // どちらかが選択されていない場合
            if(beforeID == "-1" || afterID == "-1")
            {
                MessageLabel.Text = "変更前と変更後の担当者が選択されているかを確認してください。";
                MessageLabel.ForeColor = System.Drawing.Color.Red;
                return;
            }

            // リストからそれぞれ同じものを選択した場合
            if(beforeID == afterID)
            {
                MessageLabel.Text = "変更前と変更後の担当者が同じであるため、処理を実行出来ません。";
                MessageLabel.ForeColor = System.Drawing.Color.Red;
                return;
            }

            try
            {
                string connectionString = ConfigurationManager.
                        ConnectionStrings["customer_actionConnectionString"].ConnectionString;


                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    SqlCommand command = con.CreateCommand();

                    con.Open();

                    command.CommandText = "update tbl_customer set StaffID=" + afterID +
                                            "where StaffID = " + beforeID;
                    // 変更件数を取得してメッセージを表示
                    int line = command.ExecuteNonQuery();
                    MessageLabel.Text = line + "件の顧客で担当者を変更しました。";
                }


            }
            catch (Exception err)
            {
                // メッセージラベルにエラーメッセージを表示する
                MessageLabel.Text = "エラーが発生したため、処理を中止します。<br>" + err.Message;
            }
        }
    }
}