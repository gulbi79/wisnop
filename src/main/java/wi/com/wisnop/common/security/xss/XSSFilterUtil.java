package wi.com.wisnop.common.security.xss;

import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Map.Entry;
import java.util.Set;

import org.apache.commons.lang3.StringUtils;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

public class XSSFilterUtil {
	
	public static String unfilterXSS(String value) {
		if (StringUtils.isEmpty(value)) {
			return value;
		} else {
			String tmpValue = value;
			tmpValue = tmpValue.replaceAll("&quot;", "\"");
			tmpValue = tmpValue.replaceAll("&gt;"  , ">" );
			tmpValue = tmpValue.replaceAll("&lt;"  , "<" );
			tmpValue = tmpValue.replaceAll("&amp;" , "&" );
			return tmpValue;
		}
	}
	
	public static String filterXSS(String value) {
		if (StringUtils.isEmpty(value)) {
			return value;
		} else {
			String tmpValue = value;
			tmpValue = tmpValue.replaceAll("&" , "&amp;");
			tmpValue = tmpValue.replaceAll("<" , "&lt;");
			tmpValue = tmpValue.replaceAll(">" , "&gt;");
			tmpValue = tmpValue.replaceAll("\"", "&quot;");
			return tmpValue;
		}
	}
	
	@SuppressWarnings("rawtypes")
	public static String filterXSSJson(String json) throws JsonParseException, JsonMappingException, JsonProcessingException, IOException {
		ObjectMapper mapper = new ObjectMapper();
		return mapper.writeValueAsString(XSSFilterUtil.filterXSSJsonMap(mapper.readValue(json, new TypeReference<LinkedHashMap>(){})));
	}
	
	@SuppressWarnings("rawtypes")
	private static Object filterXSSJsonValue(Object value) {
		if (value instanceof String) {
			return XSSFilterUtil.filterXSS((String) value);
		} else if (value instanceof LinkedHashMap) {
			return XSSFilterUtil.filterXSSJsonMap((LinkedHashMap) value);
		} else if (value instanceof ArrayList) {
			return XSSFilterUtil.filterXSSJsonList((ArrayList) value);
		} else {
			return value;
		}
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	private static ArrayList filterXSSJsonList(ArrayList jsonList) {
		int size = jsonList.size();
		for (int i = 0; i < size; i++) {
			jsonList.set(i, XSSFilterUtil.filterXSSJsonValue(jsonList.get(i)));
		}
		return jsonList;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private static LinkedHashMap filterXSSJsonMap(LinkedHashMap jsonMap) {
		Set<Entry> entries = jsonMap.entrySet();
		for (Entry entry : entries) {
			jsonMap.put(entry.getKey(), XSSFilterUtil.filterXSSJsonValue(entry.getValue()));
		}
		return jsonMap;
	}
}
