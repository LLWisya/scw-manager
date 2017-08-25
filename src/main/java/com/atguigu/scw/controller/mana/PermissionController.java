package com.atguigu.scw.controller.mana;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.atguigu.scw.bean.TAccountTypeCert;
import com.atguigu.scw.bean.TCert;
import com.atguigu.scw.bean.TType;
import com.atguigu.scw.service.mana.ManagerService;

/**
 * @Description:	
 * @author WisyaZZ
 * @buildTime 2017年8月2日下午9:22:17
 */
@RequestMapping("/mana")
@Controller
public class PermissionController {

	@Autowired
	ManagerService manaService;
	
	
	@ResponseBody
	@RequestMapping("/updateType")
	public Map<String, Object> updateTypeCert(@RequestParam("tid") Integer tid,
								@RequestParam("cid") Integer cid, 
								@RequestParam("isAdd") Boolean isAdd) {
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			manaService.updateTypeCert(tid, cid, isAdd);
			map.put("msg", (isAdd ? "新增资质" : "删除资质") + "-成功");
		} catch (Exception e) {
			map.put("msg", (isAdd ? "新增资质" : "删除资质") + "-失败");
		}
		return map;
	}
	
	
	/**
	 * 收到确定分类管理后，返回json数据更新复选框状态
	 */
	@ResponseBody
	@RequestMapping("/typeJson")
	public List<TAccountTypeCert> getTypeCert() {
		
		//TAccountTypeCert中保存Type的name字段，和Cert的id字段
		List<TAccountTypeCert> typeCerts = manaService.getTypeCertList();
		//MyTypeCertBean中保存Type的id字段，和Cert的id字段
		
		return typeCerts;
	}
	
	
	/**
	 * 从数据库查询出客户的类型，如商业公司、个体经营、政府机构
	 * 从数据库查询出证件的类型，如营业证、身份证
	 * 转发到页面形成二维矩阵复选框
	 */
	@RequestMapping("/type.html")
	public String manaType(Model model) {
		
		List<TCert> allCerts = manaService.getAllCerts();
		List<TType> allTypes = manaService.getAllTypes();
		
		model.addAttribute("allCerts", allCerts);
		model.addAttribute("allTypes", allTypes);
		
		return "mana/type";
	}
	
}
