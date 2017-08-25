<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core"%>    
<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="keys" content="">
    <meta name="author" content="">
    
	<!-- 此处引入通用css样式 -->
	<%@include file="/WEB-INF/includes/common-css.jsp" %>
	
	<%--引入脚本支持 --%>
	<%@include file="/WEB-INF/includes/common-js.jsp" %>
	
	<link rel="stylesheet" href="${APP_PATH}/css/login.css">
	
  </head>
  <body>
    <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
      <div class="container">
        <div class="navbar-header">
          <div><a class="navbar-brand" href="${APP_PATH}/index.jsp" style="font-size:32px;">尚筹网-创意产品众筹平台</a></div>
        </div>
      </div>
    </nav>

    <div class="container">

      <form class="form-signin" role="form" action="${APP_PATH}/login"  method="post">
        <h2 class="form-signin-heading"><i class="glyphicon glyphicon-log-in"></i> 用户登录</h2>
        
		  <%--封装TUser对象，name属性只能使用TUser的对应属性名 --%>
		  <div class="form-group has-success has-feedback">
			<input type="text" class="form-control" id="loginacct" name="loginacct" value="${user.loginacct}"
						placeholder="请输入登录账号" autofocus>
			<span class="glyphicon glyphicon-user form-control-feedback"></span>
		  </div>
		  
		  <%--封装TUser对象，name属性只能使用TUser的对应属性名 --%>
		  <div class="form-group has-success has-feedback">
			<input type="text" class="form-control" id="userpswd" name="userpswd" 
						 placeholder="请输入登录密码" style="margin-top:10px;">
			<span class="glyphicon glyphicon-lock form-control-feedback"></span>
		  </div>
		  <div class="form-group has-success has-feedback">
			<select class="form-control" >
                <option>管理</option>
            </select>
		  </div>
        <div class="checkbox">
          <label>
            <input type="checkbox" value="remember-me"> 记住我
          </label>
          <br>
          <label>
            忘记密码
          </label>
          <label style="float:right">
            <a href="${APP_PATH}/reg.jsp">我要注册</a>
          </label>
        </div>
        <a id="login_btn" class="btn btn-lg btn-success btn-block" > 登录</a>
      </form>
    </div>
    <script>
    
    <%-- 登录事件 --%>
    $("#login_btn").click(function(){
		
    	var role = $("select.form-control").val();
    	
			$("form.form-signin").submit();
    	
    	return false;
	});
    
    
    
    
    /*
    function dologin() {
        var type = $(":selected").val();
        if ( type == "user" ) {
        		alert("登录成功");	
//             window.location.href = "${APP_PATH}/main.jsp";
        } else {
        		alert("登录失败");	
//             window.location.href = "${APP_PATH}/index.jsp";
        }
    }*/
    
    
    </script>
  </body>
</html>