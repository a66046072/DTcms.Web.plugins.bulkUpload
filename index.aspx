<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="DTcms.Web.plugins.bulkUpload.index" %>
<%@ Import Namespace="System.Data" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>批量上传</title>
<!-- Bootstrap -->
<link href="src/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<!-- Fonts -->
<!--<link href='http://fonts.useso.com/css?family=Ubuntu:300,400,700' rel='stylesheet' type='text/css'>-->
<link href="src/css/sugarrush.css" rel="stylesheet" type="text/css">
<!-- SugarRush CSS -->
<!-- <link href="src/css/sugarrush.css" rel="stylesheet"> -->
<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
<!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>

<body class="">
<div class="animsition">
  <main>
    <div class="container-fluid">
            <!-- PAGE TITLE -->
    <section id="page-title" class="row">

        <div class="col-md-8">
        <h1>批量上传</h1>
        <p class="lead">批量上传产品或案例图片</p>
        </div>

        <div class="col-md-4">

        <ol class="breadcrumb pull-right no-margin-bottom">
            <li><a href="/saipuAdmin">主页</a></li>
            <li><a href="#">插件管理</a></li>
            <li class="active">批量上传</li>
        </ol>

        </div>
    </section> <!-- / PAGE TITLE -->
      <div class="row">
        <div class="col-md-12"> 
            <section class="panel">
                <div class="panel-body">
                    <form>
                    <div class="form-group">
                        <label for="ipt_title">请输入标题(不填则使用图片名称作为标题)</label>
                        <input type="text" class="form-control" id="title" placeholder="请输入标题">
                    </div>
                    <div class="form-group">
                        <label for="channel">请选择栏目</label>
                        <select class="form-control" id="channel" onchange="getCategoryList($(this).val())">
<%
    DataTable dt = AccessHelper.ExecuteDataSet("select id,title from dt_channel order by sort_id,id").Tables[0];
    StringBuilder sb = new StringBuilder();
    foreach (DataRow dr in dt.Rows) {
        sb.Append(string.Format("<option value=\"{0}\">{1}</option>", dr["id"], dr["title"]));
    }
    
