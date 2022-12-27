package wi.com.wisnop.security.service;

import java.util.Optional;

import wi.com.wisnop.security.dto.UserDto;

/**
 * 로그인 정보를 DB에서 확인하기 위한 Service interface를 의미합니다.
 * @author sung
 *
 */
public interface UserService {
	Optional<UserDto> login(UserDto userVo);
}
