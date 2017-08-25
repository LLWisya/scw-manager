package com.atguigu.scw.controller.demos;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.atguigu.scw.bean.TPermission;
import com.atguigu.scw.service.auth.PermissionService;

/**
 * @Description:	
 * @author WisyaZZ
 * @buildTime 2017年8月3日下午3:04:00
 */
@Controller
public class Demos {

	@Autowired
	PermissionService pmsService;

	@ResponseBody
	@RequestMapping("/demo/ztreeHello")
	public List<TPermission> getZtreeList(HttpSession session) {
		
		List<TPermission> pmsList = pmsService.getAllPermissions();
		
		if (session.getAttribute("demoPmsList") == null) {
			session.setAttribute("demoPmsList", pmsList);
		}
		
		return pmsList;
		
	}
	
}
