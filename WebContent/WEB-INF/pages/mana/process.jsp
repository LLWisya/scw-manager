<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<% 
	pageContext.setAttribute("barinfo", "流程管理");
%>
<!DOCTYPE html>
<html lang="UTF-8">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author" content="">

<%-- 此处引入通用css样式 --%>
<%@include file="/WEB-INF/includes/common-css.jsp"%>

<%--引入脚本支持 --%>
<%@include file="/WEB-INF/includes/common-js.jsp"%>
<link rel="stylesheet" href="${APP_PATH}/css/main.css">
<style>
.tree li {
	list-style-type: none;
	cursor: pointer;
}

table tbody tr:nth-child(odd) {
	background: #F4F4F4;
}

table tbody td:nth-child(even) {
	color: #C00;
}
</style>
</head>

<body>

	<%--引入后台导航条 --%>
	<%@include file="/WEB-INF/includes/manager-nav-bar.jsp"%>

	<div class="container-fluid">
		<div class="row">
			<%--引入用户菜单栏 --%>
			<%@include file="/WEB-INF/includes/user-menu.jsp"%>

			<div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
				<div class="panel panel-default">
					<div class="panel-heading">
						<h3 class="panel-title">
							<i class="glyphicon glyphicon-th"></i> 数据列表
						</h3>
					</div>
					<div class="panel-body">
						<form class="form-inline" role="form" style="float: left;">
							<div class="form-group has-feedback">
								<div class="input-group">
									<div class="input-group-addon">查询条件</div>
									<input class="form-control has-success" type="text"
										placeholder="请输入查询条件">
								</div>
							</div>
							<button type="button" class="btn btn-warning">
								<i class="glyphicon glyphicon-search"></i> 查询
							</button>
						</form>

						<button id="uploadBtn" type="button" class="btn btn-primary"
							style="float: right;">
							<i class="glyphicon glyphicon-upload"></i> 上传流程定义文件
						</button>
						<br>
						<hr style="clear: both;">
						<div class="table-responsive">
							<table class="table  table-bordered">
								<thead>
									<tr>
										<th width="30">#</th>
										<th>流程名称</th>
										<th>流程版本</th>
										<th>流程分类</th>
										<th>流程key</th>
										<th width="100">操作</th>
									</tr>
								</thead>
								<tbody id="dataTbody">
									<%-- 数据列使用动态生成
									<tr>
										<td>1</td>
										<td>实名认证审批流程</td>
										<td>2</td>
										<td>人工审核</td>
										<td>张三</td>
										<td>
											<button type="button" class="btn btn-success btn-xs">
												<i class=" glyphicon glyphicon-eye-open"></i>
											</button>
											<button type="button" class="btn btn-danger btn-xs">
												<i class=" glyphicon glyphicon-remove"></i>
											</button>
										</td>
									</tr>
									--%>
								</tbody>
								<tfoot>
									<tr>
										<td colspan="6" align="center">
											<ul class="pagination" id="pageBarLi">
									<%-- 分页数据使用动态生成
												<li class="disabled"><a href="${APP_PATH}/#">上一页</a></li>
												<li class="active"><a href="${APP_PATH}/#">1 <span
														class="sr-only">(current)</span></a></li>
												<li><a href="${APP_PATH}/#">2</a></li>
												<li><a href="${APP_PATH}/#">下一页</a></li>
									--%>
											</ul>
										</td>
									</tr>
								</tfoot>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
<%-- ++++++++++++++++++++++++++++++++++++++++++++++模态框用于上传流程文件++++++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>
	<div class="modal fade" id="activitiModal" tabindex="-1" role="dialog">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title" id="activitiModalLabel">上传流程文件</h4>
				</div>
				<div class="modal-body">
					<form id="uploadForm" enctype="multipart/form-data">
						<div class="form-group">
							<label>选择流程文件</label> <input type="file" class="form-control"
								id="activitiFile" name="activitiFile" placeholder="Email">
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button id="submitForm" type="button" class="btn btn-primary">上传</button>
				</div>
			</div>
		</div>
	</div>
	
	
