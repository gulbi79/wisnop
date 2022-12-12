package wi.com.wisnop.common.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.ModelAndViewDefiningException;
import org.springframework.web.servlet.HandlerInterceptor;

import wi.com.wisnop.common.webutil.SessionUtil;

public class CommonInterceptor implements HandlerInterceptor {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		
		logger.info("Request URL : {}", request.getRequestURL());
		/*
        logger.info("Method URL : {}", request.getMethod());
        logger.info("QueryString : {}", request.getQueryString());
        */
        
        String reqUrl = request.getRequestURL().toString();
        HttpSession session = request.getSession(false);
        
        //요청 URL이 로그인일경우  
        if (!reqUrl.contains("/login/goPortal") && (reqUrl.contains("/login/") || reqUrl.contains("/common/getDomainMsg"))) {
    		logger.info("+login+++++++++++++++++++++++++++");
//    		if (session != null){
//	    		logger.info("token session remove!!!");
//    		  	request.setAttribute("loginUser", null);
//    		}
    		return true;
    	}
        
        if (!this.checkSession()) {
        	//AJAX 인지 판단
        	if (isAjaxRequest(request)) {
        		logger.info("+AJAX+++++++++++++++++++++++++++");
        		throw new Exception("msg.sessionFire"); //NOPMD
        	} else {
        		logger.info("+FORM SUBMIT+++++++++++++++++++++++++++");
    			throw new ModelAndViewDefiningException(new ModelAndView("login/sessionFire"));
        	}
	    }
        
	    return true;
	}
	
	@Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
            ModelAndView modelAndView) throws Exception {
	}
	
	@Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
            throws Exception {
    }
	
	private boolean checkSession() {
		try {
			if (StringUtils.isEmpty(SessionUtil.getUserId())) return false;
			else return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
	
	private boolean isAjaxRequest(HttpServletRequest req) {
		String ajaxHeader = "AJAX";
		return req.getHeader(ajaxHeader) != null && req.getHeader(ajaxHeader).equals(Boolean.TRUE.toString());
	}
	
}
