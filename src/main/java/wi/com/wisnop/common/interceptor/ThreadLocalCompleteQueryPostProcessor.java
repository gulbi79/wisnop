package wi.com.wisnop.common.interceptor;

import org.anyframe.jdbc.support.impl.DefaultCompleteQueryPostProcessor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ThreadLocalCompleteQueryPostProcessor extends DefaultCompleteQueryPostProcessor {
	
	protected static Logger logger = LoggerFactory.getLogger(ThreadLocalCompleteQueryPostProcessor.class);
	
	@Override
    public void processCompleteQuery(String sql) {
		logger.debug(sql);
		/*
		super.processCompleteQuery(sql);
        if ("Y".equals(SharedInfoHolder.getJobType())) {
        	SharedInfoHolder.setJobType("N"); //초기화
            throw new QueryLogException("-777777",sql);
        }
        */
    }
	
}
