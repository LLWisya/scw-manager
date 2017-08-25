<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>	
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

	<%
		pageContext.setAttribute("barinfo", "用户维护");
	%>

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
						<button id="deleteBtn" type="button" class="btn btn-danger"
							style="float: right; margin-left: 10px;">
							<i class=" glyphicon glyphicon-remove"></i> 删除
						</button>
						<button id="addUserBtn" type="button" class="btn btn-primary"
							style="float: right;">
							<i class="glyphicon glyphicon-plus"></i> 新增
						</button>
						<br>
						<hr style="clear: both;">
						<div class="table-responsive">
							<%-- 增加 showUserTable类，此table用于给显示用户信息--%>
							<table class="table  table-bordered showUserTable">
								<thead>
									<tr>
										<th width="30">编号</th>
										<th width="30"><input id="selectAllBox" type="checkbox"></th>
										<th>账号</th>
										<th>名称</th>
										<th>邮箱地址</th>
										<th width="100">操作</th>
									</tr>
								</thead>
								<tbody>

									<%-- Ajax获得用户数据 --%>

								</tbody>
								<tfoot>
									<tr>
										<td colspan="6" align="center">
											<%-- 类pagination索引分页条 --%>
											<ul class="pagination">
												<%-- 分页条，结合Ajax作动态绑定 --%>
											
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

	<%-- 模态框,用于添加用户和修改用户的信息输入 --%>
	<div class="modal fade" id="myUserModel">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	        	<span aria-hidden="true">&times;</span>
	        </button>
	        <h4 class="modal-title" id="myUserModelHeader">模态框标题</h4>
	      </div>
	      <div class="modal-body">
	      <!-- 模态框体使用表格装载信息 -->
	        <form id="userForm" action="${APP_PATH }/user/save" method="post">
				<div class="form-group">
					<label>登陆账号</label> 
					<input type="text" class="form-control" name="loginacct"
						id="loginacct_input" placeholder="输入账号">
				</div>
				<div class="form-group">
					<label>用户昵称</label> 
					<input type="text" class="form-control" name="username"
						id="username_input" placeholder="用户昵称">
				</div>
				<div class="form-group">
					<label>邮箱地址</label> 
					<input type="text" class="form-control" name="email"
						id="email_input" placeholder="test@atguigu.com">
				</div>
			</form>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
	        <button type="button" class="btn btn-primary" id="confirmBtn">确认</button>
	      </div>
	    </div><!-- /.modal-content -->
	  </div><!-- /.modal-dialog -->
	</div><!-- /.modal -->


<%-- ++++++++++++++++++++++++++++++++++++++js部分++++++++++++++++++++++++++++++++++++++++++++++++++  --%>		
	<script type="text/javascript">
		//定义js中的全局变量index
		var index;
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
		});
		$("tbody .btn-success").click(function() {
			window.location.href = "assignRole.html";
		});
		$("tbody .btn-primary").click(function() {
			window.location.href = "edit.html";
		});
		
<%-- ++++++++++++++++++++++++++++++++++++++当前侧边栏展开且红色++++++++++++++++++++++++++++++++++++++++++++++++++  --%>	

		//每个页面的效果改变
		$(function() {
			//按照当前页面的超链接
			//给当前超链接加红；
			$("a[href='${APP_PATH}/user/list.html']").css("color", "red");
			//将这个超链接对应的ul展开
			$("a[href='${APP_PATH}/user/list.html']").parents("ul:hidden")
					.show();
		});
		
<%-- +++++++++++++++++++++++++++++++++++++++++页面加载完成+++++++++++++++++++++++++++++++++++++++++++++++  --%>
		
		<%-- 页面加载完成后，自动发送Ajax请求获得用户列表 --%>
		$(function() {
			getUsers(1);
		});
		
		function getUsers(pageNo) {
			$.ajax({
				url:"${APP_PATH}/user/ajaxUserlist",	
				data:"pageNo="+pageNo,
				dataType:"json",
				<%-- 只有一个数据时，data就是和数据本事，这里data以json格式封装了数据 --%>
				success:function(data){
				<%-- 获得数据后，加载在对应的位置即可 --%>
				//构建数据
					buildData(data);
				}
			});
		}

