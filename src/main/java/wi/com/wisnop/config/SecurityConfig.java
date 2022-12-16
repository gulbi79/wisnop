package wi.com.wisnop.config;

import org.springframework.boot.web.servlet.ServletListenerRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.core.session.SessionRegistry;
import org.springframework.security.core.session.SessionRegistryImpl;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.session.HttpSessionEventPublisher;

@Configuration
@EnableWebSecurity
public class SecurityConfig {
	
	@Bean
    public WebSecurityCustomizer configure() {
        return (web) -> web.ignoring().mvcMatchers(
                "/v3/api-docs/**",
                "/swagger-ui/**",
                "/login/login", // 임시
                "/**" // 임시
        );
    }
	
	@Bean
	public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
		
		/*
    	// 인가정책
    	http.authorizeRequests()
	    	.antMatchers("/admin").hasAuthority("ADMIN")
	    	.antMatchers("/auth/**", "/static/**", "/statics/**").permitAll() // 로그인 권한은 누구나, resources파일도 모든권한
	    	.anyRequest().authenticated();

    	// 인증정책
    	http.formLogin()
	    	.loginPage("/login/form")
	    	.loginProcessingUrl("/login/submit")
	    	.defaultSuccessUrl("/goPortal", true)
	    	.failureUrl("/login/sessionFire")
    		.permitAll();

    	// 로그아웃
    	http.logout()
	    	.logoutRequestMatcher(new AntPathRequestMatcher("/auth/logoutProc"))
	    	.logoutSuccessUrl("/auth/logout")
//	    	.deleteCookies("JSESSIONID", "remember - me") // 로그아웃 후 해당 쿠키 삭제
	    	.invalidateHttpSession(true);
    	
    	http.exceptionHandling()
//    	    .authenticationEntryPoint(new AjaxAuthenticationEntryPoint("/auth/login"))
    		.accessDeniedPage("/auth/denied");
    	
    	http.headers()
    		.frameOptions().sameOrigin();
    	
    	http.csrf()
    		.disable();
    	
    	// 동시세션 정책
    	http.sessionManagement()
	        .maximumSessions(1)
	        .maxSessionsPreventsLogin(false)
	        .sessionRegistry(sessionRegistry())
	        .expiredUrl("/auth/sessionexpired");
		*/
		
		http
        .csrf().disable()
        .authorizeRequests()
            .antMatchers("/", "/user/availability/**").permitAll()
            .anyRequest().authenticated()
            .and()
        .formLogin()
            .loginPage("/auth/login")
            .permitAll()
            .and()
        .logout()
            .permitAll();
		
    	return http.build();
    }

    /**
     * 로그인 인증 처리 메소드
     * @param auth
     * @throws Exception
     */
//    @Override
//    public void configure(AuthenticationManagerBuilder auth) throws Exception {
//        auth.userDetailsService(userService).passwordEncoder(new BCryptPasswordEncoder());
//    }
    
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