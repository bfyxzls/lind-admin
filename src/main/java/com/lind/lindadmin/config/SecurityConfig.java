package com.lind.lindadmin.config;

import com.lind.lindadmin.security.LoginFailureHandler;
import com.lind.lindadmin.security.LoginSuccessHandler;
import com.lind.lindadmin.security.LogoutSuccessHandlerImpl;
import com.lind.lindadmin.security.SecurityUserDetailsService;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.ProviderManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.csrf.CookieCsrfTokenRepository;
import org.springframework.security.web.csrf.CsrfTokenRequestAttributeHandler;

/**
 * Spring Security配置
 */
@Configuration
@EnableWebSecurity
@EnableMethodSecurity
@RequiredArgsConstructor
public class SecurityConfig {

	private final SecurityUserDetailsService userDetailsService;

	private final LoginSuccessHandler loginSuccessHandler;

	private final LoginFailureHandler loginFailureHandler;

	private final LogoutSuccessHandlerImpl logoutSuccessHandler;

	private final PasswordEncoder passwordEncoder;

	@Bean
	public AuthenticationManager authenticationManager() {
		DaoAuthenticationProvider provider = new DaoAuthenticationProvider(userDetailsService);
		provider.setPasswordEncoder(passwordEncoder);
		return new ProviderManager(provider);
	}

	@Bean
	public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
		http
				// 启用CSRF（前后端不分离项目通常需要保留，cookie中会有XSRF-TOKEN，与与服务端的这个值进行对比，防止csrf攻击）
				.csrf(csrf -> csrf.csrfTokenRepository(CookieCsrfTokenRepository.withHttpOnlyFalse())
						.csrfTokenRequestHandler(new CsrfTokenRequestAttributeHandler()))
				// 允许同源iframe嵌入（系统使用iframe加载页面）
				.headers(headers -> headers.frameOptions(frameOptions -> frameOptions.sameOrigin()))
				// 配置请求授权
				.authorizeHttpRequests(auth -> auth
						// 静态资源允许访问
						.requestMatchers("/static/**", "/css/**", "/js/**", "/images/**", "/fonts/**", "/favicon.ico")
						.permitAll()
						// 登录页面允许访问
						.requestMatchers("/login", "/login/**").permitAll()
						// API字典接口部分开放
						.requestMatchers("/api/dict/data/type/**").permitAll()
						// 其他请求需要认证
						.anyRequest().authenticated())
				// 配置表单登录
				.formLogin(form -> form.loginPage("/login").loginProcessingUrl("/login")
						.successHandler(loginSuccessHandler).failureHandler(loginFailureHandler).permitAll())
				// 配置登出
				.logout(logout -> logout.logoutUrl("/logout").logoutSuccessHandler(logoutSuccessHandler)
						.invalidateHttpSession(true).deleteCookies("JSESSIONID").permitAll())
				// 配置Session管理
				.sessionManagement(session -> session.maximumSessions(1).expiredUrl("/login?expired=true"))
				// 记住我
				.rememberMe(
						remember -> remember.rememberMeParameter("rememberMe").tokenValiditySeconds(7 * 24 * 60 * 60) // 7天
				);

		return http.build();
	}

}