<%-- +++++++++++++++++++++++++++++++++++++++++构建用户表单数据+++++++++++++++++++++++++++++++++++++++++++++++  --%>				
		
		//构建数据,分两步
        function buildData(data){
        	//1、显示整个tr；
        	buildTr(data);
        	//2、构建显示整个分页条
        	buildPage(data);
        }
        
		function buildTr(data) {
			<%-- 先清空页面 --%>
			$(".showUserTable tbody").empty();
			
			<%-- 数据中的每一条记录，都插入一条tr行 --%>
        	$.each(data.list,function(){
        		
        		//1、创建出整个tr
        		var tr =$("<tr></tr>");
        		var buttonTd = $("<td></td>");
        				 <%-- 检查按钮 --%>
        		buttonTd.append($("<button type='button' uid='"+this.id+"' username='"+this.username+"' class='btn btn-success btn-xs assignRole'><i class='glyphicon glyphicon-check'></i></button>"))
        				.append(" ")
        				  <%-- 编辑按钮 --%>
        				.append($('<button type="button" num="' + this.id + '" class="btn btn-primary btn-xs editUserBtn"><i class="glyphicon glyphicon-pencil"></i></button>'))
        				.append(" ")
        				  <%-- 删除按钮 --%>
        				  <%-- 此处存在bug,当username为空时会把id=this.id当作username被获取，再去获取id时则无法获取，导致程序出错--%>
        				.append($('<button type="button" username="'+this.username+'" uid="'+this.id+'" class="btn btn-danger btn-xs delUserBtn"><i class="glyphicon glyphicon-remove"></i></button>'));
        		
        		//2、tr里面的每一个td添加上
        		tr.append($("<td>"+this.id+"</td>")) 
        			.append("<td><input type='checkbox'></td>")
        			.append("<td>"+this.loginacct+"</td>")
        			.append("<td>"+this.username+"</td>")
        			.append("<td>"+this.email+"</td>")
        			.append(buttonTd);
        		
        		//将这个tr放到tbody中；
        		$(".showUserTable tbody").append(tr);
			});
		}
<%-- ++++++++++++++++++++++++++++++++++++++++++构建分页条++++++++++++++++++++++++++++++++++++++++++++++  --%>		
		//构建分页条
        function buildPage(data){
			<%-- ul列表项 --%>
        	var pageBar = $(".showUserTable .pagination");
        	
			<%-- 刷新 --%>
        	pageBar.empty();
        	
        	<%-- 上一页, prePage是PageInfo对象的内置属性 --%>
        	var prePage = $("<li num='"+data.prePage+"'><a>上一页</a></li>");
        	if(!data.hasPreviousPage){
        		//没有上一页
        		prePage.addClass("disabled");
        	}else{
        		prePage.removeClass();
        	}
        	pageBar.append(prePage);
        	
        	//连续分页 [1,2,3,4,5]
        	$.each(data.navigatepageNums,function(){
         		//遍历的这个数字是否就是当前页码
        		var li;
        		if(this == data.pageNum){
        			<%-- 为当前页面设置class样式--%>
        			li = $("<li num='"+this+"' class='active'><a>"+this+" <span class='sr-only'>(current)</span></a></li>");
        		}else{
        			<%-- 非当前页面没有样式，仅有一个数字--%>
        			li = $("<li num='"+this+"'><a>"+this+"</a></li>");
        		}
        		<%-- 为分页条ul列表项添加li元素--%>
        		pageBar.append(li);
        	});
        	
        	
        	//下一页
        	var nextPage = $("<li num='"+data.nextPage+"'><a>下一页</a></li>");
        	if(!data.hasNextPage){
        		//没有下一页
        		nextPage.addClass("disabled");
        	}else{
        		nextPage.removeClass();
        	}
        	pageBar.append(nextPage);
        };
        
        //为当前页面加载完成后存在数据绑事件；未来的元素绑不上；jquery1.7后不推荐使用live绑定未来事件，推荐使用on；
       $(".pagination").on("click","li",function(){
    	   <%-- 调用Ajax请求函数，获得对应页码的用户列表 --%>
    	   getUsers($(this).attr("num"));
       });
		
