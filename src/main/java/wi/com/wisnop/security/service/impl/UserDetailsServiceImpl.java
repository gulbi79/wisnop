package wi.com.wisnop.security.service.impl;

import java.util.Collections;
import java.util.Optional;

import org.springframework.security.authentication.AuthenticationServiceException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import wi.com.wisnop.security.dto.UserDetailsDto;
import wi.com.wisnop.security.dto.UserDto;
import wi.com.wisnop.security.service.CustomUserDetailsService;
import wi.com.wisnop.security.service.UserService;

@Service
public class UserDetailsServiceImpl implements CustomUserDetailsService {
	private final UserService userService;

    public UserDetailsServiceImpl(UserService us) {
        this.userService = us;
    }

    @Override
    public UserDetails loadUserByUsername(String userId) {
        UserDto userDto = UserDto
                .builder()
                .userId(userId)
                .build();

        // 사용자 정보가 존재하지 않는 경우
        if (userId == null || userId.equals("")) {
            return userService.login(userDto)
                    .map(u -> new UserDetailsDto(u, Collections.singleton(new SimpleGrantedAuthority(u.getUserId()))))
                    .orElseThrow(() -> new AuthenticationServiceException(userId));
        }
        // 비밀번호가 맞지 않는 경우
        else {
            return userService.login(userDto)
                    .map(u -> new UserDetailsDto(u, Collections.singleton(new SimpleGrantedAuthority(u.getUserId()))))
                    .orElseThrow(() -> new BadCredentialsException(userId));
        }
    }

    @Override
    public UserDetails loadUserByUsername(String userId, String userPw) {
    	UserDto userDto = UserDto
    			.builder()
    			.userId(userId)
    			.userPw(userPw)
    			.build();
    	
    	/*
    	// 사용자 정보가 존재하지 않는 경우
    	if (userId == null || userId.equals("")) {
    		return userService.login(userDto)
    				.map(u -> new UserDetailsDto(u, Collections.singleton(new SimpleGrantedAuthority(u.getUserId()))))
    				.orElseThrow(() -> new AuthenticationServiceException(userId));
    	}
    	// 비밀번호가 맞지 않는 경우
    	else {
    		return userService.login(userDto)
    				.map(u -> new UserDetailsDto(u, Collections.singleton(new SimpleGrantedAuthority(u.getUserId()))))
    				.orElseThrow(() -> new BadCredentialsException(userId));
    	}
    	*/
    	
    	Optional<UserDto> rtnUser = userService.login(userDto);
    	if (rtnUser == null) {
    		return Optional.ofNullable(userDto)
    				.map(u -> new UserDetailsDto(u, Collections.singleton(new SimpleGrantedAuthority(u.getUserId()))))
    				.orElseThrow(() -> new AuthenticationServiceException(userId));
    	}
    		
    	return rtnUser.map(u -> new UserDetailsDto(u, Collections.singleton(new SimpleGrantedAuthority(u.getUserId()))))
    			   	  .orElseThrow(() -> new BadCredentialsException(userId));
    }
}
