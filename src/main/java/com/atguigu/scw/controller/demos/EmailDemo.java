package com.atguigu.scw.controller.demos;

import org.apache.commons.mail.EmailException;
import org.apache.commons.mail.SimpleEmail;

/**
 * @Description:
 * @author WisyaZZ
 * @buildTime 2017年8月4日上午9:43:59
 */
public class EmailDemo {

	/*
	 * 信件存储在服务器上，需要由客户端主动请求接收邮件，接收到的邮件，删除时只是删除客户端的存储，不影响服务器。 pop3:服务器与客户端不同步
	 * imap: 服务器与客户端同步度较pop3高 smtp: 推荐用来作发送服务器
	 */

	public static void main(String[] args) {

		myDomainEmail();
			
	}

	/**
	 * 使用163的服务器发送简单邮件
	 */
	public static void helloEmail() {
		SimpleEmail email = new SimpleEmail();

		// 1.设置服务器HostName
		email.setHostName("smtp.163.com");
		// 2.设置登录证明
		email.setAuthentication("kaka2567877042@163.com", "xxx12340.");
		try {
			// 3.发送人
			email.setFrom("kaka2567877042@163.com");
			// 4.设置其他信息
			email.addTo("kaka2567877042@163.com");

			email.setSubject("这是邮件测试");

			//email.setContent("哈哈哈哈哈哈", "text/plain;charset=utf-8");
			
			email.setMsg("你好");

			// 5.最后必须主动发送
			email.send();
			System.out.println("发送成功");
		} catch (EmailException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.out.println("发送失败");
		}

	}

	/**
	 * 使用自己搭建的服务器发送邮件，如果没有注册该服务器域名，则可以发送邮件，可以接收内部邮件，不可以接收外部服务器的邮件
	 */
	public static void myDomainEmail() {
		
		SimpleEmail email = new SimpleEmail();
	
		//1.自己搭建的服务器没有在网络上注册，所以只能在本机上或内网使用
		email.setHostName("127.0.0.1");
		
		email.setAuthentication("wisya@atguigu.com", "12345");
		
		try {
			email.setFrom("wisya@atguigu.com");
			
			email.setMsg("测试测试");
			
			email.addTo("L~yinwazi@atguigu.com");
			
			email.send();
			
			System.out.println("发送成功..");
		} catch (EmailException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.out.println("发送失败..");
		}
		
	}

}
