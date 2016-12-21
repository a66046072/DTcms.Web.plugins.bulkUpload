using System;
using System.Data.OleDb;
using System.IO;
using System.Web;

namespace DTcms.Web.plugins.bulkUpload
{
    /// <summary>
    /// upload 的摘要说明
    /// </summary>
    public class upload : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/html";            
            string title = context.Request.Form["title"];
            string category = context.Request.Form["category"];
            if (category=="null")
            {
                context.Response.Write("请选择分类");
            }
            else {
                HttpPostedFile file = context.Request.Files[0];
                string res = checkFileAndUpload(file);
                if (res == "0")
                {
                    if (string.IsNullOrEmpty(title)) {
                        title = Path.GetFileNameWithoutExtension(file.FileName);                        
                    }                    
                    string sql = "insert into dt_article (channel_id,category_id,title,img_url,user_name) values (@channel_id,@category_id,@title,@img_url,'admin')";
                    OleDbParameter[] pars = {
                        new OleDbParameter("@channel_id", getChannel_id(category)),
                        new OleDbParameter("@category_id", category),
                        new OleDbParameter("@title", title),
                        new OleDbParameter("@img_url", UploadFile(file, "/upload/bulkUpload/")),
                    };
                    if (AccessHelper.ExecuteNonQuery(sql, pars) == 1)
                    {                        
                        context.Response.Write("操作成功！");
                    }
                    else {
                        context.Response.Write("服务器繁忙！");
                    }
                }
                else {
                    context.Response.Write(res);
                }
            }            
            //context.Response.Write("Hello World");
        }

        #region 检测文件
        public string checkFileAndUpload(HttpPostedFile file)
        {
            if (file == null)
            {
                return ("请选择图片！");
            }
            else
            {
                string fileName = file.FileName;
                int fileSize = file.ContentLength;
                string fileExt = Path.GetExtension(fileName).ToLower();
                if (!(fileExt == ".png" || fileExt == ".gif" || fileExt == ".jpg" || fileExt == ".jpeg"))
                {
                    return ("文件格式不正确！");
                }
                else
                {
                    if (fileSize > (int)(1000 * 1024))
                    {
                        return ("最大只能上传1M文件！");
                    }
                    else
                    {
                        return ("0");
                    }
                }
            }
        } 
        #endregion

        #region 上传文件
        /// <summary>
        /// 上传文件
        /// </summary>
        /// <param name="file">文件</param>
        /// <param name="myFilePath">保存的路径</param>
        /// <returns></returns>
        public string UploadFile(HttpPostedFile file, string myFilePath)
        {
            string fileExt = Path.GetExtension(file.FileName).ToLower();
            string uploadFileName = DateTime.Now.ToString("yyyyMMddHHmmss") + Guid.NewGuid().ToString("N") + fileExt;
            try
            {
                string myFile = myFilePath + DateTime.Now.ToString("yyyyMM") + "/";
                string directoryPath = HttpContext.Current.Server.MapPath(myFile);
                //不存在这个文件夹就创建这个文件夹
                if (!Directory.Exists(directoryPath))
                {
                    Directory.CreateDirectory(directoryPath);
                }
                file.SaveAs(directoryPath + uploadFileName);
                return (myFile + uploadFileName); //返回文件绝对路径
            }
            catch
            //catch (Exception ex)  不返回错误消息
            {
                //return ex.Message;
                return "0";
            }
        }
        #endregion

        #region 获取channel_id
        public string getChannel_id(string id) {
            return AccessHelper.ExecuteScalar("select channel_id from dt_article_category where id=@id",new OleDbParameter("@id", id)).ToString();
        }
        #endregion


        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}