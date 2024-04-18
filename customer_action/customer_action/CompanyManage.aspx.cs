using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;

namespace customer_action
{
    public partial class CompanyManage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // webページをキャッシュしないように設定
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
        }

        protected void Page_Init(object sender, EventArgs e)
        {


            if (Session["StaffID"] == null)
            {
                // ユーザー認証されていない場合ログオン画面に遷移
                Response.Redirect("Logon.aspx", false);
            }
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            // 新しい会社IDの取得
            int newID = GetNewID();
            // 新しい会社ID取得出来なかった場合、処理を終了
            if(newID == -1)
            {
                MessageLabel.Text = "会社IDの取得に失敗しました。データベースを確認してください。";
                return;
            }
            // 挿入クエリを作成
            string queryString = "insert into tbl_company(" +
                "companyID, company_name, company_kana, delete_flag)" +
                "values( " + newID + ", '(新規)', '', 0)";

            try
            {

                // 接続文字列を取得
                string connectionString = ConfigurationManager.ConnectionStrings["customer_actionConnectionString"].ConnectionString;

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    using (SqlCommand comamnd = new SqlCommand(queryString, con))
                    {
                        con.Open();
                        // クエリの実行
                        comamnd.ExecuteNonQuery();
                        // グリッドビューを再バインドしてデータを更新する
                        AdminGridView.DataBind();
                        // メッセージを表示
                        MessageLabel.Text = "新しい会社を追加しました。";
                    }
                }
            }
            catch(Exception err)
            {
                Console.WriteLine(err.Message);
                MessageLabel.Text = "エラーが発生しました。処理を中止します。<br />" + err.Message;
            }
        }

        int GetNewID()
        {
            int companyID = -1;
            string queryString = "select isnull(max(companyID), 0)+1 from tbl_company";

            try
            {
                // 接続文字列の取得
                string connectionString = ConfigurationManager.ConnectionStrings["customer_actionConnectionString"].ConnectionString;
                
                using(SqlConnection con = new SqlConnection(connectionString))
                {
                    using(SqlCommand command = new SqlCommand( queryString, con))
                    {
                        con.Open();
                        // クエリを実行し値を取得
                        Object result = command.ExecuteScalar();
                        // 値を取得出来ていれば値を変数に格納
                        if(result != null)
                        {
                            companyID = Convert.ToInt32(result.ToString());
                        }
                    }
                }
            }
            catch(Exception err)
            {
                Console.WriteLine(err.Message);
            }

            return companyID;
        }

        protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            if (e.NewValues["company_name"] == null)
            {
                MessageLabel.Text = "会社名は必須入力です。";
                e.Cancel = true;
            }
        }

        protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}