package com.atguigu.scw.controller.auth;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.atguigu.project.MyStringUtils;
import com.atguigu.scw.bean.TPermission;
import com.atguigu.scw.bean.TRole;
import com.atguigu.scw.bean.TUser;
import com.atguigu.scw.pojo.Constants;
import com.atguigu.scw.service.auth.PermissionService;
import com.atguigu.scw.service.auth.TUserRoleService;
import com.atguigu.scw.service.auth.TUserService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

/**
 * @Description:	
 * @author WisyaZZ
 * @buildTime 2017年7月28日下午4:07:10
 */
@Controller
public class UserController {
	
	@Autowired
	TUserService userService;
	
	@Autowired
	PermissionService permissionService;
	
	@Autowired
	TUserRoleService userRoleService;
	
	/**
	 * 根据用户id,为该用户添加ids中包含的角色
	 * @param uid
	 * @param ids
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/user/addRoles")
	public Map<String, Object> getUserRoles(@RequestParam("uid") String uid,  @RequestParam("ids") String ids) {
		
		userRoleService.addRoles(uid, ids);	
		
		return null;
	}
	
	/**
	 * 根据用户id，为该用户删除ids中包含的角色
	 * @param uid
	 * @param ids
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/user/deleteRoles")
	public Map<String, Object> deleteUserRoles(@RequestParam("uid") String uid,  @RequestParam("ids") String ids) {
		
		userRoleService.deleteRoles(uid, ids);	
		
		return null;
	}
	
	/**
	 * 转发到用户角色管理页面
	 * @param uid
	 * @param model
	 * @return
	 */
	@RequestMapping("/user/roles.html")
	public String getUserRoles(@RequestParam("uid") String uid, Model model) {
		List<TRole> allRoles = userRoleService.getUserRoles();
		List<TRole> userRoles = userRoleService.getUserRoles(uid);
		model.addAttribute("allRoles", allRoles);
		model.addAttribute("hasRoles", userRoles);
		
		return "auth/assignRole";
	}
	
	
	/**
	 * 接收Ajax请求，根据id批量删除用户
	 * @param uid
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/user/deleteUsers")
	public Map<String, Object> deleteUsers(@RequestParam("ids") String ids) {
		Map<String, Object> map = new HashMap<String, Object>();
		
		int i = userService.deleteUsers(ids);
		
		if (i > 0) {
			map.put("msg", "删除成功,已删除["+i+"]位用户");
		} else {
			map.put("msg", "删除失败");
		}
		return map;
	}
	
	
	/**
	 * 接收Ajax请求，根据id删除用户
	 * @param uid
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/user/deleteUser")
	public Map<String, Object> deleteUser(@RequestParam("id") String id) {
		Map<String, Object> map = new HashMap<String, Object>();
		
		int i = userService.deleteUser(id);
		
		if (i > 0) {
			map.put("msg", "删除成功");
		} else {
			map.put("msg", "删除失败");
		}
		return map;
	}
	
	/**
	 * 接收Ajax请求，更新用户
	 * @param uid
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/user/update")
	public Map<String, Object> updateUser(TUser user) {
		Map<String, Object> map = new HashMap<String, Object>();
		
		int i = userService.updateUser(user);
		
		if (i > 0) {
			map.put("msg", "修改成功");
		} else {
			map.put("msg", "修改失败");
		}
		return map;
	}
	
	/**
	 * 接收Ajax请求，根据id查询用户
	 * @param uid
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/user/getUser")
	public TUser getUser(@RequestParam("uid") int uid) {
		
		TUser user = userService.getUser(uid);
		
		return user;
	}
	
	
	/**
	 * 处理ajax请求，添加新用户
	 * @param tUser
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/user/save")
	public Map<String, Object> saveUser(TUser tUser) {
		Map<String, Object> map = new HashMap<String, Object>();
		int save = userService.save(tUser);
		if (save > 0) {
			map.put("success", "true");
			map.put("msg", "添加用户【" + tUser.getLoginacct() + "】成功");
		}else {
			map.put("success", "false");
			map.put("msg", "添加用户【" + tUser.getLoginacct() + "】失败");
		}
		return map;
	}
	
	
	/**
	 * ajax请求获得对应页码的用户列表
	 * @param pageNo
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/user/ajaxUserlist")
	public PageInfo<TUser> ajaxListUser(@RequestParam(value="pageNo", defaultValue="1") Integer pageNo) {
		
		PageHelper.startPage(pageNo, Constants.NAV_PAGE_NUMS);
		List<TUser> users = userService.listUser();
		PageInfo<TUser> pageInfo = new PageInfo<>(users, Constants.NAV_PAGE_NUMS);
		
		return pageInfo;
	}
	
	
	/**
	 * 虚拟路径请求的处理方法,转发到用户显示列表.不带数据，在该页面加载完成后，使用Ajax请求获得用户列表。
	 * @return
	 */
	@RequestMapping("/user/list.html")
	public String getUserList() {
		
		return "auth/user";
	}
	
	
	/**
	 * 注册业务
	 * @param user
	 * @param model
	 * @return
	 */
	//路径建议使用双层目录
	@RequestMapping("/regist")
	public String regist(TUser user, Model model) {
		
		//向数据库中插入注册的user
		int n = userService.save(user);
		//插入成功则返回1，重定向到登录页面
		if (1 == n) {
			model.addAttribute("msg", "注册成功，请登录");
			return "forward:/login.jsp";
		}
		//插入失败则转发到注册页面
		model.addAttribute("msg", "注册失败,帐号已存在");
		return "forward:/reg.jsp";
	}
	
