<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

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

	<h1>最简单的树 -- 简单 JSON 数据</h1>
	<div class="content_wrap">
		<div class="zTreeDemoBackground left">
			<ul id="treeDemo" class="ztree"></ul>
		</div>
	</div>

	<script type="text/javascript">
		$(function() {

			var setting = {
				data : {
					simpleData : {
						enable : true,
						idKey: "id",
						pIdKey: "pid"
					}
				}
			};
			$.get("${APP_PATH}/demo/ztreeHello", function(data) {
				
				var zNodes = data;
				
				console.log(zNodes);
				
				$.fn.zTree.init($("#treeDemo"), setting, zNodes);
			});

		});
	</script>

</body>
</html>