package wi.com.wisnop.service.common.impl;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import wi.com.wisnop.common.constant.Namespace;
import wi.com.wisnop.dao.CommonDao;
import wi.com.wisnop.dto.common.UserVO;
import wi.com.wisnop.service.common.LoginService;

@Service
public class LoginServiceImpl implements LoginService {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    // 공통 DAO
    @Autowired
    private CommonDao commonDao;

    @Override
    public UserVO getLogin( Map<String, Object> inMap ) {
    	
    	//로그인 아이디 조회
    	logger.info("userId ==> {}",inMap.get("userId"));
    	return commonDao.selectOne(Namespace.LOGIN_SSCD+"loginSelect", inMap);
    }

	@Override
	public Map<String, Object> getLoginDetail(Map<String, Object> inMap) {
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		//1.로그인시 사용자 정보
    	//rtnMap.put("userList", commonDao.selectList(Namespace.loginsscd+"userSelect", inMap));
        
        //2.사업부권한 ---------------------------------
    	rtnMap.put("divtypeList", commonDao.selectList(Namespace.LOGIN_SSCD+"divtypeSelect", inMap));
        
        //3.메뉴권한 ---------------------------------
    	rtnMap.put("menuList", commonDao.selectList(Namespace.LOGIN_SSCD+"menuSelect", inMap));
        
        return rtnMap;
	}

}
