package wi.com.wisnop.common.message;

import java.util.List;
import java.util.Map;

public interface MessageResourceService {
	
	List<Map<String, String>> loadAllMessages();
}
