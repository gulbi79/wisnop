package wi.com.wisnop.service.common.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.NumberUtils;
import org.springframework.util.StringUtils;

import wi.com.wisnop.common.constant.Namespace;
import wi.com.wisnop.common.webutil.CommUtil;
import wi.com.wisnop.common.webutil.SharedInfoHolder;
import wi.com.wisnop.dao.CommonDao;
import wi.com.wisnop.service.common.BizService;

@Service
public class BizServiceImpl implements BizService {

	private final Logger logger = LoggerFactory.getLogger(BizServiceImpl.class);

    // 공통 DAO
    @Autowired
    private CommonDao commonDao;

    @SuppressWarnings("unchecked")
	@Override
    public Map<String,Object> getList(Map<String, Object> paramMap) throws Exception {
    	logger.debug("method ============> {}","getList");

    	List<HashMap<String,Object>> rtnList = null;
    	HashMap<String,Object> rtnMap = new HashMap<String,Object>();
    	
    	if (!StringUtils.isEmpty(paramMap.get("sql"))) {
    		SharedInfoHolder.setJobType(paramMap.get("sql").toString());
    	}
    	
    	for (HashMap<String,Object> tranMap : (ArrayList<HashMap<String,Object>>)paramMap.get("tranData")) {
    		
    		//공통변수 설정
    		CommUtil.setCommonVar(tranMap);
    		
    		CommUtil.setParamsVar(tranMap, paramMap, Arrays.asList("grdData"));
    		
    		rtnList = commonDao.selectList(changeSiq((String)tranMap.get("_siq"))+Namespace.SQL_SELECT, tranMap);
    		
    		setOmitFlag(paramMap, tranMap, rtnList);
    		
    		rtnMap.put((String)tranMap.get("outDs"), rtnList);
    	}
    	
    	return rtnMap;
    }
    
    @SuppressWarnings("unchecked")
	private void setOmitFlag(Map<String, Object> paramMap, HashMap<String,Object> tranMap, List<HashMap<String,Object>> rtnList) {
    	
    	if (rtnList != null && !rtnList.isEmpty() && paramMap.get("meaList") != null && tranMap.get("omitBaseCd") != null) {
    		List<HashMap<String,Object>> meaList = (List<HashMap<String, Object>>) paramMap.get("meaList");
    		
    		int meaCnt = meaList.size();
    		int rtnListSize = rtnList.size();
    		int omitCnt = 0;
    		int totCnt = 0;
    		String omit0 = "N";
    		
    		HashMap<String,Object> bizMap = null;
			HashMap<String,Object> baseMap = null;
			BigDecimal omitFlag = new BigDecimal(0);
			BigDecimal zero = new BigDecimal(0);
    		
    		if (meaCnt > 0 && rtnList.size() > 0) {
    			
    			//1. omit_flag의 값을 구한다.
    			//2.차례대로 올라가는 카운트와 메저리스트의 카운트 의 갯수가 일치하때 
    			//  - 메저 셋의 리스트가 0인지 0이 아닌지 판단해서 
    			//  - 전체를 omit을 0으로 세팅 또는 1로 세팅해서
    			//  - UI 화면에서 셋 별로 보여주고 안보여준다.
    				
    			for (int i = 0; i < rtnListSize; i++) {
    				
    				totCnt++;
    				
    				baseMap = rtnList.get(i);
    				omitFlag = (BigDecimal) baseMap.get("OMIT_FLAG");
    				
    				if(omitFlag != null){
    					if(omitFlag.compareTo(zero) == 0){
        					omitCnt++;
        				}
    				}
    				
    				if(totCnt % meaCnt == 0){
        				if(omitCnt == meaCnt){
        					omit0 = "Y";
        				}else{
        					omit0 = "N";
        				}
        				
        				int forCnt = totCnt - meaCnt;
        				for(int j = forCnt; j < totCnt; j++){
        					
        					baseMap = rtnList.get(j);
        					
        					if("Y".equals(omit0)){
        						bizMap = rtnList.get(j);
        	    				bizMap.put("OMIT_FLAG", zero); 
        					}else{
        						bizMap = rtnList.get(j);
        	    				bizMap.put("OMIT_FLAG", 1);
        					}
        				}
        				omitCnt = 0;
        			}
    			}
    		}
    	}
    }
    
