package wi.com.wisnop.controller.th;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping(value = "/th/auth")
@RequiredArgsConstructor
//@Slf4j
public class AuthController {

	@RequestMapping("/login")
    public String loginView() {
    	return "th/auth/login";
    }
    
    @GetMapping("/sessionFire")
    public String sessionFire() {
    	return "th/auth/sessionexpired";
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
    
}
