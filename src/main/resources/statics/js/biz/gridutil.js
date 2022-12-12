var gv_subColCnt = 0;
var gv_dimW = 80;
var gv_meaW = 80;
var gv_bucketW = 85;
var gv_multiTxt = true;
var gv_fixedHeight = 20;
var gv_multiFixedHeight = 30;
var gv_measureCd = "CATEGORY_CD";
var gv_measureNm = "CATEGORY_NM";
var gv_measureTxt = "Measure";
var gv_grpLvlId = "GRP_LVL_ID";
var gv_omitFlag = "OMIT_FLAG";
var gv_expand = "(-)";
var gv_folding = "(+)";
var gv_arrDimColor = ["#edf7fd","#f4fffe","#fbffec","#f2f2f2","#fdfafe","#fffcec","#eeece1","#ebffcc","#d9ddf9","#dcfbef"];
var gv_redColor = "#FF0000";
var gv_totalColor = "#FDEFB3";
var gv_bucketColor = "#F2F2F2";
var gv_bucketMtColor = "#FAF4C0";
var gv_bucketTtColor = "#FFE6A5";
var gv_colBucketTotal = "TOTAL";
var gv_total = "Total";
var gv_subTotal = "Sub Total";
var gv_nanText = "";
var gv_whiteColor = "#FFFFFF";
var gv_requiredColor = "#11ff0000";
var gv_noneEditColor = "#EAEAEA";
var gv_editColor = "#F5F6CE";
var gv_headerColor = "#FFB4B4";
var gv_cellDefaultStyles = [
	{criteria: "value < 0",styles: "foreground=#ffff0000"}
];
var gv_monthSumFlag = "N";
var gv_monthSumOut = "N";
var gv_hideColumns = [{CD:gv_grpLvlId},{CD:gv_omitFlag}];
var gv_tmpInstance;
var gv_searchRow = "";
var gv_sumRow = "0";
var gv_avg = "0";
var gv_totalCalcArray = [];
var gv_filterFlag = "N";

var GV_ARR_GRID = [];
var GV_ARR_CHART = [];
var GRID = function () {
    this.objGrid;
    this.objData;
    this.totalFlag = false;
    this.totalPos  = "R";
    this.measureHFlag = false;
    this.measureCFlag = false;
    this.measureAlign = "near";
    this.idMap = []; //그리드 접힘/펼침 처리용
    this.orgLayout;
    this.orgColumns;
    this.orgFields;
    this.treeFlag = false;
    this.objColumnSelect = [];
    this.divId;
    this.bnFormat;
    this.arrIcon = [];
    this.topUpdKeys = "";
    this.custBucketFalg = false;
    this.custNextBucketFalg = false;
    this.custBeforeBucketFalg = false;
    this.custAfterTotalFlag   = false;
};

