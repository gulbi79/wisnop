
package wi.com.wisnop.dao;


import java.util.List;
import java.util.Map;

public interface Common2Dao {

	public <T> T selectOne(String id);
	
	public <E> List<E> selectList(String id);
	
    public <T> T selectOne(String id, Map<String, ?> paramMap);

    public <E> List<E> selectList(String id, Map<String, ?> paramMap);

    public int insert(String id, Map<String, ?> paramMap);
    
    public int update(String id, Map<String, ?> paramMap);
    
    public int delete(String id, Map<String, ?> paramMap);
    
}
