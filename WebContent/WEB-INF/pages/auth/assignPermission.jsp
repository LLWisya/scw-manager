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
</style>
</head>

<body>


	<div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">

		<div class="panel panel-default">
			<div class="panel-heading">
				<i class="glyphicon glyphicon-th-list"></i> 权限分配列表  -- ${param.rolename }
				<div style="float: right; cursor: pointer;" data-toggle="modal"
					data-target="#myModal">
					<i class="glyphicon glyphicon-question-sign"></i>
				</div>
			</div>
			<div class="panel-body">
				<ul id="myPermissionTree" class="ztree"></ul>
			</div>
			
			<button type="button" class="btn btn-default" data-dismiss="modal" id="returnBtn">返回列表</button>
			<button type="button" rid=${param.rid } class="btn btn-primary" id="permissionAssignBtn">分配权限</button>
			
		</div>
	</div>
	
	
	<script type="text/javascript">
			
		
	
		$(function() {
			
<%-- ++++++++++++++++++++++++++++++++++++++++++初始化管理树+++++++++++++++++++++++++++++++++++++++++++++++ --%>		

		var ztreeObject;	
			
			<%-- 页面加载完成后发送Ajax请求获得权限树 --%>
			<%-- 权限管理的请求应发送至PermissionController --%>
			$.get("${APP_PATH}/role/ajaxPermission", function(data) {
				
				<%--简单json的ztree--%>
				var setting = {
						data : {
							simpleData : {
								enable : true,
								idKey: "id",
								pIdKey: "pid"
							},
							key: {
								url: "xUrl"     //此设置使得节点的超链接失效，不能实现跳转功能.
							}
						},
						check:{					//复选框
							enable: true
						},
						view: { 		//自定义显示风格
							addDiyDom: showIcon 		//调用函数
						}
					};
				
				
// 				{ name:"叶子节点", icon:"/img/leaf.gif"}  自定义图标语法
				
				<%--zNodes数据从服务器查询，且封装好对应的格式 --%>
				var zNodes = data;
				
				<%--zNodes数据处理，对于父级菜单，使用默认展开样式--%>
				$.each(zNodes,function(){
					if(this.pid==0)
						this.open = true;
				});
				
				<%--权限树的声明格式,三个参数，id, setting,和 zNodes --%>
				<%--注意顺序，这个初始化应该在各个参数之后 --%>
				ztreeObject = $.fn.zTree.init($("#myPermissionTree"), setting, zNodes);
				
				<%--ajax为异步请求，需要判断权限树加载完成后，再发送请求获得该角色所拥有的权限，实现已有权限自动勾选 --%>
				var rid = $("#permissionAssignBtn").attr("rid");
				refresh(rid);	
				
			});
			
			//每一个节点显示都会调用这个方法；
			//treeId：当前树的id	--内置参数
			//treeNode：当前的这个节点			--内置参数
			function showIcon(treeId, treeNode){
				var tid = treeNode.tId;
				//根据tid找到图标的span即可
				$("#"+tid+"_ico").attr("style","");
				$("#"+tid+"_ico").removeClass().addClass(treeNode.icon);
			}
			
			<%-- 此函数用于权限树加载完成后，发送Ajax请求获得该用户所拥有的权限，实现自动勾选 --%>
			function refresh(rid) {
				$.get("${APP_PATH}/role/ajaxRolePms?rid="+rid, function(data) {
					<%-- 遍历回传的数据data,若出现pmsId,则找到权限树中对应的权限id节点，给该节点勾选 --%>
					$.each(data, function() {
						var pmsId = this.id;	//获得Permission的id
						var node = ztreeObject.getNodeByParam("id", pmsId, null);	//根据Permission的id获得对应节点
						ztreeObject.checkNode(node, true, false, false); //该节点勾选上
					});
				});
			};
			
			
<%-- ++++++++++++++++++++++++++++++++++++++++++分配权限+++++++++++++++++++++++++++++++++++++++++++++++ --%>		

			<%--确认按钮绑 --%>
			$("#permissionAssignBtn").click(function() {
				
				var rid = $(this).attr("rid");
				var nodes = ztreeObject.getCheckedNodes(true);	//获得全部被选中的节点
				
				<%-- 不建议使用getChangeCheckedNodes()获得被改变状态的节点，在获得被取消选中节点时非常不智能，
				建议采用getCheckedNodes(true)获得所有被选中节点，在操作数据库时先删除所有权限记录，再添加被选中的权限
				操作麻烦，但是可靠好用 --%>
				
				var addNodes = "";
				$.each(nodes, function() {
					addNodes += this.id + ",";
				});
				
				$.get("${APP_PATH}/role/updateRolePms", {rid:rid, addNodes:addNodes}).done(function(data) {
					layer.msg(data.msg);
				}).fail(function() {
					layer.msg("操作失败，请检查网络或联系管理员");
				});
				
			});

<%-- ++++++ +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>		
			
			<%-- 返回按钮 --%>	
			$("#returnBtn").click(function() {
				location.href="${APP_PATH}/role/list.html";
			});


		});
	</script>
</body>
</html>
