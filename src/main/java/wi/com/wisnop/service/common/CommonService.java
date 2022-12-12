package wi.com.wisnop.service.common;

import java.util.List;
import java.util.Map;

public interface CommonService {

    public <T> T getOne( Map<String, Object> inMap ) throws Exception;

    public <E> List<E> getList( Map<String, Object> inMap ) throws Exception;

    public Map<String,Object> saveAll( Map<String, Object> inMap ) throws Exception;

    public Map<String,Object> mergeAll(Map<String, Object> inMap) throws Exception;

    public int saveInsert(String id, Map<String, Object> paramMap) throws Exception;

    public int saveUpdate(String id, Map<String, Object> paramMap) throws Exception;

    public int saveDelete(String id, Map<String, Object> paramMap) throws Exception;

    public List<Map<String, Object>> selectTableInfo(Map<String, Object> inMap) throws Exception;

    public int pkCheck(Map<String, Object> rowMap, List<Map<String, Object>> tableInfoList) throws Exception;

    public Map<String,Object> dupCheck( Map<String, Object> inMap, Map<String,String> grdMap, List<String> arrGrdNm) throws Exception;
}