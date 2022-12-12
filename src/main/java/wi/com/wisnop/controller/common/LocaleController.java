package wi.com.wisnop.controller.common;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.support.DelegatingMessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

import wi.com.wisnop.common.constant.Namespace;
import wi.com.wisnop.common.message.DatabaseDrivenMessageSource;
import wi.com.wisnop.common.webutil.SessionUtil;
import wi.com.wisnop.service.common.CommonService;


/**
 * Handles requests for the application locale page.
 */
@Controller
@RequestMapping(value = "/locale")
public class LocaleController {
	
	private final Logger logger = LoggerFactory.getLogger(LocaleController.class);

	@Autowired
	private MessageSource messageSource;

	@Autowired
    private CommonService commonService;
	
	@RequestMapping(value = "/changeLocale")
    public String changeLocale(HttpServletRequest request, HttpServletResponse response, @RequestParam(required = false) String locale) throws Exception {

        HttpSession session = request.getSession();

        Locale lo = null;

        //step. 파라메터에 따라서 로케일 생성, 기본은 KOREAN 
        if (locale.matches("en")) {
        	lo = Locale.ENGLISH;
        } else {
        	lo = Locale.KOREAN;
        }

        SessionUtil.setAttribute(Namespace.LANG, locale);
        
        // step. Locale을 새로 설정한다.
        logger.info("LOCALE_SESSION_ATTRIBUTE_NAME : {}", SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME);
        session.setAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME, lo);
        
        //locale 정보 저장 
        Map<String, Object> paramMap = new HashMap<String, Object>();
      	commonService.saveUpdate(Namespace.LOGIN_SSCD+"userLangCd", paramMap);

        // step. 해당 컨트롤러에게 요청을 보낸 주소로 돌아간다.
        String redirectURL = "redirect:" + request.getHeader("referer");

        return redirectURL;

    }
	
	@RequestMapping(value = "/applyLocale", method= RequestMethod.POST)
    public @ResponseBody Map<String, Object> applyLocale(HttpServletRequest request, HttpServletResponse response) throws Exception {
		reloadDatabaseMessages();
		Map<String,Object> hm = new HashMap<String,Object>();
		hm.put("errMsg", "success");
		return hm;
    }
	
	private void reloadDatabaseMessages() {
		if (messageSource instanceof DatabaseDrivenMessageSource) {
			((DatabaseDrivenMessageSource)messageSource).reload();
		} else if (messageSource instanceof DelegatingMessageSource) {
			DelegatingMessageSource myMessage = ((DelegatingMessageSource)messageSource);
			if (myMessage.getParentMessageSource()!=null && myMessage.getParentMessageSource() instanceof DatabaseDrivenMessageSource) {
				((DatabaseDrivenMessageSource) myMessage.getParentMessageSource()).reload();
			}
		}
	}
	
}
