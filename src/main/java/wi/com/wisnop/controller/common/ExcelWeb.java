package wi.com.wisnop.controller.common;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

@Controller
@RequestMapping(value="/excel")
public class ExcelWeb {

	/**
	 * 엑셀업로드 처리
	 * @param file
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/load", method = RequestMethod.POST)
	public @ResponseBody HashMap<String,Object> excelToJson(HttpServletRequest request, @RequestParam("excelFile") MultipartFile file, ModelMap model) {

		HashMap<String,Object> hm = new HashMap<String,Object>();
		try {

			String columnNames = "";
			if(request.getParameter("columnNames") != null) {
				columnNames = request.getParameter("columnNames");
			}

			int headerLine = 1; 
			if(request.getParameter("headerLine") != null) {
				headerLine = Integer.parseInt(request.getParameter("headerLine"));
			}

			String[] columnNameArr = null;

			if(!"".equals(columnNames)) {
				columnNameArr = columnNames.split(",");
			}

			List<Map<String,Object>> list = new ArrayList<Map<String, Object>>();
			Map<String, Object> map = null;

			String fileName = file.getOriginalFilename();
			String extension = fileName.substring(fileName.lastIndexOf(".") + 1, fileName.length());

			Sheet sh;
			if (extension.equalsIgnoreCase("xlsx")) {
				XSSFWorkbook wb = new XSSFWorkbook(file.getInputStream()); //넘어온 파일Stream
				sh = wb.getSheetAt(0);
			} else {
				HSSFWorkbook wb = new HSSFWorkbook(file.getInputStream()); //넘어온 파일Stream
				sh = wb.getSheetAt(0);
			}

			int rowCnt = sh.getPhysicalNumberOfRows();
			Row headerRow = sh.getRow(0);
			int colCnt = headerRow.getPhysicalNumberOfCells();

			String[] colName = null;
			if(columnNameArr != null) {
				colName = columnNameArr;
			} else {
				colName = new String[colCnt];
				for (int colidx = headerRow.getFirstCellNum(), idx = 0; colidx < headerRow.getLastCellNum(); colidx++, idx++) {
					//검토 로직 시도 할때 여기보면 됨
					colName[idx] = headerRow.getCell(colidx).getStringCellValue();
				}
			}
			
			/* 2016.11.25 - 엑셀 컬럼추가후 업로드시 해당 디버그 로직에서 에러남 : 주석처리
			for (int colidx = headerRow.getFirstCellNum(); colidx < headerRow.getLastCellNum(); colidx++) {
				System.out.print(colName[colidx] + ",");
			}
			*/

			boolean isNotNullRow = false;
			
			for (int rowidx=headerLine; rowidx < rowCnt; rowidx++) {
				
				map = new LinkedHashMap<String, Object>();
				Row row = sh.getRow(rowidx);
				
				if (row == null) continue;
				
				isNotNullRow = false;
				for (int colidx = 0, idx = 0; colidx<colName.length; colidx++, idx++) {
					
					Cell cell = row.getCell(colidx);
					Object value = null;
					
					if (cell != null) {
						
						switch (cell.getCellType()) {
							case XSSFCell.CELL_TYPE_FORMULA : 
								try { value = cell.getNumericCellValue(); } catch (Exception e) { value = cell.getCellFormula(); }
								break;
							case XSSFCell.CELL_TYPE_NUMERIC :
								
								/*if (DateUtil.isCellDateFormatted(cell)) { //날짜데이터 포멧설정
									Date date = cell.getDateCellValue();
									value = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault(Locale.Category.FORMAT)).format(date);
								} else {
									
									cell.setCellType(Cell.CELL_TYPE_STRING);
									value = cell.getStringCellValue();
								}*/
								
								cell.setCellType(Cell.CELL_TYPE_STRING);
								value = cell.getStringCellValue();
								
								break;
							case XSSFCell.CELL_TYPE_STRING : 
								value = cell.getStringCellValue();
								break;
							case XSSFCell.CELL_TYPE_BLANK : 
								value = cell.toString();
								break;
							case XSSFCell.CELL_TYPE_BOOLEAN : 
								value = cell.getBooleanCellValue(); 
								break;
							case XSSFCell.CELL_TYPE_ERROR : 
								value = cell.getErrorCellValue(); 
								break;
							default : break;
						}
					} else {
						value = "";
					}

					if (!StringUtils.isEmpty(value)) isNotNullRow = true;
					
					map.put(colName[idx], value);
				}

				//row의 cell 중의 하나라도 데이터가 있어야한다.
				if (isNotNullRow) {
					list.add(map);
				}
			}

			hm.put("results" ,list);

		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

		return hm;
	}
}
