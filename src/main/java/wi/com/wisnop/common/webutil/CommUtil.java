package wi.com.wisnop.common.webutil;

import java.net.URLEncoder;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;

import wi.com.wisnop.common.constant.Namespace;

public class CommUtil {

	/**
	 * 공통변수 설정
	 * @param inMap
	 * @throws Exception
	 */
	public static void setCommonVar(Map<String, Object> inMap) throws Exception {
		//공통변수 설정
    	inMap.put("GV_USER_ID"    ,SessionUtil.getUserId());
    	inMap.put("GV_COMPANY_CD" ,SessionUtil.getAttribute(Namespace.COMPANY));
    	inMap.put("GV_BU_CD"      ,SessionUtil.getAttribute(Namespace.BU));
    	inMap.put("GV_LANG"       ,SessionUtil.getAttribute(Namespace.LANG));
	}

	/**
	 * 파라미터 설정
	 * @param inMap
	 * @param paramMap
	 * @throws Exception
	 */
	public static void setParamsVar(Map<String, Object> inMap, Map<String, Object> paramMap, List<String> arrGrdNm) throws Exception {
		boolean chkGrd = false;
		for (Map.Entry<String, Object> entry : paramMap.entrySet()) {
			if (arrGrdNm != null) {
				if ("grdData".equals(entry.getKey())) continue;

				for (String grdNm : arrGrdNm) {
					if (grdNm.equals(entry.getKey())) {
						chkGrd = true;
						break;
					}
				}
			}

			//지정한 그리드 데이터면 처리안함
			if (chkGrd) {
				chkGrd = false;
				continue;
			}

			inMap.put(entry.getKey() ,entry.getValue());
		}
	}

	public static String getClientIpAddr(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }
	
	public static String getBrowser(HttpServletRequest request) { 
		String header = request.getHeader("User-Agent"); 
		if (header.indexOf("MSIE") > -1) { 
			return "MSIE"; 
		} else if (header.indexOf("Chrome") > -1) { 
			return "Chrome"; 
		} else if (header.indexOf("Opera") > -1) { 
			return "Opera"; 
		} else if (header.indexOf("Trident/7.0") > -1) { 
			//IE 11 이상 //IE 버전 별 체크 >> Trident/6.0(IE 10) , Trident/5.0(IE 9) , Trident/4.0(IE 8) 
			return "MSIE"; 
		} 
		
		return "Firefox"; 
	}
	
	public static String getDisposition(String filename, String browser) throws Exception { 
		String encodedFilename = null; 
		if (browser.equals("MSIE")) { 
			encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20"); 
		} else if (browser.equals("Firefox")) { 
			encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\""; 
		} else if (browser.equals("Opera")) { 
			encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\""; 
		} else if (browser.equals("Chrome")) { 
			StringBuffer sb = new StringBuffer(); 
			for (int i = 0; i < filename.length(); i++) { 
				char c = filename.charAt(i); 
				if (c > '~') { 
					sb.append(URLEncoder.encode("" + c, "UTF-8")); 
				} else { 
					sb.append(c); 
				} 
			} encodedFilename = sb.toString(); 
		} else { 
			throw new RuntimeException("Not supported browser"); 
		}
		
		return encodedFilename; 
	}
	
	public static int validationPwd(String pw) {
		String rule1 = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$";
		String rule2 = "(.)\\1\\1";
		Matcher m = Pattern.compile(rule1).matcher(pw);
	    if (!m.matches()) {
	        return 1;
	    }

	    Matcher m2 = Pattern.compile(rule2).matcher(pw);
	    if (m2.find()) {
	    	return 2;
	    }
	    
	    if (!stck(pw,3)) {
	    	return 3;
	    }
	    return 0;
	}
	
	public static boolean stck(String str, Integer limit) {
	    int o = 0, d = 0, p = 0, n = 0, l = limit == null ? 3 : limit;
	    for (int i = 0; i < str.length(); i++) {
	        char c = str.charAt(i);
	        if (i > 0 && (p = o - c) > -2 && p < 2 && (n = p == d ? n + 1 : 0) > l - 3) return false;
	        d = p;
	        o = c;
	    }
	    return true;
	}
}
