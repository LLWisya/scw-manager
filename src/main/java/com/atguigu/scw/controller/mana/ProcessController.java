package com.atguigu.scw.controller.mana;


import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.activiti.engine.RepositoryService;
import org.activiti.engine.repository.ProcessDefinition;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.atguigu.scw.pojo.ScwReturn;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageInfo;

/**
 * @Description:	
 * @author WisyaZZ
 * @buildTime 2017年8月7日下午6:44:06
 */
@Controller
@RequestMapping("/mana")
public class ProcessController {

	@Autowired
	RepositoryService repositoryService;
	
	@ResponseBody
	@RequestMapping("/delProcess")
	public ScwReturn<Object> delProcess(@RequestParam("depId") String depId) {
		
		try {
			repositoryService.deleteDeployment(depId);
			return ScwReturn.success("移除成功", null, null);
		} catch (Exception e) {
			return ScwReturn.fail("移除失败", null, null);
		}
	}
	
	/**
	 * 返回对应页码的流程信息集合，和分页条对象
	 * @param pageNo 当前页码
	 */
	@ResponseBody
	@RequestMapping("/listProcess")
	public ScwReturn<Object> listPds(@RequestParam(value="pageNo", defaultValue="1") Integer pageNo) {
		
		Map<String, Object> ext = new HashMap<>();
		int pageSize = 5;
		
		//查询流程数
		long count = repositoryService.createProcessDefinitionQuery().count();
		
		//PageHelper可以直接给mybatis查询构建分页，activiti框架内调用自己的查询，因此PageHelper不起效
		//这里利用PageHelper帮助对已经查询好的数据进行分页计算并构建
		Page<Object> page = new Page<>(pageNo, pageSize);
		
		page.setTotal(count);  //设置总记录数
		//构建分页条对象, 5页显示数 	 PageInfo对象有各种分页条的信息
		PageInfo<Object> pageInfo = new PageInfo<>(page, 5);
		
		//分页条放入返回数据中
		ext.put("pageBar", pageInfo);
		
		//查询出所有需要的流程定义集合
		List<ProcessDefinition> list = repositoryService.createProcessDefinitionQuery().listPage(page.getStartRow(), pageSize);
		//自定义属性使用map保存，使用list保存各个流程信息的map对象
		List<Map<String, Object>> pdMapList = new ArrayList<>();
		
		//遍历所有查询到的流程集合，获得所需要的流程信息，保存在自定义的集合中
		for (ProcessDefinition pd : list) {
			HashMap<String, Object> hashMap = new HashMap<String, Object>();
			hashMap.put("id", pd.getId());
			hashMap.put("name", pd.getName());
			hashMap.put("category", pd.getCategory());
			hashMap.put("key", pd.getKey());
			hashMap.put("version", pd.getVersion());
			hashMap.put("depId", pd.getDeploymentId());
			
			pdMapList.add(hashMap);
		}
		
		//流程信息放入到返回数据中
		ext.put("pdInfoList", pdMapList);
		
		return ScwReturn.success("查询到记录数:"+list.size(), null, ext);
	}
	
	
	/**
	 * 把上传的流程文件进行部署，同步数据库
	 * @param file
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/uploadFile")
	public ScwReturn<Object> uploadProcess(@RequestParam("processFile") MultipartFile file) {
		String filename = file.getOriginalFilename();
		InputStream is;
		
		try {
			is = file.getInputStream();
			//部署流程
			repositoryService.createDeployment()
							.addInputStream(filename, is)
							.category("实名审核")
							.deploy();
			
			return ScwReturn.success("流程部署成功", null, null);
		} catch (IOException e) {
			e.printStackTrace();
			return ScwReturn.fail("流程部署失败", null, null);
		}
	}
	
	@RequestMapping("/process.html")
	public String processPage() {
		return "mana/process";
	}
	
}
