package wi.com.wisnop.security.service.impl;

import java.util.Collections;
import java.util.Optional;

import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import wi.com.wisnop.security.dto.UserDetailsDto;
import wi.com.wisnop.security.dto.UserDto;
import wi.com.wisnop.security.service.CustomUserDetailsService;
import wi.com.wisnop.security.service.UserService;

@RequiredArgsConstructor
@Service
public class UserDetailsServiceImpl implements CustomUserDetailsService {
	private final UserService userService;

    @Override
    public UserDetails loadUserByUsername(String userId) {
    	return null;
    }

    @Override
    public UserDetails loadUserByUsername(String userId, String userPw) {
    	UserDto rtnUser = userService.login(userId, userPw);
    	
    	if(rtnUser == null) {
            throw new UsernameNotFoundException(userId);
        }

    	return Optional.ofNullable(rtnUser).map(u -> new UserDetailsDto(u, Collections.singleton(new SimpleGrantedAuthority(u.getUserId()))))
    			   	  .orElseThrow(() -> new BadCredentialsException(userId));
    }
}
