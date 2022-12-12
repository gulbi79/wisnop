package wi.com.wisnop.controller.common;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import wi.com.wisnop.common.constant.Namespace;
import wi.com.wisnop.dto.common.MenuVO;
import wi.com.wisnop.service.common.CommonService;

/**
 * Handles requests for the application home page.
 */
@Controller
@RequestMapping({"admin", "/dp", "/snop", "/master", "/bsc", "/supply", "/dashboard", "/aps"})
public class PopupController {
	@Autowired
    private CommonService commonService;
	
	/**
	 * 공통팝업 처리
	 */
	@RequestMapping(value = "/popup/{popupGubun}")
	public ModelAndView goPopup(@PathVariable("popupGubun") String popupGubun, @RequestParam Map<String, Object> paramMap
			, HttpServletRequest request, HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();
		
		paramMap.put("sqlId",Namespace.COMMON_SSCD+"uiMaster");
		MenuVO menuInfo = commonService.getOne(paramMap);
		
		mav.addObject("menuInfo", menuInfo);
		mav.addObject(popupGubun, paramMap);
		return mav;
	}

	/**
	 * 공통팝업 처리
	 */
	@RequestMapping(value = "/{popupRoot}/popup/{popupGubun}")
	public ModelAndView goPopup(@PathVariable("popupRoot") String popupRoot, @PathVariable("popupGubun") String popupGubun, @RequestParam Map<String, Object> paramMap
			, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		
		paramMap.put("sqlId",Namespace.COMMON_SSCD+"uiMaster");
		MenuVO menuInfo = commonService.getOne(paramMap);
		
		mav.addObject("menuInfo", menuInfo);
		mav.addObject(popupGubun, paramMap);
		return mav;
	}
}
