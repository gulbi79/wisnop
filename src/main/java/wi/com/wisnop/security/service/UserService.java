package wi.com.wisnop.security.service;

import wi.com.wisnop.security.dto.UserDto;

/**
 * 로그인 정보를 DB에서 확인하기 위한 Service interface를 의미합니다.
 * @author sung
 *
 */
public interface UserService {
	UserDto login(String userId, String userPw);
}
