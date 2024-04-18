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
    public partial class StaffManage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // webページをキャッシュしないように設定
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            if (!Convert.ToBoolean(Session["AdminFlag"]))
            {
                Session.Clear();
                Response.Redirect("Logon.aspx", false);
            }
        }

        protected void InsertButton_Click(object sender, EventArgs e)
        {
            // 新しいスタッフIDの取得
            int newStaffID = GetNewStaffID();

            if(newStaffID == -1)
            {
                MessageLabel.Text = "スタッフIDの取得に失敗しました。データベースを確認してください。";
                return;
            }

            string queryString = "insert into tbl_staff" +
                " (staffID, staff_name, userID, password, admin_flag, delete_flag)" +
                "values(" + newStaffID + ", '(新規)', '', '', 0, 0)";

            try
            {
                // 接続文字列の取得
                string connectionString = ConfigurationManager.ConnectionStrings["customer_actionConnectionString"].ConnectionString;

                using(SqlConnection con = new SqlConnection(connectionString))
                {
                    using(SqlCommand command = new SqlCommand(queryString, con))
                    {
                        con.Open();
                        // クエリの実行
                        command.ExecuteNonQuery();
                        // グリッドビューを再バインドしてデータを更新する
                        GridView1.DataBind();
                        // ラベルに結果のメッセージを表示
                        MessageLabel.Text = "新しいスタッフを追加しました。";
                    }
                }
            }
            catch (Exception err)
            {
                Console.WriteLine(err.Message);
                MessageLabel.Text = "エラーが発生しました。処理を中止します。<br />" + err.Message;
            }

        }

        int GetNewStaffID()
        {
            int staffid = -1;
            // webコンフィグから接続文字列の取得
            string connectionString = ConfigurationManager.ConnectionStrings["customer_actionConnectionString"].ConnectionString;

            try
            {
                // tbl_staffからスタッフIDに+1した値（最大値＋１）を取得するクエリ
                string queryString = "select isnull(max(staffID), 0)+1 from tbl_staff";

                using(SqlConnection con = new SqlConnection(connectionString))
                {
                    using(SqlCommand command = new SqlCommand(queryString, con))
                    {
                        con.Open();
                        // データベースから値を取得
                        Object result = command.ExecuteScalar();
                        // 値が取得できていれば、staffidに値を入れる
                        if(result != null)
                        {
                            staffid = Convert.ToInt32(result.ToString());
                        }
                    }
                }
            }
            catch(Exception err)
            {
                Console.WriteLine(err.Message);
            }

            return staffid;
        }


        protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            if (e.NewValues["staff_name"] == null)
            {
                MessageLabel.Text = "スタッフ名は必須入力です。";
                e.Cancel = true;
            }
        }
    }
}