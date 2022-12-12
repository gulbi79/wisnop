package wi.com.wisnop.service.common;

import java.util.Map;

import wi.com.wisnop.dto.common.UserVO;

public interface LoginService {

    public UserVO getLogin( Map<String, Object> inMap );

    public Map<String, Object> getLoginDetail( Map<String, Object> inMap );
    
}