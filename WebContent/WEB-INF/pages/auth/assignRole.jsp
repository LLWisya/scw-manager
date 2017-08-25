<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
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
				<ol class="breadcrumb">
				  <li class="active" style="font-size: 28px;">分配角色-${param.username}</li>
				</ol>
		<div class="panel panel-default">
			<div class="panel-body">
				<form role="form" class="form-inline">
					<div class="form-group">
						<label for="exampleInputPassword1">未分配角色列表</label><br> 
						<select id="allRolesSelect"
							class="form-control" multiple size="13" style="width: 200px; overflow-y: auto;">
							<c:forEach items="${allRoles}" var="role">
								<option  id="${role.id }" value="${role.name }">${role.name }</option>
							</c:forEach>
						</select>
					</div>
					<div class="form-group">
						<ul>
							<li class="btn btn-default glyphicon glyphicon-chevron-right"></li>
							<br/>
							<li class="btn btn-default glyphicon glyphicon-chevron-left" style="margin-top: 20px;"></li>
						</ul>
					</div>
					<div class="form-group" style="margin-left: 50px;">
						<label for="exampleInputPassword1">已分配角色列表</label><br> 
						<select id="hasRolesSelect"
							class="form-control" multiple size="13" style="width: 200px; overflow-y: auto;">
							<c:forEach items="${hasRoles}" var="role">
								<option id="${role.id }" value="${role.name }">${role.name }</option>
							</c:forEach>
						</select>
					</div>
					<br/>&nbsp;
					<hr/>
					<div class="form-group">
						<button type="button" class="btn btn-primary" id="userListBtn">返回用户页面</button>
					</div>
				</form>
			</div>
		</div>
	</div>



	<script type="text/javascript">
	
		
		$(function() {
			
			<%-- 把所有角色列表中，去除已拥有角色 (左表-右表，去重)--%>
			$("#hasRolesSelect option").each(function(){
				$("#allRolesSelect option[value='"+$(this).val()+"']").remove();
			});
			
			
			<%-- 为右移动按钮绑定事件,即添加角色--%>
			$(".glyphicon-chevron-right").click(function(){
				
				<%-- 从上一个请求中带了用户uid参数--%>					
				var uid = ${param.uid};					
				var toAdd = $("#allRolesSelect :selected");
				var ids = "";
				
				<%-- 除了移动选项，还必须获得该选择的id，用于同步数据库操作 --%>
				toAdd.each(function() {
					ids += $(this).attr("id") + ",";
				});
				
				$.get("${APP_PATH}/user/addRoles", {uid:uid, ids:ids}).done(function() {
					layer.msg("操作成功");
				});
				<%-- 请求完成后，刷新页面效果 --%>
				toAdd.appendTo($("#hasRolesSelect"));
				
			});
			
			
			<%-- 为左移动按钮绑定事件,即删除角色--%>
			$(".glyphicon-chevron-left").click(function(){
			
				<%-- 从上一个请求中带了用户uid参数--%>					
				var uid = ${param.uid};					
				var toAdd = $("#hasRolesSelect :selected");
				var ids = "";
				
				<%-- 除了移动选项，还必须获得该选择的id，用于同步数据库操作 --%>
				toAdd.each(function() {
					ids += $(this).attr("id") + ",";
				});
				
				$.get("${APP_PATH}/user/deleteRoles", {uid:uid, ids:ids}).done(function() {
					layer.msg("操作成功");
				});
				<%-- 请求完成后，刷新页面效果 --%>
				toAdd.appendTo($("#allRolesSelect"));
			
			});
			
			
			$("#userListBtn").click(function() {
				location.href="${APP_PATH}/user/list.html";
			});
			
		});
	
	
	
	
	
	</script>
</body>
</html>
