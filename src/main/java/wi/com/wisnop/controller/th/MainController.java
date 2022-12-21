package wi.com.wisnop.controller.th;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.ObjectUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

import lombok.extern.slf4j.Slf4j;
import wi.com.wisnop.common.constant.Namespace;
import wi.com.wisnop.common.webutil.CommUtil;
import wi.com.wisnop.common.webutil.SessionUtil;
import wi.com.wisnop.dto.common.MenuVO;
import wi.com.wisnop.service.common.CommonService;


/**
 * Handles requests for the application home page.
 */
@Slf4j
@Controller
@RequestMapping(value="/th/common")
public class MainController {

    @Autowired
    private CommonService commonService;

    @Autowired
    private MessageSource messageSource;
    
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
		
		mav.setViewName("th/layout/layout");
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
		mav.setViewName("th/layout/tab_frame");
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
    
    
	
	
	
    
    
    

	@RequestMapping(value = "/main", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		return "index";
	}

	@RequestMapping(value = "/layout", method = RequestMethod.GET)
	public String layout(Locale locale, Model model) {
		return "common/layout";
	}
	

	@RequestMapping(value="/subMenuList", method=RequestMethod.POST)
	public @ResponseBody HashMap<String,Object> getSubMenuList(@RequestParam Map<String, Object> paramMap
			, HttpServletRequest request, HttpServletResponse response) throws Exception {

		HashMap<String,Object> hm = new HashMap<String,Object>();
		paramMap.put("sqlId", Namespace.COMMON_SSCD+"uiSubMaster");
		hm.put("rtnList" ,commonService.getList(paramMap));
        return hm;
	}

	

	@RequestMapping(value="/menuInit", method=RequestMethod.POST)
	public @ResponseBody HashMap<String,Object> getMenuInit(@RequestParam Map<String, Object> paramMap
			, HttpServletRequest request, HttpServletResponse response) throws Exception {

		HashMap<String,Object> hm = new HashMap<String,Object>();
		if ("Y".equals(paramMap.get("dimensionYn").toString())) {
			paramMap.put("sqlId", Namespace.COMMON_SSCD+"dimension");
			hm.put("dimList" ,commonService.getList(paramMap));
		}
		if ("Y".equals(paramMap.get("measureYn").toString())) {
			paramMap.put("sqlId", Namespace.COMMON_SSCD+"measure");
			hm.put("meaList" ,commonService.getList(paramMap));
		}
		return hm;
	}

	@RequestMapping(value="/hrcy", method=RequestMethod.POST)
	public @ResponseBody HashMap<String,Object> getHrcy(@RequestParam Map<String, Object> paramMap
			, HttpServletRequest request, HttpServletResponse response) throws Exception {

		HashMap<String,Object> hm = new HashMap<String,Object>();

		if (!StringUtils.isEmpty(paramMap.get("producthrcyYn")) && "Y".equals(paramMap.get("producthrcyYn").toString())) {
			paramMap.put("sqlId", Namespace.COMMON_SSCD+"producthrcy");
			hm.put("producthrcyList" ,commonService.getList(paramMap));
		}

		if (!StringUtils.isEmpty(paramMap.get("customerhrcyYn")) && "Y".equals(paramMap.get("customerhrcyYn").toString())) {
			paramMap.put("sqlId", Namespace.COMMON_SSCD+"customerhrcy");
			hm.put("customerhrcyList" ,commonService.getList(paramMap));
		}

		if (!StringUtils.isEmpty(paramMap.get("salesOrghrcyYn")) && "Y".equals(paramMap.get("salesOrghrcyYn").toString())) {
			paramMap.put("sqlId", Namespace.COMMON_SSCD+"salesOrghrcy");
			hm.put("salesOrghrcyList" ,commonService.getList(paramMap));
		}

		return hm;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value="/bucketInit", method=RequestMethod.POST)
	public @ResponseBody HashMap<String,Object> getBucketInit(@RequestBody Map<String, Object> paramMap
			, HttpServletRequest request, HttpServletResponse response) throws Exception {

		HashMap<String,Object> hm = new HashMap<String,Object>();
		List<String> sqlList = (ArrayList<String>)paramMap.get("sqlId");
		int i = 1;
		for (String sqlId : sqlList) {
			if (sqlId.indexOf(".") > -1) {
				paramMap.put("sqlId", sqlId);
			} else {
				paramMap.put("sqlId", Namespace.COMMON_SSCD+sqlId);
			}
			hm.put("bucket"+(i++)+"List" ,commonService.getList(paramMap));
		}
		return hm;
	}

	@RequestMapping(value="/CRUD", method=RequestMethod.POST)
	public @ResponseBody HashMap<String,Object> CRUD(@RequestBody Map<String, Object> paramMap
			, HttpServletRequest request, HttpServletResponse response) throws Exception {

		HashMap<String,Object> hm = new HashMap<String,Object>();
		int rtnInt = 0;
			
		commonService.saveUpdate((String)paramMap.get("sqlId"), paramMap);
		rtnInt++;
		hm.put("outDs", rtnInt);
		
		return hm;
	}
	
	
	@RequestMapping(value="/getDomainMsg", method=RequestMethod.POST)
	public @ResponseBody HashMap<String,Object> getDomainMsg(@RequestParam Map<String, Object> paramMap
			, HttpServletRequest request, HttpServletResponse response) throws Exception {

		HashMap<String,Object> hm = new HashMap<String,Object>();
		String msgKey   = paramMap.get("msgKey").toString();
		String msgParams = StringUtils.isEmpty(paramMap.get("msgParams")) ? "" : paramMap.get("msgParams").toString();
		String[] params = StringUtils.tokenizeToStringArray(msgParams, "|");

		hm.put("rtnMsg" ,messageSource.getMessage(msgKey, params, (Locale)SessionUtil.getAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME)));
		return hm;
	}
}