GRID.prototype = {
    //constructor: GRID,
	treeInit : function( divId ) {
		this.objData = new RealGridJS.LocalTreeDataProvider();
		this.objGrid = new RealGridJS.TreeView(divId);
		this.divId = divId;
		GV_ARR_GRID.push(this);
		this.treeFlag = true;
		gfn_setOption(this, "tree");
		gfn_setGridEvent(this);
		return this;
	},
    init : function( divId ) {
		this.objData = new RealGridJS.LocalDataProvider();
		this.objGrid = new RealGridJS.GridView(divId);
		this.divId = divId;
		GV_ARR_GRID.push(this);
		gfn_setOption(this);
		gfn_setGridEvent(this);
		return this;
	},
	
	//리그드 포커스 처리
	saveTopUpdKeys : function( keys, totalField ) {
		var rtn = "";
		for (var i=0; i<this.objData.getRowCount(); i++) {
			if ( "updated,created".indexOf(this.objData.getRowState(i)) > -1 && ( totalField == undefined || this.objData.getJsonRow(i)[totalField] != gv_total ) ) {
				var splitKeys = keys.split("|");
				for (var is=0; is<splitKeys.length; is++) {
					rtn += splitKeys[is] + ":" + this.objData.getJsonRow(i)[splitKeys[is]] + ",";
				}
				break;
			}
		}
		this.topUpdKeys = rtn.substring(0, rtn.length - 1);
	},

	setFocusKeys : function( focusField ) {
		if (this.topUpdKeys == "") {
			return;
		}
		var findValues = this.topUpdKeys.split(",");
		for (var i=0; i<this.objData.getRowCount(); i++) {
			var isFindRow = true;
			for (var is=0; is<findValues.length; is++) {
				var kv = findValues[is].split(":");
				if (kv[1] != this.objData.getValue(i, kv[0])) {
					isFindRow = false;
					break;
				}
			}
			if (isFindRow) {
				this.objGrid.setCurrent({dataRow : i, column : (focusField == undefined ? 1 : focusField) });
				break;
			}
		}
		
		this.topUpdKeys = ""; //초기화
	},

	setDraw : function () {
		this.objGrid.setColumns(null);
		this.objData.setFields(null);
		this.setFields();
		this.setColumns();

		this.objGrid.setStyles({
            body: {
                cellDynamicStyles: gv_cellDefaultStyles
            }
        });

    	this.orgLayout = this.objGrid.saveColumnLayout();
    	gfn_setBucketFoldinig(this,this.objGrid); //그리드 접힘/펼침
	},

	//그리드 필드 맵데이터 생성
	setFields : function() {

		var fields = new Array();

		//sum,omit0 컬럼
		$.each(gv_hideColumns, function() {
			fields.push({fieldName : this.CD, dataType : "text"});
		});
		
		if (this.custBeforeDimensionFalg == true && typeof fn_setNextFieldsBuket == "function") {
			$.merge(fields, fn_setNextFieldsBuket());
		}

		//디멘전
		$.each(DIMENSION.user, function() {
			fields.push({fieldName : this.DIM_CD, dataType : "text"});
			fields.push({fieldName : this.DIM_CD+"_NM", dataType : "text"});
		});
		
		//cust bucket
		/*if (this.custBeforeBucketFalg == true && typeof fn_setNextFieldsBuket == "function") {
			$.merge(fields, fn_setNextFieldsBuket());
		}*/
		
		if (this.custBeforeBucketFalg == true && typeof fn_setBeforeFieldsBuket == "function") {
			$.merge(fields, fn_setBeforeFieldsBuket());
		}
		

		//hidden 데이셋에만 존재하는 컬럼 생성
		$.each(DIMENSION.hidden, function() {
			fields.push({fieldName : this.CD, dataType : this.dataType || "text"});
		});
		
		

		//메저 전
		$.each(MEASURE.pre, function() {
			fields.push({fieldName : this.CD, dataType : "text"});
			fields.push({fieldName : this.CD+"_NM", dataType : this.dataType || "text"});
		});

		//메저 전 고정
		$.each(MEASURE.fix, function() {
			fields.push({fieldName : this.CD, dataType : this.dataType || "text"});
		});

		//메저
		if(this.measureHFlag == false && $.isArray(MEASURE.user) && MEASURE.user.length>0) {
			fields.push({fieldName : gv_measureCd, dataType : this.dataType || "text"});
			fields.push({fieldName : gv_measureNm, dataType : this.dataType || "text"});
		}
		
		// 버켓 없이 메져만 쓸경우
		if(this.measureCFlag == true  && $.isArray(MEASURE.user) && MEASURE.user.length>0) {
			$.each(MEASURE.user, function() {
				fields.push({fieldName : this.CD, dataType : this.dataType || "text"});
				//fields.push({fieldName : this.CD+"_NM", dataType : this.dataType || "text"});
			});
		}

		//메저 후
		$.each(MEASURE.next, function() {
			fields.push({fieldName : this.CD, dataType : "text"});
			fields.push({fieldName : this.CD+"_NM", dataType : this.dataType || "text"});
		});
		
		//최하단 버켓
		if (this.custBucketFalg == true && typeof fn_setFieldsBuket == "function") {
			$.merge(fields, fn_setFieldsBuket());
		} else {
			gfn_setFieldsBuket(fields);
		}

		//cust bucket
		if (this.custNextBucketFalg == true && typeof fn_setNextFieldsBuket == "function") {
			$.merge(fields, fn_setNextFieldsBuket());
		}

		//합계
		if (this.totalFlag) {
			fields.push({fieldName : gv_colBucketTotal, dataType : "number", subtype: "unum"});
		}

		//비고
		if (this.custAfterTotalFlag) {
			fields.push({fieldName : 'REMARK', dataType : "text"});
		}

		//console.log(fields);
		this.objData.setFields(fields);

		//원본데이터
		this.orgFields = fields;
	},

	//setColumns 함수로 그리드에 반영
	setColumns : function() {
		var columns = [];

		//sum,omit0 컬럼
		$.each(gv_hideColumns, function() {
			var columnsMap = {
				name      	: this.CD,
	    		fieldName 	: this.CD,
	    		width 		: 0,
	    		header 		: {text : ""},
	    		visible : false
			};
			columns.push(columnsMap);
		});

		//디멘전
		var preRule = "";
		var strRule = "";
		var dimAlign = "near";
		var preLvl = "";
		var comLvlIdx = -1;
		
		if (this.custBeforeDimensionFalg == true && typeof fn_setNextColumnsBuket == "function") {
			$.merge(columns, fn_setNextColumnsBuket());
		}
		
		$.each(DIMENSION.user, function(idx) {
			if (preLvl != this.LVL) comLvlIdx++;
			
			strRule = strRule + preRule + (preRule ? " + " : "");
			dimAlign = this.DIM_ALIGN_CD == "C" ? "center" : (this.DIM_ALIGN_CD == "R" ? "far" : "near");
			var columnsMap = {
				name      	: this.DIM_CD+"_NM",
	    		fieldName 	: this.DIM_CD+"_NM",
	    		editable    : false,
	    		width 		: this.WIDTH,
	    		header 		: {text : this.DIM_NM},
	    		mergeRule   : { criteria: strRule + "value" },
	    		//equalBlank  : true, //row fix 처리위해 설정
	    		styles      : { background: gfn_getArrDimColor(comLvlIdx), textAlignment: dimAlign, lineAlignment: "near", paddingTop:4},
	    		dynamicStyles:[gfn_getDynamicStyle(idx)]
			};
			
			if (this.numberFormat) {
				columnsMap.styles.numberFormat = this.numberFormat;
			}
			
			columns.push(columnsMap);
			preRule = "values['"+this.DIM_CD+"_NM"+"']";
			preLvl = this.LVL;
		});
		
		//cust bucket
		/*if (this.custBeforeBucketFalg == true && typeof fn_setNextColumnsBuket == "function") {
			$.merge(columns, fn_setNextColumnsBuket());
		}*/
		if (this.custBeforeBucketFalg == true && typeof fn_setBeforeColumnsBuket == "function") {
			$.merge(columns, fn_setBeforeColumnsBuket());
		}

		//메저 전
		$.each(MEASURE.pre, function(idx) {
			strRule = strRule + preRule + (preRule ? " + " : "");
			dimAlign = this.DIM_ALIGN_CD == "C" ? "center" : (this.DIM_ALIGN_CD == "R" ? "far" : "near");
			var mergeRule = { criteria: strRule + "value" };
			if(this.mergeYn!="Y") {
				mergeRule = {};
			}

			var columnsMap = {
				name 		 : this.CD,
	    		fieldName 	 : this.CD+"_NM",
	    		editable     : false,
	    		//equalBlank   : this.equalBlankYn=="N"?false:true,
	    		mergeRule    : mergeRule,
	    		width 		 : this.width?this.width:gv_dimW,
	    		header 		 : {text : this.NM},
	    		styles       : {textAlignment: (this.textAlignment ? this.textAlignment : dimAlign), lineAlignment: "near", paddingTop:4},
	    		dynamicStyles:[gfn_getDynamicStyle(-1)]
			};
			columns.push(columnsMap);
			preRule = "values['"+this.CD+"_NM"+"']";
		});

		//메저 고정
		$.each(MEASURE.fix, function(idx) {
			strRule = strRule + preRule + (preRule ? " + " : "");
			var mergeRule = { criteria: strRule + "value" };
			if(this.mergeYn!="Y") {
				mergeRule = {};
			}
			
			var columnsMap = {
					name 		 : this.CD,
					fieldName 	 : this.CD,
					editable     : this.EDITABLE || false,
					//equalBlank   : this.equalBlankYn=="N"?false:true,
					mergeRule    : mergeRule,
					width 		 : this.WIDTH || gv_dimW,
					header 		 : {text : this.NM},
					styles       : {numberFormat: this.numberFormat || "#,##0", background: this.BACKGROUND || gv_editColor, textAlignment: this.TEXTALIGNMENT || "near", lineAlignment: "near", paddingTop:4},
					dynamicStyles:[gfn_getDynamicStyle(-1)]
			};
			columns.push(columnsMap);
			preRule = "values['"+this.CD+"']";
		});

		//메저
		if(this.measureHFlag == false && $.isArray(MEASURE.user) && MEASURE.user.length>0) {
			var columnsMap = {
				name 		 : gv_measureNm,
				fieldName 	 : gv_measureNm,
				editable     : false,
				width 		 : gv_meaW,
				header 		 : {text : gv_measureTxt},
				styles       : {textAlignment: this.measureAlign
							  , iconLocation: "left"
						      , iconAlignment: "center"
						      , numberFormat: this.numberFormat || "#,##0"},
				dynamicStyles:[gfn_getDynamicStyle(-1)],
			};

			//아이콘 renderer 처리
			if ($.inArray(gv_measureNm, this.arrIcon) > -1) {
				columnsMap.imageList = "images1";
				columnsMap.renderer  = "icon";
			}

			columns.push(columnsMap);
		};
		
		if(this.measureCFlag == true && $.isArray(MEASURE.user) && MEASURE.user.length>0) {
			$.each(MEASURE.user, function(idx) {
				strRule = "values['"+this.CD+"']";
				var columnsMap = {
					name 		 : this.CD,
					fieldName 	 : this.CD,
					editable     : false,
					width 		 : gv_dimW,
					header 		 : {text : this.NM},
					nanText      : this.nanText || "",
					styles       : {textAlignment: this.measureAlign
								  , iconLocation: "left"
							      , iconAlignment: "center"
							      , numberFormat: this.numberFormat || "#,##0"
							      , background: this.background || gv_noneEditColor},
					dynamicStyles:[gfn_getDynamicStyle(-2)]
				};
				columns.push(columnsMap);
			});
		}

		//메저 후
		$.each(MEASURE.next, function(idx) {
			strRule = "values['"+this.CD+"_NM"+"']";
			var columnsMap = {
				name 		 : this.CD,
				fieldName 	 : this.CD+"_NM",
				editable     : false,
				equalBlank   : this.equalBlankYn=="N"?false:true,
				width 		 : this.width?this.width:gv_dimW,
				header 		 : {text : this.NM},
				nanText      : this.nanText || "",
				styles       : {
					             numberFormat: this.numberFormat || $("#comBucketMask").val() || "#,##0",
								 textAlignment: this.TEXT_ALIGN || "near",
								 background: this.background || gv_bucketColor,
					           },
				dynamicStyles:[gfn_getDynamicStyle(-2)]
			};
			columns.push(columnsMap);
		});

		//합계 함수정의
		var fncTotal = function() {
			var columnsMap = {
					name 		: gv_colBucketTotal,
					fieldName 	: gv_colBucketTotal,
					editable    : false,
					editor      : { positiveOnly: true },
					width 		: gv_bucketW,
					header 		: {text : "Total"},
					nanText     : gv_nanText,
					styles      : {
						numberFormat: $("#comBucketMask").val() || "#,##0",
						textAlignment: "far",
						background: gv_bucketTtColor
					},
					dynamicStyles:[gfn_getDynamicStyle(-2)]
			};
			columns.push(columnsMap);
		}
		
		//합계 뒤  REMARK 정의
		var fncRemark = function() {
			var columnsMap = {
					name 		: 'REMARK',
					fieldName 	: 'REMARK',
					editable    : true,
					width 		: 100,
					header 		: {text : "비고"},
					styles      : {
						textAlignment: "near",
						background: gv_editColor
					},
					dynamicStyles:[gfn_getDynamicStyle(-2)]
			};
			columns.push(columnsMap);
		}
		
		
		//합계 left
		if (this.totalFlag && this.totalPos == "L") fncTotal();
		
		//버켓
		if (this.custBucketFalg == true && typeof fn_setColumnsBuket == "function") {
			$.merge(columns, fn_setColumnsBuket());
		} else {
			gfn_setColumnsBuket(columns,{numberFormat: this.bnFormat});
		}
		
		//cust bucket
		if (this.custNextBucketFalg == true && typeof fn_setNextColumnsBuket == "function") {
			$.merge(columns, fn_setNextColumnsBuket());
		}
		

		//합계 right
		if (this.totalFlag && this.totalPos != "L") fncTotal();

		//비고
		if (this.custAfterTotalFlag)fncRemark();
		
		//console.log(columns);
		this.objGrid.setColumns(columns);

		//원본데이터
		this.orgColumns = columns;
	}
}

