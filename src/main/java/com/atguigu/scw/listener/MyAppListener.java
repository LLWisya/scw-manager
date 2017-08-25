package com.atguigu.scw.listener;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

/**
 * @Description:用于初始化APP的全局配置，随程序启动
 * @author WisyaZZ
 * @buildTime 2017年7月28日下午3:30:05
 */
public class MyAppListener implements ServletContextListener {

	@Override
	public void contextInitialized(ServletContextEvent sce) {
		//设置当前工程路径的全局常量
		sce.getServletContext().setAttribute("APP_PATH", sce.getServletContext().getContextPath());
	}

	@Override
	public void contextDestroyed(ServletContextEvent sce) {

	}

}
