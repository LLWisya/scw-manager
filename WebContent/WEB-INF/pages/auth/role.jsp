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
		cursor:pointer;
	}
	table tbody tr:nth-child(odd){background:#F4F4F4;}
	table tbody td:nth-child(even){color:#C00;}
	</style>
  </head>

  <body>

	<%
		pageContext.setAttribute("barinfo", "角色维护");
	%>

    <%--引入后台导航条 --%>
	<%@include file="/WEB-INF/includes/manager-nav-bar.jsp"%>

    <div class="container-fluid">
      <div class="row">
        
        <%--引入角色菜单栏 --%>
		<%@include file="/WEB-INF/includes/user-menu.jsp"%>
        
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
			<div class="panel panel-default">
			  <div class="panel-heading">
				<h3 class="panel-title"><i class="glyphicon glyphicon-th"></i> 数据列表</h3>
			  </div>
			  <div class="panel-body">
<form class="form-inline" role="form" style="float:left;">
  <div class="form-group has-feedback">
    <div class="input-group">
      <div class="input-group-addon">查询条件</div>
      <input class="form-control has-success" type="text" placeholder="请输入查询条件">
    </div>
  </div>
  <button type="button" class="btn btn-warning"><i class="glyphicon glyphicon-search"></i> 查询</button>
</form>
<button type="button" id="deleteAllBtn" class="btn btn-danger" style="float:right;margin-left:10px;"><i class=" glyphicon glyphicon-remove"></i> 删除</button>
<button type="button" id="addRoleBtn" class="btn btn-primary" style="float:right;"><i class="glyphicon glyphicon-plus"></i> 新增</button>
<br>
 <hr style="clear:both;">
          <div class="table-responsive">
            <table class="table  table-bordered showRoleTable">
              <thead>
                <tr >
                  <th width="30">#</th>
				  <th width="30"><input id="selectAllBox" type="checkbox"></th>
                  <th>名称</th>
                  <th width="100">操作</th>
                </tr>
              </thead>
              <tbody>
              
              	 <%-- 使用ajax获得role表 --%>
             
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

<%-- ++++++++++++++++++++++++++++++++++++++模态框,用于添加角色和修改角色的信息输入++++++++++++++++++++++++++++++++++++++++++++++++++  --%>

	<%-- 模态框,用于添加用户和修改用户的信息输入 --%>
	<div class="modal fade" id="myRoleModel">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	        	<span aria-hidden="true">&times;</span>
	        </button>
	        <h4 class="modal-title" id="myRoleModelHeader">模态框标题</h4>
	      </div>
	      <div class="modal-body">
	      <!-- 模态框体使用表格装载信息 -->
	        <form id="roleForm" action="${APP_PATH }/role/save" method="post">
				<div class="form-group">
					<label>名称</label> 
					<input type="text" class="form-control" name="name"
						id="rolename_input" placeholder="名称">
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



<%-- ++++++++++++++++++++++++++++++++++++++模态框,用于编辑权限树++++++++++++++++++++++++++++++++++++++++++++++++++  --%>


<div class="modal fade" id="myRolePmsModel">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	        	<span aria-hidden="true">&times;</span>
	        </button>
	        <h4 class="modal-title">权限分配</h4>
	      </div>
	      <div class="modal-body">
	      <!-- 模态框体使用表格装载信息 -->
	      
	        <%-- 使用菜单树ztree --%>
	        <ul id="myPermissionTree" class="ztree"></ul>
	        
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
      	  var index;
        
            $(function () {
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
            });
            
//             $("tbody .btn-success").click(function(){
//                 window.location.href = "assignPermission.html";
//             });
            
<%-- ++++++++++++++++++++++++++++++++++++++当前侧边栏展开且红色++++++++++++++++++++++++++++++++++++++++++++++++++  --%>	    

          //每个页面的效果改变
    		$(function() {
    			//按照当前页面的超链接
    			//给当前超链接加红；
    			$("a[href='${APP_PATH}/role/list.html']").css("color", "red");
    			//将这个超链接对应的ul展开
    			$("a[href='${APP_PATH}/role/list.html']").parents("ul:hidden")
    					.show();
    		});
 <%-- +++++++++++++++++++++++++++++++++++++++++页面加载完成+++++++++++++++++++++++++++++++++++++++++++++++  --%>
    		
    		<%-- 页面加载完成后，自动发送Ajax请求获得角色列表 --%>
    		$(function() {
    			getRoles(1);
    		});
    		
    		function getRoles(pageNo) {
    			$.ajax({
    				url:"${APP_PATH}/role/listRoles",	
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

    <%-- +++++++++++++++++++++++++++++++++++++++++构建角色表单数据+++++++++++++++++++++++++++++++++++++++++++++++  --%>				
    		
    		//构建数据,分两步
            function buildData(data){
            	//1、显示整个tr；
            	buildTr(data);
            	//2、构建显示整个分页条
            	buildPage(data);
            }
            
    		function buildTr(data) {
    			<%-- 先清空页面 --%>
    			$(".showRoleTable tbody").empty();
    			
    			<%-- 数据中的每一条记录，都插入一条tr行 --%>
            	$.each(data.list,function(){
            		
            		//1、创建出整个tr
            		var tr =$("<tr></tr>");
            		var buttonTd = $("<td></td>");
            				 <%-- 检查按钮 --%>
            		buttonTd.append($("<button type='button' rid='"+this.id+"' rolename='"+this.name+"' class='btn btn-success btn-xs assignPermissionBtn'><i class='glyphicon glyphicon-check'></i></button>"))
            				.append(" ")
            				  <%-- 编辑按钮 --%>
            				.append($('<button type="button" rolename"'+this.name+'" num="'+this.id+'" class="btn btn-primary btn-xs editRoleBtn"><i class="glyphicon glyphicon-pencil"></i></button>'))
            				.append(" ")
            				  <%-- 删除按钮 --%>
            				  <%-- 此处存在bug,当rolename为空时会把id=this.id当作rolename被获取，再去获取id时则无法获取，导致程序出错--%>
            				.append($('<button type="button" rolename"'+this.name+'" rid="'+this.id+'" class="btn btn-danger btn-xs delRoleBtn"><i class="glyphicon glyphicon-remove"></i></button>'));
            		
            		//2、tr里面的每一个td添加上
            		tr.append($("<td>"+this.id+"</td>"))
            			.append("<td><input type='checkbox'></td>")
            			.append("<td>"+this.name+"</td>")
            			.append(buttonTd);
            		
            		//将这个tr放到tbody中；
            		$(".showRoleTable tbody").append(tr);
    			});
    		}
    <%-- ++++++++++++++++++++++++++++++++++++++++++构建分页条++++++++++++++++++++++++++++++++++++++++++++++  --%>		
    		//构建分页条
            function buildPage(data){
    			<%-- ul列表项 --%>
            	var pageBar = $(".showRoleTable .pagination");
            	
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
            
            <%-- 为当前页面加载完成后存在数据绑事件；未来的元素绑不上；jquery1.7后不推荐使用live绑定未来事件，推荐使用on --%>
           $(".pagination").on("click","li",function(){
        	   <%-- 调用Ajax请求函数，获得对应页码的角色列表 --%>
        	   getRoles($(this).attr("num"));
           });
    		
    <%-- +++++++++++++++++++++++++++++++++++++++++新增角色+++++++++++++++++++++++++++++++++++++++++++++++  --%>
           
           <%-- 为新增按钮绑定事件，使用模态框添加信息 --%>
           $('#addRoleBtn').click(function() {
        	   //为确定按钮添加自定义属性edit，true表示这是修改角色，false表示这是添加角色
    		   $("#confirmBtn").attr("edit",false);
        	   $("#myRoleModelHeader").text("添加角色");
        	   <%-- 帐号可以输入 --%>
        	   //重置表单数据
    		   $("#roleForm")[0].reset();
        	   $('#myRoleModel').modal({
    				backdrop : 'static',
    				show : true
    			});
        	});
       
    <%-- ++++++++++++++++++++++++++++++++++++++修改角色++++++++++++++++++++++++++++++++++++++++++++++++++  --%>       
           
           <%-- 为修改角色按钮绑定事件，使用模态框添加信息 --%>
           $("body").on("click","button.editRoleBtn", function() {
        	   
       		   <%--加一个角色id的自定义属性,用于查询role,作数据回显--%>
        	   var rid = $(this).attr("num");
        	   var rname = $(this).attr("rolename");
        	   <%--把id加入到确定按钮属性中 --%>
        	   $("#confirmBtn").attr("rid", rid);
        	   
        	   
        	   <%--为确定按钮添加自定义属性edit，true表示这是修改角色，false表示这是添加角色--%>
       	  	   $("#confirmBtn").attr("edit",true);
       	  	   $("#myRoleModelHeader").text("修改角色");
       	  	   
       	  	   <%-- 帐号不能修改 --%>
       	  	   $("#loginacct_input").prop("disabled", true);
       	  	   
       	  	  <%--发送Ajax请求，获得角色数据，数据回显--%>
       	  	  <%--
     		   $.get("${APP_PATH}/role/getRole", {rid:rid}).done(function(data) {     
     		   		$("#rolename_input").val(data.loginacct);
     			});--%>
			  
    		  <%-- 不需要Ajax请求，直接在页面中获得rolename --%> 
    		  $("#rolename_input").val(rname);
    		   
    		  <%-- 与新增角色使用同一个模态框 --%> 
       	  	   $('#myRoleModel').modal({
    			 backdrop : 'static',
    		  	 show : true
    		   });
    	   });
       
     <%-- +++++++++++++++++++++++++++++++++++++模态框确认提交+++++++++++++++++++++++++++++++++++++++++++++++++++  --%>
           
        	<%-- 为添加角色的确认按钮绑定使  --%>
    		$("#confirmBtn").click(function() {
    			
    			var edit = $("#confirmBtn").attr("edit");
    			
    			<%--edit == "false"标识是添加新角色 --%>
    			if (edit == "false") {
    			
    				$.post("${APP_PATH}/role/save", $("#roleForm").serialize()).done(function(data){
    					
    					<%-- 如果是添加成功 --%>
    					if (data.success == "true") {
    						
    						<%-- 为事件添加索引index --%>
    						index = layer.confirm(data.msg + ", 是否继续添加角色？", {
    							<%-- 两个按钮选项，以下对应两个function --%>
    							btn:['是', '算了']
    						}, function() {
    							$("#roleForm")[0].reset();
    							<%-- 关闭该索引层,即关闭layer.confirm这个弹窗 --%>
    		 					layer.close(index);
    						}, function() {
    							<%-- 关闭模态框,刷新页面到最后一页 --%>
    							$("#myRoleModel").modal("hide");
    							getRoles(99999);
    						});
    					<%-- 如果是添加失败 ,提示失败信息--%>
    					} else {
    						layer.msg(data.msg);
    					}
    					<%-- 请求失败的回调函数--%>
    				}).fail(function(e) {
    					layer.msg(e);
    				});
    		<%--edit != "false"标识是修改角色 --%>		
    			} else {
    				
    				var data = $("#roleForm").serialize()+"&id="+$(this).attr("rid");
    				
    				$.post("${APP_PATH}/role/update", data).done(function(data){
    					
    					$("#myRoleModel").modal("hide");
    					layer.msg(data.msg);
    					
    					<%-- 刷新页面--%>
    					var pageNo = $(".pagination li.active").attr("num");
    					getRoles(pageNo);
    				});
    			};
    			
    		});
    		
    <%-- +++++++++++++++++++++++++++++++++++++删除角色按钮+++++++++++++++++++++++++++++++++++++++++++++++++++  --%>      
    		 $("body").on("click","button.delRoleBtn", function() {
    			var name = $(this).attr("rolename");
    			var id = $(this).attr("rid");
    			
    			 layer.confirm("确定要删除角色【" + name + "】吗？", {
    				 btn:['赶紧删除', '朕按错了']
    			 }, function() {
    				$.get("${APP_PATH}/role/deleteRole", {id:id}).done(function(data) {
    					
    					layer.msg(data.msg + ", 删除：" + name, {icon: 1});
    					
    					<%-- 刷新页面--%>
    					var pageNo = $(".pagination li.active").attr("num");
    					getRoles(pageNo);
    				});
    			 }, function() {
    				 <%-- 取消，什么也不做--%>
    			});
    			 
    			 
    		 });
    	
 <%-- +++++++++++++++++++++++++++++++++++++批量删除角色操作+++++++++++++++++++++++++++++++++++++++++++++++++++  --%>   	

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
           $("#deleteAllBtn").click(function() {
    			var checkBoxes = $("tbody :checkbox:checked");
        	    var ids = "";
        	    var names = "";
        	    
        	    <%-- 获取需要删除的id--%>
        	    $.each(checkBoxes, function() {
    				ids += $(this).parent("td").prev("td").text() + ",";
    				names += $(this).parent("td").next("td").text() + ",";
    			});
        	    
        	   
        	  layer.confirm("确定要删除角色【" + names + "】吗？", {
        		  btn:['赶紧删除', '朕再想想']
        	  }, function() {
    			 $.get("${APP_PATH}/role/deleteRoles", {ids:ids}).done(function(data) {
    				layer.msg(data.msg+"<br/>删除的角色有:"+names);
    				
    				<%-- 刷新页面--%>
    				var pageNo = $(".pagination li.active").attr("num");
    				getRoles(pageNo);
    			});
    		  }, function() {
    			  <%-- 取消，是也不做--%>
    		  }); 
        	   
    	   }); 
                    	
<%-- +++++++++++++++++++++++++++++++++++++ 编辑角色许可:方案一 +++++++++++++++++++++++++++++++++++++++++++++++++++  --%>  
<%-- 
	使用页面转发，服务器查询得到该角色所拥有的Permissions，结构化成子父关系结构存放在list中，放入到Session中，服务器转发到Permission编辑页面，
	在页面中取得list数据并非ztree所需的良好结构的数据，需要额外处理数据结构，暂时不使用此方案。  --此结论带商榷  --%>
		$("body").on("click","button.assignPermissionBtn", function() {
			var rid = $(this).attr("rid");	
		    var rolename = $(this).attr("rolename");	
		   
		   //get请求参数中的中文需要解决编码问题  
		   location.href="${APP_PATH}/role/permission.html?rid="+rid+"&rolename="+rolename;
		});	

<%-- +++++++++++++++++++++++++++++++++++++ 编辑角色许可:方案二 +++++++++++++++++++++++++++++++++++++++++++++++++++  --%>  

<%-- 在本页面中使用模态框弹出权限树编辑页面，发送Ajax请求获得所需的权限树数据，返回的json对象中良好封装了所需的数据，可以不需要处理直接使用 --%>	
<%--  暂时不用此方案，使用方案一  结构简单
		var ztreeObject;
		
		// ztree使用的配置
		var setting = {
			data : {
				simpleData : {
					enable : true,
					idKey: "id",
					pIdKey: "pid"
				},
				key: {
					url: "haha"//写一个不存在属性
				}
			},
			check: {
				enable: true
			}
			
		};
		
		
		//文档加载完成以后使用ztree初始化权限树
		
			//拿到所有的权限   data：返回的菜单数据
			$.get("${APP_PATH}/role/ajaxPermission.html", function(data) {
				//使用ztree的简单数据进行父子关系确定；data直接就是所有的菜单数据
				//为了展开父节点，可以为每一个节点添上open=true的属性；
				console.log(data);
				$.each(data,function(){
					if(this.pid==0)
						this.open = true;
				});
				//返回json数据
				ztreeObject = $.fn.zTree.init($("#myPermissionTree"), setting, data);
			});
			
		//为角色分配权限按钮；打开权限树的模态框
		$("body").on("click", ".assignPermissionBtn", function() {
			//1、弹出分配权限的模态框
			$("#myRolePmsModel").modal({
				backdrop:'static',
				show:true
			});
			
			
			//2、先清除掉权限之前操作的勾选状态
// 			ztreeObject.checkAllNodes(false);
			
			var rid = $(this).parents("tr").find("td:first").text();
			//****:将rid传给模态框
			$("#myRolePmsModel").attr("rid",rid);
			
			//2、模态框里面展示所有的权限数据（菜单）
// 			$.get("${APP_PATH}/permission/role?rid="+rid,function(data){
// 				$.each(data,function(){
// 					var node = ztreeObject.getNodeByParam("id", this.id, null);
// 					ztreeObject.checkNode(node, true, false);
// 				});
// 			});

		});
		
		//点击权限分配按钮，保存权限
		$("#confirmBtn").click(function(){
			var rids = $(this).attr("rid");
			var pidStr = "";
			//在ztree中找到选中的所有节点。拿出他们的id；
			$.each(ztreeObject.getCheckedNodes(true),function(){
				pidStr+= this.id+",";
			});
			//alert(pids);
			$.post("${APP_PATH}/permission/assign",{rid:rids,pids:pidStr},function(data){
				layer.msg(data.msg);
				//关闭模态框
				$("#myRolePmsModel").modal("hide");
			});
			
		});
		

--%>
           
        </script>
  </body>
</html>
