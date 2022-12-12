package wi.com.wisnop.dto.common;

import java.io.Serializable;

public class MenuVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private String frameMenuCd;
	private String menuCd;
	private String menuNm;
	private String url;
	private String dimensionYn;
	private String measureYn;
	private String producthrcyYn;
	private String customerhrcyYn;
	private String salesOrghrcyYn;
	private String dimFixYn;
	
	private String searchYn;
	private String saveYn;
	private String sqlYn;
	private String decimalYn;
	
	private String excelYn;
	private String comBucketMask;

	private String level1Nm;
	private String level2Nm;
	private String level3Nm;
	private int    subMenuCnt;
	private String menuType;
	private String menuParam;
	
	public String getDimFixYn() {
		return dimFixYn;
	}
	public void setDimFixYn(String dimFixYn) {
		this.dimFixYn = dimFixYn;
	}
	public String getMenuType() {
		return menuType;
	}
	public void setMenuType(String menuType) {
		this.menuType = menuType;
	}
	public String getMenuParam() {
		return menuParam;
	}
	public void setMenuParam(String menuParam) {
		this.menuParam = menuParam;
	}
	public String getFrameMenuCd() {
		return frameMenuCd;
	}
	public void setFrameMenuCd(String frameMenuCd) {
		this.frameMenuCd = frameMenuCd;
	}
	public String getDecimalYn() {
		return decimalYn;
	}
	public void setDecimalYn(String decimalYn) {
		this.decimalYn = decimalYn;
	}
	public String getComBucketMask() {
		return comBucketMask;
	}
	public void setBucketMask(String comBucketMask) {
		this.comBucketMask = comBucketMask;
	}
	public int getSubMenuCnt() {
		return subMenuCnt;
	}
	public void setSubMenuCnt(int subMenuCnt) {
		this.subMenuCnt = subMenuCnt;
	}
	public String getSalesOrghrcyYn() {
		return salesOrghrcyYn;
	}
	public void setSalesOrghrcyYn(String salesOrghrcyYn) {
		this.salesOrghrcyYn = salesOrghrcyYn;
	}
	public String getSearchYn() {
		return searchYn;
	}
	public void setSearchYn(String searchYn) {
		this.searchYn = searchYn;
	}
	public String getSaveYn() {
		return saveYn;
	}
	public void setSaveYn(String saveYn) {
		this.saveYn = saveYn;
	}
	public String getSqlYn() {
		return sqlYn;
	}
	public void setSqlYn(String sqlYn) {
		this.sqlYn = sqlYn;
	}
	public String getLevel1Nm() {
		return level1Nm;
	}
	public void setLevel1Nm(String level1Nm) {
		this.level1Nm = level1Nm;
	}
	public String getLevel2Nm() {
		return level2Nm;
	}
	public void setLevel2Nm(String level2Nm) {
		this.level2Nm = level2Nm;
	}
	public String getLevel3Nm() {
		return level3Nm;
	}
	public void setLevel3Nm(String level3Nm) {
		this.level3Nm = level3Nm;
	}
	public String getMenuNm() {
		return menuNm;
	}
	public void setMenuNm(String menuNm) {
		this.menuNm = menuNm;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public String getCustomerhrcyYn() {
		return customerhrcyYn;
	}
	public void setSaleshrcyYn(String customerhrcyYn) {
		this.customerhrcyYn = customerhrcyYn;
	}
	public String getProducthrcyYn() {
		return producthrcyYn;
	}
	public void setProducthrcyYn(String producthrcyYn) {
		this.producthrcyYn = producthrcyYn;
	}
	public String getMenuCd() {
		return menuCd;
	}
	public void setMenuCd(String menuCd) {
		this.menuCd = menuCd;
	}
	public String getDimensionYn() {
		return dimensionYn;
	}
	public void setDimensionYn(String dimensionYn) {
		this.dimensionYn = dimensionYn;
	}
	public String getMeasureYn() {
		return measureYn;
	}
	public void setMeasureYn(String measureYn) {
		this.measureYn = measureYn;
	}
	public String getExcelYn() {
		return excelYn;
	}
	public void setExcelYn(String excelYn) {
		this.excelYn = excelYn;
	}
}
