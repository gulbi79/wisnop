package wi.com.wisnop.controller.common;

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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;
import org.thymeleaf.util.StringUtils;

import lombok.RequiredArgsConstructor;
//import lombok.RequiredArgsConstructor;
import wi.com.wisnop.common.constant.Namespace;
import wi.com.wisnop.common.webutil.CommUtil;
import wi.com.wisnop.common.webutil.SessionUtil;
import wi.com.wisnop.dto.common.UserVO;
import wi.com.wisnop.service.common.CommonService;
//import wi.com.wisnop.service.common.CommonService;
//import wi.com.wisnop.service.common.LoginService;
import wi.com.wisnop.service.common.LoginService;

@Controller
@RequestMapping(value = "/auth")
@RequiredArgsConstructor
//@Slf4j
public class AuthrController {

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
    
    @RequestMapping(value = "/submit", method = RequestMethod.POST)
	public ModelAndView submit(@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		
    	ModelAndView mav = new ModelAndView();
		String userId    = paramMap.get("userId").toString();
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		rtnMap.put("userId", userId);
		mav.setViewName("th/auth/login");
		
		//1.로그인 ---------------------------------
		paramMap.put("userId" ,userId);
		setSNOPLogin(request, mav, paramMap, rtnMap);
        
    	mav.addObject("loginMap",rtnMap);
		return mav;
	}
    
    @RequestMapping(value = "/logout", method = RequestMethod.POST)
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
			Map<String, Object> paramMap, Map<String, Object> rtnMap) throws Exception {
		paramMap.put("userPw"    ,paramMap.get("userPw"));
		
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
				mav.setViewName("redirect:/auth/goPortal");

			} else if (StringUtils.isEmpty(userVo.getPwd())) {
				rtnMap.put("errCode", -3);
				rtnMap.put("errMsg", "최초등록자용자입니다. 패스워드를 한번더 입력해주십시오.");
				rtnMap.put("userPw", paramMap.get("userPw").toString());
					
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
    
    /*

    @GetMapping("/auth/logout")
    public String logoutView() {
    	return "auth/logout";
    }

    @GetMapping("/auth/signup")
    public String signupView() {
        return "auth/signup";
    }

    @PostMapping("/auth/signupProc")
    public String signup(UserVo userVo) {
        userService.joinUser(userVo);
        return "redirect:/auth/login";
    }
    
    @GetMapping("/home")
    public String loginAfterView(@AuthenticationPrincipal UserVo uservo, Model model) {
    	//1.로그인한 유저의 권한에 따른 메뉴 조회
    	HashMap<String,Object> paramMap = new HashMap<String,Object>();
    	paramMap.put("userId", uservo.getUserId());
    	model.addAttribute("menuList", userService.userMenu(paramMap));
    	
        return "layouts/top";
    }

    @GetMapping("/auth/denied")
    public String deniedView() {
        return "auth/denied";
    }

    @GetMapping("/auth/sessionexpired")
    public String sessionexpiredView() {
    	return "auth/sessionexpired";
    }
    
    @SuppressWarnings("unchecked")
	@GetMapping("/page/{menuCd}")
    public String goToInnerView(@PathVariable String menuCd, Model model, @AuthenticationPrincipal UserVo uservo) {
    	String pageUrl = "auth/denied";
    	
    	if (uservo == null || StringUtils.isEmpty(uservo.getUserId())) return "auth/sessionexpired";
    	
    	//화면에서 받은 menu code로 mapping url을 조회 후 해당 화면을 리턴
    	HashMap<String,Object> paramMap = new HashMap<String,Object>();
    	paramMap.put("userId", uservo.getUserId());
    	paramMap.put("menuCd", menuCd);
    	List<HashMap<String, String>> menuList = userService.userMenu(paramMap);
    	
    	if (menuList.size() > 0) {
    		HashMap<String, String> map = menuList.get(0);
    		String url = map.get("url");
    		String tree = map.get("tree");
    		if (url != null && !url.isEmpty()) {
    			pageUrl = url;
    			
    			//tree 조회
    			HashMap<String, Object> treeMap = commonService.selectTree();
    			model.addAllAttributes(treeMap); //salesTree, productTree

    			//ui에서 사용하기 편하게 레벨별로 분기한다.
    			
    			//sales -----------------------
    			if (tree.indexOf(",SALES,") != -1) {
    				List<HashMap<String, String>> salesList = (List<HashMap<String, String>>)treeMap.get("salesTree");
    				model.addAttribute("sales1",salesList.stream().filter(t->"1".equals(String.valueOf(t.get("levelCd")))).collect(Collectors.toList())); //salesTree 1 level
    				model.addAttribute("sales2",salesList.stream().filter(t->"2".equals(String.valueOf(t.get("levelCd")))).collect(Collectors.toList())); //salesTree 2 level
    				model.addAttribute("sales3",salesList.stream().filter(t->"3".equals(String.valueOf(t.get("levelCd")))).collect(Collectors.toList())); //salesTree 3 level
    				model.addAttribute("sales4",salesList.stream().filter(t->"4".equals(String.valueOf(t.get("levelCd")))).collect(Collectors.toList())); //salesTree 4 level
    				model.addAttribute("sales5",salesList.stream().filter(t->"5".equals(String.valueOf(t.get("levelCd")))).collect(Collectors.toList())); //salesTree 5 level
    				
				//product -----------------------
    			} else if (tree.indexOf(",PRODUCT,") != -1) {
    				List<HashMap<String, String>> productList = (List<HashMap<String, String>>)treeMap.get("productTree");
    				
    				model.addAttribute("prod1",productList.stream().filter(t->"1".equals(String.valueOf(t.get("levelCd")))).collect(Collectors.toList())); //productTree 1 level
    				model.addAttribute("prod2",productList.stream().filter(t->"2".equals(String.valueOf(t.get("levelCd")))).collect(Collectors.toList())); //productTree 2 level
    				model.addAttribute("prod3",productList.stream().filter(t->"3".equals(String.valueOf(t.get("levelCd")))).collect(Collectors.toList())); //productTree 3 level
    				model.addAttribute("prod4",productList.stream().filter(t->"4".equals(String.valueOf(t.get("levelCd")))).collect(Collectors.toList())); //productTree 4 level
    				model.addAttribute("prod5",productList.stream().filter(t->"5".equals(String.valueOf(t.get("levelCd")))).collect(Collectors.toList())); //productTree 5 level

    			//plant -----------------------
    			} else if (tree.indexOf(",PLANT,") != -1) {
    				List<HashMap<String, String>> plantList = (List<HashMap<String, String>>)treeMap.get("plantTree");
    				
    				model.addAttribute("plant1",plantList.stream().filter(t->"1".equals(String.valueOf(t.get("levelCd")))).collect(Collectors.toList())); //plantTree 1 level
    				model.addAttribute("plant2",plantList.stream().filter(t->"2".equals(String.valueOf(t.get("levelCd")))).collect(Collectors.toList())); //plantTree 2 level
    				model.addAttribute("plant3",plantList.stream().filter(t->"3".equals(String.valueOf(t.get("levelCd")))).collect(Collectors.toList())); //plantTree 3 level
    				model.addAttribute("plant4",plantList.stream().filter(t->"4".equals(String.valueOf(t.get("levelCd")))).collect(Collectors.toList())); //plantTree 4 level
    				model.addAttribute("plant5",plantList.stream().filter(t->"5".equals(String.valueOf(t.get("levelCd")))).collect(Collectors.toList())); //plantTree 5 level
    			}
    		}
    		model.addAllAttributes(map);
    	}
        return pageUrl;
    }
    */
}
