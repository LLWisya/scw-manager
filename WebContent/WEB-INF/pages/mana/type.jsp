<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
		cursor:pointer;
	}
	table tbody tr:nth-child(odd){background:#F4F4F4;}
	table tbody td:nth-child(even){color:#C00;}
    
    input[type=checkbox] {
        width:18px;
        height:18px;        
    }
	</style>
  </head>

  <body>

	<%
		pageContext.setAttribute("barinfo", "分类管理");
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
				<h3 class="panel-title"><i class="glyphicon glyphicon-th"></i> 数据矩阵</h3>
			  </div>
			  <div class="panel-body">
          <div class="table-responsive">
            <table class="table  table-bordered">
              <thead>
                <tr >
                  <th>名称</th>
                  <%-- 查询出所有客户类型 --%>
                  <c:forEach items="${allTypes }" var="type">
	                  <th >${type.name}</th>
                  </c:forEach>
                </tr>
              </thead>
              <tbody>
               <%-- 每个证件类型占一行 --%>
              <c:forEach items="${allCerts }" var="cert">
                <tr>
                  <td>${cert.name }</td>
                	<c:forEach items="${allTypes }" var="type">
                		<%-- 每行中，一个客户类型列需要一个复选框，复选框携带cid、tid数据 --%>
	                  <td><input cid="${cert.id }" tid="${type.id }" type="checkbox" class="type_cert_checkbox"></td>
                 	</c:forEach>
                </tr>
              </c:forEach>
              </tbody>
            </table>
            
          </div>
			  </div>
			</div>
        </div>
      </div>
    </div>
    
<%-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++js部分+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>
    
        <script type="text/javascript">
            $(function () {
        
            	<%-- 页面加载完成后自动刷新复选框状态 --%>
				$.get("${APP_PATH}/mana/typeJson").done(function(data) {
					<%-- 为每个符合cid与tid的复选框选中 --%>
					$.each(data, function() {
						$(".type_cert_checkbox[cid='"+this.certid+"'][tid='"+this.accttype+"']").prop("checked",true);
					});
				});
				
            	
			    $(".list-group-item").click(function(){
				    if ( $(this).find("ul") ) {
						$(this).toggleClass("tree-closed");
						if ( $(this).hasClass("tree-closed") ) {
							$("ul", this).hide("fast");
						} else {
							$("ul", this).show("fast");
						}
					}
				});
<%-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++复选框单击+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>
	
				
				<%-- 复选框绑定单击事件 --%>	
				$(".type_cert_checkbox").click(function() {
					
					var cid = $(this).attr("cid");
					var tid = $(this).attr("tid");
					var isAdd = $(this).prop("checked");
					
					$.get("${APP_PATH}/mana/updateType", {tid:tid, cid:cid, isAdd:isAdd}).done(function(data) {
						layer.msg(data.msg);
					});
					
				});

            });
        </script>
  </body>
</html>