<%-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>

	<script src="${APP_PATH }/script/docs.min.js"></script>
	<script type="text/javascript">
		$(function() {
			$(".list-group-item").click(function() {
				if ($(this).find("ul")) {
					$(this).toggleClass("tree-closed");
					if ($(this).hasClass("tree-closed")) {
						$("ul", this).hide("fast");
					} else {
						$("ul", this).show("fast");
					}
				}
			});
			
			<%-- 点击页面的上传，触发模态框 --%>
			$("#uploadBtn").click(function() {
				$("#activitiModal").modal({
					backdrop : 'static',
					show : true
				});
			});
			
<%-- +++++++++++++++++++++++++++++++++++++++++++++++++上传流程文件++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>	

			<%-- 点击模态框的上传，发送Ajax请求将文件上传至服务器 --%>
			$("#submitForm").click(function() {
				
				<%-- 1.使用正则表达式验证文件的有效性 --%>
				var $regExp = / *bpmn$/;
				var fileInfo = $("#activitiFile")[0].files[0];   //input上传域可以上传多个文件，使用list保存
				
				if (jQuery.isEmptyObject(fileInfo)) {
					layer.msg("请选择文件");
					return false;
				};
				
				var fileName = fileInfo.name;
				if (!$regExp.test(fileName)) {
					layer.msg("请上传后缀名为.bpmn的文件！");
					return false;
				};
				
				<%-- 2.使用FormData封装表单项,添加额外的属性 --%>
				
				var fd = new FormData();			
				fd.append("username", "高渐离");			<%--使用append方法给表单项添加k=v属性 --%> 
				fd.append("processFile", $("#activitiFile")[0].files[0]);	<%--可以添加普通项和文件项 --%> 
				
				$.ajax({
					url:"${APP_PATH}/mana/uploadFile",
					data:fd,		  
					type:"POST",     <%--文件上传必须使用post --%> 
					processData:false,  <%--数据不处理成k=v&k=v模式    --%>
					contentType:false,	<%--多部件表单，类型非原来的application/x-www-form-urlencoded  --%>
					success:function(data) {
						layer.msg(data.msg);
						$("#activitiModal").modal("hide");
						listProcesses(1);
					},
					error:function(){
						layer.msg("网络异常");
					}
				});
				
			});
			
<%-- +++++++++++++++++++++++++++++++++++++++++++++++Ajax请求获得流程部署数据回显+++++++++++++++++++++++++++++++++++++++++++++++++++ --%>				
			
			<%--页面加载完成即调用方法显示出流程信息列表和分页条 --%>
			listProcesses(1);
			
			<%--传入显示页码，分页显示 --%>
			function listProcesses(pageNo) {
				
				$.get("${APP_PATH}/mana/listProcess", {pageNo:pageNo}).done(function(data) {
					buildData(data);
					buildPageBar(data);
				}).fail(function(data) {
					layer.msg("网络异常");
				});
			};
			
			<%--构建数据列 --%>
			function buildData(data) {
				var tbody = $("#dataTbody");		//获得显示数据的表格
					tbody.empty();					//清空数据
				var pds = data.ext.pdInfoList;
				
				$.each(pds, function() {
					var tr = $("<tr></tr>");
					var btn = $("<td></td>")		//构建预览按钮和删除按钮
								.append('<button type="button" class="btn btn-success btn-xs previewBtn"><i class=" glyphicon glyphicon-eye-open"></i></button>')
								.append(" ")
								.append('<button type="button" class="btn btn-danger btn-xs removeBtn" depId="'+this.depId+'"><i class=" glyphicon glyphicon-remove"></i></button>');
					
					tr.append("<td>"+this.id+"</td>")
					  .append("<td>"+this.name+"</td>")
					  .append("<td>"+this.version+"</td>")
					  .append("<td>"+this.category+"</td>")
					  .append("<td>"+this.key+"</td>")
					  .append(btn);
					
					tbody.append(tr);
				});
			};
			
			<%--构建分页条 --%>
			function buildPageBar(data) {
				var pageBarLi = $("#pageBarLi");  //拿到分页条的ul对象
				
				var preLi, nextLi, pagesLi, firstLi, lastLi;			//为该ui对象添加li对象作为分页链接
				var to_href = "${APP_PATH}/mana/listProcess?page=";	//分页条上的超链接
				
				<%--拿到分页条对象 --%>
				var pageBar = data.ext.pageBar;
				
				<%-- 构建前一页的li --%>
				if (pageBar.hasPreviousPage) {		 
					preLi = $('<li num="'+pageBar.prePage+'"><a href="'+ to_href + pageBar.prePage +'">上一页</a></li>');
				} else {
					preLi = $('<li class="disabled" num="'+-1+'"><a>上一页</a></li>');
				}
				
				<%-- 构建后一页的li --%>
				if (pageBar.hasNextPage) {		
					nextLi = $('<li num="'+pageBar.nextPage+'"><a href="'+ to_href + pageBar.nextPage +'">下一页</a></li>');
				} else {
					nextLi = $('<li class="disabled" num="'+-1+'"><a>下一页</a></li>');
				}
				
				<%-- 构建首页与末页 --%>
				firstLi = $('<li num="'+1+'"><a href="'+ to_href + 1 +'">首页</a></li>');
				lastLi = $('<li num="'+pageBar.pages+'"><a href="'+ to_href + pageBar.pages +'">尾页</a></li>');
				
				<%-- 构建分页条的导航条 --%>
				pagesLi = '';
				$.each(pageBar.navigatepageNums, function() {
					var tLi;
					if (pageBar.pageNum == this) {
						<%-- 注意pagesLi为原生的dom对象，非jQuery对象,所以直接使用字符串 --%>
						tLi = '<li class="active" num="'+this+'" id="currPage"><a href="'+ to_href + this +'">'+this+'</a></li>';
					} else {
						tLi = '<li num="'+this+'"><a href="'+ to_href + this +'">'+this+'</a></li>';
					}
					pagesLi += tLi;
				});
				
				pageBarLi.empty()
						 .append(firstLi)
						 .append(preLi)
						 .append(pagesLi)
						 .append(nextLi)
						 .append(lastLi);
				
			};
			
<%-- +++++++++++++++++++++++++++++++++++++++++++分页条各页绑定单击事件++++++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>	
		
			$("body").on("click", "#pageBarLi li", function() {
				var num = $(this).attr("num");
				var currNum = $("#currPage").attr("num");
				<%-- num==-1时为不可点击状态，当前页等于跳转目标页时不发送请求 --%>
				if (num == -1 || currNum == num) {
					return false;
				}
				listProcesses(num);
				return false;
			});

<%-- +++++++++++++++++++++++++++++++++++++++++++移除流程项按钮++++++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>	

			$("body").on("click", ".removeBtn", function() {
				$.get("${APP_PATH}/mana/delProcess", {depId:$(this).attr("depId")}).done(function(data) {
					layer.msg(data.msg);
					<%-- 删除成功则刷新页面 --%>
					listProcesses($("#currPage").attr("num"));
				}).fail(function() {
					layer.msg("网络异常,移除失败.");
				});
			});
			
<%-- +++++++++++++++++++++++++++++++++++++++++++预览流程图按钮++++++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>			
			$("body").on("click", ".previewBtn", function() {
				
			});	
			
<%-- +++++++++++++++++++++++++++++++++++++++++++预览流程图结束++++++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>			
			
		});
	</script>
</body>
</html>