<%-- +++++++++++++++++++++++++++++++++++++++++新增用户+++++++++++++++++++++++++++++++++++++++++++++++  --%>
       
       <%-- 为新增按钮绑定事件，使用模态框添加信息 --%>
       $('#addUserBtn').click(function () {
    	   //为确定按钮添加自定义属性edit，true表示这是修改用户，false表示这是添加用户
		   $("#confirmBtn").attr("edit",false);
    	   $("#myUserModelHeader").text("添加用户");
    	   <%-- 帐号可以输入 --%>
    	   $("#loginacct_input").prop("disabled", false);
    	   //重置表单数据
		   $("#userForm")[0].reset();
    	   $('#myUserModel').modal({
				backdrop : 'static',
				show : true
			});
    	});
   
<%-- ++++++++++++++++++++++++++++++++++++++修改用户++++++++++++++++++++++++++++++++++++++++++++++++++  --%>       
       
       <%-- 为修改用户按钮绑定事件，使用模态框添加信息 --%>
       $("body").on("click","button.editUserBtn", function() {
    	   
   		   <%--加一个用户id的自定义属性,用于查询user,作数据回显--%>
    	   var uid = $(this).attr("num");
    	   <%--把id加入到确定按钮属性中 --%>
    	   $("#confirmBtn").attr("uid", uid);
    	   
    	   
    	   <%--为确定按钮添加自定义属性edit，true表示这是修改用户，false表示这是添加用户--%>
   	  	   $("#confirmBtn").attr("edit",true);
   	  	   $("#myUserModelHeader").text("修改用户");
   	  	   
   	  	   <%-- 帐号不能修改 --%>
   	  	   $("#loginacct_input").prop("disabled", true);
   	  	   
   	  	  <%--发送Ajax请求，获得用户数据，数据回显--%>
		   $.get("${APP_PATH}/user/getUser", {uid:uid}).done(function(data) {
			    $("#loginacct_input").val(data.loginacct);
			    $("#username_input").val(data.username);
				$("#email_input").val(data.email);
			});
		   
		  //与新增用户使用同一个模态框
   	  	   $('#myUserModel').modal({
			 backdrop : 'static',
		  	 show : true
		   });
	   });
   
 <%-- +++++++++++++++++++++++++++++++++++++模态框确认提交+++++++++++++++++++++++++++++++++++++++++++++++++++  --%>
       
    	<%-- 为添加用户的确认按钮绑定使  --%>
		$("#confirmBtn").click(function() {
			
			var edit = $("#confirmBtn").attr("edit");
			
			<%--edit == "false"标识是添加新用户 --%>
			if (edit == "false") {
			
				$.post("${APP_PATH}/user/save", $("#userForm").serialize()).done(function(data){
					
					<%-- 如果是添加成功 --%>
					if (data.success == "true") {
						
						<%-- 为事件添加索引index --%>
						index = layer.confirm(data.msg + ", 是否继续添加用户？", {
							<%-- 两个按钮选项，以下对应两个function --%>
							btn:['是', '算了']
						}, function() {
							$("#userForm")[0].reset();
							<%-- 关闭该索引层,即关闭layer.confirm这个弹窗 --%>
		 					layer.close(index);
						}, function() {
							<%-- 关闭模态框,刷新页面到最后一页 --%>
							$("#myUserModel").modal("hide");
							getUsers(99999);
						});
					<%-- 如果是添加失败 ,提示失败信息--%>
					} else {
						layer.msg(data.msg);
					}
					<%-- 请求失败的回调函数--%>
				}).fail(function(e) {
					layer.msg(e);
				});
		<%--edit != "false"标识是修改用户 --%>		
			} else {
				
				var data = $("#userForm").serialize()+"&id="+$(this).attr("uid");
				
				$.post("${APP_PATH}/user/update", data).done(function(data){
					
					$("#myUserModel").modal("hide");
					layer.msg(data.msg);
					
					<%-- 刷新页面--%>
					var pageNo = $(".pagination li.active").attr("num");
					getUsers(pageNo);
				});
			};
			
		});
		
