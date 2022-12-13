package wi.com.wisnop.controller.common;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.compress.archivers.zip.ZipArchiveEntry;
import org.apache.commons.compress.archivers.zip.ZipArchiveOutputStream;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.http.CacheControl;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import wi.com.wisnop.service.common.BizService;

/**
 * Handles requests for the application home page.
 */
@Slf4j
@RestController
@RequestMapping(value = "/file")
public class FileController {
	
	@Value("${props.SERVER_FILE_PATH}")
    private String SERVER_FILE_PATH;	

	@Value("${props.PDF_FILE_PATH}")
	private String PDF_FILE_PATH;	
	
    @Autowired
    private BizService bizService;

	@RequestMapping(value="/upload", method = RequestMethod.POST)
	public HashMap<String,Object> fileUpload(@RequestParam Map<String, Object> paramMap
			, @RequestParam("file") MultipartFile[] files, HttpServletRequest request) throws Exception {
		
		HashMap<String,Object> rtnMap = null;
		List<HashMap<String,Object>> fileList = new ArrayList<HashMap<String,Object>>();
		
		if (files != null && files.length>0) {
			
			String sFilePath = "Y".equals(paramMap.get("FILE_MNG_YN")) ? PDF_FILE_PATH : SERVER_FILE_PATH;
			File fdir = new File(sFilePath);
			if (!fdir.exists()) {
				fdir.mkdirs(); // 해당 디렉토리를 만든다. 
            }
			
			for (MultipartFile file : files) {
				
				HashMap<String,Object> fileMap = new HashMap<String,Object>();
				
                String orgFileNm    = file.getOriginalFilename();
                String extension    = orgFileNm.substring(orgFileNm.lastIndexOf(".") + 1, orgFileNm.length());
                long   size         = file.getSize();
                String uuid         = UUID.randomUUID().toString(); // 중복될 일이 거의 없다.
                String saveFileName = sFilePath + File.separator + uuid; // 실제 저장되는 파일의 절대 경로
 
                // 실제 파일을 저장함.
                File f = new File(saveFileName);
                file.transferTo(f);
                
                //파일 저장정보 처리
                fileMap.put("FILE_NM"     ,uuid);
                fileMap.put("FILE_NM_ORG" ,orgFileNm);
                fileMap.put("FILE_SIZE"   ,size);
                fileMap.put("FILE_PATH"   ,sFilePath);
                fileMap.put("EXTENSION"   ,extension);
                fileMap.put("DEL_FLAG"    ,"N");
                
                fileList.add(fileMap);
			}
		}
		
		paramMap.put("fileList", fileList);
		rtnMap = (HashMap<String, Object>)bizService.saveFile(paramMap);

		return rtnMap;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value="/download22", method = RequestMethod.POST)
	public ModelAndView fileDownload(@RequestParam("FILE_NO") String fileNo, @RequestParam("FILE_SEQ") String[] fileSeq
			, HttpServletRequest request) throws Exception {
		
		HashMap<String,Object> paramMap = new HashMap<String,Object>();
		
        //db에서 조회된 정보로 처리 ---------
		HashMap<String,Object> tranMap = new HashMap<String,Object>();
        List<HashMap<String,Object>> tranData = new ArrayList<HashMap<String,Object>>();

        tranMap.put("outDs" ,"fileList");
        tranMap.put("_siq"  ,"file");
        tranData.add(tranMap);
		paramMap.put("tranData" ,tranData);
		paramMap.put("FILE_NO"  ,fileNo);
		paramMap.put("FILE_SEQ" ,fileSeq);
		
		Map<String, Object> rtnMap = bizService.getList(paramMap);
		List<HashMap<String,Object>> rtnList = (List<HashMap<String,Object>>)rtnMap.get("fileList");
		if(rtnList.isEmpty()) {
			throw new FileNotFoundException("파일이 존재하지 않습니다.");
		}
		
		HashMap<String,Object> fileMap = new HashMap<String,Object>();
		
		//zip file 처리
		if (rtnList.size() > 1) {
			String[] filePath    = new String[rtnList.size()];
			String[] fileName    = new String[rtnList.size()];
			String[] orgFileName = new String[rtnList.size()];
			int i = 0;
			for (HashMap<String,Object> rtnFileMap : rtnList) {
				filePath[i]    = (String)rtnFileMap.get("FILE_PATH");
				fileName[i]    = (String)rtnFileMap.get("FILE_NM");
				orgFileName[i] = (String)rtnFileMap.get("FILE_NM_ORG");

				/*
				if (!getFileExists(filePath[i]+"/"+fileName[i])) {
					throw new FileNotFoundException("파일이 존재하지 않습니다.");
				}
				*/
				
				i++;
			}
			
			fileMap.put("filePath"    ,filePath);
			fileMap.put("fileName"    ,fileName);
			fileMap.put("orgFileName" ,orgFileName);
			
			return new ModelAndView("zipDownloadView", fileMap);
		
		//파일 한개 다운로드
		} else {
			
			/*
			if (!getFileExists(sFilePath+"/"+rtnList.get(0).get("FILE_NM"))) {
				throw new FileNotFoundException("파일이 존재하지 않습니다.");
			}
			*/
			
			fileMap.put("filePath"    ,rtnList.get(0).get("FILE_PATH"));
			fileMap.put("fileName"    ,rtnList.get(0).get("FILE_NM"));
			fileMap.put("orgFileName" ,rtnList.get(0).get("FILE_NM_ORG"));
			
			return new ModelAndView("downloadView", fileMap);
		}
	}
	
