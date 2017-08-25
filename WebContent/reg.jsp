<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
	
  <head>
    <meta charset="GB18030">
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
          <div><a class="navbar-brand" href="${APP_PATH}/index.html" style="font-size:32px;">尚筹网-创意产品众筹平台</a></div>
        </div>
      </div>
    </nav>

    <div class="container">

      <form id="reg_form" class="form-signin" role="form" action="${APP_PATH}/regist" method="post">
        <h2 class="form-signin-heading"><i class="glyphicon glyphicon-log-in"></i> 用户注册</h2>
        
		  <div class="form-group has-success has-feedback">
			<input type="text" class="form-control" id="loginacct" name="loginacct" value="${TUser.loginacct}"
				placeholder="请输入登录账号" autofocus>
			<span class="error_msg" style="color: red;"></span>	
			<span class="glyphicon glyphicon-user form-control-feedback"></span>
		  </div>
		  
		  <div class="form-group has-success has-feedback">
			<input type="text" class="form-control" id="userpswd" name="userpswd"
				placeholder="请输入登录密码" style="margin-top:10px;">
			<span class="error_msg" style="color: red;"></span>	
			<span class="glyphicon glyphicon-lock form-control-feedback"></span>
		  </div>
		  
		  <div class="form-group has-success has-feedback">
			<input type="text" class="form-control" id="rep_pswd" name="rep_pswd"
				placeholder="请再次输入密码" style="margin-top:10px;">
			<span class="error_msg" style="color: red;"></span>	
			<span class="glyphicon glyphicon-lock form-control-feedback"></span>
		  </div>
		  
		  <div class="form-group has-success has-feedback">
			<input type="text" class="form-control" id="email" name="email"
				placeholder="请输入邮箱地址" style="margin-top:10px;">
			<span class="error_msg" style="color: red;"></span>	
			<span class="glyphicon glyphicon glyphicon-envelope form-control-feedback"></span>
		  </div>
		  
		  <div class="form-group has-success has-feedback">
			<select class="form-control" >
                <option>会员</option>
                <option>管理</option>
            </select>
		  </div>
        <div class="checkbox">
          <label>
            忘记密码
          </label>
          <label style="float:right">
            <a href="${APP_PATH}/login.html">我有账号</a>
          </label>
        </div>
        <a id="reg_btn" class="btn btn-lg btn-success btn-block" href="${APP_PATH}/member.html" > 注册</a>
      </form>
    </div>
   
  </body>
      
  <script type="text/javascript">
  
	  	$.validator.setDefaults({
 		 <%-- 发生错误信息时触发函数 --%>
 			showErrors:function(map, list){
				
	  			<%-- 清空所有错误信息 --%>
				$("span.error_msg").text("");
				
				<%-- 移除错误及警告样式--%>
				$("div.form-group").removeClass("has-error has-warning");
				
	  			<%-- 遍历设置每一个错误信息 --%>
				$.each(list,function(){
					$(this.element).nextAll("span.error_msg").text(this.message);
					
		  			<%-- 设置错误样式 --%>
					$(this.element).parent(".form-group").addClass("has-error");
				});	
					
			}
		});
  
  		<%-- 页面加载完成后执行此项 --%>
		$().ready(function() {
			<%-- 表单提交时触发这里 --%>
			$("#reg_form").validate({
				rules: {
					loginacct: {
						required:true,
						minlength:5,
						maxlength:15
					},
					userpswd: {
						required:true,
						minlength:5,
						maxlength:15
					},
					rep_pswd: {
						required:true,
						equalTo: "#userpswd"
					},
					email: {
						required:true,
						email:true
					}
				},
				
				messages: {
					loginacct: {
						required:"帐号不能为空",
						minlength:"最小长度为5个字符",
						maxlength:"最大长度为15个字符"
					},
					userpswd: {
						required:"密码不能为空",
						minlength:"最小长度为5个字符",
						maxlength:"最大长度为15个字符"
					},
					rep_pswd: {
						required:"请确认密码",
						equalTo: "两次密码不一致"
					},
					email: {
						required:"邮箱不能为空",
						email:"邮箱格式不正确"
					}
				}
			});
			
		});
		
		$(function() {
	
			$("#reg_btn").click(function(){
				
				$("#reg_form").submit();
				
				return false;
			});
			
		});
		
		<%-- 使用json作局部请求，查询帐号是否可用 --%>
		$("#loginacct").blur(function() {
			
			$.getJSON("ajaxRegist", {
				loginacct:$(this).val()
			}, function(data) {
				//接收单个数据时，data即为该数据，多个数据一般使用map保存
				if (data) {
					$("#loginacct").next().text("用户名已存在");
				} else {
					$("#loginacct").next().text("用户名可用");
				}
			});
			
		});
		
  </script>
    
</html>