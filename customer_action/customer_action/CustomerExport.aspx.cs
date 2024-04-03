using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Text;
using System.Configuration;

namespace customer_action
{
    public partial class CustomerExport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ExportButton_Click(object sender, EventArgs e)
        {
            // カンマ区切りの
            string csvString = MakeCSVData();
            // BOMデータの作成
            byte[] bom = new byte[3] { 0xef, 0xbb, 0xbf };
            // 出力する既定のファイル名
            const string csvfile = "customer.csv";

            // クライアントに出力するバッファデータをクリア
            Response.Clear();
            // コンテンツタイプを指定
            Response.ContentType = "application/octet-stream";
            // HTTPヘッダーを指定
            Response.AddHeader("Content-Disposition", "attachment; filename=" + csvfile);
            // BOM出力後、UTF-8のテキストファイルを出力する
            Response.BinaryWrite(bom);
            Response.BinaryWrite(Encoding.GetEncoding("UTF-8").GetBytes(csvString));

            // 出力するファイルを終了する
            Response.End();
        }

        string MakeCSVData()
        {
            StringBuilder sb = new StringBuilder();
            // ヘッダー行の追加
            sb.AppendLine("\"顧客ID\", \"顧客名\", \"顧客名カナ\", \"会社名\", \"部署\",\"役職\", \"郵便番号\", \"住所\", \"電話番号\", \"担当者名\"");
            // クエリを作成
            string queryString = "Select c.*, co.company_name, st.staff_name " +
                " From tbl_customer as c " +
                " Left Join tbl_staff as st on c.staffID = st.staffID " +
                " Left Join tbl_company as co on c.companyID = co.companyID " +
                " Where c.delete_flag = 0";

            // 担当者が選択されていた場合、条件を追加
            if(StaffDropDownList.SelectedValue != "-1")
            {
                queryString += " And c.staffID=" + StaffDropDownList.SelectedValue;
            }

            // データベースと接続してデータを取得
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["customer_actionConnectionString"].ConnectionString;

                using(SqlConnection con = new SqlConnection(connectionString))
                {
                    SqlCommand command = new SqlCommand(queryString, con);

                    con.Open();

                    // データリーダーを定義
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        // １レコードずつ取得して値を追加していく
                        while (reader.Read())
                        {
                            sb.Append("\"" + ReplaceDoubleQuotes(reader["customerID"]) + "\",");
                            sb.Append("\"" + ReplaceDoubleQuotes(reader["customer_name"]) + "\",");
                            sb.Append("\"" + ReplaceDoubleQuotes(reader["customer_kana"]) + "\",");
                            sb.Append("\"" + ReplaceDoubleQuotes(reader["company_name"]) + "\",");
                            sb.Append("\"" + ReplaceDoubleQuotes(reader["section"]) + "\",");
                            sb.Append("\"" + ReplaceDoubleQuotes(reader["post"]) + "\",");
                            sb.Append("\"" + ReplaceDoubleQuotes(reader["zipcode"]) + "\",");
                            sb.Append("\"" + ReplaceDoubleQuotes(reader["address"]) + "\",");
                            sb.Append("\"" + ReplaceDoubleQuotes(reader["tel"]) + "\",");
                            sb.Append("\"" + ReplaceDoubleQuotes(reader["staff_name"]) + "\"");
                            // 改行コードを追加
                            sb.Append("\r\n");
                        }
                    }

                }
            }
            catch(Exception err)
            {
                Console.WriteLine(err.Message);
            }

            return sb.ToString();
        }

        // ダブルクオーテーションの置換
        string ReplaceDoubleQuotes(object apdata)
        {
            string tmp = apdata.ToString();
            return tmp.Replace("\"", "\\\"");
        }
    }
}