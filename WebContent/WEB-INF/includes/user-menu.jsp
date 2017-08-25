<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<div class="col-sm-3 col-md-2 sidebar">
	<div class="tree">
		<ul style="padding-left: 0px;" class="list-group">
			<li class="list-group-item tree-closed"><a href="/main.html"><i
					class="glyphicon glyphicon-dashboard"></i> 控制面板</a> 
				<%--遍历获得菜单项 --%>
				 <c:forEach items="${userMenu }" var="menu">
					
					<li class="list-group-item tree-closed"><span><i
							class="${menu.icon }"></i>${menu.name} <span class="badge"
							style="float: right">${fn:length(menu.childs) }</span></span>

						<ul style="margin-top: 10px; display: none;">
							<%-- 遍历子菜单 --%>
							<c:forEach items="${menu.childs }" var="cMenu">
								<li style="height: 30px;">
									<%--图标，URL都从数据库中获得 --%>
									 <a href="${APP_PATH}/${cMenu.url}">
										<i class="${cMenu.icon }"></i> ${cMenu.name }
								 	</a>
								</li>
							</c:forEach>
						</ul>
					</li>
				</c:forEach>
			<li class="list-group-item tree-closed"><a href="/param.html"><i
					class="glyphicon glyphicon-list-alt"></i> 参数管理</a></li>
		</ul>
	</div>
</div>