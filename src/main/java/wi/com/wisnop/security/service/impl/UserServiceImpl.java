package wi.com.wisnop.security.service.impl;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import org.springframework.stereotype.Service;

import lombok.extern.slf4j.Slf4j;
import wi.com.wisnop.dao.CommonDao;
import wi.com.wisnop.security.dto.UserDto;
import wi.com.wisnop.security.service.UserService;

/**
 * 로그인 정보를 DB에서 확인하기 위한 Service interface의 구현체를 의미합니다.
 * @author sung
 *
 */
@Service
@Slf4j
public class UserServiceImpl implements UserService {
	
	// 공통 DAO
    private final CommonDao commonDao;
	
	public UserServiceImpl(CommonDao ss) {
        this.commonDao = ss;
    }

    /**
     * 로그인 구현체
     *
     * @param userDto UserDto
     * @return Optional<UserDto>
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
    public Optional<UserDto> login(UserDto userDto) {
    	Map param = new HashMap();
    	param.put("userId", userDto.getUserId());
    	param.put("userPw", userDto.getUserPw());
        return Optional.ofNullable((UserDto)commonDao.selectOne("security.login.loginSelect", param));
    }
}
