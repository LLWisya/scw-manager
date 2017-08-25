package com.atguigu.scw.controller.auth;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.atguigu.scw.bean.TPermission;
import com.atguigu.scw.bean.TRole;
import com.atguigu.scw.pojo.Constants;
import com.atguigu.scw.service.auth.PermissionService;
import com.atguigu.scw.service.auth.RoleService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;


/**
 * @Description:	
 * @author WisyaZZ
 * @buildTime 2017年7月31日下午8:59:52
 */
@Controller
public class RoleController {

	@Autowired
	RoleService roleService;
	
	@Autowired
	PermissionService pmsService;
	
	/**
	 * 根据角色id，为该角色分配权限，删除或者添加
	 * @param rid
	 * @param addNodes
	 */
	@ResponseBody
	@RequestMapping("/role/updateRolePms")
	public Map<String, Object> updateRolePms(@RequestParam("rid") Integer rid,
											@RequestParam("addNodes") String addNodes) {
		Map<String, Object> map = new HashMap<>();
		
		String[] addNs = addNodes.split(",");
		Integer[] nodes;
		int index;
		try {
			index = 0;
			//判断是否为全部删除操作
			boolean delAll = false;
			nodes = new Integer[addNs.length];
			for (String string : addNs) {
				//为""时说明addNodes中没有id号，说明没有需要添加的权限，删除该角色的全部权限
				if (string.equals("")) {
					delAll = true;
					break;
				}
				int addNode = Integer.parseInt(string);
				nodes[index++] = addNode;
			}
			if (!delAll) {
				pmsService.updatePermissions(rid, nodes, "add");
			} else {
				pmsService.updatePermissions(rid, nodes, "del");
			}
			
			map.put("msg", "操作成功");
		} catch (Exception e) {
			e.printStackTrace();
			map.put("msg", "操作失败");
		}
		
		return map;
	} 
	
	/**
	 * 角色权限页面加载完成后自动调用此方法， 使用Ajax请求获得所有权限数据。
	 */  
	@ResponseBody
	@RequestMapping("/role/ajaxPermission")
	public List<TPermission> listPermissoins() {
		
		List<TPermission> allPmsList = pmsService.getAllPermissions();
		
		return allPmsList;
	}   

	/**
	 * 根据角色id返回该角色所拥有的权限菜单，数据没有结构化.
	 * @param rid
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/role/ajaxRolePms")
	public List<TPermission> listRolePms(@RequestParam("rid") String rid) {
		
		List<TPermission> rolePms = pmsService.getRolePermissions(rid);
		
		for (TPermission tPermission : rolePms) {
			System.out.println(tPermission);
		}
		
		return rolePms;
	}
	
	
	
	/**
	 * 处理角色管理页面的(编辑角色权限)的请求，转发到角色权限编辑页面.
	 */
	@RequestMapping("/role/permission.html")
	public String assignRolePermission() {
		return "auth/assignPermission";
	}
	
	
	/**
	 * 接收Ajax请求，根据id批量删除角色
	 * @param uid
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/role/deleteRoles")
	public Map<String, Object> deleteRoles(@RequestParam("ids") String ids) {
		Map<String, Object> map = new HashMap<String, Object>();
		
		int i = roleService.deleteRoles(ids);
		
		if (i > 0) {
			map.put("msg", "删除成功,已删除["+i+"]位角色");
		} else {
			map.put("msg", "删除失败");
		}
		return map;
	}
	
	
	
	/**
	 * 接收Ajax请求，根据id删除角色
	 * @param uid
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/role/deleteRole")
	public Map<String, Object> deleteRole(@RequestParam("id") String id) {
		Map<String, Object> map = new HashMap<String, Object>();
		
		
		int i = roleService.deleteRole(id);
		
		if (i > 0) {
			map.put("msg", "删除成功");
		} else {
			map.put("msg", "删除失败");
		}
		return map;
	}
	
	
	/**
	 * 接收Ajax请求，更新角色
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/role/update")
	public Map<String, Object> updateRole(TRole tRole) {
		Map<String, Object> map = new HashMap<String, Object>();
		
		int i = roleService.updateRole(tRole);
		
		if (i > 0) {
			map.put("msg", "修改成功");
		} else {
			map.put("msg", "修改失败");
		}
		return map;
	}
	
	/**
	 * 添加角色
	 * @param tRole
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/role/save")
	public Map<String, Object> saveRole(TRole tRole) {
		Map<String, Object> map = new HashMap<String, Object>();
		int save = roleService.save(tRole);
		if (save > 0) {
			map.put("success", "true");
			map.put("msg", "添加角色【" + tRole.getName() + "】成功");
		}else {
			map.put("success", "false");
			map.put("msg", "添加角色【" + tRole.getName() + "】失败");
		}
		return map;
	}
	
	/**
	 * Ajax请求获得role列表，分页显示
	 * @param pageNo
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/role/listRoles")
	public PageInfo<TRole> getRoleListsByJson(@RequestParam("pageNo") int pageNo) {
		
		PageHelper.startPage(pageNo, Constants.NAV_PAGE_NUMS);
		List<TRole> roles = roleService.listRole();
		PageInfo<TRole> pageInfo = new PageInfo<>(roles, Constants.NAV_PAGE_NUMS);
		
		return pageInfo;
	}
	
	@RequestMapping("/role/list.html")
	public String getRoleList() {
		return "auth/role";
	}
	
	
}
