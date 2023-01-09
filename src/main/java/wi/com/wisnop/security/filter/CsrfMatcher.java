package wi.com.wisnop.security.filter;

import javax.servlet.http.HttpServletRequest;

import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.security.web.util.matcher.RequestMatcher;

public class CsrfMatcher implements RequestMatcher{
	
    private AntPathRequestMatcher[] requestMatchers = {
		new AntPathRequestMatcher("/th/**")
    };
    
    @Override
    public boolean matches(HttpServletRequest request) {
        for (AntPathRequestMatcher rm : requestMatchers) {
        	return !rm.matches(request);
        }
        return true;
    }
}