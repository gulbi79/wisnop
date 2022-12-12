package wi.com.wisnop.dao.impl;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Repository;

import wi.com.wisnop.dao.CommonDao;

@Primary
@Repository("commonDao")
public class CommonDaoImpl implements CommonDao {

    @Autowired
    @Qualifier("mySqlsqlSessionTemplate")
    private SqlSessionTemplate sqlSession;

    @Override
    public <T> T selectOne(String id) {
    	return sqlSession.selectOne(id);
    }
    
    @Override
    public <T> T selectOne(String id, Map<String, ?> paramMap) {
        return sqlSession.selectOne(id, paramMap);
    }

    @Override
    public <E> List<E> selectList(String id) {
    	return sqlSession.selectList(id);
    }

    @Override
    public <E> List<E> selectList(String id, Map<String, ?> paramMap) {
    	/*
    	try {
			SqlUtil.getSql(sqlSession, id, paramMap);
		} catch (Throwable e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		*/
    	return sqlSession.selectList(id, paramMap);
    }

	@Override
	public int insert(String id, Map<String, ?> paramMap) {
		return sqlSession.insert(id, paramMap);
	}

	@Override
	public int update(String id, Map<String, ?> paramMap) {
		return sqlSession.update(id, paramMap);
	}

	@Override
	public int delete(String id, Map<String, ?> paramMap) {
		return sqlSession.delete(id, paramMap);
	}

}
