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
    public partial class Logon : System.Web.UI.Page
    {
        int staffID;
        string staffName;
        bool adminflag;

        protected void Page_Load(object sender, EventArgs e)
        {
            // ユーザIDテキストボックスにフォーカスをセット
            UserIDTextBox.Focus();
            // ログオンボタンをフォームの既定ボタンに設定
            this.Form.DefaultButton = LogonButton.UniqueID;
        }

        protected void LogonButton_Click(object sender, EventArgs e)
        {
            // ユーザーIDの入力チェック
            if (UserIDTextBox.Text == "")
            {
                ErrorLabel.Text = "ユーザーIDを入力して下さい。";
                return;
            }

            // パスワードの入力チェック
            if (PasswordTextBox.Text == "")
            {
                ErrorLabel.Text = "パスワードを入力して下さい。";
                return;
            }

            // ユーザーIDとパスワードの検証
            if (!CheckUserPassword(UserIDTextBox.Text, PasswordTextBox.Text))
            {
                ErrorLabel.Text = "ユーザーIDまたはパスワードが違います。";
                return;
            }

            // セッション変数に値をセット
            Session["StaffID"] = staffID;
            Session["StaffName"] = staffName;
            Session["AdminFlag"] = adminflag;

            // メニュー画面に遷移
            Response.Redirect("Menu.aspx", false);
        }

        // ユーザーが入力したIDとパスワードが正しいかを確認する関数
        bool CheckUserPassword(string username, string password)
        {
            bool isTrueflag; // ユーザーIDとパスワードの有無を判定
            string queryString;

            try
            {
                // クエリ文字列の作成
                queryString = "select staffID, staff_name, userID, password, admin_flag from tbl_staff " +
                        "where userId = '" + username.Replace("'", "''") +
                        "' and password = '" + password.Replace("'", "''") + "'" +
                        "collate japanese_cs_as_ks_ws";

                // 接続文字列を取得
                string connectionString = ConfigurationManager.ConnectionStrings["customer_actionConnectionString"].ConnectionString;

                using(SqlConnection con = new SqlConnection(connectionString))
                {
                    // コマンドを定義
                    SqlCommand command = new SqlCommand(queryString, con);
                    
                    con.Open();

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        // 値を取得出来たら変数に値を格納
                        if (reader.Read())
                        {
                            staffID = Int32.Parse(reader["staffId"].ToString());
                            staffName = reader["staff_name"].ToString();
                            adminflag = Convert.ToBoolean(reader["admin_flag"]);
                            
                            isTrueflag = true;
                        }
                        else
                        {
                            isTrueflag = false;
                        }
                    }
                }
            }
            catch(Exception err)
            {
                Console.WriteLine(err.Message);
                isTrueflag = false;
            }

            return isTrueflag;
        }
    }
}