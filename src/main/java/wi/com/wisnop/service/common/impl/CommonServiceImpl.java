package wi.com.wisnop.service.common.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import wi.com.wisnop.common.constant.Namespace;
import wi.com.wisnop.common.webutil.CommUtil;
import wi.com.wisnop.common.webutil.SharedInfoHolder;
import wi.com.wisnop.dao.CommonDao;
import wi.com.wisnop.service.common.CommonService;

@Service
public class CommonServiceImpl implements CommonService {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    // 공통 DAO
    @Autowired
    private CommonDao commonDao;

    @Override
	public <T> T getOne(Map<String, Object> inMap) throws Exception {
    	logger.debug("method ============> {}","getOne");

    	if (!StringUtils.isEmpty(inMap.get("sql"))) {
    		SharedInfoHolder.setJobType(inMap.get("sql").toString());
    	}

		//공통변수 설정
    	CommUtil.setCommonVar(inMap);
    	return commonDao.selectOne(inMap.get("sqlId")+Namespace.SQL_SELECT, inMap);
	}

    @Override
    public <E> List<E> getList(Map<String, Object> inMap) throws Exception {
    	logger.debug("method ============> {}","getList");

    	if (!StringUtils.isEmpty(inMap.get("sql"))) {
    		SharedInfoHolder.setJobType(inMap.get("sql").toString());
    	}

    	//공통변수 설정
    	CommUtil.setCommonVar(inMap);
    	return commonDao.selectList(inMap.get("sqlId")+Namespace.SQL_SELECT, inMap);
    }