%>
                          <option value="0">请选择栏目</option>
                          <%=sb.ToString() %>
                        </select>
                    </div>
                    <div class="form-group" style="display:none;">
                        <label for="category">请选分类</label>
                        <select class="form-control" id="category">
                          
                        </select>
                    </div>
                    </form>
                </div>
                <script>
                    function getCategoryList(channel_id) {
                        if (channel_id != 0) {
                            $.post("getCategoryList.ashx", { "channel_id": channel_id }, function (data) {
                                if (data != "") {
                                    $("#category").parent().show();
                                    $("#category").html(data);
                                }
                            });
                        }
                        else {
                            $("#category").parent().hide();
                            $("#category").html("");
                        }
                    }
                </script>
            </section> <!-- / section -->
          <!-- Attachments -->
          <div class=" panel">
            <div class="panel-body">
              <div class="table table-striped files" id="previews">
                <div id="template" class="file-row"> 
                  <!-- This is used as the file preview template -->
                  <div> <span class="preview"><img data-dz-thumbnail src="#" alt="" /></span> </div>
                  <div>
                    <p class="name" data-dz-name></p>
                    <strong class="error text-danger" data-dz-errormessage></strong> </div>
                  <div>
                    <p class="size" data-dz-size></p>
                    <div class="progress progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0">
                      <div class="progress-bar progress-bar-success" style="width:0%;" data-dz-uploadprogress></div>
                    </div>
                  </div>
                  <div class="text-right pull-right">
                    <button class="btn btn-primary start"> <i class="ti-cloud-up"></i> <span>开始</span> </button>
                    <button data-dz-remove class="btn btn-warning cancel"> <i class="ti-hand-stop"></i> <span>取消</span> </button>
                    <button data-dz-remove class="btn btn-danger delete"> <i class="ti-trash"></i> <span>删除</span> </button>
                  </div>
                </div>
              </div>
              <div id="actions" class="row">
                <div> 
                  <!-- The fileinput-button span is used to style the file input field as button --> 
                  <span class="btn btn-success fileinput-button btn-sm"> <i class="ti-clip"></i> <span>选择文件</span> </span>
                  <button type="submit" class="btn btn-primary start btn-sm"> <i class="ti-cloud-up"></i> <span>开始上传</span> </button>
                  <button type="reset" class="btn btn-warning cancel btn-sm"> <i class="ti-hand-stop"></i> <span>清空列表</span> </button>
                </div>
                <div> 
                  <!-- The global file processing state --> 
                  <span class="fileupload-process">
                  <div id="total-progress" class="progress progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0">
                    <div class="progress-bar progress-bar-success" style="width:0%;" data-dz-uploadprogress></div>
                  </div>
                  </span> </div>
              </div>
            </div>
          </div>
          <!-- / Attachments --> 
        </div>
        <!-- / col-md-12 --> 
      </div>
      <!-- / row --> 
    </div>
    <!-- / container-fluid --> 
  </main>
  <!-- /playground --> 
  <!-- - - - - - - - - - - - - --> 
  <!-- start of NOTIFICATIONS  --> 
  <!-- - - - - - - - - - - - - -->
  <aside id="multi-panel">
    <div class="container-fluid no-margin slimscroll">
      <ul id="multi-panel-tabs" class="nav nav-tabs" role="tablist">
        <li><a href="#" class="close-multi-panel"><i class="fa fa-indent"></i></a></li>
        <li role="presentation" class="active"><a href="#contacts" role="tab" id="contacts-tab" data-toggle="tab" aria-controls="contacts" aria-expanded="true">Contacts</a></li>
        <li role="presentation"><a href="#alerts" id="alerts-tab" role="tab" data-toggle="tab" aria-controls="alerts">Alerts</a></li>
      </ul>
      <section class="panel ">
        <div id="multi-panel-tabs-content" class="tab-content"> 
          <!-- Chat -->
          <div role="tabpanel" class="tab-pane fade in active" id="contacts" aria-labelledby="contacts-tab">
            <div class="widget chat-widget list-group"> <a class="list-group-item" href="chat.html"> <span class="chat-status success"></span> Daenerys Targaryen <span class="label label-warning pull-right">13</span> </a> </div>
            <div class="widget chat-widget list-group"> <a class="list-group-item" href="chat.html"> <span class="chat-status success"></span> Tyrion Lannister </a> </div>
            <div class="widget chat-widget list-group"> <a class="list-group-item" href="chat.html"> <span class="chat-status warning"></span> Cersei Lannister <span class="label label-warning pull-right">2</span> </a> </div>
            <div class="widget chat-widget list-group"> <a class="list-group-item" href="chat.html"> <span class="chat-status danger"></span> Arya Stark </a> </div>
            <div class="widget chat-widget list-group"> <a class="list-group-item" href="chat.html"> <span class="chat-status danger"></span> Sansa Stark </a> </div>
          </div>
          <!-- / Chat --> 
          <!-- Alerts -->
          <div role="tabpanel" class="tab-pane fade" id="alerts" aria-labelledby="alerts-tab">
            <div class="widget">
              <h4 class="widget-title">Tasks Updated</h4>
              <div class="panel-body">
                <div class="form-group">
                  <div class="small"><span class="initialism">HTML</span> coding <span class="pull-right label label-danger">90%</span></div>
                  <div class="progress">
                    <div class="progress-bar progress-bar-danger" role="progressbar" aria-valuenow="90" aria-valuemin="0" aria-valuemax="100" style="width: 90%;"></div>
                  </div>
                </div>
                <div class="form-group">
                  <div class="small">Server setup <span class="pull-right label label-info">21%</span></div>
                  <div class="progress">
                    <div class="progress-bar progress-bar-info" role="progressbar" aria-valuenow="21" aria-valuemin="0" aria-valuemax="100" style="width: 21%;"></div>
                  </div>
                </div>
                <div class="form-group">
                  <div class="small">Bandwidth <span class="pull-right label label-warning">16%</span></div>
                  <div class="progress">
                    <div class="progress-bar progress-bar-warning" role="progressbar" aria-valuenow="16" aria-valuemin="0" aria-valuemax="100" style="width: 16%;"></div>
                  </div>
                </div>
              </div>
            </div>
            <!-- MESSAGES WIDGET -->
            <div class="widget messages-widget">
              <h4 class="widget-title">New Messages</h4>
              <ul class="list-group">
                <li class="list-group-item unread"> <span class="from"><a href="#">Jon Snow</a></span> <span class="label label-success">Jobs</span>
                  <p><a href="#">Lorem ipsum dolor sit amet, consectetur adipiscing elit.</a></p>
                </li>
                <li class="list-group-item"> <span class="from"><a href="#">Cersei Lannister</a></span> <span class="label label-info">PHP</span> <span class="label label-danger">Javascript</span>
                  <p><a href="#">Class aptent taciti sociosqu ad litora torquent per conubia nostra, vestibulum.</a></p>
                </li>
                <li class="list-group-item"> <span class="from"><a href="#">Sansa Stark</a></span>
                  <p><a href="#">Aenean cursus lacinia dolor et lacinia. Duis felis, venenatis et.</a></p>
                </li>
              </ul>
            </div>
            <!-- / MESSAGES WIDGET --> 
            <!-- MESSAGES WIDGET -->
            <div class="widget files-widget">
              <h4 class="widget-title">New Uploads</h4>
              <ul class="list-group">
                <li class="list-group-item unread"> <i class="ti-clip"></i> <span class="from"><a href="#">project1.jpg</a></span> by <strong>Sansa S.</strong> <a href="#" class="btn btn-danger btn-xs pull-right"><i class="ti-cloud-down"></i></a> </li>
                <li class="list-group-item"> <i class="ti-clip"></i> <span class="from"><a href="#">userlist.xls</a></span> by <strong>Jamie L.</strong> <a href="#" class="btn btn-danger btn-xs pull-right"><i class="ti-cloud-down"></i></a> </li>
                <li class="list-group-item unread"> <i class="ti-clip"></i> <span class="from"><a href="#">userphoto.jpg</a></span> by <strong>John S.</strong> <a href="#" class="btn btn-danger btn-xs pull-right"><i class="ti-cloud-down"></i></a> </li>
                <li class="list-group-item"> <i class="ti-clip"></i> <span class="from"><a href="#">item_codecanyon.rar</a></span> by <strong>Sansa S.</strong> <a href="#" class="btn btn-danger btn-xs pull-right"><i class="ti-cloud-down"></i></a> </li>
              </ul>
            </div>
            <!-- / MESSAGES WIDGET --> 
          </div>
          <!-- / Alerts --> 
        </div>
      </section>
    </div>
  </aside>
</div>
<!-- /animsition --> 
<!-- jQuery (necessary for Bootstrap's JavaScript plugins) --> 
<script src="src/js/raphael-min.js"></script> 
<script src="src/js/jquery-1.11.2.min.js"></script> 
<script src="src/js/jquery-ui.min.js"></script> 
<script src="src/bootstrap/js/bootstrap.min.js"></script> 
<!-- Include all compiled plugins (below), or include individual files as needed --> 
<script src="src/js/dropzone.js"></script> 
<script src="src/js/animsition/dist/js/jquery.animsition.min.js"></script> 
<script src="src/js/includes.js"></script> 
<script src="src/js/sugarrush.js"></script> 
<script src="src/js/sugarrush.uploads.js"></script>
</body>
</html>