	/**
	 * 用于Ajax请求查询是否用户名已存在，返回boolean对象实体，需要注解@ResponseBody
	 * @param loginacct
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/ajaxRegist")
	public Boolean ajaxRegist(String loginacct) {
		System.out.println("触发ajaxRegist方法-->" + MyStringUtils.formatSimpleDate(new Date()) +", loginacct:" +loginacct );
		boolean existAccount = userService.isExistAccount(loginacct);
		System.out.println(existAccount);
		//此处设置json
		
		return existAccount;
	}
	
	/**
	 * 登录业务
	 * @param user
	 * @param model
	 * @param session
	 * @return
	 */
	@RequestMapping("/login")
	public String login(TUser user, Model model, HttpSession session) {
		
		TUser loginUser = userService.login(user);
		
		if (loginUser != null) {
			session.setAttribute(Constants.LOGIN_USER, loginUser);
			//通过一个中间页面(虚的)，在main.html中再次转发到实际的WEB-INF下的main.jsp，
			//解决了重复提交的问题，也保护了main.jsp页面
			return "redirect:/user/main.html";
		} else {
			model.addAttribute("msg", "登录失败，无此用户");
			return "forward:/index.jsp";
		}
	}
	
	//虚拟页面main.html转向main.jsp的中间处理过程
	@RequestMapping("/user/main.html")
	public String mainHtmlHandler(Model model, HttpSession session) {
		Object object = session.getAttribute(Constants.LOGIN_USER);
		if (object == null) {
			// 用户没有登陆。转发到登陆页面
			model.addAttribute("msg", "你还没有登陆，请先登陆");
			return "forward:/login.jsp";
		}

		// 菜单是从session中获取的；如果有就直接用，如果没有就去查
		// 查出所有菜单；构建好子父级关系来到页面显示；
		if (session.getAttribute(Constants.USER_MENUS) == null) {
			//如果session中没有保存菜单
			List<TPermission> menus = permissionService.getBuildMenus();
			session.setAttribute(Constants.USER_MENUS, menus);
		}
		// 查出的菜单我们直接放在session域中进行保存；
		return "main";
	}
	
}