function gfn_setFieldsBuket(objFields, param) {
	var param = param || {};

	//최하단 버켓
	$.each(BUCKET.query, function() {
		objFields.push({
			fieldName : this.CD,
			dataType  : this.DATA_TYPE || "number",
		});
	});

	//hidden 버켓
	$.each(BUCKET.hidden, function() {
		objFields.push({
			fieldName : this.CD,
			dataType : "text",
			subtype : param.subtype || ""
		});
	});
}

function gfn_setColumnsBuket(objColumns, param) {
	var param = param || {};

	//여기서 한번만 처리한다.
	if ( param.dynamicStyles == undefined ) {
		param.dynamicStyles = [gfn_getDynamicStyle(-2)];
	}

	var tmpColumnsMap;
	$.each(BUCKET.all[0], function() {
		if (this.TYPE == "group" && BUCKET.all.length > 1) {
			gv_subColCnt = 0;
			tmpColumnsMap = gfn_subBucket(this, 0, param);
			tmpColumnsMap.width = gfn_getSubBucketCnt(this.CD) * gv_bucketW; //Sub Cell count
			objColumns.push(tmpColumnsMap);
		} else {
			var columnsMap = {};
			_gfn_subBucket(objColumns, columnsMap, this, param); //최하단 컬럼 설정
		}
	});
}

//그리드헤더가 2단이상일때 호출되는 함수
function gfn_subBucket(bucketList, idx, param) {
	var columnsMap = {};
	var rootCd = bucketList.CD;
	var addTxt = "";
	if (bucketList.EXPAND_YN == "Y") {
		addTxt = (bucketList.FOLDING_FLAG == "Y" ? gv_folding : gv_expand); //접힘/펼침 처리
	}

	columnsMap.type   = bucketList.TYPE;
	columnsMap.name   = bucketList.CD;
	if (bucketList.TOT_TYPE == "MT") {
		columnsMap.header = {text : bucketList.NM+addTxt};
	} else {
		//columnsMap.header = {text : bucketList.NM+addTxt, fixedHeight : gv_multiTxt && (bucketList.BUCKET_TYPE == "PWEEK" || bucketList.BUCKET_TYPE == "FWEEK") ? gv_multiFixedHeight : gv_fixedHeight};
		if((bucketList.NM).indexOf("\n") != -1) {
			columnsMap.header = {text : bucketList.NM+addTxt, fixedHeight : gv_multiFixedHeight};
		} else {
			columnsMap.header = {text : bucketList.NM+addTxt, fixedHeight : gv_fixedHeight};
		}
	}
	var columns2 = [];
	var tmpColumnsMap;
	$.each(BUCKET.all[++idx], function() {
		var columnsMap2 = {};
		if (this.ROOT_CD == rootCd) {
			if (this.TYPE == "group" && BUCKET.all.length > (idx+1)) {
				tmpColumnsMap = gfn_subBucket(this, idx, param);
				tmpColumnsMap.width = gfn_getSubBucketCnt(this.CD) * gv_bucketW; //Sub Cell count
				columns2.push(tmpColumnsMap);
    		} else {
    			gv_subColCnt++; //Sub Cell count
	    		_gfn_subBucket(columns2, columnsMap2, this, param); //최하단 컬럼 설정
    		}

			if (columns2.length > 0) {
				columnsMap.columns = columns2;
			}
		}
	});

	//columnsMap.width  = gv_subColCnt * gv_bucketW;
	return columnsMap;
}

//최하단 컬럼 설정
function _gfn_subBucket(objColumn, objMap, obj, param) {
	objMap.name          = obj.CD;
	objMap.fieldName     = obj.CD;
	objMap.editable      = (param.editable == undefined ? false : param.editable);
	objMap.editor        = { positiveOnly: true };
	objMap.width         = gv_bucketW;
	objMap.displayWidth  = gv_bucketW;
	if (obj.TOT_TYPE == "MT") {
		objMap.header        = {text : obj.NM};
	} else {
		//objMap.header        = {text : obj.NM, fixedHeight : gv_multiTxt && (obj.BUCKET_TYPE == "PWEEK" || obj.BUCKET_TYPE == "FWEEK") ? gv_multiFixedHeight : gv_fixedHeight};
		if((obj.NM).indexOf("\n") != -1) {
			objMap.header        = {text : obj.NM, fixedHeight : gv_multiFixedHeight};
		} else {
			objMap.header        = {text : obj.NM, fixedHeight : gv_fixedHeight};
		}
	}
	objMap.sortable	     = (param.sortable == undefined ? true : param.sortable);
	objMap.readOnly	     = (param.readOnly == undefined ? false : param.readOnly);
	objMap.styles        = {
								numberFormat: param.numberFormat || obj.numberFormat || $("#comBucketMask").val() || "#,##0",
								textAlignment: obj.TEXT_ALIGN || "far",
								background: (obj.TOT_TYPE=="MT" ? gv_bucketMtColor : (param.readOnly != undefined && !param.readOnly ? gv_editColor : gv_bucketColor) )
								//,textWrap : "normal"
						   };
	/*
	if ( param.dynamicStyles != undefined ) {
		objMap.dynamicStyles = param.dynamicStyles;
	} else {
		objMap.dynamicStyles = [gfn_getDynamicStyle(-2)];
	}
	*/
	objMap.dynamicStyles = param.dynamicStyles;
	objMap.nanText       = obj.nanText == "" ? "" : (obj.nanText || gv_nanText);
	objColumn.push(objMap);
}

