using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using System.Diagnostics;
using System.Configuration;

namespace customer_action
{
    public partial class CustomerCard : Page
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

            // ポストバックかどうかの判定
            if (!IsPostBack)
            {
                if (Request.QueryString["id"] == null)
                {
                    FormView1.DefaultMode = FormViewMode.Insert;
                }
            }
        }

        protected void FormView1_PageIndexChanging(object sender, FormViewPageEventArgs e)
        {

        }

        protected void FormView1_ItemUpdating(object sender, FormViewUpdateEventArgs e)
        {
            // 最終更新日時と最終更新者をセット
            e.NewValues["update_date"] = DateTime.Now;
            e.NewValues["update_staff_name"] = Session["StaffName"];
        }

        protected void FormView1_ItemInserting(object sender, FormViewInsertEventArgs e)
        {
            // 顧客IDを取得
            int customerID = GetNewID();
            // 顧客IDが取得できたら
            if(customerID != -1)
            {
                e.Values["customerID"] = customerID;
                e.Values["input_date"] = DateTime.Now;
                e.Values["input_staff_name"] = Session["StaffName"];
                e.Values["update_date"] = DateTime.Now;
                e.Values["update_staff_name"] = Session["StaffName"];
            }
            else
            {
                e.Cancel = true;
            }

        }

        int GetNewID()
        {
            // 顧客id変数にデフォルトで取得に失敗した時の値-1を定義
            int customer_id = -1;
            Console.WriteLine(customer_id);
            try
            {
                // web.configから接続文字列の取得
                string connectionString = ConfigurationManager.
                            ConnectionStrings["customer_actionConnectionString"].ConnectionString;

                using(SqlConnection con = new SqlConnection(connectionString))
                {
                    // sqlステートメントを定義（customerIDの最大値に＋１した値を取得。nullの場合１を返す）
                    string queryString = "SELECT ISNULL(MAX(customerID),0)+1 FROM tbl_customer";
                    // コマンドを定義
                    SqlCommand command = new SqlCommand(queryString, con);

                    // 接続開始
                    con.Open();

                    // sqlステートメントの実行結果を取得
                    Object result = command.ExecuteScalar();

                        // 結果を正しく取得できたら
                        if (result != null)
                        {
                            customer_id = (int)result;
                        }
                    
                }
            }
            catch (SqlException err)
            {
                Console.WriteLine(err.Message);
            }
            catch (Exception err)
            {
                Console.WriteLine(err.Message);
            }

            return customer_id;
        }

        protected void FormView1_ItemCommand(object sender, FormViewCommandEventArgs e)
        {
            // 実行するコマンド名と現在のモードを判定
            if(e.CommandName == "Cancel" && FormView1.CurrentMode == FormViewMode.Insert)
            {
                // コマンド名がCancelである且つ、挿入モードの時はCustomerList.aspxにリダイレクト
                Response.Redirect("CustomerList.aspx", false);
            }
        }

        protected void CustomValidator1_ServerValidate(object source, ServerValidateEventArgs args)
        {
            // isValidプロパティをfalseに設定
            args.IsValid = false;
            if (DateTime.TryParse((string)args.Value, out DateTime d))
            {
                if(d.Year >= 1900 && d.Year <= 9999)
                {
                    args.IsValid = true;
                }
            }
        }



        protected void LinkButton1_Click(object sender, EventArgs e)
        {
            // 営業報告IDを取得
            int newActionID = GetActionID();

            if (newActionID == -1)
            {
                MessageLabel.Text = "営業報告IDを取得出来ませんでした。データベースを確認してください。";
                return;
            }

            // クエリの宣言
            string queryString = "insert into tbl_action" +
                " (ID, customerID, action_date, action_content, action_staffID)" +
                " values(" + newActionID + ", " + Request.QueryString["id"] + ",'" + DateTime.Today + "', " +
                "'新規営業報告データ'," + Session["StaffID"] + ")";

            try
            {
                // 接続文字列の取得
                string connectionString = ConfigurationManager.ConnectionStrings["customer_actionConnectionString"].ConnectionString;

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    using (SqlCommand command = new SqlCommand(queryString, con))
                    {
                        con.Open();
                        // コマンド実行
                        command.ExecuteNonQuery();
                        // グリッドビューを更新
                        GridView1.DataBind();
                        // 結果をメッセージで表示
                        MessageLabel.Text = "新しいデータを追加しました。";
                    }
                }
            }
            catch(Exception err)
            {
                Console.WriteLine(err.Message);
                MessageLabel.Text = "エラーが発生したため、処理を中止しました。<br />" + err.Message;
            }
        }

        int GetActionID()
        {
            int actNum = -1;

            try
            {
                // 接続文字列の取得
                string connectionString = ConfigurationManager.ConnectionStrings["customer_actionConnectionString"].ConnectionString;

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    // クエリを宣言
                    string queryString = "select isnull(max(ID), 0)+1 from tbl_action";

                    using (SqlCommand command = new SqlCommand(queryString, con))
                    {
                        con.Open();
                        // コマンドを実行し値を取得
                        Object result = command.ExecuteScalar();

                        if (result != null)
                        {
                            actNum = Convert.ToInt32(result.ToString());
                        }
                    }
                }
            }
            catch (Exception err)
            {
                Console.WriteLine(err.Message);
            }

            return actNum;
        }
    }
}