    @SuppressWarnings({ "unchecked"})
	@Override
	public Map<String,Object> saveAll(Map<String, Object> paramMap) throws Exception {

		//그리드명을 갖는 배열생성
		Map<String,Object> rtnMap = new HashMap<String,Object>();

		int errCode = Namespace.SUCCESS_CODE;
		int rtnInt = 0;
		String sqlId = null;
		String outDs = null;
		
		for (HashMap<String,Object> tranMap : (ArrayList<HashMap<String,Object>>)paramMap.get("tranData")) {
    		
			Map<String,String> dupChkMap = (HashMap<String,String>)tranMap.get("custDupChkYn");
			List<Map<String,Object>> grdData = (List<Map<String,Object>>)tranMap.get("grdData");
			sqlId = changeSiq((String)tranMap.get("_siq"));
			outDs = (String)tranMap.get("outDs");
			rtnInt = 0; //초기화
			
			//duplicate 체크
			if (dupChkMap != null) {
				dupChkMap.put("sqlId", sqlId);
				rtnMap = dupCheck(dupChkMap, tranMap, grdData);
				errCode = NumberUtils.parseNumber(rtnMap.get("errCode").toString(), Integer.class);
				if (errCode != Namespace.SUCCESS_CODE) {
					return rtnMap;
				}
			}
			
			for (Map<String,Object> rowMap : grdData) {
				
				//공통변수 설정
				CommUtil.setCommonVar(rowMap);
				
				CommUtil.setParamsVar(rowMap, paramMap, null);
				
				if ("Y".equals(tranMap.get("mergeFlag"))) {
					if ("deleted".equals(rowMap.get("state"))) {
						commonDao.update(sqlId+Namespace.SQL_DELETE, rowMap);
					} else if ("updated".equals(rowMap.get("state")) || "inserted".equals(rowMap.get("state"))) {
						commonDao.update(sqlId+Namespace.SQL_MERGE, rowMap);
					}
				} else {
					if ("deleted".equals(rowMap.get("state"))) {
						commonDao.update(sqlId+Namespace.SQL_DELETE, rowMap);
					} else if ("updated".equals(rowMap.get("state"))) {
						commonDao.update(sqlId+Namespace.SQL_UPDATE, rowMap);
					} else if ("inserted".equals(rowMap.get("state"))) {
						commonDao.update(sqlId+Namespace.SQL_INSERT, rowMap);
					}
				}
				
				rtnInt++;
			}
    		
    		rtnMap.put(outDs, rtnInt);
    	}

		return rtnMap;
	}