	@SuppressWarnings("unchecked")
	@Override
	public Map<String,Object> saveAll(Map<String, Object> inMap) throws Exception {

		//그리드명을 갖는 배열생성
		List<String> arrGrdNm = new ArrayList<String>();

		Map<String,Object> rtnMap = new HashMap<String,Object>();
		//if (!StringUtils.isEmpty(inMap.get("sql"))) {
    	//	SharedInfoHolder.setJobType(inMap.get("sql").toString());
    	//}

		arrGrdNm.clear();
		int errCode = Namespace.SUCCESS_CODE;

		//duplicate 체크
		/*
		if (!StringUtils.isEmpty(inMap.get("dupChkTbNm")) || "Y".equals(inMap.get("custDupChkYn"))) {
			if (StringUtils.isEmpty(inMap.get(Namespace.MULTI_GRID_DATA))) {
				rtnMap = dupCheck(inMap,null, arrGrdNm);
				errCode = NumberUtils.parseNumber(rtnMap.get("errCode").toString(), Integer.class);
			} else {
				Map<String,String> grdMap = null;
				List<Map<String,String>> grdList = (List<Map<String,String>>)inMap.get(Namespace.MULTI_GRID_DATA);

				for (Map<String,String> mapGrdNm : grdList) {
					for (Map.Entry<String, String> entry : mapGrdNm.entrySet()) {
						arrGrdNm.add(entry.getKey());
					}
				}

				for (int i=0; i<grdList.size(); i++) {
					grdMap = (Map<String,String>)grdList.get(i);
					inMap.put("dupChkTbNm",grdMap.get(Namespace.ARR_DUP_CHK_NM));
					rtnMap = dupCheck(inMap, grdMap, arrGrdNm);
					errCode = NumberUtils.parseNumber(rtnMap.get("errCode").toString(), Integer.class);
					if (errCode == Namespace.validateCheckCode) break;
				}
			}
		}
		*/

		//데이터 처리
		if (errCode != Namespace.VALIDATE_INSERT_CODE) {
			arrGrdNm.clear();
			if (StringUtils.isEmpty(inMap.get(Namespace.MULTI_GRID_DATA))) {
				saveGrd(inMap, rtnMap, null, false, arrGrdNm);
			} else {
				Map<String,String> grdMap = null;
				List<Map<String,String>> grdList = (List<Map<String,String>>)inMap.get(Namespace.MULTI_GRID_DATA);

				for (Map<String,String> mapGrdNm : grdList) {
					for (Map.Entry<String, String> entry : mapGrdNm.entrySet()) {
						arrGrdNm.add(entry.getKey());
					}
				}

				for (int i=0; i<grdList.size(); i++) {
					grdMap = (Map<String,String>)grdList.get(i);
					saveGrd(inMap, rtnMap, grdMap, false, arrGrdNm);
				}
			}
		}
		return rtnMap;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String,Object> mergeAll(Map<String, Object> inMap) throws Exception {

		//그리드명을 갖는 배열생성
		List<String> arrGrdNm = new ArrayList<String>();

		Map<String,Object> rtnMap = new HashMap<String,Object>();
		if (!StringUtils.isEmpty(inMap.get("sql"))) {
    		SharedInfoHolder.setJobType(inMap.get("sql").toString());
    	}

		arrGrdNm.clear();
		int errCode = Namespace.SUCCESS_CODE;

		//duplicate 체크
		/*
		if (!StringUtils.isEmpty(inMap.get("dupChkTbNm")) || "Y".equals(inMap.get("custDupChkYn"))) {
			if (StringUtils.isEmpty(inMap.get(Namespace.MULTI_GRID_DATA))) {
				rtnMap = dupCheck(inMap,null,arrGrdNm);
				errCode = NumberUtils.parseNumber(rtnMap.get("errCode").toString(), Integer.class);
			} else {
				Map<String,String> grdMap = null;
				List<Map<String,String>> grdList = (List<Map<String,String>>)inMap.get(Namespace.MULTI_GRID_DATA);

				for (Map<String,String> mapGrdNm : grdList) {
					for (Map.Entry<String, String> entry : mapGrdNm.entrySet()) {
						arrGrdNm.add(entry.getKey());
					}
				}

				for (int i=0; i<grdList.size(); i++) {
					grdMap = (Map<String,String>)grdList.get(i);
					inMap.put("dupChkTbNm",grdMap.get(Namespace.ARR_DUP_CHK_NM));
					rtnMap = dupCheck(inMap, grdMap, arrGrdNm);
					errCode = NumberUtils.parseNumber(rtnMap.get("errCode").toString(), Integer.class);
					if (errCode == Namespace.validateCheckCode) break;
				}
			}
		}
		*/

		//데이터 처리
		if (errCode != Namespace.VALIDATE_INSERT_CODE) {
			arrGrdNm.clear();
			if (StringUtils.isEmpty(inMap.get(Namespace.MULTI_GRID_DATA))) {
				saveGrd(inMap, rtnMap, null, true, arrGrdNm);
			} else {
				Map<String,String> grdMap = null;
				List<Map<String,String>> grdList = (List<Map<String,String>>)inMap.get(Namespace.MULTI_GRID_DATA);

				for (Map<String,String> mapGrdNm : grdList) {
					for (Map.Entry<String, String> entry : mapGrdNm.entrySet()) {
						arrGrdNm.add(entry.getKey());
					}
				}

				for (int i=0; i<grdList.size(); i++) {
					grdMap = (Map<String,String>)grdList.get(i);
					saveGrd(inMap, rtnMap, grdMap, true, arrGrdNm);
				}
			}
		}
		return rtnMap;
	}

	@Override
	public int saveInsert(String id, Map<String, Object> paramMap) throws Exception {
		//공통변수 설정
    	CommUtil.setCommonVar(paramMap);
		return commonDao.insert(id+Namespace.SQL_INSERT, paramMap);
	}

	@Override
	public int saveUpdate(String id, Map<String, Object> paramMap) throws Exception {
		//공통변수 설정
    	CommUtil.setCommonVar(paramMap);
		return commonDao.update(id+Namespace.SQL_UPDATE, paramMap);
	}

	@Override
	public int saveDelete(String id, Map<String, Object> paramMap) throws Exception {
		//공통변수 설정
    	CommUtil.setCommonVar(paramMap);
		return commonDao.update(id+Namespace.SQL_DELETE, paramMap);
	}

	//테이블 정보 조회
	@Override
	public List<Map<String,Object>> selectTableInfo(Map<String, Object> inMap) throws Exception {
		return commonDao.selectList(Namespace.COMMON_SSCD+"tableInfoList"+Namespace.SQL_SELECT, inMap);
	}

	//pk check
	@Override
	public int pkCheck(Map<String, Object> rowMap, List<Map<String,Object>> tableInfoList) throws Exception {
		if ("Y".equals(rowMap.get("custDupChkYn"))) {
			return commonDao.selectOne(rowMap.get("sqlId").toString()+Namespace.SQL_DUP_ID, rowMap);
		} else {
			rowMap.put("tableInfoList", tableInfoList);
			return commonDao.selectOne(Namespace.COMMON_SSCD+"pkCheck"+Namespace.SQL_SELECT, rowMap);
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String,Object> dupCheck(Map<String, Object> inMap, Map<String,String> grdMap, List<String> arrGrdNm) throws Exception {

		Map<String,Object> hm = new HashMap<String,Object>();
		hm.put("errCode", Namespace.SUCCESS_CODE);

		if (StringUtils.isEmpty(inMap.get("dupChkTbNm")) && !"Y".equals(inMap.get("custDupChkYn"))) {
			return hm;
		}

		int pkInt = 0;
		String grdNm = grdMap == null ? "grdData" : grdMap.get(Namespace.ARR_SAVE_GRID);
		List<Map<String,Object>> grdData = (List<Map<String, Object>>)inMap.get(grdNm);

		//테이블 정보 조회
		List<Map<String,Object>> tableInfoList = null;
		if (!"Y".equals(inMap.get("custDupChkYn"))) {
			for (Map<String,Object> rowMap : grdData) {
				if ("inserted".equals(rowMap.get("state"))) {
					tableInfoList = this.selectTableInfo(inMap);
					break;
				}
			}
		}

		String paramVarFlag = (StringUtils.isEmpty(inMap.get("paramVarFlag")) ? "Y" : (String)inMap.get("paramVarFlag"));

		for (Map<String,Object> rowMap : grdData) {
			//공통변수 설정
			CommUtil.setCommonVar(rowMap);

			//param 설정
			if ("Y".equals(paramVarFlag)) {
				CommUtil.setParamsVar(rowMap, inMap, arrGrdNm);
			}

			if ("inserted".equals(rowMap.get("state"))) {
				pkInt = this.pkCheck(rowMap,tableInfoList);
				if ( pkInt > 0 ) {
					hm.put("errCode", Namespace.VALIDATE_INSERT_CODE);
					hm.put("errMsg", "msg.dupData");
					hm.put("errParams", (String)rowMap.get("_ROWNUM"));
					hm.put("errLine", (String)rowMap.get("_ROWNUM"));
					break;
				}
			}
		}
		return hm;
	}

	@SuppressWarnings("unchecked")
	private void saveGrd(Map<String, Object> inMap, Map<String,Object> rtnMap, Map<String,String> grdMap
			, boolean mergeFlag, List<String> arrGrdNm) throws Exception {
		int rtnInt = 0;
		String sqlId = grdMap == null ? inMap.get("sqlId").toString() : grdMap.get(Namespace.ARR_SAVE_SQLID);
		String grdNm = grdMap == null ? "grdData" : grdMap.get(Namespace.ARR_SAVE_GRID);
		List<Map<String,Object>> grdData = (List<Map<String, Object>>)inMap.get(grdNm);

		String paramVarFlag = (StringUtils.isEmpty(inMap.get("paramVarFlag")) ? "Y" : (String)inMap.get("paramVarFlag"));
		for (Map<String,Object> rowMap : grdData) {

			//공통변수 설정
		    CommUtil.setCommonVar(rowMap);

		    //param 설정
		    if ("Y".equals(paramVarFlag)) {
	    		CommUtil.setParamsVar(rowMap, inMap, arrGrdNm);
		    }

	    	if (mergeFlag) {
	    		if ("deleted".equals(rowMap.get("state"))) {
	    			rtnInt += commonDao.delete(sqlId+Namespace.SQL_DELETE, rowMap);
	    		} else if ("updated".equals(rowMap.get("state")) || "inserted".equals(rowMap.get("state"))) {
	    			rtnInt += commonDao.update(sqlId+Namespace.SQL_MERGE, rowMap);
	    		}
	    	} else {
	    		if ("deleted".equals(rowMap.get("state"))) {
	    			rtnInt += commonDao.delete(sqlId+Namespace.SQL_DELETE, rowMap);
	    		} else if ("updated".equals(rowMap.get("state"))) {
	    			rtnInt += commonDao.update(sqlId+Namespace.SQL_UPDATE, rowMap);
	    		} else if ("inserted".equals(rowMap.get("state"))) {
	    			rtnInt += commonDao.insert(sqlId+Namespace.SQL_INSERT, rowMap);
	    		}
	    	}
		}
		rtnMap.put("saveCnt", rtnInt);
	}
}
