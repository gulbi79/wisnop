package wi.com.wisnop.controller.th;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.MessageSource;
import org.springframework.context.support.DelegatingMessageSource;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;
import org.thymeleaf.util.StringUtils;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import wi.com.wisnop.common.constant.Namespace;
import wi.com.wisnop.common.message.DatabaseDrivenMessageSource;
import wi.com.wisnop.common.webutil.CommUtil;
import wi.com.wisnop.common.webutil.SessionUtil;
import wi.com.wisnop.dto.common.MenuVO;
import wi.com.wisnop.dto.common.UserVO;
import wi.com.wisnop.security.dto.UserDetailsDto;
import wi.com.wisnop.service.common.CommonService;
import wi.com.wisnop.service.common.LoginService;


/**
 * Handles requests for the application home page.
 */
@Slf4j
@RequiredArgsConstructor
@Controller
@RequestMapping(value="/th/common")
public class MainController {

	@Value("${props.devMode}")
    private String devMode;	
	
    private final CommonService commonService;
    private final LoginService loginService;
	private final MessageSource messageSource;

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
    	
    	mav.setViewName("redirect:/th/common/goPortal");

    	return mav;
	}
    
    private void setSNOPLogin(HttpServletRequest request, ModelAndView mav, 
			Map<String, Object> paramMap, Map<String, Object> rtnMap, UserDetailsDto userDto) throws Exception {
		paramMap.put("userPw"    ,userDto.getUserPw());
//		//user 정보조회
		UserVO userVo = loginService.getLogin(paramMap);
		setSessionInit(request, userVo, mav, paramMap, userDto);
	}
    
    //세션 초기화 및 재정의
  	private void setSessionInit(HttpServletRequest request, UserVO userVo
  			, ModelAndView mav, Map<String, Object> paramMap, UserDetailsDto userDto) throws Exception {
  		
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
    
    @RequestMapping(value = "/godashboard", method = RequestMethod.POST)
	public ModelAndView goDashBoard(@RequestParam Map<String, Object> paramMap
			, HttpServletRequest request, HttpServletResponse response) throws Exception {

		Locale lo = null;
		ModelAndView mav = new ModelAndView();

		String userLang 	= (String) (ObjectUtils.isEmpty(paramMap.get("userLang")) ? SessionUtil.getAttribute(Namespace.LANG) : paramMap.get("userLang"));
		String company 		= (String) (ObjectUtils.isEmpty(paramMap.get("company")) ? SessionUtil.getAttribute(Namespace.COMPANY) : paramMap.get("company"));
		String bu 			= (String) (ObjectUtils.isEmpty(paramMap.get("bu")) ? SessionUtil.getAttribute(Namespace.BU) : paramMap.get("bu"));
		String userTimeInt 	= ObjectUtils.isEmpty(paramMap.get("userTimeInt")) ? "0" : paramMap.get("userTimeInt").toString();

		//step. 파라메터에 따라서 로케일 생성, 기본은 KOREAN
		if (ObjectUtils.isEmpty(userLang)) {
			lo = Locale.ENGLISH;
		} else {
			lo = new Locale(userLang);
		}

		//step. company, bu 설정
		SessionUtil.setAttribute(Namespace.LANG, userLang);
		SessionUtil.setAttribute(Namespace.COMPANY, company);
		SessionUtil.setAttribute(Namespace.BU, bu);
		SessionUtil.setAttribute(Namespace.TIMER, userTimeInt);

		//step. Locale 설정.
		SessionUtil.setAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME, lo);
		
		//locale 정보 저장 
		commonService.saveUpdate(Namespace.LOGIN_SSCD+"userLangCd", paramMap);
		
		paramMap.put("sqlId", Namespace.COMMON_SSCD+"currWeek");
		mav.addObject("currWeek",commonService.getList(paramMap));

		paramMap.put("sqlId", Namespace.LOGIN_SSCD+"menu");
		mav.addObject("menuList",commonService.getList(paramMap));

		paramMap.put("sqlId", Namespace.COMMON_SSCD+"userCompany");
		mav.addObject("userCompanyList",commonService.getList(paramMap));

		paramMap.put("sqlId", Namespace.COMMON_SSCD+"userBu");
		mav.addObject("userBuList",commonService.getList(paramMap));

		paramMap.put("sqlId","dashboard.supply.isSalesTeam");
		List<Object> isSalesTeamList = commonService.getList(paramMap);
		SessionUtil.setAttribute("isSalesTeam",isSalesTeamList);
		
		mav.setViewName("th/frame/layout");
		return mav;
	}
    
    @RequestMapping(value="/menuList", method=RequestMethod.POST)
	public @ResponseBody HashMap<String,Object> getMenuList(@RequestParam Map<String, Object> paramMap
			, HttpServletRequest request, HttpServletResponse response) throws Exception {

		HashMap<String,Object> hm = new HashMap<String,Object>();
		paramMap.put("sqlId", Namespace.LOGIN_SSCD+"menu");
		hm.put("rtnList" ,commonService.getList(paramMap));
        return hm;
	}
    
    @RequestMapping(value = "/goFrame", method = RequestMethod.POST)
	public ModelAndView goFrame(@RequestParam Map<String, Object> paramMap) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("th/frame/tab_frame");
		mav.addObject("paramMap",paramMap);
		return mav;
	}
    
    @RequestMapping(value = "/goHome", method = RequestMethod.POST)
	public ModelAndView goHome(@RequestParam Map<String, Object> paramMap
			, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		//mav.setViewName("layout/home");
		
		MenuVO menuInfo = new MenuVO();
		menuInfo.setFrameMenuCd("HOME");
		
		mav.addObject("menuInfo", menuInfo);
		mav.setViewName("th/dashboard/summary");
		return mav;
	}
    
    @RequestMapping(value = "/goMenu", method = RequestMethod.POST)
	public ModelAndView goMenu(@RequestParam Map<String, Object> paramMap
			, HttpServletRequest request, HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();

		//UI 마스터에서 해당 화면에 사용될 기본 정보를 조회한다.
		//1. dimension 사용여부 2. measure 사용여부 3. chart 사용여부 4. excel 사용여부
		paramMap.put("sqlId",Namespace.COMMON_SSCD+"uiMaster");
		MenuVO menuInfo = commonService.getOne(paramMap);
		
		//권한없는 페이지 처리
		if (menuInfo == null || ObjectUtils.isEmpty(menuInfo.getUrl())) {
			mav.setViewName("th/error/commonException");
		} else {
			
			//thymeleaf 페이지로 이동
			menuInfo.setUrl("th/"+menuInfo.getUrl());
			
			//접속로그 처리
			paramMap.put("ACCESS_TYPE_CD", "MENU");
			paramMap.put("URL", menuInfo.getUrl());

			paramMap.put("CLIENT_HOST", " ");
			paramMap.put("CLIENT_ADDR", CommUtil.getClientIpAddr(request));
			commonService.saveInsert(Namespace.COMMON_SSCD+"userLog", paramMap);

			menuInfo.setFrameMenuCd(paramMap.get("frameMenuCd").toString());

			log.info("MENU URL : {}",menuInfo.getUrl());
			
			mav.setViewName(menuInfo.getUrl());
			mav.addObject("menuInfo", menuInfo);
			mav.addObject("paramMap", paramMap);
		}

		return mav;
	}
    
    /**
	 * 공통팝업 처리
	 */
	@RequestMapping(value = "/popup/{popupGubun}")
	public ModelAndView goPopup(@PathVariable("popupGubun") String popupGubun, @RequestParam Map<String, Object> paramMap
			, HttpServletRequest request, HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();
		mav.addObject(popupGubun, paramMap);
		return mav;
	}
	
	@RequestMapping(value = "/locale/applyLocale", method= RequestMethod.POST)
    public @ResponseBody Map<String, Object> applyLocale(HttpServletRequest request, HttpServletResponse response) throws Exception {
		if (messageSource instanceof DatabaseDrivenMessageSource) {
			((DatabaseDrivenMessageSource)messageSource).reload();
		} else if (messageSource instanceof DelegatingMessageSource) {
			DelegatingMessageSource myMessage = ((DelegatingMessageSource)messageSource);
			if (myMessage.getParentMessageSource() != null && myMessage.getParentMessageSource() instanceof DatabaseDrivenMessageSource) {
				((DatabaseDrivenMessageSource) myMessage.getParentMessageSource()).reload();
			}
		}
		Map<String,Object> hm = new HashMap<String,Object>();
		hm.put("errMsg", "success");
		return hm;
    }
}