	/*
	private boolean getFileExists(String filePath) {
		File f = new File(filePath);
		if (!f.exists()) {
			return false;
        }
		return true;
	}
	*/
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/download", method = RequestMethod.POST)
	public ResponseEntity<Resource> fileDownloadApi(@RequestParam("FILE_NO") String fileNo, @RequestParam("FILE_SEQ") String[] fileSeq
			, HttpServletRequest request) throws Exception {
		
		HashMap<String,Object> paramMap = new HashMap<String,Object>();
		
        //db에서 조회된 정보로 처리 ---------
		HashMap<String,Object> tranMap = new HashMap<String,Object>();
        List<HashMap<String,Object>> tranData = new ArrayList<HashMap<String,Object>>();

        tranMap.put("outDs" ,"fileList");
        tranMap.put("_siq"  ,"file");
        tranData.add(tranMap);
		paramMap.put("tranData" ,tranData);
		paramMap.put("FILE_NO"  ,fileNo);
		paramMap.put("FILE_SEQ" ,fileSeq);
		
		Map<String, Object> rtnMap = bizService.getList(paramMap);
		List<HashMap<String,Object>> rtnList = (List<HashMap<String,Object>>)rtnMap.get("fileList");
		if(rtnList.isEmpty()) {
			throw new FileNotFoundException("파일이 존재하지 않습니다.");
		}
		
		HashMap<String,Object> fileMap = new HashMap<String,Object>();
		
		//zip file 처리
		if (rtnList.size() > 1) {
			/*
			String[] filePath    = new String[rtnList.size()];
			String[] fileName    = new String[rtnList.size()];
			String[] orgFileName = new String[rtnList.size()];
			int i = 0;
			for (HashMap<String,Object> rtnFileMap : rtnList) {
				filePath[i]    = (String)rtnFileMap.get("FILE_PATH");
				fileName[i]    = (String)rtnFileMap.get("FILE_NM");
				orgFileName[i] = (String)rtnFileMap.get("FILE_NM_ORG");

				i++;
			}
			
			fileMap.put("filePath"    ,filePath);
			fileMap.put("fileName"    ,fileName);
			fileMap.put("orgFileName" ,orgFileName);
			*/

			//String zipFileName         = System.nanoTime()+"";
			String firstFilePath  = (String)rtnList.get(0).get("FILE_PATH");
			String firstFileNm    = (String)rtnList.get(0).get("FILE_NM");
			String firstFileNmOrg = (String)rtnList.get(0).get("FILE_NM_ORG");
			
			String zipFileName         = firstFileNmOrg;
			FileOutputStream fos       = new FileOutputStream(firstFilePath + "/" + zipFileName+".zip");
			ZipArchiveOutputStream zos = new ZipArchiveOutputStream(fos);
			zos.setEncoding("UTF-8");
			
			byte[] buff = new byte[4096];
			for (HashMap<String,Object> rtnFileMap : rtnList) {
				String filePath  = (String)rtnFileMap.get("FILE_PATH");
				String fileNm    = (String)rtnFileMap.get("FILE_NM");
				String fileNmOrg = (String)rtnFileMap.get("FILE_NM_ORG");
				
				File file           = new File(filePath + "/" + fileNm);
				FileInputStream fis = new FileInputStream(file);
				ZipArchiveEntry ze  = new ZipArchiveEntry(fileNmOrg);
				zos.putArchiveEntry(ze);

				int len;
				while ((len = fis.read(buff)) > 0) {
					zos.write(buff, 0, len);
				}

				zos.closeArchiveEntry();
				fis.close();
			}

			zos.close();
			
			File zipFile = new File(firstFilePath + "/" + zipFileName+".zip");
			String orgFileName = zipFileName+".zip";
			
			Path filePath = Paths.get(firstFilePath+"\\"+orgFileName);
		    InputStreamResource resource = new InputStreamResource(new FileInputStream(filePath.toString()));
			
		    log.info("Success download input excel file : {}",filePath);
		    
			return ResponseEntity.ok()
		            .contentType(MediaType.APPLICATION_OCTET_STREAM)
		            .cacheControl(CacheControl.noCache())
		            .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=" + zipFileName+".zip")
		            .body(resource);
			
		
		//파일 한개 다운로드
		} else {
			
			fileMap.put("filePath"    ,rtnList.get(0).get("FILE_PATH"));
			fileMap.put("fileName"    ,rtnList.get(0).get("FILE_NM"));
			fileMap.put("orgFileName" ,rtnList.get(0).get("FILE_NM_ORG"));
			
			Path filePath = Paths.get((String)rtnList.get(0).get("FILE_PATH")+"\\"+(String)rtnList.get(0).get("FILE_NM"));
		    InputStreamResource resource = new InputStreamResource(new FileInputStream(filePath.toString()));
		    String fileName = (String)rtnList.get(0).get("FILE_NM_ORG");
		    
		    log.info("Success download input excel file : {}",filePath);
		    
		    return ResponseEntity.ok()
		            .contentType(MediaType.APPLICATION_OCTET_STREAM)
		            .cacheControl(CacheControl.noCache())
		            .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=" + fileName)
		            .body(resource);
			
		}
	}
}
