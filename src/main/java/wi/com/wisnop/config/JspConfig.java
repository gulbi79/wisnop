package wi.com.wisnop.config;

import java.util.Collections;

import org.apache.catalina.Context;
import org.apache.tomcat.util.descriptor.web.JspConfigDescriptorImpl;
import org.apache.tomcat.util.descriptor.web.JspPropertyGroup;
import org.apache.tomcat.util.descriptor.web.JspPropertyGroupDescriptorImpl;
import org.springframework.boot.web.embedded.tomcat.TomcatServletWebServerFactory;
import org.springframework.boot.web.servlet.ServletRegistrationBean;
import org.springframework.boot.web.servlet.server.ConfigurableServletWebServerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.DispatcherServlet;

@Configuration
public class JspConfig {
	@Bean
    public ConfigurableServletWebServerFactory configurableServletWebServerFactory() {
        return new TomcatServletWebServerFactory() {
        
            @Override
            protected void postProcessContext(Context context) {
                super.postProcessContext(context);
                JspPropertyGroup jspPropertyGroup = new JspPropertyGroup();
                jspPropertyGroup.addUrlPattern("*.jsp");
                jspPropertyGroup.setPageEncoding("UTF-8");
                jspPropertyGroup.setScriptingInvalid("false");
                jspPropertyGroup.addIncludePrelude("/WEB-INF/view/common/common.jsp");
                jspPropertyGroup.setTrimWhitespace("true");
                jspPropertyGroup.setDefaultContentType("text/html");
                JspPropertyGroupDescriptorImpl jspPropertyGroupDescriptor = new JspPropertyGroupDescriptorImpl(
                        jspPropertyGroup);
                context.setJspConfigDescriptor(new JspConfigDescriptorImpl(
                        Collections.singletonList(jspPropertyGroupDescriptor), Collections.emptyList()));
            }
        };
    }
	
	/*
	@Bean
	public ServletRegistrationBean<DispatcherServlet> appServletBean() {
	    ServletRegistrationBean<DispatcherServlet> registrationBean = new ServletRegistrationBean<DispatcherServlet>(new DispatcherServlet());
	    registrationBean.addUrlMappings("/biz/*.do");
        registrationBean.addInitParameter("isAbsolutePath", "true");
        registrationBean.addInitParameter("propertyPath", "src/main/resources/public/rd/");
		
        return registrationBean;
	}
	*/
}
