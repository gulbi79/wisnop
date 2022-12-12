package wi.com.wisnop.controller.common;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import wi.com.wisnop.service.common.BizService;

/**
 * Handles requests for the application home page.
 */
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
	@RequestMapping(value="/download", method = RequestMethod.POST)
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
}