//그리드 옵션 공통 설정
function gfn_setOption(objInstance, flag) {
	objInstance.objGrid.setDataSource(objInstance.objData);
	
	if(flag == "tree"){
		objInstance.objGrid.setOptions({
	        panel	: { visible: false },
	        footer	: { visible: false },
	        checkBar: { visible: false },
	        stateBar: { visible: false },
	        //edit    : { editable: false},
	        sorting : { enabled: true  },
	        edit    : { insertable: true, appendable: false, updatable: true, editable: true, deletable: true},
	        header  : {
	        	//height: 50,
	            heightFill: "fixed",
	            showTooltip: true
	        },
	        display : {
	        	emptyMessage: "",
	            //heightMeasurer: "fixed",
	            //rowHeight: 70,
	            //rowResizable: true
	        }
	        /*
	        ,
	        filtering : {
	        	toast : {
	        		visible : true,
	        		message : "Filtering..."
	        	}
	        }
	        */
	        //sorting: { handleVisibility: "always" }
	    });
	}else{
		objInstance.objGrid.setOptions({
	        panel	: { visible: false },
	        footer	: { visible: false },
	        checkBar: { visible: false },
	        stateBar: { visible: false },
	        //edit    : { editable: false},
	        sorting : { enabled: true  },
	        edit    : { insertable: true, appendable: false, updatable: true, editable: true, deletable: true},
	        header  : {
	        	//height: 50,
	            heightFill: "fixed",
	            showTooltip: true
	        },
	        display : {
	        	emptyMessage: "",
	            //heightMeasurer: "fixed",
	            //rowHeight: 70,
	            //rowResizable: true
	        },
	        sortMode: "explicit"
	        /*
	        ,
	        filtering : {
	        	toast : {
	        		visible : true,
	        		message : "Filtering..."
	        	}
	        }
	        */
	        //sorting: { handleVisibility: "always" }
	    });
	}
	
	

	objInstance.objGrid.setPasteOptions({
		checkReadOnly: true,
		enableAppend: false,
		eventEachRow: true,
		forceColumnValidation : true,
		forceRowValidation : true,
		stopOnError : true,
		checkDomainOnly : true,
		noEditEvent : true,
		selectBlockPaste: true,
		numberchars : ","
	});
	
	objInstance.objGrid.setDisplayOptions({
		editItemMerging : true,
	});

	//context menu
	objInstance.objGrid.setContextMenu([
	    {
	    	label: "Fix Column",
	    	callback: function () {
	    		var index = objInstance.objGrid.getCurrent();
	    		if (index.column != null) {
	    			var colCount = gfn_getDisplayIndex(objInstance.objGrid, index.column);
	    			gfn_setFixed(objInstance.objGrid, colCount, 0, null); //index.dataRow
	    		}
	    	}
		},
		{
			label: "Unfix Column",
			callback: function () {
				gfn_setFixed(objInstance.objGrid, 0, 0, null);
			}
		},
		{label: "--------------------------"},
		{
			label: "Fix Row",
			callback: function () {
				var index = objInstance.objGrid.getCurrent();
				if (index.column != null) {
					var colCount = gfn_getDisplayIndex(objInstance.objGrid, index.column);
					gfn_setFixed(objInstance.objGrid, null, 0, index.itemIndex); //index.dataRow
				}
			}
		},
		{
			label: "Unfix Row",
			callback: function () {
				gfn_setFixed(objInstance.objGrid, null, 0, 0);
			}
		},
		{label: "--------------------------"},
		{
			label: "Block Selection",
			callback: function () {
				var options = {
			        style: "block"
			    };
				objInstance.objGrid.setSelectOptions(options);
			}
		},
		{
			label: "Row Selection",
			callback: function () {
				var options = {
						style: "rows"
				};
				objInstance.objGrid.setSelectOptions(options);
			}
		},
		/*
		{label: "--------------------------"},
		{
			label: "Column Select",
			callback: function () {
				gv_tmpInstance = objInstance;
				gfn_comPopupOpen("COLUMNSELECT",null);
			}
		},
		*/
		{label: "--------------------------"},
		{
			label: 'Filter',
			callback: function () {
				var index = objInstance.objGrid.getCurrent();
				createColumnFilter(objInstance.objGrid, index.column, objInstance.objData);
			}
		}
		
	]);

	objInstance.objData.setOptions({
		commitBeforeDataEdit:true,
		restoreMode: "auto",
    	softDeleting:true //삭제시 상태값만 바꾼다.
    });
	
	objInstance.objGrid.setFilteringOptions({
		clearWhenSearchCheck : true,
		selector: {
		    showSearchInput: true,       
		    showButtons:false
		}
	});

	objInstance.objGrid.setStyles(basicGreenSkin);
	objInstance.objGrid.setStyles({header:{textWrap:"none"}});
}

function gfn_getDisplayIndex(grid, name) {
	var column = grid.columnByName(name);
	if (column.parent) {
		return gfn_getDisplayIndex(grid, column.parent);
	} else {
		return column.displayIndex;
	}
}

function gfn_setGridEvent(objInstance) {
	objInstance.objGrid.onContextMenuPopup = function (grid, x, y, elementName) {
	    if (elementName == "HeaderCell") return false;
	}
	
	//헤더 클릭 이벤트 ----------------------
	objInstance.objGrid.onColumnHeaderClicked = function (grid, column) {
		gfn_setChildColumnResize(objInstance, grid, column.name);
    }

	//합계
	objInstance.objGrid.onSelectionChanged = function (grid) {
		var bSum = 0;
		var cells;
		var cnt=0;
		var buffer= "";
		try { cells = grid.getSelectionData(); } catch(e){}
		if (cells) {
			$.each(cells, function(n,v) {
				$.each(v, function(nn,v) {
					if ($.isNumeric(v))
					{
						bSum += Number(v);
						cnt++;
					}
				})
			})
			gv_sumRow = bSum.toFixed(1).toLocaleString();
			buffer = (bSum / cnt).toFixed(1).toLocaleString();
			
			gv_avg = isNaN(buffer)?"0.0":buffer;
			
			parent.$("#bottom_userSum").text(gfn_addCommas(gv_sumRow));
			parent.$("#bottom_userAvg").text(gfn_addCommas(gv_avg));
		}
	};
	
	
	objInstance.objGrid.onKeyDown = function (grid, key, ctrl, shift, alt) {
	    if (key === "F".charCodeAt() && ctrl) {
	    	gfn_findGridLayer(grid);
	    	return false;
	    }
	};
	
}

//버켓영역 접힘/펼침처리
function gfn_setBucketFoldinig(objInstance, objGrd) {
	//첫번째 헤더만 처리
	if (BUCKET.all) {
		for (var i=0; i<BUCKET.all.length; i++) {
			if (i != 0) break;
			$.each(BUCKET.all[i], function() {
				if (this.FOLDING_FLAG == "Y") {
					gfn_setChildColumnResize(objInstance, objGrd, this.CD);
				}
			});
		}
	}
}

//그리드 접힘 펼침 처리
function gfn_setChildColumnResize(objInstance, objGrd, name) {
	//접힘/펼침모드인지 확인
	var header = objGrd.getColumnProperty(name, "header");
	if (header.text.indexOf(gv_expand) == -1 && header.text.indexOf(gv_folding) == -1) {
		return;
	}

	var visible = false;
	var columns = objGrd.getColumnProperty(name, "columns");
	var chkCnt = -1;
	var cName, subColumns, cDisplayWidth;
	
	for (var i=columns.length-1; i>=0; i--) {
		cName         = columns[i]._name;
		subColumns    = objGrd.getColumnProperty(cName, "columns");
		visible       = !objGrd.getColumnProperty(cName, "visible");
		cDisplayWidth = objGrd.getColumnProperty(cName, "displayWidth");
		
		if (isNaN(cDisplayWidth)) cDisplayWidth = objGrd.getColumnProperty(cName, "width"); 
		
		if (cDisplayWidth > 0) chkCnt++;
		if (chkCnt == 0) continue;
		
		objGrd.setColumnProperty(cName, "visible", visible);
		if (subColumns) {
			_gfn_setChildColumnResize(objInstance,objGrd, cName);
		}
	}

	var tmpWidth = gv_bucketW;
	var addHTxt  = gv_folding;
	if (visible) {
		addHTxt = gv_expand;
		$.each(objInstance.idMap, function() {
			if (this.key == name) {
				tmpWidth = this.value;
				return false;
			}
		});
	} else {
		var chkColumn = true;
		$.each(objInstance.idMap, function() {
			if (this.key == name) {
				this.value = objGrd.getColumnProperty(name, "displayWidth");
				chkColumn = false;
			}
		});
		if (chkColumn) {
			objInstance.idMap.push({key:name,value:objGrd.getColumnProperty(name, "displayWidth")});
		}
	}
	
	try{
		tmpWidth = planConfirmWidth;
	}catch(err){}
	

	objGrd.setColumnProperty(name, "displayWidth", tmpWidth);

	//헤더텍스트 변경
	var header = objGrd.getColumnProperty(name, "header");
	header.text = (header.text).replace(gv_folding,"").replace(gv_expand,"") + addHTxt;
	objGrd.setColumnProperty(name, "header", header);

}

