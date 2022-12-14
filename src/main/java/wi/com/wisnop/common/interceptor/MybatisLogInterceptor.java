package wi.com.wisnop.common.interceptor;

import java.lang.reflect.Field;
import java.sql.Statement;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.apache.ibatis.executor.statement.StatementHandler;
import org.apache.ibatis.mapping.BoundSql;
import org.apache.ibatis.mapping.MappedStatement;
import org.apache.ibatis.mapping.ParameterMapping;
import org.apache.ibatis.plugin.Interceptor;
import org.apache.ibatis.plugin.Intercepts;
import org.apache.ibatis.plugin.Invocation;
import org.apache.ibatis.plugin.Plugin;
import org.apache.ibatis.plugin.Signature;
import org.apache.ibatis.reflection.DefaultReflectorFactory;
import org.apache.ibatis.reflection.MetaObject;
import org.apache.ibatis.reflection.SystemMetaObject;
import org.apache.ibatis.session.ResultHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.StopWatch;

import lombok.extern.slf4j.Slf4j;
import wi.com.wisnop.common.webutil.SharedInfoHolder;

@Slf4j
@Intercepts({
    @Signature(type=StatementHandler.class, method="batch", args={Statement.class}),
    @Signature(type=StatementHandler.class, method="update", args={Statement.class}),
    @Signature(type=StatementHandler.class, method="query", args={Statement.class, ResultHandler.class})
})
public class MybatisLogInterceptor implements Interceptor {

    @Override
    public Object intercept(Invocation invocation) throws Throwable {
    	
        StatementHandler handler = (StatementHandler)invocation.getTarget();
        MetaObject metaObject = MetaObject.forObject(handler, SystemMetaObject.DEFAULT_OBJECT_FACTORY,
        							SystemMetaObject.DEFAULT_OBJECT_WRAPPER_FACTORY, new DefaultReflectorFactory());

		MappedStatement mappedStatement = (MappedStatement) metaObject.getValue("delegate.mappedStatement");
		String sqlId = mappedStatement.getId();
		
        BoundSql boundSql = handler.getBoundSql();
        
        // 쿼리문을 가져온다(이 상태에서의 쿼리는 값이 들어갈 부분에 ?가 있다)
        String sql = boundSql.getSql();
        
        // 쿼리실행시 맵핑되는 파라미터를 구한다
        Object param = handler.getParameterHandler().getParameterObject();
        
        // 파라미터가 아무것도 없을 경우
        if (param == null) {
            sql = sql.replaceFirst("\\?", "null");
        
        // 해당 파라미터의 클래스가 Integer, Long, Float, Double 클래스일 경우
        } else {
            if (param instanceof Integer || param instanceof Long || param instanceof Float || param instanceof Double) {
            	sql = sql.replaceFirst("\\?", param.toString());
            
            // 해당 파라미터의 클래스가 String 일 경우(이 경우는 앞뒤에 '(홑따옴표)를 붙여야해서 별도 처리
            } else if (param instanceof String) {	
            	sql = sql.replaceFirst("\\?", "'" + param + "'");
            
            // 해당 파라미터가 Map 일 경우
            } else if(param instanceof Map) {
        	
	        	/*
	        	 * 쿼리의 ?와 매핑되는 실제 값들의 정보가 들어있는 ParameterMapping 객체가 들어간 List 객체로 return이 된다.
	        	 * 이때 List 객체의 0번째 순서에 있는 ParameterMapping 객체가 쿼리의 첫번째 ?와 매핑이 된다
	        	 * 이런 식으로 쿼리의 ?과 ParameterMapping 객체들을 Mapping 한다
	        	 */
	        	List<ParameterMapping> paramMapping = boundSql.getParameterMappings();	
	        	
	        	for (ParameterMapping mapping : paramMapping) {
	        	    String propValue = mapping.getProperty();		// 파라미터로 넘긴 Map의 key 값이 들어오게 된다
	        	    Object value = ((Map) param).get(propValue);	// 넘겨받은 key 값을 이용해 실제 값을 꺼낸다
	        	    if (value == null) {
						//continue;
					}
	        	    
	        	    // SQL의 ? 대신에 실제 값을 넣는다. 이때 String 일 경우는 '를 붙여야 하기땜에 별도 처리
	        	    if (value instanceof String) {
	        	    	sql = sql.replaceFirst("\\?", "'" + value + "'");
	        	    } else {
	        	    	sql = sql.replaceFirst("\\?", value != null ? value.toString() : "null");
	        	    }
	        	}
            
	        // 해당 파라미터가 사용자 정의 클래스일 경우
            } else {
        	
	        	/*
	        	 * 쿼리의 ?와 매핑되는 실제 값들이 List 객체로 return이 된다.
	        	 * 이때 List 객체의 0번째 순서에 있는 ParameterMapping 객체가 쿼리의 첫번째 ?와 매핑이 된다
	        	 * 이런 식으로 쿼리의 ?과 ParameterMapping 객체들을 Mapping 한다
	        	 */
	        	List<ParameterMapping> paramMapping = boundSql.getParameterMappings();
	        	
	        	Class<? extends Object> paramClass = param.getClass();
	        	// logger.debug("paramClass.getName() : {}", paramClass.getName());
	        	for (ParameterMapping mapping : paramMapping) {
	        	    String propValue = mapping.getProperty();			// 해당 파라미터로 넘겨받은 사용자 정의 클래스 객체의 멤버변수명
	        	    Field field = paramClass.getDeclaredField(propValue);	// 관련 멤버변수 Field 객체 얻어옴
	        	    field.setAccessible(true);					// 멤버변수의 접근자가 private일 경우 reflection을 이용하여 값을 해당 멤버변수의 값을 가져오기 위해 별도로 셋팅
	        	    Class<?> javaType = mapping.getJavaType();			// 해당 파라미터로 넘겨받은 사용자 정의 클래스 객체의 멤버변수의 타입
	        	    
	        	    // SQL의 ? 대신에 실제 값을 넣는다. 이때 String 일 경우는 '를 붙여야 하기땜에 별도 처리
	        	    if (String.class == javaType) {
	        	    	sql = sql.replaceFirst("\\?", "'" + field.get(param) + "'");
	        	    } else {
	        	    	sql = sql.replaceFirst("\\?", field.get(param).toString());
	        	    }
	        	}
            }
        }
         
        //logger.info("=====================================================================");
        log.info("sql : {}", sql);
        //logger.info("=====================================================================");
        
        if ("Y".equals(SharedInfoHolder.getJobType())) {
        	SharedInfoHolder.setJobSql(sql.concat(";"));
        	return null;
        } else {
        	long startTime = System.currentTimeMillis();
//        	String methodName = invocation.getMethod().getName();
        	StopWatch sw = new StopWatch();
        	sw.start("SQL_"+startTime);
        	Object rtnObj = invocation.proceed(); // 쿼리 실행
        	sw.stop();
        	log.info("[SQL ID] : {} was called. [SQL 처리시간] : {}", sqlId, sw.getTotalTimeSeconds());
            
        	return rtnObj;
        }
        
    }

    @Override
    public Object plugin(Object target) {
	// TODO Auto-generated method stub
	return Plugin.wrap(target, this);
    }

    @Override
    public void setProperties(Properties properties) {
	// TODO Auto-generated method stub

    }

}
