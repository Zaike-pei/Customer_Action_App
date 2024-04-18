using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace customer_action
{
    public partial class ActionList : System.Web.UI.Page
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            if (Session["StaffID"] == null)
            {
                Response.Redirect("Logon.aspx", false);
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // このWebページをキャッシュしないように設定する
            Response.Cache.SetCacheability(HttpCacheability.NoCache);

            // ポストバックかどうか判定する
            if (!IsPostBack)
            {
                // ポストバック時ではないときには、期間に既定値をセットする
                FirstDateTextBox.Text = DateTime.Now.AddDays(-6).ToString("yyyy/MM/dd");
                LastDateTextBox.Text = DateTime.Now.ToString("yyyy/MM/dd");
            }
            else
            {
                // ポストバック時の処理
                // 開始日が日付で指定されていないときには、既定値に戻す
                DateTime dt;
                if (!DateTime.TryParse(FirstDateTextBox.Text, out dt))
                {
                    FirstDateTextBox.Text = DateTime.Now.AddDays(-6).ToString("yyyy/MM/dd");
                }

                // 終了日が日付で指定されていないときには、既定値に戻す
                if (!DateTime.TryParse(LastDateTextBox.Text, out dt))
                {
                    LastDateTextBox.Text = DateTime.Now.ToString("yyyy/MM/dd");
                }

            }
            // ［フィルター］ボタンをこのWebフォームの既定ボタンにする
            this.Form.DefaultButton = FilterButton.UniqueID;
        }
    }
}