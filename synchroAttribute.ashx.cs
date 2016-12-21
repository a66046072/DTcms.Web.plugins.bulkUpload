using System;
using System.Data;
using System.Data.OleDb;
using System.Text;
using System.Web;

namespace DTcms.Web.plugins.bulkUpload
{
    /// <summary>
    /// upload 的摘要说明
    /// </summary>
    public class synchroAttribute : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/html";
            int maxId = Convert.ToInt32(AccessHelper.ExecuteScalar("select top 1 article_id from dt_article_attribute_value order by article_id desc"));
            DataTable dt = AccessHelper.ExecuteDataSet("select id from dt_article where id > @maxId",new OleDbParameter("@maxId", maxId)).Tables[0];
            if (dt.Rows.Count > 0) {
                foreach (DataRow dr in dt.Rows)
                {
                    AccessHelper.ExecuteNonQuery("insert into dt_article_attribute_value (article_id) values (@article_id)", new OleDbParameter("@article_id", dr["id"]));
                }
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