function _gfn_setChildColumnResize(objInstance,objGrd, name) {
	
	var btnMonthOutClass = $("#btnMonthOut").attr("class");
	if(btnMonthOutClass == "on"){
		$("#btnMonthOut").removeClass("on");
		gfn_monthOut(objInstance);
	}
	
	var chkCnt = -1;
	var visible = false;
	var cName,subColumns,cDisplayWidth;
	var columns = objGrd.getColumnProperty(name, "columns");
	for (var i=columns.length-1; i>=0; i--) {
		cName         = columns[i]._name;
		subColumns    =  objGrd.getColumnProperty(cName, "columns");
		visible       = !objGrd.getColumnProperty(cName, "visible");
		cDisplayWidth =  objGrd.getColumnProperty(cName, "displayWidth");
		
		if (isNaN(cDisplayWidth)) cDisplayWidth = objGrd.getColumnProperty(cName, "width"); 
		
		if (cDisplayWidth > 0) chkCnt++;
		if (chkCnt == 0) continue;

		objGrd.setColumnProperty(cName, "visible", visible);

		if (subColumns) {
			_gfn_setChildColumnResize(objInstance,objGrd, cName);
		}
	}
}

//column select에서 처리된 컬럼인지 확인
function gfn_isColumnSelect(objInstance,name) {
	var tmpChk = false;
	$.each(objInstance.objColumnSelect, function(n,v) {
		if (v.ORG_VI != v.NEW_VI && v.COLUMN_CD == name) {
			tmpChk = true;
		}
	});
	return tmpChk;
}

//수정된 그리드 데이터를 json으로 리턴한다.
function gfn_getGrdSavedataAll(objGrid) {
	objGrid.commit();
	var objData = objGrid.getDataProvider();
    var state;
    var jData;
    var jRowsData = [];
    var rows = objData.getAllStateRows();

    if (rows.deleted.length > 0) {
        $.each(rows.deleted, function(k, v) {
            jData = objData.getJsonRow(v);
            jData.state = "deleted";
            jData._ROWNUM = (v + 1) + "";
            jRowsData.push(jData);
        });
    }

    if (rows.updated.length > 0) {
        $.each(rows.updated, function(k, v) {
            jData = objData.getJsonRow(v);
            jData.state = "updated";
            jData._ROWNUM = (v + 1) + "";
            jRowsData.push(jData);
        });
    }

    if (rows.created.length > 0) {
        $.each(rows.created, function(k, v) {
            jData = objData.getJsonRow(v);
            jData.state = "inserted";
            jData._ROWNUM = (v + 1) + "";
            jRowsData.push(jData);
        });
    }

    if (jRowsData.length == 0) {
        objData.clearRowStates(true);
        return jRowsData;
    }

    return jRowsData;
}

function gfn_getGrdSaveCount(objGrid) {
	objGrid.commit();
	var rtnCnt = 0;
	var objData = objGrid.getDataProvider();
	rtnCnt += objData.getStateRows("created").length;
	rtnCnt += objData.getStateRows("updated").length;
	rtnCnt += objData.getStateRows("deleted").length;
	
	return rtnCnt;
}

var fixFlagCnt = 0;
function gfn_setFixed(objGrid, leftFixCount, rightFixCount, rowFixCount) {
	
	if(leftFixCount > 0 || rowFixCount > 0){
		fixFlagCnt++;
		
		if(fixFlagCnt > 2){
			fixFlagCnt = 2;
		}
	}else{
		
		fixFlagCnt--;
		
		if(fixFlagCnt == -1){
			fixFlagCnt = 0;
		}
	}
	
	var fixOptions = objGrid.getFixedOptions();
	leftFixCount = leftFixCount != null ? leftFixCount : fixOptions.colCount;
	rowFixCount  = rowFixCount  != null ? rowFixCount  : fixOptions.rowCount;

    var options = new RealGridJS.FixedOptions();
    options.colCount = leftFixCount;
    options.rowCount = rowFixCount;
    options.rightColCount = rightFixCount;
    options.colBarWidth = 2;
    options.rowBarHeight  = 2;
    options.resizable = true;
    options.ignoreColumnStyles = false; //??
    options.ignoreDynamicStyles = false;
    //options.editable = false;
    objGrid.setFixedOptions(options);
}


function createColumnFilter(grid, colName, dataProvider) {
	
	
    var fieldName = grid.getColumnProperty(colName, "fieldName");
    var distinctValues = dataProvider.getDistinctValues(fieldName);
    var filters = [];
   
    
    for(var i = 0; i < distinctValues.length; i++){
    	
    	var tmpFilter;
    	var disVal = distinctValues[i];
    
    	if(disVal != "Sub Total"){
    		//0일때 조건
    		//if(disVal == "" || disVal == " "){
    		if(disVal == ""){
    			
    			
    			tmpFilter = {
    					name:"EMPTY!@#$%^&*",
        				criteria:"value = '"  + disVal +"'"
        		}
        		
        		filters.push(tmpFilter);
        		
        	}else if(disVal === null || disVal === undefined){
        		
        		tmpFilter = {
        				name : "null",
    			        criteria : "value is null"
        		}
        		
        		filters.push(tmpFilter);
        	}
    		else{
        		
        		tmpFilter = {
    		        name : disVal,
    		        criteria: "value ="+ "'" + disVal + "'"
    		    };
        		filters.push(tmpFilter);
        	} 
    	}
    }
    
    grid.setColumnFilters(colName, filters);
    
    if(gv_filterFlag == "Y"){
    	grid.onFilteringChanged = function (grid, column){
        	fn_setExpand();
    	}
    }
}



