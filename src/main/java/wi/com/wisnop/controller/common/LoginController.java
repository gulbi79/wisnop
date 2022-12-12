package wi.com.wisnop.controller.common;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

import wi.com.wisnop.common.constant.Namespace;
import wi.com.wisnop.common.webutil.CommUtil;
import wi.com.wisnop.common.webutil.SessionUtil;
import wi.com.wisnop.dto.common.UserVO;
import wi.com.wisnop.service.common.CommonService;
import wi.com.wisnop.service.common.LoginService;


/**
 * Handles requests for the application home page.
 */
@Controller
@RequestMapping(value = "/login")
public class LoginController {
	
    @Autowired
    private CommonService commonService;

    @Autowired
    private LoginService loginService;
    
    @Autowired
	//private EpService epService;
	
    @Value("${props.devMode}")
    private String devMode;	

	/**
	 * Simply selects the home view to render by returning its name.
	 * @throws Exception 
	 */
	@RequestMapping(value = "/form", method = RequestMethod.GET)
	public ModelAndView login(@RequestParam Map<String, Object> paramMap,
			Locale locale, Model model,
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName("login/login");
		
		HttpSession session = request.getSession();
		session.invalidate(); //세션 삭제
		
		//쿠키값이 있으면 쿠키값으로 로그인처리
		String snopCookieId  = getCookieVal(request,"snopCookieId");
		String snopCookiePwd = getCookieVal(request,"snopCookiePwd");
		if (!StringUtils.isEmpty(snopCookieId) && !StringUtils.isEmpty(snopCookiePwd)) {
			paramMap.put("loginType" ,"SNOP");
			paramMap.put("userId"    ,snopCookieId);
			paramMap.put("userPw"    ,snopCookiePwd);
			paramMap.put("userPwCfn" ,"");
			mav = setLoginSession(paramMap,request);
		} else {
			Map<String, Object> rtnMap = new HashMap<String, Object>();
			rtnMap.put("errCode", -2);
			rtnMap.put("errMsg", "LOGIN FAILED.");
			mav.addObject("loginMap",rtnMap);
		}
		
		return mav;
		
	}
	
	@RequestMapping(value = "/logout", method = RequestMethod.POST)
	public ModelAndView logout(HttpServletRequest request) {
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName("login/login");
		
		//세션 삭제
		HttpSession session = request.getSession();
		session.invalidate(); //세션 삭제
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		mav.addObject("loginMap",rtnMap);
		
		return mav;
	}

	@RequestMapping(value = "/goPortal", method = RequestMethod.GET)
	public ModelAndView goPortal(HttpServletRequest request) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		//접속로그 처리
		paramMap.put("ACCESS_TYPE_CD", "PORTAL");
		paramMap.put("menuCd", "PORTAL");
		paramMap.put("URL", "");

		paramMap.put("CLIENT_HOST", " ");
		paramMap.put("CLIENT_ADDR", CommUtil.getClientIpAddr(request));
		commonService.saveInsert(Namespace.COMMON_SSCD+"userLog", paramMap);
		
