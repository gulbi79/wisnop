package wi.com.wisnop.common.webutil;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.compress.archivers.zip.ZipArchiveEntry;
import org.apache.commons.compress.archivers.zip.ZipArchiveOutputStream;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.servlet.view.AbstractView;
 

public class ZipDownloadView extends AbstractView {
	
	public ZipDownloadView() {
		setContentType("application/download; charset=utf-8");
	}

	@Override
	protected void renderMergedOutputModel(Map<String, Object> model,HttpServletRequest request, HttpServletResponse response) throws Exception {
		String[] listFilePath    = (String[])model.get("filePath");
		String[] listOrgFileName = (String[])model.get("orgFileName");
		String[] listFileName    = (String[])model.get("fileName");

		if(listOrgFileName == null || listOrgFileName.length == 0) {
			return;
		}

		//String zipFileName         = System.nanoTime()+"";
		String zipFileName         = listOrgFileName[0];
		FileOutputStream fos       = new FileOutputStream(listFilePath[0] + "/" + zipFileName+".zip");
		ZipArchiveOutputStream zos = new ZipArchiveOutputStream(fos);
		zos.setEncoding("UTF-8");

		byte[] buff = new byte[4096];
		for (int i = 0; i < listFileName.length; i++) {
			File file           = new File(listFilePath[i] + "/" + listFileName[i]);
			FileInputStream fis = new FileInputStream(file);
			ZipArchiveEntry ze  = new ZipArchiveEntry(listOrgFileName[i]);
			zos.putArchiveEntry(ze);

			int len;
			while ((len = fis.read(buff)) > 0) {
				zos.write(buff, 0, len);
			}

			zos.closeArchiveEntry();
			fis.close();
		}

		zos.close();

		File zipFile = new File(listFilePath[0] + "/" + zipFileName+".zip");
		response.setContentType(getContentType());
		response.setContentLength((int)zipFile.length());

		String userAgent = request.getHeader("User-Agent");
		boolean ie = userAgent.indexOf("MSIE") > -1;
		String fileName = null;

		String orgFileName = zipFileName+".zip";
		if(ie) {
			fileName = URLEncoder.encode(orgFileName, "utf-8");
		} else {
			fileName = new String(orgFileName.getBytes("utf-8"), "iso-8859-1");
		}

		response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\";");
		response.setHeader("Content-Transfer-Encoding", "binary");
		OutputStream out = response.getOutputStream();

		FileInputStream fis2 = null;
		try {
			fis2 = new FileInputStream(zipFile);
			FileCopyUtils.copy(fis2, out);
		} finally {
			if(fis2 != null) { 
				try { 
					fis2.close(); 
				} catch (IOException ioe) {} 
			}
			zipFile.delete();
		}
		out.flush();
	}
}