//디멘전에 따른 백그라운드 처리
function gfn_getDynamicStyle(aIdx, userArray) {
	var rtnVal = {};
	var arrCriteria = [];
	var arrStyles = [];
	var curCol = "";
	var i = 0;
	var preLvl = ""
	var preIdx = -1;
	var tmpIdx = -1;
	var tmpObj = [];
	if (!gfn_isNull(userArray) && $.isArray(userArray)) {
		$.each(userArray, function(n,v) {
			tmpObj.push({DIM_CD : v, LVL: (n+1)});
		});
	} else {
		tmpObj = DIMENSION.user;
	}
	
	$.each(tmpObj, function(n,v) {
		i = tmpIdx+1;
		if (aIdx < n && aIdx != -1 && aIdx != -2) return false;
		
		curCol = tmpObj[n].DIM_CD+"_NM";
		if (!gfn_isNull(userArray) && $.isArray(userArray)) {
			curCol = tmpObj[n].DIM_CD;
		}
		
		if (n == 0) {
			arrCriteria.push("values['"+curCol+"'] = '"+gv_total+"'");
			arrStyles.push("background="+gv_totalColor);
		} else {
			tmpIdx = preLvl == v.LVL ? preIdx : preIdx+1;
			if (aIdx < 0) {
				arrCriteria.push("values['"+curCol+"'] = '"+gv_subTotal+"'");
				arrStyles.push("background="+gfn_getArrDimColor(tmpIdx-1));
			} else {
				arrCriteria.push("(values['"+curCol+"'] = '"+gv_subTotal+"')");
				arrStyles.push("background="+gfn_getArrDimColor(tmpIdx-1));
			}
		}
		
		preIdx = preLvl == v.LVL ? preIdx : preIdx+1;
		preLvl = v.LVL;
	});
	
	//메저일때
	if (aIdx == -1) {
		arrCriteria.push("1=1");
		arrStyles.push("background="+gfn_getArrDimColor(i-1));
	}

	rtnVal.criteria = arrCriteria;
	rtnVal.styles = arrStyles;

	return rtnVal;
}

function gfn_getSubValidation(objGrid,objData,columns,jData,v) {
	var tmpRtnVal = true;
	var focusCell = {dataRow : -1};
	$.each(columns, function(idx, val) {
		if (tmpRtnVal == false) return false;
    	if (!jData[val]) {
    		header = objGrid.getColumnProperty(val, "header");
    		alert(header.text+"는 필수입니다.");
    		//focusCell.itemIndex = v;
    		focusCell.dataRow = v;
    		focusCell.column = val;
    		focusCell.fieldName = val;
    		//포커스된 셀 변경
    		objGrid.setCurrent(focusCell);
    		tmpRtnVal == false;
    		return false;
    	}
    });

	return focusCell;
}

//그리드 필수값 객체리턴
function gfn_getValidation(objInstance,columns, param) {
	var objGrid = objInstance.objGrid;
	var objData = objInstance.objData;
	var jData, header;
	var focusCell = {dataRow : -1};
    objGrid.commit();

	param = param || {};

	var rows = objData.getAllStateRows();

	//신규
	if (rows.created.length > 0) {
        $.each(rows.created, function(k, v) {
        	jData = objData.getJsonRow(v);
        	if (focusCell.dataRow != -1) return false;
        	focusCell = gfn_getSubValidation(objGrid,objData,columns,jData,v);
        	if (focusCell.dataRow != -1) return false;

        	// 필드별 코드값 체크
        	if ( param.CHECK_CODE != undefined ) {
        		if (focusCell.dataRow != -1) return false;
            	focusCell = gfn_getSubCodeValidation(objGrid,objData,jData,v,param);
            	if (focusCell.dataRow != -1) return false;
        	}
        });
    }

	//수정
	if (rows.updated.length > 0) {
        $.each(rows.updated, function(k, v) {
        	jData = objData.getJsonRow(v);
        	if (focusCell.dataRow != -1) return false;
        	focusCell = gfn_getSubValidation(objGrid,objData,columns,jData,v);
        	if (focusCell.dataRow != -1) return false;

        	// 필드별 코드값 체크
        	if ( param.CHECK_CODE != undefined ) {
        		if (focusCell.dataRow != -1) return false;
            	focusCell = gfn_getSubCodeValidation(objGrid,objData,jData,v,param);
            	if (focusCell.dataRow != -1) return false;
        	}
        });
    }

    return (focusCell.dataRow == -1);
}

// 필드별 코드값 체크 로직
function gfn_getSubCodeValidation(objGrid,objData,jData,v,param) {
	var focusCell = {dataRow : -1};
	var tmpRtnVal = true;
	for (var field in param.CHECK_CODE) {
		if (tmpRtnVal == false) return false;
		var checkCodes = param.CHECK_CODE[field] + ",";
		if ( !gfn_isNull(objGrid.getValue(v, field)) && checkCodes.indexOf(objGrid.getValue(v, field) + ",") < 0 ) {
    		header = objGrid.getColumnProperty(field, "header");
    		alert(header.text+"의 코드값을 확인해 주세요.");
    		focusCell.dataRow = v;
    		focusCell.column = field;
    		focusCell.fieldName = field;
    		//포커스된 셀 변경
    		objGrid.setCurrent(focusCell);
    		tmpRtnVal = false;
    		return false;
		}
    }

	return focusCell;
}

//공통 renderer type 정의
function gfn_getRenderer(type,params) {
	params = params || {};
	var rtnRenderer;
	switch(type) {
		case "CHECK" :
			rtnRenderer = {
				type: "check",
                shape: "box",
                editable: params.editable != false ? true : false,
                startEditOnClick: true,
                trueValues: "Y",
                falseValues: "N"
			}
			break;
	}
	return rtnRenderer;
}

//디멘전 색상을 가져온다.
function gfn_getArrDimColor(idx) {
	return gv_arrDimColor.length-1 < idx || idx < 0 ? "#FFFFFF" : gv_arrDimColor[idx];
}

//month, sum, omit zero
function gfn_setMonthSum(objInstance, monthFlag, sumFlag, omitFlag, totalFlag, monthOutFlag) {
	
	if (!monthOutFlag) {
		$("#btnMonthOut").addClass("disable");
		$("#btnMonthOut").text("");
	} else {
		$("#btnMonthOut").click("on", function() {
			gv_monthSumOut = "Y";
			gfn_monthOut(objInstance); 
		});
	}
	
	if (!monthFlag) {
		$("#btnMonth").addClass("disable");
		$("#btnMonth").text("");
	} else {
		$("#btnMonth").click("on", function() {
			gv_monthSumFlag = "Y";
			gfn_month(objInstance); 
		});
	}

	if (!sumFlag) {
		$("#btnSum").addClass("disable");
		$("#btnSum").text("");
	} else {
		$("#btnSum").click("on", function() {
			gfn_sum(objInstance.objGrid);
			gfn_setSearchRow(gfn_addCommas(objInstance.objGrid.getItemCount()) + " / " +gfn_addCommas(objInstance.objData.getRowCount()));
		});
	}

	if (!omitFlag) {
		$("#btnOmit0").addClass("disable");
		$("#btnOmit0").text("");
	} else {
		$("#btnOmit0").click("on", function() {
			gfn_omit(objInstance.objGrid);
			gfn_setSearchRow(gfn_addCommas(objInstance.objGrid.getItemCount()) + " / " +gfn_addCommas(objInstance.objData.getRowCount()));
		});
	}

	if (!totalFlag) {
		$("#btnTotal").addClass("disable");
		$("#btnTotal").text("");
	} else {
		$("#btnTotal").click("on", function() {
			gfn_omitTotal(objInstance.objGrid);
			gfn_setSearchRow(gfn_addCommas(objInstance.objGrid.getItemCount()) + " / " +gfn_addCommas(objInstance.objData.getRowCount()));
		});
	}
}

