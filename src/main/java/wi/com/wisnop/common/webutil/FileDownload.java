package wi.com.wisnop.common.webutil;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;

import org.apache.commons.compress.archivers.zip.ZipArchiveEntry;
import org.apache.commons.compress.archivers.zip.ZipArchiveOutputStream;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.http.CacheControl;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class FileDownload {
	
	@Value("${props.PDF_FILE_PATH}")
	private String PDF_FILE_PATH;	
	
	public ResponseEntity<Resource> download(List<HashMap<String,Object>> rtnList) throws IOException {
		
		//zip file 처리
		if (rtnList.size() > 1) {
			
			String firstFilePath  = (String)rtnList.get(0).get("FILE_PATH");
			String firstFileNmOrg = (String)rtnList.get(0).get("FILE_NM_ORG");
			
			String zipFileName         = firstFileNmOrg+".zip";
			FileOutputStream fos       = new FileOutputStream(firstFilePath + "/" + zipFileName);
			ZipArchiveOutputStream zos = new ZipArchiveOutputStream(fos);
			zos.setEncoding("UTF-8");
			
			byte[] buff = new byte[4096];
			for (HashMap<String,Object> rtnFileMap : rtnList) {
				String sFilePath  = (String)rtnFileMap.get("FILE_PATH");
				String sFileNm    = (String)rtnFileMap.get("FILE_NM");
				String sFileNmOrg = (String)rtnFileMap.get("FILE_NM_ORG");
				
				File file           = new File(sFilePath + "/" + sFileNm);
				FileInputStream fis = new FileInputStream(file);
				ZipArchiveEntry ze  = new ZipArchiveEntry(sFileNmOrg);
				zos.putArchiveEntry(ze);

				int len;
				while ((len = fis.read(buff)) > 0) {
					zos.write(buff, 0, len);
				}

				zos.closeArchiveEntry();
				fis.close();
			}

			zos.close();
			
			new File(firstFilePath + "/" + zipFileName); //zipfile 생성
			
			return createResponse(MediaType.APPLICATION_OCTET_STREAM, firstFilePath+"\\"+zipFileName, zipFileName);
		
		//파일 한개 다운로드
		} else {
			
			String sFilePath  = (String)rtnList.get(0).get("FILE_PATH");
			String sFileNm    = (String)rtnList.get(0).get("FILE_NM");
			String sFileNmOrg = (String)rtnList.get(0).get("FILE_NM_ORG");
			
			return createResponse(MediaType.APPLICATION_OCTET_STREAM, sFilePath+"\\"+sFileNm, sFileNmOrg);
		}
	}

	public ResponseEntity<Resource> pdfViewer(List<HashMap<String,Object>> rtnList) throws IOException {
		
		String sFilePath  = (String)rtnList.get(0).get("FILE_PATH");
		String sFileNm    = (String)rtnList.get(0).get("FILE_NM");
		String sFileNmOrg = (String)rtnList.get(0).get("FILE_NM_ORG");
		
		sFilePath = PDF_FILE_PATH; //임시
		
		return createResponse(MediaType.APPLICATION_PDF, sFilePath+"\\"+sFileNm, sFileNmOrg);
	}
	
	private ResponseEntity<Resource> createResponse(MediaType contentType,  String fullPath, String downFileNm) throws FileNotFoundException {
		Path filePath = Paths.get(fullPath);
	    InputStreamResource resource = new InputStreamResource(new FileInputStream(filePath.toString()));
	    
	    log.info("Success download file : {}", filePath);
	    
	    String sAttachment = MediaType.APPLICATION_PDF.equals(contentType) ? "inline" : "attachment";
	    return ResponseEntity.ok()
	            .contentType(contentType)
	            .cacheControl(CacheControl.noCache())
	            .header(HttpHeaders.CONTENT_DISPOSITION, sAttachment+"; filename=" + downFileNm)
	            .body(resource);
	}
}