	@SuppressWarnings({ "unchecked" })
	@Override
	public Map<String,Object> saveUpdate(Map<String, Object> paramMap) throws Exception {
		
		//그리드명을 갖는 배열생성
		Map<String,Object> rtnMap = new HashMap<String,Object>();

		int errCode = Namespace.SUCCESS_CODE;
		int rtnInt = 0;
		String sqlId = null;
		String outDs = null;
		
		for (HashMap<String,Object> tranMap : (ArrayList<HashMap<String,Object>>)paramMap.get("tranData")) {
		
			Map<String,String> dupChkMap = (HashMap<String,String>)tranMap.get("custDupChkYn");
			List<Map<String,Object>> grdData = (List<Map<String,Object>>)tranMap.get("grdData");
			sqlId = changeSiq((String)tranMap.get("_siq"));
			outDs = (String)tranMap.get("outDs");
			rtnInt = 0; //초기화
			
			//duplicate 체크
			if (dupChkMap != null) {
				dupChkMap.put("sqlId", sqlId);
				rtnMap = dupCheck(dupChkMap, tranMap, grdData);
				errCode = NumberUtils.parseNumber(rtnMap.get("errCode").toString(), Integer.class);
				if (errCode != Namespace.SUCCESS_CODE) {
					return rtnMap;
				}
			}
			
			for (Map<String,Object> rowMap : grdData) {
				
				//공통변수 설정
				CommUtil.setCommonVar(rowMap);
				
				CommUtil.setParamsVar(rowMap, paramMap, Arrays.asList("grdData"));
				
				commonDao.update(sqlId + Namespace.SQL_UPDATE, rowMap);
				
				rtnInt++;
			}
			
	    	rtnMap.put(outDs, rtnInt);
		}
		
		return rtnMap;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String,Object> saveFile(Map<String, Object> paramMap) throws Exception {
		
		//그리드명을 갖는 배열생성
		Map<String,Object> rtnMap = new HashMap<String,Object>();
			
		//file 저장
		List<HashMap<String,Object>> fileList = (List<HashMap<String,Object>>)paramMap.get("fileList");
		String rowBizYn = StringUtils.isEmpty(paramMap.get("ROW_BIZ_YN")) ? "N" : (String)paramMap.get("ROW_BIZ_YN");
		String kpiIdSeq[] = StringUtils.tokenizeToStringArray((String) paramMap.get("KPI_ID_SEQ"), "||");
		int rtnInt = 0; //초기화
		
		String fileNo = null;
		boolean bizFlag = false; 
		if (StringUtils.isEmpty(paramMap.get("FILE_NO"))) {
			fileNo = commonDao.selectOne("common.fileNoSelect");
			paramMap.put("FILE_NO", fileNo);
			bizFlag = "Y".equals(rowBizYn) ? false : true;
		}
		
		for (HashMap<String,Object> fileMap : fileList) {
			
			//공통변수 설정
			CommUtil.setCommonVar(fileMap);
			
			//file no set
			fileMap.put("FILE_NO", paramMap.get("FILE_NO"));
			commonDao.update("common.file" + Namespace.SQL_UPDATE, fileMap);
			
			//row file & seq set
			if ("Y".equals(rowBizYn)) {
				fileMap.put("KPI_ID", kpiIdSeq[rtnInt]);
				commonDao.update(paramMap.get("_siq") + Namespace.SQL_UPDATE, fileMap);
			}
			
			rtnInt++;
		}

		//삭제파일처리
		HashMap<String,Object> delMap = null;
		for (String delFileSeq : StringUtils.tokenizeToStringArray((String) paramMap.get("DEL_FILE_SEQ"), "||")) {
			
			delMap = new HashMap<String,Object>();
			
			//공통변수 설정
			CommUtil.setCommonVar(delMap);
			
			delMap.put("FILE_NO", paramMap.get("FILE_NO"));
			delMap.put("FILE_SEQ", delFileSeq);
			commonDao.update("common.file" + Namespace.SQL_DELETE, delMap);
			rtnInt++;
		}
		
		//파일저장 후 업무테이블에 update 
		if (bizFlag) {
			//공통변수 설정
			CommUtil.setCommonVar(paramMap);
			commonDao.update(paramMap.get("_siq") + Namespace.SQL_UPDATE, paramMap);
		}
		
		rtnMap.put("FILE_NO", paramMap.get("FILE_NO"));
		rtnMap.put("saveCnt", rtnInt);
		
		return rtnMap;
	}

	
	@SuppressWarnings("unused")
	private Map<String,Object> dupCheck(Map<String,String> dupChkMap, Map<String, Object> inMap, List<Map<String,Object>> grdData) throws Exception {

		Map<String,Object> hm = new HashMap<String,Object>();
		hm.put("errCode", Namespace.SUCCESS_CODE);
		
		if (!"Y".equals(dupChkMap.get("insert")) && !"Y".equals(dupChkMap.get("update")) && !"Y".equals(dupChkMap.get("delete"))) {
			return hm;
		}

		int pkInt = 0;
		String rownum = "-1";
		String rowState = "";
		for (Map<String,Object> rowMap : grdData) {
			//공통변수 설정
			CommUtil.setCommonVar(rowMap);
			
			//param 설정
			//CommUtil.setParamsVar(rowMap, inMap, null);

			pkInt = 0;
			rowState = (String)rowMap.get("state");
			if ("Y".equals(inMap.get("mergeFlag"))) {
				if ("deleted".equals(rowMap.get("state"))) {
					pkInt = commonDao.selectOne(changeSiq((String)dupChkMap.get("sqlId"))+Namespace.SQL_DUP_ID+Namespace.SQL_DELETE, rowMap);
				} else if ("updated".equals(rowMap.get("state")) || "inserted".equals(rowMap.get("state"))) {
					pkInt = commonDao.selectOne(changeSiq((String)dupChkMap.get("sqlId"))+Namespace.SQL_DUP_ID+Namespace.SQL_MERGE, rowMap);
				}
			} else {
				if ("inserted".equals(rowState) && "Y".equals(dupChkMap.get("insert"))) {
					pkInt = commonDao.selectOne(changeSiq((String)dupChkMap.get("sqlId"))+Namespace.SQL_DUP_ID+Namespace.SQL_INSERT, rowMap);
				} else if ("updated".equals(rowState) && "Y".equals(dupChkMap.get("update"))) {
					pkInt = commonDao.selectOne(changeSiq((String)dupChkMap.get("sqlId"))+Namespace.SQL_DUP_ID+Namespace.SQL_UPDATE, rowMap);
				} else if ("deleted".equals(rowState) && "Y".equals(dupChkMap.get("delete"))) {
					pkInt = commonDao.selectOne(changeSiq((String)dupChkMap.get("sqlId"))+Namespace.SQL_DUP_ID+Namespace.SQL_DELETE, rowMap);
				}
			}
			
			
			if (pkInt > 0) {
				//hm.put("errMsg"    ,"msg.dupData");
				hm.put("errCode"   ,"inserted".equals(rowState) ? Namespace.VALIDATE_INSERT_CODE : "updated".equals(rowState) ? Namespace.VALIDATE_UPDATE_CODE : Namespace.VALIDATE_DELETE_CODE);
				hm.put("errLine"   ,(String)rowMap.get("_ROWNUM"));
				hm.put("errpkInt"  ,pkInt);
				break;
			}
		}
		return hm;
	}
	
	private String changeSiq(String siq) {
		//return siq.replaceAll("\\|",".");
		return siq;
	}

}