function gfn_setChildColumnResizeMonthOut(objInstance, objGrd, name) {
	//접힘/펼침모드인지 확인
	var header = objGrd.getColumnProperty(name, "header");
	
	if (header.text.indexOf(gv_expand) == -1 && header.text.indexOf(gv_folding) == -1) {
		return;
	}

	var visible = false;
	var columns = objGrd.getColumnProperty(name, "columns");
	var chkCnt = -1;
	var cName, subColumns, cDisplayWidth;
	
	
	for (var i=columns.length-1; i>=0; i--) {
		cName         = columns[i]._name;
		subColumns    = objGrd.getColumnProperty(cName, "columns");
		visible       = !objGrd.getColumnProperty(cName, "visible");
		cDisplayWidth = objGrd.getColumnProperty(cName, "displayWidth");
		
		if (isNaN(cDisplayWidth)) cDisplayWidth = objGrd.getColumnProperty(cName, "width"); 
		
		if (cDisplayWidth > 0) chkCnt++;
		
		if (chkCnt != 0) {
			continue;
		}
		
		objGrd.setColumnProperty(cName, "visible", visible);
		if (subColumns) {
			//_gfn_setChildColumnResize(objInstance,objGrd, cName);
		}
	}
/*
	var tmpWidth = gv_bucketW;
	var addHTxt  = gv_folding;
	if (visible) {
		addHTxt = gv_expand;
		$.each(objInstance.idMap, function() {
			if (this.key == name) {
				tmpWidth = this.value;;
				return false;
			}
		});
	} else {
		var chkColumn = true;
		$.each(objInstance.idMap, function() {
			if (this.key == name) {
				this.value = objGrd.getColumnProperty(name, "displayWidth");
				chkColumn = false;
			}
		});
		if (chkColumn) {
			objInstance.idMap.push({key:name,value:objGrd.getColumnProperty(name, "displayWidth")});
		}
	}

	objGrd.setColumnProperty(name, "displayWidth", tmpWidth);

	//헤더텍스트 변경
	var header = objGrd.getColumnProperty(name, "header");
	header.text = (header.text).replace(gv_folding,"").replace(gv_expand,"") + addHTxt;
	objGrd.setColumnProperty(name, "header", header);
	*/
}

function gfn_monthOut(objInstance){
	
	if (gv_monthSumOut != "Y") return; //한번도 처리한적이 없는경우
	
	var btnMonthClass = $("#btnMonth").attr("class");
	var classNm = $("#btnMonthOut").attr("class");
	var columnNames = objInstance.objGrid.getColumnNames(false);
	var header, visible;
	var tmpChk = true;
	
	if(btnMonthClass == "on"){
		$("#btnMonthOut").removeClass("on");
		alert(monthOutMessage);
		return;
	}
	
	// 접힘
	if (classNm == "on") {
		for (var i = columnNames.length - 1;  i >= 0; i--) {
			header = objInstance.objGrid.getColumnProperty(columnNames[i], "header");
			visible = objInstance.objGrid.getColumnProperty(columnNames[i], "visible");
			
			if (header.text == undefined) continue;

			if (header.text.indexOf(gv_expand) != -1) {
				if (!visible) continue;
				
				
				gfn_setChildColumnResizeMonthOut(objInstance, objInstance.objGrid, columnNames[i]);
			}
		}

	// 펼침
	} else {
		for (var i=0; i<columnNames.length; i++) {
			header = objInstance.objGrid.getColumnProperty(columnNames[i], "header");
			if (header.text == undefined) continue;

			if (header.text.indexOf(gv_expand) != -1) {
				
				gfn_setChildColumnResizeMonthOut(objInstance, objInstance.objGrid, columnNames[i]);
			}
		}
	}
}

//데이터 조회후 처리용
function gfn_actionMonthSum(objInstance) {
	if ($("#btnMonthOut").attr("class") != "disable") gfn_monthOut(objInstance);
	if ($("#btnMonth").attr("class") != "disable") gfn_month(objInstance);
	if ($("#btnSum"  ).attr("class") != "disable") gfn_sum(objInstance.objGrid);
	if ($("#btnOmit0").attr("class") != "disable") gfn_omit(objInstance.objGrid);
	if ($("#btnTotal").attr("class") != "disable") gfn_omitTotal(objInstance.objGrid);

	gfn_setSearchRow(gfn_addCommas(objInstance.objGrid.getItemCount()) + " / " +gfn_addCommas(objInstance.objData.getRowCount()));
}

function gfn_month(objInstance) {
	
	if (gv_monthSumFlag != "Y") return; //한번도 처리한적이 없는경우
	
	
	var btnMonthOutClass = $("#btnMonthOut").attr("class");
	var classNm = $("#btnMonth").attr("class");
	var columnNames = objInstance.objGrid.getColumnNames(false);
	var header, visible;
	var tmpChk = true;
	
	if(btnMonthOutClass == "on"){
		$("#btnMonth").removeClass("on");
		alert(monthMessage);
		return;
	}
	
	// 접힘
	if (classNm == "on") {
		for (var i=columnNames.length-1; i>=0; i--) {
			header = objInstance.objGrid.getColumnProperty(columnNames[i], "header");
			visible = objInstance.objGrid.getColumnProperty(columnNames[i], "visible");
			
			if (header.text == undefined) continue;

			if (header.text.indexOf(gv_expand) != -1) {
				if (!visible) continue;
				
				gfn_setChildColumnResize(objInstance, objInstance.objGrid, columnNames[i]);
			}
		}

	// 펼침
	} else {
		for (var i=0; i<columnNames.length; i++) {
			header = objInstance.objGrid.getColumnProperty(columnNames[i], "header");
			if (header.text == undefined) continue;

			if (header.text.indexOf(gv_folding) != -1) {
				
				gfn_setChildColumnResize(objInstance, objInstance.objGrid, columnNames[i]);
			}
		}
	}
}

//Filter Sum 기능 함수 ( 활성화시 Sum이 나옴 )
function gfn_sum(grid) {
   	if ( $("#btnSum").attr("class") == "on" ) {
		grid.addColumnFilters(gv_grpLvlId,[{
			name: gv_grpLvlId,
			criteria: "value = '0'",
			active: true
		 }]);
	} else {
		grid.clearColumnFilters(gv_grpLvlId);
   	}
}

//Filter Omit0 함수 ( 활성화시 0를 없애줌 )
function gfn_omit(grid) {
	if ( $("#btnOmit0").attr("class") == "on" ) {
		grid.addColumnFilters(gv_omitFlag,[{
            name: gv_omitFlag,
            criteria: "value <> '0'",
	    	active: true
       	}]);
   	} else {
   		grid.clearColumnFilters(gv_omitFlag);
   	}
}

function gfn_omitTotal(grid) {
   	if ( $("#btnTotal").attr("class") == "on" ) {
   		grid.addColumnFilters("TOTAL_FLAG",[{
			name: "TOTAL_FLAG",
			criteria: "value <> '0'",
			active: true
		 }]);
	} else {
		grid.clearColumnFilters("TOTAL_FLAG");
   	}
}

function gfn_setColumnSel(pStr) {
	gv_tmpInstance.objColumnSelect = JSON.parse(pStr);
}

//행 토탈 arrField
function gfn_getChnArrField(gridInst, provider, field) {
	var rtnArr   = [];
	var bucketId = provider.getFieldName(field);
	var rootCd   = gfn_getFindValueInDs(BUCKET.query, "BUCKET_ID", bucketId, "ROOT_CD");
	
	//변경될 index set
	rtnArr.push(bucketId);
	rtnArr.push(rootCd.replace("M","MT_"));
	if (gridInst.totalFlag == true) rtnArr.push(gv_colBucketTotal);
	
	return rtnArr;
}

//수정될 영역 검색
function gfn_getTotalEndIdx(provider, idx, type) {
	
	type = type || "A";
	
	var grpLvlId = provider.getValue(idx, gv_grpLvlId);
	var meaCd    = provider.getValue(idx, gv_measureCd);
	var totCnt = provider.getRowCount();
	for (var i=idx+1; i<totCnt; i++) {
		if (type == "A" && meaCd == provider.getValue(i, gv_measureCd) && (Number(grpLvlId) == Number(provider.getValue(i, gv_grpLvlId)) || Number(grpLvlId) < Number(provider.getValue(i, gv_grpLvlId)))) {
			return i-1;
		} else if (type != "A" && meaCd == provider.getValue(i, gv_measureCd) && Number(grpLvlId) < Number(provider.getValue(i, gv_grpLvlId))) {
			return i-1;
		}
	}
	return totCnt-1;
}

