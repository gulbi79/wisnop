package wi.com.wisnop.common.webutil;

import java.util.Locale;

import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;

import wi.com.wisnop.common.constant.Namespace;
import wi.com.wisnop.dto.common.UserVO;

public class SessionUtil {
	
	/**
	  * attribute 값을 가져 오기 위한 method
	  * 
	  * @return Object attribute obj
	 */
	public static Object getAttribute(String attr) throws Exception {
		return (Object)RequestContextHolder.getRequestAttributes().getAttribute(attr, RequestAttributes.SCOPE_SESSION);
	}

	/**
	  * attribute 설정 method
	  * 
	  * @param Object  attribute obj
	  * @return void
	 */
	public static void setAttribute(String attr, Object object) throws Exception {
		RequestContextHolder.getRequestAttributes().setAttribute(attr, object, RequestAttributes.SCOPE_SESSION);
	}

	/**
	  * 설정한 attribute 삭제 
	  * 
	  * @return void
	 */
	public static void removeAttribute(String attr) throws Exception {
		RequestContextHolder.getRequestAttributes().removeAttribute(attr, RequestAttributes.SCOPE_SESSION);
	}
	 
	/**
	  * session id 
	  * 
	  * @return String SessionId 값
	 */
	public static String getSessionId() throws Exception  {
		return RequestContextHolder.getRequestAttributes().getSessionId();
	}

	public static Object getSession() throws Exception {
		return (Object)RequestContextHolder.getRequestAttributes().getAttribute(Namespace.USER_INFO, RequestAttributes.SCOPE_SESSION);
	}

	/*
	 * Session을 제거한다.
	 */
	public static void getSessionDestory() throws Exception {
		RequestContextHolder.getRequestAttributes().setAttribute(Namespace.USER_INFO, null, RequestAttributes.SCOPE_SESSION);
	}

	/**
	  * session User id 
	  * 
	  * @return String User id  값
	 */
	public static String getUserId() throws Exception  {
		 UserVO sess = (UserVO)RequestContextHolder.getRequestAttributes().getAttribute(Namespace.USER_INFO, RequestAttributes.SCOPE_SESSION);
		 
		 if ( sess == null)
			 return "";
		 else
			 return sess.getUserId();
	}

	/**
	  * session User name
	  * 
	  * @return String User name  값
	 */
	public static String getUserNm() throws Exception  {
		 UserVO sess = (UserVO)RequestContextHolder.getRequestAttributes().getAttribute(Namespace.USER_INFO, RequestAttributes.SCOPE_SESSION);
		 
		 if ( sess == null)
			 return "";
		 else
			 return sess.getUserNm();
	}

	/**
	 * session locale
	 * @return
	 * @throws Exception
	 */
	public static Locale getLocale() throws Exception  {
		 return (Locale)RequestContextHolder.getRequestAttributes().getAttribute(Namespace.LANG, RequestAttributes.SCOPE_SESSION);
	}

}
