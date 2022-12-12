package wi.com.wisnop.common.security.xss;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ReadListener;
import javax.servlet.ServletException;
import javax.servlet.ServletInputStream;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;

import org.apache.commons.lang3.StringUtils;

public class XSSFilter implements Filter {

	public FilterConfig filterConfig;

	public void init(FilterConfig filterConfig) throws ServletException {
		this.filterConfig = filterConfig;
	}

	public void destroy() {
		this.filterConfig = null;
	}

	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		chain.doFilter(new XSSRequestWrapper((HttpServletRequest) request), response);
	}
}

class XSSRequestWrapper extends HttpServletRequestWrapper {
	
	public XSSRequestWrapper(HttpServletRequest request) {
		super(request);
	}

	@Override
	public String getHeader(String name) {
		return XSSFilterUtil.filterXSS(super.getHeader(name));
	}
	
	@Override
	public String getParameter(String name) {
		return XSSFilterUtil.filterXSS(super.getParameter(name));
	}
	
	@Override
	public String[] getParameterValues(String name) {
		
		String[] values = super.getParameterValues(name);
		if (values == null) {
			return null;
		}
		
		int valueCnt = values.length;
		String[] filterValues = new String[valueCnt];
		for (int i = 0; i < valueCnt; i++) {
			filterValues[i] = XSSFilterUtil.filterXSS(values[i]);
		}
		
		return filterValues;
	}

	@Override
	public ServletInputStream getInputStream() throws IOException {

		String contentType = super.getContentType();
		if (!StringUtils.isEmpty(contentType) && contentType.indexOf("application/json") != -1) {
				
			InputStream inStream = super.getInputStream();
			if (inStream == null) {
				return null;
			}
			
			BufferedReader buffReader = new BufferedReader(new InputStreamReader(inStream, "UTF-8"));
			
			int readCharNum = -1;
			char[] charBuff = new char[128];
			StringBuilder sBuilder = new StringBuilder ();
			
			while((readCharNum = buffReader.read(charBuff)) > 0) {
				sBuilder.append(charBuff, 0, readCharNum);
			}
			
			final InputStream filterInStream = new ByteArrayInputStream(XSSFilterUtil.filterXSSJson(sBuilder.toString()).getBytes("UTF-8"));
			
			return new ServletInputStream() {

				@Override
				public int read() throws IOException {
					return filterInStream.read();
				}

				@Override
				public boolean isFinished() {
					return false;
				}

				@Override
				public boolean isReady() {
					return true;
				}

				@Override
				public void setReadListener(ReadListener paramReadListener) {
				}
			};
			
		} else {
			return super.getInputStream();
		}
	}
}