<%-- +++++++++++++++++++++++++++++++++++++删除用户按钮+++++++++++++++++++++++++++++++++++++++++++++++++++  --%>      
		 $("body").on("click","button.delUserBtn", function() {
			var name = $(this).attr("username");
			var id = $(this).attr("uid");
			
			 layer.confirm("确定要删除用户【" + name + "】吗？", {
				 btn:['赶紧删除', '朕按错了']
			 }, function() {
				$.get("${APP_PATH}/user/deleteUser", {id:id}).done(function(data) {
					
					layer.msg(data.msg + ", 删除：" + name, {icon: 1});
					
					<%-- 刷新页面--%>
					var pageNo = $(".pagination li.active").attr("num");
					getUsers(pageNo);
				});
			 }, function() {
				 <%-- 取消，什么也不做--%>
			});
			 
			 
		 });
	
<%-- +++++++++++++++++++++++++++++++++++++批量删除用户操作+++++++++++++++++++++++++++++++++++++++++++++++++++  --%>   	

		<%-- 监听复选框的选择状态，当已选项等于可选项时，自动把全选项勾上 --%>
		$("tbody").on("click", ":checkbox", function() {
		  	<%-- 已选择项 --%>
		   var selectedBoxes = $("tbody :checkbox:checked");
		  	<%-- 可选择项 --%>
		   var selectBoxes = $("tbody :checkbox");
		  	<%-- 全选项 --%>
	       var selectAllBox = $("#selectAllBox");
		       
	       $("#selectAllBox").prop("checked", selectedBoxes.length == selectBoxes.length);
		});
		
		<%-- 为全选复选框绑定事件 --%>
		$("#selectAllBox").click(function() {
			var isSelected = $(this).prop("checked");
		    $("tbody :checkbox").each(function() {
		    	$(this).prop("checked", isSelected);
		    });
		});
		
		<%-- 为批量删除按钮绑定事件 --%>
       $("#deleteBtn").click(function() {
			var checkBoxes = $("tbody :checkbox:checked");
    	    var ids = "";
    	    var names = "";
    	    
    	    <%-- 获取需要删除的id--%>
    	    $.each(checkBoxes, function() {
				ids += $(this).parent("td").prev("td").text() + ",";
				names += $(this).parent("td").next("td").text() + ",";
			});
    	    
    	   
    	  layer.confirm("确定要删除用户【" + names + "】吗？", {
    		  btn:['赶紧删除', '朕再想想']
    	  }, function() {
			 $.get("${APP_PATH}/user/deleteUsers", {ids:ids}).done(function(data) {
				layer.msg(data.msg+"<br/>删除的用户有:"+names);
				
				<%-- 刷新页面--%>
				var pageNo = $(".pagination li.active").attr("num");
				getUsers(pageNo);
			});
		  }, function() {
			  <%-- 取消，是也不做--%>
		  }); 
    	   
	   });
       
<%-- +++++++++++++++++++++++++++++++++++++用户角色管理+++++++++++++++++++++++++++++++++++++++++++++++++++  --%>    

		<%-- 定向到角色维护页面 --%>
		$("body").on("click", "button.assignRole",function(){
		
		   var uid = $(this).attr("uid");	
		   var username = $(this).attr("username");	
		   
		   <%-- get请求参数中的中文需要解决编码问题 --%>
		   location.href="${APP_PATH}/user/roles.html?uid="+uid+"&username="+username;
		   
	   });
		
	</script>
</body>
</html>