//DS에서 해당컬럼에 데이터가 일치하는 건수를 반환한다.
/**
 * pColNm : Array or String
 * pVal   : Array or String
 */
function gfn_getCaseCnt(pDs,pColNm,pVal) {
	var cnt = 0;
	for (var i=0; i<pDs.getRowCount(); i++) {
		var chkComapre = true;
		if($.isArray(pColNm)) {
			$.each(pColNm, function(n,v) {
				if (pVal[n] != pDs.getValue(i,v)) chkComapre = false;
			})

		} else {
			if (pVal != pDs.getValue(i,pColNm)) chkComapre = false;
		}

		if (chkComapre) cnt++;
	}
	return cnt;
}

//DS에서 해당컬럼에 데이터가 일치하는 첫번째row index를 반환한다.
function gfn_getFindRow(pDs,pColNm,pVal,curIdx,delFlag) {
	delFlag = delFlag || "Y"; //삭제 데이터 포함 여부
	var rtn = -1;
	for (var i=0; i<pDs.getRowCount(); i++) {
		
		if (delFlag != "Y" && (pDs.getRowState(i) == "deleted" || pDs.getRowState(i) == "createAndDeleted")) continue;
		
		var chkComapre = true;
		//자신의 row면 pass
		if (!gfn_isNull(String(curIdx)) && i == curIdx) continue;

		if($.isArray(pColNm)) {
			$.each(pColNm, function(n,v) {
				if (pVal[n] != pDs.getValue(i,v)) {
					chkComapre = false;
					return false;
				}
			});
		} else {
			if (pVal != pDs.getValue(i,pColNm)) chkComapre = false;
		}

		if (chkComapre) {
			rtn = i;
			break;
		}
	}
	return rtn;
}

//DS에서 해당컬럼에 데이터가 일치하는 마지막row index를 반환한다.
function gfn_getLastRow(pDs,pColNm,pVal,curIdx,delFlag) {
	delFlag = delFlag || "Y"; //삭제 데이터 포함 여부
	var rtn = -1;
	for (var i=pDs.getRowCount()-1; i>=0; i--) {
		
		if (delFlag != "Y" && (pDs.getRowState(i) == "deleted" || pDs.getRowState(i) == "createAndDeleted")) continue;
		
		var chkComapre = true;
		//자신의 row면 pass
		if (!gfn_isNull(String(curIdx)) && i == curIdx) continue;
		
		if($.isArray(pColNm)) {
			$.each(pColNm, function(n,v) {
				if (pVal[n] != pDs.getValue(i,v)) {
					chkComapre = false;
					return false;
				}
			});
		} else {
			if (pVal != pDs.getValue(i,pColNm)) chkComapre = false;
		}
		
		if (chkComapre) {
			rtn = i;
			break;
		}
		
		/*
		if (pVal == pDs.getValue(i,pColNm)) {
			rtn = i;
			break;
		}
		*/
	}
	return rtn;
}

//Total Row Fixed
function gfn_setRowTotalFixed(grdObj) {
	
	if (grdObj.getItemCount() == 0) return;
	
	var arrCol = grdObj.getColumns();
	var fCol = "";
	$.each(arrCol, function(n,v) {
		if (v.visible) {
			fCol = v.name;
			return false;
		}
	});
	
	var i = -1;
	for (i=0; i<grdObj.getItemCount(); i++) {
		if (grdObj.getValue(i, fCol) != gv_total) {
			break;
		}
	}
	
	if(fixFlagCnt == 0){
		if (i > -1) {
			var colCount = gfn_getDisplayIndex(grdObj, fCol);
			gfn_setFixed(grdObj, colCount, 0, i);
		}
	}
}

function gfn_findGridLayer(grid) {
	var inHtml = '';
	inHtml += '<div class="popup2" style="width:250px;" id="treeFind">';
	inHtml += '	<div class="drag">';
	inHtml += '	<div class="pop_tit">Find</div>';
	inHtml += '	<div class="popCont" style="height:23px;">';
	inHtml += '		<div class="view_combo">';
	inHtml += '			<div class="ilist">';
	inHtml += '				<input type="text" id="FIND_TXT" name="FIND_TXT" class="ipt" style="width:157px;"> <a href="#" class="app">Find</a>';
	inHtml += '			</div>';
	inHtml += '		</div>';
	inHtml += '	</div>';
	inHtml += '	</div>';
	inHtml += '	<a href="#" class="popClose"><img src="'+ GV_CONTEXT_PATH +'/statics/images/common/pop_close.png" alt=""></a>';
	inHtml += '</div>';

	$("#divFindPopup").html(""); //초기화
	$("#divFindPopup").html(inHtml);
	
	$("#FIND_TXT").next().on("click", function() {
		gfn_findGrid(grid);
	});
	
	$("#divFindPopup").draggable({
		containment: '#wrap', 
		scroll: false,
		handle:'.drag .pop_tit'
	});
	
	$("#divFindPopup").css('zIndex',99999);
	$("#divFindPopup").show();
	$("#FIND_TXT").focus();
	//$(".back_white").show();
	$(".back_white").on("click", function() {
		//$(".popup2").hide();
		$("#divFindPopup").hide();
		$(".back_white").hide();
	});

	$(".popClose").click(function() {
		$(".back_white").trigger("click");
	});
	
	//text 초기화
	$("#FIND_TXT").unbind();
	$("#FIND_TXT").bind("keydown", function() {
		if (event.keyCode == 13) {
			gfn_findGrid(grid);
			return false;
		}
		if (event.key == "Escape") {
			$(".back_white").trigger("click");
		}
	});
	
	$("#divFindPopup").click( function( e ) {
        return false;
    });

	//$("#divFindPopup").css("left", $("#treewrap").width()+10);
	//$("#divFindPopup").css("top", $("#treewrap").offset().top+25);
}

function gfn_findGrid(grid) {
	var columnNames = grid.getColumnNames(true,true);
	var value = $("#FIND_TXT").val();
    var fields = columnNames;
    //var startFieldIndex = grid.getCurrent().fieldIndex + 1;
    var startFieldIndex = fields.indexOf(grid.getCurrent().fieldName) + 1;
    var options = {
        fields : fields,
        //columns : columnNames,
        value : value,
        startItemIndex : grid.getCurrent().itemIndex,
        startFieldIndex : startFieldIndex,
        wrap : true,
        caseSensitive : false,
        partialMatch : true
    };

    var index = grid.searchCell(options);
    if (index == null) {
    	//alert(gfn_getDomainMsg("msg.noDataFound"));
    } else {
    	grid.setCurrent(index);
    }
}

//그리드 컬럼중 자신의 부모 컬럼을 배열로 리턴한다.
function gfn_getArrParent(grid,name) {
	var rtnArr = [];
	var column = grid.columnByName(name);
	
	if (column.parent) {
		rtnArr.push(column.parent);
		$.each(gfn_getArrParent(grid,column.parent), function(n,v) {
			rtnArr.push(v);
		});
	}
	return rtnArr;
}

//그리드 컬럼중 배열로 받은 컬럼을 visible 처리
function gfn_gridCtrl(grid,arrColumn,visi) {
	var orgW,pColW,chnW;
	var arrParent = [];
	$.each(arrColumn, function(n,v) {
		arrParent = gfn_getArrParent(grid,v);
		orgW      = grid.getColumnProperty(v, "width");
		grid.setColumnProperty(v, "visible", visi);		
		$.each(arrParent, function(nn,vv) {
			pColW = grid.getColumnProperty(vv, "width");
			chnW  = pColW + (orgW * (visi ? 1 : -1));
			grid.setColumnProperty(vv, "width", chnW);				
		});
	});
}