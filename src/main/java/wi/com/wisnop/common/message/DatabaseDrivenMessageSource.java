package wi.com.wisnop.common.message;

import java.text.MessageFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ResourceLoaderAware;
import org.springframework.context.support.AbstractMessageSource;
import org.springframework.core.io.DefaultResourceLoader;
import org.springframework.core.io.ResourceLoader;

public class DatabaseDrivenMessageSource extends AbstractMessageSource implements ResourceLoaderAware {

	
	@SuppressWarnings("unused")
	private ResourceLoader resourceLoader;

	private final Map<String, Map<String, String>> properties = new HashMap<String, Map<String, String>>();

	@Autowired
	private MessageResourceService messageResourceService;

	public DatabaseDrivenMessageSource() {
		reload();
	}

	public DatabaseDrivenMessageSource(MessageResourceService messageResourceService) {
		this.messageResourceService = messageResourceService;
		reload();
	}

	@Override
	protected MessageFormat resolveCode(String code, Locale locale) {
		String msg = getText(code, locale);
		MessageFormat result = createMessageFormat(msg, locale);
		return result;
	}

	@Override
	protected String resolveCodeWithoutArguments(String code, Locale locale) {
		return getText(code, locale);
	}

	private String getText(String code, Locale locale) {
		Map<String, String> localized = properties.get(code);
		String textForCurrentLanguage = null;
		if (localized != null) {
			textForCurrentLanguage = localized.get(locale.getLanguage());
			if (textForCurrentLanguage == null) {
				textForCurrentLanguage = localized.get(Locale.FRANCE.getLanguage());
			}
		}
		if (textForCurrentLanguage == null) {
			try {
				textForCurrentLanguage = getParentMessageSource().getMessage(code, null, locale);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return textForCurrentLanguage != null ? textForCurrentLanguage : code;
	}

	public void reload() {
		properties.clear();
		properties.putAll(loadTexts());
	}

	protected Map<String, Map<String, String>> loadTexts() {
		
		Map<String, Map<String, String>> m = new HashMap<String, Map<String, String>>();
		List<Map<String, String>> texts = messageResourceService.loadAllMessages();
		for (Map<String, String> map : texts) {
			Map<String, String> v = new HashMap<String, String>();
			v.put("en", map.get("EN_TEXT"));
			v.put("ko", map.get("KR_TEXT"));
			v.put("cn", map.get("CN_TEXT"));
			m.put(map.get("TRANS_TYPE") + "." + map.get("TRANS_ID"), v);
		}
		return m;
	}

	@Override
	public void setResourceLoader(ResourceLoader resourceLoader) {
		this.resourceLoader = (resourceLoader != null ? resourceLoader : new DefaultResourceLoader());
	}
}
