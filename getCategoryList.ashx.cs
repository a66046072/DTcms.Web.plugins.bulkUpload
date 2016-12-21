using System.Data;
using System.Data.OleDb;
using System.Text;
using System.Web;

namespace DTcms.Web.plugins.bulkUpload
{
    /// <summary>
    /// upload 的摘要说明
    /// </summary>
    public class getCategoryList : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/html";
            int channel_id = int.Parse(context.Request.Form["channel_id"]);
            DataTable oldData = AccessHelper.ExecuteDataSet("select id,title,class_layer,parent_id from dt_article_category where channel_id=@channel_id order by sort_id,id", new OleDbParameter("@channel_id", channel_id)).Tables[0];
            DataTable dt = oldData.Clone();
            //调用迭代组合成DAGATABLE
            GetChilds(oldData, dt, 0, channel_id);
            StringBuilder sb = new StringBuilder();
            if (dt.Rows.Count > 0) {
                foreach (DataRow dr in dt.Rows)
                {
                    string Id = dr["id"].ToString();
                    int ClassLayer = int.Parse(dr["class_layer"].ToString());
                    string Title = dr["title"].ToString().Trim();

                    if (ClassLayer == 1)
                    {
                        sb.Append(string.Format("<option value=\"{0}\">{1}</option>", Id, Title));
                    }
                    else
                    {
                        Title = "├ " + Title;
                        Title = Common.Utils.StringOfChar(ClassLayer - 1, "　") + Title;
                        sb.Append(string.Format("<option value=\"{0}\">{1}</option>", Id, Title));
                    }
                }
            }
            context.Response.Write(sb);
        }

        /// <summary>
        /// 从内存中取得所有下级类别列表（自身迭代）
        /// </summary>
        private void GetChilds(DataTable oldData, DataTable dt, int parent_id, int channel_id)
        {
            DataRow[] dr = oldData.Select("parent_id=" + parent_id);
            for (int i = 0; i < dr.Length; i++)
            {
                //添加一行数据
                DataRow row = dt.NewRow();
                row["id"] = int.Parse(dr[i]["id"].ToString());
                row["parent_id"] = int.Parse(dr[i]["parent_id"].ToString());
                row["title"] = dr[i]["title"].ToString();               
                row["class_layer"] = int.Parse(dr[i]["class_layer"].ToString());
                dt.Rows.Add(row);
                //调用自身迭代
                this.GetChilds(oldData, dt, int.Parse(dr[i]["id"].ToString()), channel_id);
            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}