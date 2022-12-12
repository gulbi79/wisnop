package wi.com.wisnop.controller.common;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import wi.com.wisnop.common.webutil.SharedInfoHolder;
import wi.com.wisnop.service.common.BizService;

/**
 * Handles requests for the application home page.
 */
@RestController
@RequestMapping(value = "/biz")
public class BizController {
	
    @Autowired
    private BizService bizService;

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/obj", method = RequestMethod.POST)
	public HashMap<String,Object> obj(@RequestBody Map<String, Object> paramMap
			, HttpServletRequest request, HttpServletResponse response) throws Exception {
			
		HashMap<String,Object> hm = new HashMap<String,Object>();
		Object bean = bizService;
		Method method = getMethod(bean,(String)paramMap.get("_mtd"));
		
		try {
			hm = (HashMap<String,Object>) method.invoke(bean, paramMap);
			if (!StringUtils.isEmpty(paramMap.get("sql")) && "Y".equals(paramMap.get("sql"))) {
				hm.put("errCode", -777777);
				hm.put("errMsg", SharedInfoHolder.getJobSql());
				SharedInfoHolder.setJobType("N"); //초기화
				SharedInfoHolder.setInitJobSql();
			}
			
		} catch (InvocationTargetException e) {
			throw new Exception(e.getCause());
		}
		
		return hm;
	}
	
	private Method getMethod (Object bean, String methodName) throws Exception {
		Method[] methods = bean.getClass().getMethods();
		
		for (int i=0; i<methods.length; i++) {
			if (methods[i].getName().equals(methodName)) {
				return methods[i];
			}
		}
		
		throw new Exception ("Cann't find " + methodName + "."); //NOPMD
	}
	
}
