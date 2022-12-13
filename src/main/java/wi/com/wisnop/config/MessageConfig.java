package wi.com.wisnop.config;

import java.util.Locale;

import org.springframework.boot.web.servlet.server.Encoding;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.i18n.AcceptHeaderLocaleResolver;
import org.springframework.web.servlet.i18n.LocaleChangeInterceptor;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

import lombok.RequiredArgsConstructor;
import wi.com.wisnop.common.message.DatabaseDrivenMessageSource;
import wi.com.wisnop.common.message.MessageResourceService;

@Configuration
@RequiredArgsConstructor
public class MessageConfig implements WebMvcConfigurer {
	
	private final MessageResourceService messageResourceService;
	
	@Bean
    public LocaleResolver defaultLocaleResolver() {
        AcceptHeaderLocaleResolver localeResolver = new AcceptHeaderLocaleResolver();
        localeResolver.setDefaultLocale(Locale.ENGLISH);
        
        return localeResolver;
    }

    @Bean("propertiesMessageSource")
    public ReloadableResourceBundleMessageSource messageSource() {
        Locale.setDefault(Locale.ENGLISH); // 제공하지 않는 언어로 들어왔을 때 처리

        ReloadableResourceBundleMessageSource messageSource = new ReloadableResourceBundleMessageSource();
        messageSource.setBasename("classpath:/messages/messages"); 
        messageSource.setDefaultEncoding(Encoding.DEFAULT_CHARSET.toString());
        messageSource.setFallbackToSystemLocale(false);
        messageSource.setDefaultLocale(Locale.getDefault());
        messageSource.setUseCodeAsDefaultMessage(true);
        messageSource.setCacheSeconds(600);

        return messageSource;
    }
    
    @Bean("messageSource")
    public DatabaseDrivenMessageSource databaseDrivenMessageSource () {
    	DatabaseDrivenMessageSource dm = new DatabaseDrivenMessageSource(messageResourceService);
    	dm.setParentMessageSource(messageSource());
        return dm;
    }

    /*
    @Bean
    public MessageSourceAccessor messageSourceAccessor () {
        return new MessageSourceAccessor(messageSource());
    }
    */
    
    // 변경된 언어 정보를 기억할 로케일 리졸버를 생성한다. 여기서는 세션에 저장하는 방식을 사용한다.
    @Bean
    public SessionLocaleResolver localeResolver() {
        SessionLocaleResolver slr = new SessionLocaleResolver();
        slr.setDefaultLocale(Locale.ENGLISH);
        return slr;
    }
    
    /**
     * 언어 변경을 위한 인터셉터를 생성한다.
     */

    // locale 을 변경할수 있는 interceptor 설정
    // 특정 파라미터를 통해 locale 설정을 변경 할 수 있도록 interceptor를 등록, LocaleChangeInterceptor 를
    // 사용
    // xxxx.com/xxx?lang=ko 를 호출하면 한국어로 변경, xxxx.com/lang=en 를 호출하면 영어로 변경
    @Bean
    public LocaleChangeInterceptor localeChangeInterceptor() {
        LocaleChangeInterceptor interceptor = new LocaleChangeInterceptor();
        interceptor.setParamName("lang");
        return interceptor;
    }

    /**
     * 인터셉터를 등록한다.
     */
    // 위에서 생성한 Bean 을 등록한다.
    // WebMvcConfigurer 를 구현하면 해당 method 를 override할 수 있다.
    // 이 코드는 localeChangeInterceptor()를 스프링의 인터셉터 목록에 등록하는 코드다. 이렇게 하지않으면 작동하지않는다.
    @Override // WebMvcConfigurer 가 정의한것을 구현한다.
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(localeChangeInterceptor());
    }
}
