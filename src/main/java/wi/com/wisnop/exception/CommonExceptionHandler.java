package wi.com.wisnop.exception;

import java.util.HashMap;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.MessageSource;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

import wi.com.wisnop.common.webutil.SessionUtil;

@ControllerAdvice
public class CommonExceptionHandler {

	private final Logger logger = LoggerFactory.getLogger(CommonExceptionHandler.class);

	@Autowired
    private MessageSource messageSource;
	
	@Value("${props.SERVER_FILE_MAX}")
    private long SERVER_FILE_MAX;	
	
	@ExceptionHandler(Exception.class)
	public @ResponseBody HashMap<String, Object> handleExceptionHandler(Exception e, HttpServletResponse res) {
		HashMap<String, Object> hm = new HashMap<String, Object>();

		logger.info("CommonExceptionHandler ===============");
		e.printStackTrace();
		
		try {
			if ("msg.sessionFire".equals(e.getMessage())) {
				hm.put("errCode", -1);
				hm.put("errMsg", e.getMessage());
			/*
			} else if (e.getCause() != null && e.getCause().getCause() != null 
					&& e.getCause().getCause() instanceof QueryLogException) {
				QueryLogException queryLogEx = (QueryLogException) e.getCause().getCause();
				logger.info("QueryLogException11 is {}", queryLogEx.getErrMsg());
				hm.put("errCode", -777777);
				hm.put("errMsg", queryLogEx.getErrMsg());
			} else if (e.getCause() != null && e.getCause().getCause() != null && e.getCause().getCause().getCause() != null 
					&& e.getCause().getCause().getCause() instanceof QueryLogException) {
				QueryLogException queryLogEx = (QueryLogException) e.getCause().getCause().getCause();
				logger.info("QueryLogException22 is {}", queryLogEx.getErrMsg());
				hm.put("errCode", -777777);
				hm.put("errMsg", queryLogEx.getErrMsg());
			*/
			} else {
				hm.put("errCode", -1);
				hm.put("errMsg", "msg.systemError");
			}
		} catch (Exception ext) {
			logger.info("ext ======================");
			try {
				ext.printStackTrace();
				hm.put("errCode", -1);
				hm.put("errMsg", "msg.systemError");
			} catch(Exception exte) {
				logger.info("exte ======================");
				exte.printStackTrace();
				hm.put("errCode", -1);
				hm.put("errMsg", "msg.systemError");
			}
		}
		
		return hm;
	}

	@ExceptionHandler(MaxUploadSizeExceededException.class)
	public @ResponseBody HashMap<String, Object> exceededExceptionHandler(Exception e, HttpServletRequest req, HttpServletResponse res) {
		logger.info("exceededExceptionHandler ==============="+ SERVER_FILE_MAX);
		HashMap<String, Object> hm = new HashMap<String, Object>();
		String msg = "msg.maxUploadSizeInfo";
		try {
			msg = messageSource.getMessage(msg, new String[]{(SERVER_FILE_MAX / 1024 / 1024)+""}, (Locale)SessionUtil.getAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME));
		} catch (Exception e1) {
			e1.printStackTrace();
		}
		hm.put("errCode", -1);
		hm.put("errMsg", msg);
//		hm.put("errParams", SERVER_FILE_MAX / 1024 / 1024);
		//hm.put("errMsg", "업로드 파일용량은  "+ (SERVER_FILE_MAX / 1024 / 1024) + "MB 까지 가능합니다.");
		
		return hm;
	}

	/*
	@ExceptionHandler(FileNotFoundException.class)
	public @ResponseBody HashMap<String, Object> fileNotFoundException(Exception e, HttpServletRequest req, HttpServletResponse res) {
		logger.info("fileNotFoundException ===============");
		HashMap<String, Object> hm = new HashMap<String, Object>();
		hm.put("errCode", -1);
		hm.put("errMsg", e.getMessage());
		
		return hm;
	}
	*/
}