		mav.setViewName("login/portal");
		return mav;
	}

	@RequestMapping(value = "/sessionFire", method = RequestMethod.GET)
	public String sessionFire(Locale locale, Model model) {
		return "login/sessionFire";
	}

	@RequestMapping(value = "/submit", method = RequestMethod.POST)
	public ModelAndView submit(@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ModelAndView mav = setLoginSession(paramMap,request);
		
		//쿠키생성
		if (StringUtils.isEmpty(SessionUtil.getUserId()) || paramMap.get("chkAutoLogin") == null) {
			setCookieVal(response, "snopCookieId", null, 0);
			setCookieVal(response, "snopCookiePwd", null, 0);
		} else {
			if ("on".equals(paramMap.get("chkAutoLogin"))) {
				setCookieVal(response, "snopCookieId", paramMap.get("userId").toString(), 365*60*60*240);
				setCookieVal(response, "snopCookiePwd", paramMap.get("userPw").toString(), 365*60*60*240);
			}
		}
		
		return mav;
	}
	
	private ModelAndView setLoginSession(Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		String userId    = paramMap.get("userId").toString();
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		rtnMap.put("userId", userId);
		mav.setViewName("login/login");
		
		//1.로그인 ---------------------------------
		paramMap.put("userId" ,userId);
		setSNOPLogin(request, mav, paramMap, rtnMap);
        
    	mav.addObject("loginMap",rtnMap);
		return mav;
	}
	
	
	private void setSNOPLogin(HttpServletRequest request, ModelAndView mav, 
			Map<String, Object> paramMap, Map<String, Object> rtnMap) throws Exception {
		paramMap.put("userPw"    ,paramMap.get("userPw").toString());
		paramMap.put("userPwCfn" ,paramMap.get("userPwCfn").toString());
		
		//user 정보조회
		UserVO userVo = loginService.getLogin(paramMap);
		
		//사용자 아이디가 없음
    	if (userVo == null || StringUtils.isEmpty(userVo.getUserId())) {
    		rtnMap.put("errCode", -1);
    		rtnMap.put("errMsg", "로그인 사용자가 없습니다.");
    		
    	} else {
    		//비밀번호 일치
			if ("Y".equals(userVo.getPwCompareYn())) {
				setSessionInit(request, userVo, mav, paramMap);

			} else if (StringUtils.isEmpty(userVo.getPwd())) {
				
				//최초로그인시 패스워드 저장
    			if (!StringUtils.isEmpty(paramMap.get("userPwCfn"))) {
    				
    				//패스워드 유효성 검증처리
    				int rtnI = CommUtil.validationPwd((String)paramMap.get("userPwCfn"));
    				switch(rtnI) {
    					case 0 : 
    						commonService.saveInsert("userPw", paramMap);
    						setSessionInit(request, userVo, mav, paramMap);
    						break;
    					case 1 : 
    						rtnMap.put("errCode", -3);  
    						rtnMap.put("errMsg", "숫자와 영문 대소문자  조합으로 8자리 이상 사용해야 합니다.");
    						rtnMap.put("userPw", paramMap.get("userPw").toString());
    						break; 
    					case 2 : 
    						rtnMap.put("errCode", -3);  
    						rtnMap.put("errMsg", "같은 문자를 3번 이상 사용하실 수 없습니다.");
    						rtnMap.put("userPw", paramMap.get("userPw").toString());
    						break; 
    					case 3 : 
    						rtnMap.put("errCode", -3);  
    						rtnMap.put("errMsg", "연속된 문자를 3번 이상 사용하실 수 없습니다.");
    						rtnMap.put("userPw", paramMap.get("userPw").toString());
    						break; 
    				}
    				
    			} else {
    				
    				rtnMap.put("errCode", -3);
    				rtnMap.put("errMsg", "최초등록자용자입니다. 패스워드를 한번더 입력해주십시오.");
    				rtnMap.put("userPw", paramMap.get("userPw").toString());
    			}
					
			} else {
				rtnMap.put("errCode", -1);
				rtnMap.put("errMsg", "비밀번호가 다릅니다.");
			}
    	}
	}
	
	//세션 초기화 및 재정의
	private void setSessionInit(HttpServletRequest request, UserVO userVo
			, ModelAndView mav, Map<String, Object> paramMap) throws Exception {
		
		HttpSession session = request.getSession();
		session.invalidate(); //세션 삭제
		SessionUtil.getSessionDestory(); //세션 삭제
		
		//개발모드 설정
		SessionUtil.setAttribute(Namespace.DEV_MODE ,devMode);
		SessionUtil.setAttribute(Namespace.LOGIN_TYPE ,"PC");
		
		//언어설정
		Locale lo = null;
		//step. 파라메터에 따라서 로케일 생성, 기본은 KOREAN
		if (StringUtils.isEmpty(userVo.getLangCd())) {
			lo = Locale.ENGLISH;
		} else {
			lo = new Locale(userVo.getLangCd());
		}
		
		SessionUtil.setAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME, lo);
		SessionUtil.setAttribute(Namespace.LANG, userVo.getLangCd());
		
		//user info
		SessionUtil.setAttribute(Namespace.USER_ID, userVo.getUserId());
		SessionUtil.setAttribute(Namespace.USER_INFO, userVo);
		
		paramMap.put("sqlId", Namespace.COMMON_SSCD+"userCompany");
		List<Object> userCompanyList = commonService.getList(paramMap);
		mav.addObject("userCompanyList",userCompanyList);
		SessionUtil.setAttribute(Namespace.COMPANY_LIST, userCompanyList);

		paramMap.put("sqlId", Namespace.COMMON_SSCD+"userBu");
		List<Object> userBuList = commonService.getList(paramMap);
		mav.addObject("userBuList",userBuList);
		SessionUtil.setAttribute(Namespace.BU_LIST, userBuList);
	}
	
	
	private String getCookieVal(HttpServletRequest request, String cookieName) throws Exception {
		
		//쿠키값이 있으면 쿠키값으로 로그인처리
		String cookieVal = null;
		if (!StringUtils.isEmpty(request.getCookies())) {
			for (Cookie cookies : request.getCookies()) {
				if (cookieName.equals(cookies.getName())) {
					cookieVal = cookies.getValue();
					break;
				}
			}
		}
		
		return cookieVal;
	}

	private boolean setCookieVal(HttpServletResponse response, String cookieName, String cValue, int cTime) {
		try {
			Cookie snopCookie = new Cookie(cookieName,cValue);
			snopCookie.setMaxAge(cTime); //24시간
			response.addCookie(snopCookie);
			return true;
		} catch(Exception e) {
			return false;
		}
		
	}
}
