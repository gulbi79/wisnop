package wi.com.wisnop.common.message.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import wi.com.wisnop.common.message.MessageResourceService;
import wi.com.wisnop.dao.CommonDao;

@Service
public class MessageResourceServiceImpl implements MessageResourceService {
	// 공통 DAO
	@Autowired
	private CommonDao commonDao;

	@Override
	public List<Map<String, String>> loadAllMessages() {
		return commonDao.selectList("admin.translateMngSelect");
	} 
}
