package wi.com.wisnop.common.webutil;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Component;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.servlet.view.AbstractView;

@Component("downloadView")
public class DownloadView extends AbstractView {
	public DownloadView() {
		setContentType("application/download; charset=utf-8");
	}

	@Override
	protected void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		System.out.println(" == renderMergedOutputModel ==");
		
		String _path    = (String) model.get("filePath");
		String _name    = (String) model.get("fileName");
		String _orgName = (String) model.get("orgFileName");
		
		// 파일 인코딩
		_orgName = CommUtil.getDisposition(_orgName, CommUtil.getBrowser(request));
		
		if (_name == null || _name.equals("")) {
			return;
		}
		File file = new File(_path + "/" + _name);

		response.setContentType(getContentType());
		response.setContentLength((int) file.length());

		String fileName = _orgName;
		response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\";");
		response.setHeader("Content-Transfer-Encoding", "binary");
		OutputStream out = response.getOutputStream();

		FileInputStream fis = null;
		try {
			fis = new FileInputStream(file);
			FileCopyUtils.copy(fis, out);
		} finally {
			if (fis != null) {
				try {
					fis.close();
				} catch (IOException ioe) {
				}
			}
		}
		out.flush();
	}
}
