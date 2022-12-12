package wi.com.wisnop.controller.common;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import wi.com.wisnop.common.constant.Namespace;
import wi.com.wisnop.service.common.CommonService;

/**
 * Handles requests for the application home page.
 */
@RestController
@RequestMapping(value = "/template")
public class TempController {
	
	@SuppressWarnings("unused")
	private final Logger logger = LoggerFactory.getLogger(TempController.class);
	
    @Autowired
    private CommonService commonService;

	@RequestMapping(value = "/menu001", method = RequestMethod.POST)
	public HashMap<String,Object> getMenu001List(@RequestBody Map<String, Object> paramMap
			, HttpServletRequest request, HttpServletResponse response) throws Exception {

		HashMap<String,Object> hm = new HashMap<String,Object>();
		paramMap.put("sqlId", Namespace.COMMON_SSCD+"temp001");
		hm.put("gridList" ,commonService.getList(paramMap));
        return hm;
	}

	@RequestMapping(value = "/menu002", method = RequestMethod.POST)
	public HashMap<String,Object> getMenu002List(@RequestBody Map<String, Object> paramMap
			, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		HashMap<String,Object> hm = new HashMap<String,Object>();
		paramMap.put("sqlId", Namespace.COMMON_SSCD+"temp002");
		hm.put("gridList" ,commonService.getList(paramMap));
		return hm;
	}

	@RequestMapping(value = "/menu002/saveall", method = RequestMethod.POST)
	public HashMap<String,Object> saveAll(@RequestBody Map<String, Object> paramMap
			, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		HashMap<String,Object> hm = new HashMap<String,Object>();
		paramMap.put("sqlId", Namespace.COMMON_SSCD+"temp");
		hm.put("saveCnt" ,commonService.saveAll(paramMap));
		return hm;
	}
	
}
