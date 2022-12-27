package wi.com.wisnop.controller.th;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

//import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;
import org.thymeleaf.util.StringUtils;

import lombok.RequiredArgsConstructor;
//import lombok.RequiredArgsConstructor;
import wi.com.wisnop.common.constant.Namespace;
import wi.com.wisnop.common.webutil.CommUtil;
import wi.com.wisnop.common.webutil.SessionUtil;
import wi.com.wisnop.dto.common.UserVO;
import wi.com.wisnop.security.dto.UserDetailsDto;
import wi.com.wisnop.service.common.CommonService;
//import wi.com.wisnop.service.common.CommonService;
//import wi.com.wisnop.service.common.LoginService;
import wi.com.wisnop.service.common.LoginService;

@Controller
@RequestMapping(value = "/th/auth")
@RequiredArgsConstructor
//@Slf4j
public class AuthController {

    private final CommonService commonService;
    private final LoginService loginService;
    
    @Value("${props.devMode}")
    private String devMode;	

    @GetMapping("/login")
    public ModelAndView loginView(@AuthenticationPrincipal UserVO uservo) {
//    	if (uservo != null && !StringUtils.isEmpty(uservo.getUserId())) return "redirect:/home";
//    	else return "th/auth/login";
    	
    	ModelAndView mav = new ModelAndView();
    	mav.setViewName("th/auth/login");
    	return mav;
    }
    
    @GetMapping("/sessionFire")
    public String sessionFire() {
    	return "th/auth/sessionexpired";
    }
    
    @GetMapping("/loginFailed")
    public String lginFailed() {
    	return "th/auth/loginFailed";
    }
    
    @RequestMapping(value = "/loginAfter")
	public ModelAndView submit(@AuthenticationPrincipal UserDetailsDto userDto,
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		
    	ModelAndView mav = new ModelAndView();
		String userId    = userDto.getUserId();
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		rtnMap.put("userId", userId);
		
		//1.로그인 ---------------------------------
		paramMap.put("userId" ,userId);
		setSNOPLogin(request, mav, paramMap, rtnMap, userDto);
    	mav.addObject("loginMap",rtnMap);
    	
//    	mav.setViewName("th/auth/login");
    	mav.setViewName("redirect:/th/auth/goPortal");

    	return mav;
	}
    
    @RequestMapping(value = "/logout")
	public ModelAndView logout(HttpServletRequest request) {
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName("th/auth/login");
		
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
//		commonService.saveInsert(Namespace.COMMON_SSCD+"userLog", paramMap);
		
		mav.setViewName("th/auth/portal");
		return mav;
	}
    
    private void setSNOPLogin(HttpServletRequest request, ModelAndView mav, 
			Map<String, Object> paramMap, Map<String, Object> rtnMap, UserDetailsDto userDto) throws Exception {
		paramMap.put("userPw"    ,userDto.getUserPw());
		
//		//user 정보조회
		UserVO userVo = loginService.getLogin(paramMap);
		
		//사용자 아이디가 없음
//    	if (userVo == null || StringUtils.isEmpty(userVo.getUserId())) {
//    		rtnMap.put("errCode", -1);
//    		rtnMap.put("errMsg", "로그인 사용자가 없습니다.");
//    		
//    	} else {
    		//비밀번호 일치
//			if ("Y".equals(userVo.getPwCompareYn())) {
				setSessionInit(request, userVo, mav, paramMap, userDto);
				mav.setViewName("redirect:/th/auth/goPortal");

//			} else if (StringUtils.isEmpty(userVo.getPwd())) {
//				rtnMap.put("errCode", -3);
//				rtnMap.put("errMsg", "최초등록자용자입니다. 패스워드를 한번더 입력해주십시오.");
//				rtnMap.put("userPw", paramMap.get("userPw").toString());
//					
//			} else {
//				rtnMap.put("errCode", -1);
//				rtnMap.put("errMsg", "비밀번호가 다릅니다.");
//			}
//    	}
	}
    
    //세션 초기화 및 재정의
  	private void setSessionInit(HttpServletRequest request, UserVO userVo
  			, ModelAndView mav, Map<String, Object> paramMap, UserDetailsDto userDto) throws Exception {
  		
//  		HttpSession session = request.getSession();
//  		session.invalidate(); //세션 삭제
//  		SessionUtil.getSessionDestory(); //세션 삭제
  		
  		//개발모드 설정
  		SessionUtil.setAttribute(Namespace.DEV_MODE ,devMode);
  		SessionUtil.setAttribute(Namespace.LOGIN_TYPE ,"PC");
  		
  		//언어설정
  		Locale lo = null;
  		//step. 파라메터에 따라서 로케일 생성, 기본은 KOREAN
  		if (StringUtils.isEmpty(userDto.getLangCd())) {
  			lo = Locale.ENGLISH;
  		} else {
  			lo = new Locale(userDto.getLangCd());
  		}
  		
  		SessionUtil.setAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME, lo);
  		SessionUtil.setAttribute(Namespace.LANG, userDto.getLangCd());
  		
  		//user info
  		SessionUtil.setAttribute(Namespace.USER_ID, userDto.getUserId());
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
    
}
