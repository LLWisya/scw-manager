<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
${requestScope.user.loginacct }
<hr/>

<table border="1" cellpadding="5" cellspacing="0">
	<tr>
		<th>id</th>
		<th>loginacct</th>
		<th>userpswd</th>
		<th>username</th>
		<th>email</th>
		<th>createtime</th>
	</tr>
	<c:forEach items="${info.list }" var="user">
		<tr>
			<td>${user.id }</td>
			<td>${user.loginacct }</td>
			<td>${user.userpswd }</td>
			<td>${user.username }</td>
			<td>${user.email }</td>
			<td>${user.createtime }</td>
		</tr>
	</c:forEach>
	<tr>
		<td colspan="6">
			当前第 ${info.pageNum } 页;总计 ${info.pages } 页;总记录 ${info.total } 条;
			
			<a href="getAll?pn=1">首页</a>
				<c:if test="${info.hasPreviousPage }">
					<a href="getAll?pn=${info.prePage }">上一页</a>
				</c:if>
				
				<!-- 连续页码 -->
				<c:forEach items="${info.navigatepageNums }" var="num">
					<!-- 当前页显示为不能点击的 -->
					<c:if test="${info.pageNum == num }">
						[${num }]
					</c:if>
					<c:if test="${info.pageNum != num }">
						<a href="getAll?pn=${num }">${num }</a>
					</c:if>
					
				</c:forEach>
				
				
				<c:if test="${info.hasNextPage }">
					<a href="getAll?pn=${info.nextPage }">下一页</a>
				</c:if>
				   
			<a href="getAll?pn=${info.pages }">末页</a>
			
		</td>
	</tr>

</table>
</body>
</html>