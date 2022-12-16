package wi.com.wisnop.controller.common;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
@RequestMapping(value = "/index2")
public class TestController {
	

	/**
	 * Simply selects the home view to render by returning its name.
	 * @throws Exception 
	 */
	@GetMapping
    public String hello() {
        return "th/test";
    }
	
}
