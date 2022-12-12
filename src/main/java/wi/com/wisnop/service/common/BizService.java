package wi.com.wisnop.service.common;

import java.util.Map;

public interface BizService {

    Map<String,Object> getList( Map<String, Object> inMap ) throws Exception;
    
    Map<String,Object> saveAll( Map<String, Object> inMap ) throws Exception;

    Map<String,Object> saveUpdate(Map<String, Object> paramMap) throws Exception;

    Map<String,Object> saveFile(Map<String, Object> paramMap) throws Exception;

}