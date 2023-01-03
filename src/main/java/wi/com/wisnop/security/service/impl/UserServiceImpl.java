package wi.com.wisnop.security.service.impl;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import wi.com.wisnop.dao.CommonDao;
import wi.com.wisnop.security.dto.UserDto;
import wi.com.wisnop.security.service.UserService;

/**
 * 로그인 정보를 DB에서 확인하기 위한 Service interface의 구현체를 의미합니다.
 * @author sung
 *
 */
@RequiredArgsConstructor
//@Slf4j
@Service
public class UserServiceImpl implements UserService {
	
	// 공통 DAO
    private final CommonDao commonDao;
	
//	public UserServiceImpl(CommonDao ss) {
//        this.commonDao = ss;
//    }

    /**
     * 로그인 구현체
     *
     * @param userDto UserDto
     * @return Optional<UserDto>
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
    public UserDto login(String userId, String userPw) {
    	Map param = new HashMap();
    	param.put("userId", userId);
    	param.put("userPw", userPw);
        return (UserDto)commonDao.selectOne("security.login.loginSelect", param);
    }
}
