package wi.com.wisnop.config;

import org.springframework.boot.web.servlet.ServletListenerRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.ProviderManager;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.core.session.SessionRegistry;
import org.springframework.security.core.session.SessionRegistryImpl;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.session.HttpSessionEventPublisher;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

import wi.com.wisnop.security.filter.CustomAuthenticationFilter;
import wi.com.wisnop.security.handler.CustomAuthFailureHandler;
import wi.com.wisnop.security.handler.CustomAuthSuccessHandler;
import wi.com.wisnop.security.handler.CustomAuthenticationProvider;

@Configuration
@EnableWebSecurity
public class SecurityConfig {
	
	/**
     * 1. 정적 자원(Resource)에 대해서 인증된 사용자가  정적 자원의 접근에 대해 ‘인가’에 대한 설정을 담당하는 메서드이다.
     *
     * @return WebSecurityCustomizer
     */
    @Bean
    public WebSecurityCustomizer webSecurityCustomizer() {
        // 정적 자원에 대해서 Security를 적용하지 않음으로 설정
//        return (web) -> web.ignoring().requestMatchers(PathRequest.toStaticResources().atCommonLocations());
    	return (web) -> web.ignoring().mvcMatchers(
                "/static/**",
                "/statics/**" // 임시
        );
    }
	
    /**
     * 2. HTTP에 대해서 ‘인증’과 ‘인가’를 담당하는 메서드이며 필터를 통해 인증 방식과 인증 절차에 대해서 등록하며 설정을 담당하는 메서드이다.
     *
     * @param http HttpSecurity
     * @return SecurityFilterChain
     * @throws Exception Exception
     */
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {

        // 서버에 인증정보를 저장하지 않기에 csrf를 사용하지 않는다.
        http.csrf().disable();

        http.authorizeHttpRequests()
        	.antMatchers("/th/**").authenticated()
        	.anyRequest().permitAll();
        
        // form 기반의 로그인
        http.formLogin()
	        .loginPage("/th/auth/login")
	    	.loginProcessingUrl("/th/auth/submit")
	    	.defaultSuccessUrl("/th/auth/loginAfter", true)
	    	.failureUrl("/th/auth/loginFailed")
			.permitAll(); 

        // Spring Security Custom Filter Load - Form '인증'에 대해서 사용
        http.addFilterBefore(customAuthenticationFilter(), UsernamePasswordAuthenticationFilter.class);

        // [STEP5] Session 기반의 인증설정
        http.sessionManagement()
	        .maximumSessions(1)
	        .maxSessionsPreventsLogin(false)
	        .sessionRegistry(sessionRegistry())
	        .expiredUrl("/th/auth/sessionexpired");
        
        // 로그아웃
    	http.logout()
	    	.logoutRequestMatcher(new AntPathRequestMatcher("/th/auth/logoutProc"))
	    	.logoutSuccessUrl("/th/auth/logout")
//	    	.deleteCookies("JSESSIONID", "remember - me") // 로그아웃 후 해당 쿠키 삭제
	    	.invalidateHttpSession(true);
        
        http.headers()
			.frameOptions().sameOrigin();

        // 최종 구성한 값을 사용함.
        return http.build();
    }
    
    /**
     * 3. authenticate 의 인증 메서드를 제공하는 매니져로'Provider'의 인터페이스를 의미합니다.
     * - 과정: CustomAuthenticationFilter → AuthenticationManager(interface) → CustomAuthenticationProvider(implements)
     *
     * @return AuthenticationManager
     */
    @Bean
    public AuthenticationManager authenticationManager() {
        return new ProviderManager(customAuthenticationProvider());
    }
    
    /**
     * 4. '인증' 제공자로 사용자의 이름과 비밀번호가 요구됩니다.
     * - 과정: CustomAuthenticationFilter → AuthenticationManager(interface) → CustomAuthenticationProvider(implements)
     *
     * @return CustomAuthenticationProvider
     */
    @Bean
    public CustomAuthenticationProvider customAuthenticationProvider() {
        return new CustomAuthenticationProvider(bCryptPasswordEncoder());
    }
    
    /**
     * 5. 비밀번호를 암호화하기 위한 BCrypt 인코딩을 통하여 비밀번호에 대한 암호화를 수행합니다.
     *
     * @return BCryptPasswordEncoder
     */
    public BCryptPasswordEncoder bCryptPasswordEncoder() {
        return new BCryptPasswordEncoder();
    }
    
    /**
     * 6. 커스텀을 수행한 '인증' 필터로 접근 URL, 데이터 전달방식(form) 등 인증 과정 및 인증 후 처리에 대한 설정을 구성하는 메서드입니다.
     *
     * @return CustomAuthenticationFilter
     */
    @Bean
    public CustomAuthenticationFilter customAuthenticationFilter() {
        CustomAuthenticationFilter filter = new CustomAuthenticationFilter(authenticationManager());
//        filter.setFilterProcessesUrl("/th/auth/login");     // 접근 URL
        
//        filter.setAuthenticationSuccessHandler(customLoginSuccessHandler());    // '인증' 성공 시 해당 핸들러로 처리를 전가한다.
//        filter.setAuthenticationFailureHandler(customLoginFailureHandler());    // '인증' 실패 시 해당 핸들러로 처리를 전가한다.
//        filter.afterPropertiesSet();
        
//        filter.setAuthenticationManager(authenticationManagerBean());
//        filter.setAuthenticationSuccessHandler(new SimpleUrlAuthenticationSuccessHandler("/th/auth/login"));
//        filter.setAuthenticationFailureHandler(new SimpleUrlAuthenticationFailureHandler("/th/auth/denied"));
        
        return filter;
    }
    
    /**
     * 7. Spring Security 기반의 사용자의 정보가 맞을 경우 수행이 되며 결과값을 리턴해주는 Handler
     *
     * @return CustomLoginSuccessHandler
     */
    @Bean
    public CustomAuthSuccessHandler customLoginSuccessHandler() {
        return new CustomAuthSuccessHandler();
    }
    
    /**
     * 8. Spring Security 기반의 사용자의 정보가 맞지 않을 경우 수행이 되며 결과값을 리턴해주는 Handler
     *
     * @return CustomAuthFailureHandler
     */
    @Bean
    public CustomAuthFailureHandler customLoginFailureHandler() {
        return new CustomAuthFailureHandler();
    }

    // logout 후 login할 때 정상동작을 위함
    @Bean
    public SessionRegistry sessionRegistry() {
        return new SessionRegistryImpl();
    }

    // was가 여러개 있을 때(session clustering)
    @SuppressWarnings({ "rawtypes", "unchecked" })
	@Bean
    public static ServletListenerRegistrationBean httpSessionEventPublisher() {
        return new ServletListenerRegistrationBean(new HttpSessionEventPublisher());
    }
}