var selectorAWidth;	

$(function(){
	
	$(".ansBox .show_mod").click(function() {
		$(".brd_writePop").show();
		$(".back").show();
	});

	$(".brd_writePop .close").click(function() {
		$(".brd_writePop").hide();
		$(".back").hide();
	});

	$(".chkLabel label").click(function() {
		$(".chkLabel label").removeClass("on");
		$(this).addClass("on");
	});

	$(".show_sitemap").click(function() {
		$("#sitemappop").show();
		$(".back").show();
	});

	$(".back").click(function() {
		//$("#sitemappop").hide();
		$(".popup2").hide();
		$(".back").hide();
	});
	
	$(".popup .popClose").click(function() {
		$(".popup").hide();
		$(".back").hide();
	});

	$(document).on("click",".popup2 .popClose, .popup2 .pClose",function() {
		$(".popup2").hide();
		$(".back").hide();
	});

	// body 클릭시 메뉴 닫기
	$("body").click(function() {
		$(top.document).find("#util .subbox").hide();
		
		$(top.document).find(".tabcontextbox").hide();
		
		$(top.document).find("#menu .depth2").hide();
		$(top.document).find("#menu .depth3").hide();
		$(top.document).find("#menu ul li").find('a').removeClass('on');

		if ($("#divTreeFindPopup").css("display") == "block" && $("#treeFind").length) {
			$(document).find("#divTreeFindPopup").hide();
		}
	});
	
	// 대메뉴에 마우스 올라갔을때 하위메뉴 열림
	$("#menu > ul > li > a > span").mouseover(function() {
	
		$("#util .subbox").hide();
		$(".tabcontextbox").hide(); //context menu
		
		$("#menu > ul > li > a").removeClass("on");
		$("#menu > ul > li > ul").hide();
		
		$(this).parent().addClass('on');
		$(this).parent().next("ul").show();
		
		$(this).parent().next("ul").find("li:first-child > a").addClass('on');
		$(this).parent().next("ul").find("li:first-child > a").next("ul").show();
		
		$(this).parent().next("ul").find("li").addClass('hide-bg');
		$(this).parent().next("ul").find("li:first-child").removeClass('hide-bg');
		return false;
	});
	
	
	
	// 2단계 메뉴에 마우스 올라갔을때 하위메뉴 열림
	$("#menu > ul > li > ul > li > a > span").mouseover(function() {
	
			$(".depth3").hide();
			$(".depth3").parent().find('a').removeClass('on');
			$("#menu > ul > li > ul > li").addClass('hide-bg');
			$(this).parent().parent().removeClass('hide-bg')
			$(this).parent().addClass('on');
			$(this).parent().next("ul").show();
		
		$(".tabcontextbox").hide(); //context menu
		return false;
	});
	
	$(".gnbWrap").mouseover(function(){
		$("#menu > ul > li > a").removeClass("on");
		$("#menu > ul > li > ul").hide();
		$(".depth3").hide();
		$(".depth3").parent().find('a').removeClass('on');
	});
	
	$("#gnb").mouseover(function(){
		$("#menu > ul > li > a").removeClass("on");
		$("#menu > ul > li > ul").hide();
		$(".depth3").hide();
		$(".depth3").parent().find('a').removeClass('on');
	});
	
	
	$("#tt").mouseover(function(){
		$("#menu > ul > li > a").removeClass("on");
		$("#menu > ul > li > ul").hide();
		$(".depth3").hide();
		$(".depth3").parent().find('a').removeClass('on');
	});
	
	
	
	
	$("#treewrap > .inner > .content_wrap > .treeNav > li > a").click(function() {
		var tree_id = $(this).attr("id");
		for(var i=1; i<=5; i++){
			if($("#treeTab"+i).hasClass("on")) $("#treeTab"+i).removeClass("on");
			$("#treeMenu"+i).hide();
		}
		$("#" + tree_id).addClass("on");
		$("#treeMenu"+tree_id.substr(7)).show();
		
	});
	
	$("#filterDv > .inner > .treeNav > li > a").click(function(){
		/* disable 클래스가 없을 경우만 클릭에 대한 액션이 실행 됨 */
		if(!$(this).hasClass("disable")){
			if($(this).hasClass("on")){
				$(this).removeClass("on");
			} else {
				$(this).addClass("on");
			}
		}
	});
	
	brresize();
	
});

$(window).resize(function(){
	brresize();
}).resize();

function brresize(){
	//브라우저 높이 체크
	if($(".hdt2").css("display") == "none"){
		var brheight = $("#wrap").height() - 51;
		$("iframe").css('height',brheight);
	} else {
		var brheight = $("#wrap").height() - 151;
		$("iframe").css('height',brheight);
	}
}

function gfn_formResize() {
	selectorAWidth = '240px'; // 초기값
	gfn_tabresize();

	if ($("#a").length) {
		Split(['#a', '#b'], {
			//sizes: [25, 75],
			gutterSize: 8,
			minSize: 100,
			cursor: 'col-resize',
			onDrag: function() {
				gfn_tabresize('col');
			},
			useResize : gfn_availableSize
		})
	}

    //트리가 있는경우만 처리
	if ($("#c").length) {
    	Split(['#c', '#d'], {
    		direction: 'vertical',
    		sizes: [30, 70],
    		gutterSize: 8,
    		minSize: 1,
    		cursor: 'row-resize',
    		onDrag: function() {
    			gfn_tabresize('col');
    		}
    	});
    }

	//상하그리드 있는경우만 처리
	if ($("#e").length && $("#f").length) {
    	Split(['#e', '#f'], {
    		direction: 'vertical',
    		sizes: [50, 50],
    		gutterSize: 7,
    		minSize: 100,
    		cursor: 'row-resize',
    		onDrag: function() {
    			gfn_tabresize('col');
    		}
    	});
    }
}

//callback 함수
function gfn_availableSize(pWidth) {
	if ($("#filterDv .scroll").hasVerticalScrollBar()) selectorAWidth = "270px";
	else selectorAWidth = "249px";
	
	if (pWidth) selectorAWidth = pWidth;
	if (selectorAWidth != undefined) return selectorAWidth.substring(0,selectorAWidth.length-2); //px 제거 
	else return selectorAWidth;
}

function gfn_tabresize(col) {
	/* 컨텐츠 우측상단 트리선택값 나오는 부분 */
	var tab_length = $(".srhTab ul li").length;
	if(tab_length != undefined){
		var tab_width = $(".srhTab ul").width();
		$(".srhTab ul li").width(tab_width/tab_length-25); // margin값 13, padding값 12 크기의 왼쪽 여백이 있기 때문에 각각에 대해 그만큼 사이즈를 작게 해야함.
	}
	
	if($(top.document).find(".header_wrap").css("display") == "none"){
		var brheight = $(top.document).height() - 43;
		$(top.document).find("iframe[name="+$("#frameMenuCd").val()+"]").css('height',brheight);
	} else {
		var brheight = $(top.document).height() - 151;
		$(top.document).find("iframe[name="+$("#frameMenuCd").val()+"]").css('height',brheight);
	}
		
	// 각 스크롤 높이 변수 선언
	var adiv = 0;
	var cdiv = 0;
	var ddiv = 0;
	
	// 트리없는 필터영역 스크롤 높이 구하기
	if ($("#a").length && !$("#c").length) {
		if($("#filterDv .scroll").position() != undefined) {
			var ah_top = $("#filterDv .scroll").position().top; 
			var ah_bottom = $("#filterDv .bt_btn").height() + 8; // 버튼 상단 여백 20
			adiv = $("#a").height() - ah_top - ah_bottom;
		}
	}
	
	// 트리영역 스크롤 높이 구하기
	if ($("#c").height()) {
		if($("#treewrap .scroll").position() != undefined) {
			var ch_top = $("#treewrap .scroll").position().top;
			cdiv = $("#c").height() - ch_top - 1; // 스크롤의 상하여백 합이 16
		}
	}
	
	// 필터영역 스크롤 높이 구하기
	if ($("#d").height()) {
		if ($("#filterDv .scroll").position() != undefined) {
			var dh_top = $("#filterDv .scroll").position().top - $("#d").position().top + 8; // 필터의 상단 여백 8
			var dh_bottom = $("#filterDv .bt_btn").height() + 8; // 버튼상단 여백 20
			ddiv = $("#d").height() - dh_top - dh_bottom;
		}
	}
	
	// 스크롤 영역 높이
	if ($("#a").length && !$("#c").length) $("#filterDv .scroll").height(adiv);
	if ($("#c").length) $("#treewrap .treeborder").height(cdiv);
	if ($("#c").length) $("#treewrap .scroll").height(cdiv);
	if ($("#d").length) $("#filterDv .scroll").height(ddiv);
	
	/* 영역 지정 */
	// col = 좌우분할화면 이동여부 / 좌우 분할 화면이 움직일때는 아래의 구문이 동작하면 안됨.
	var availSize = gfn_availableSize();
	if (availSize != undefined && col != "col") {
		if ($("#a").css("display") != "none") {
			// 브라우저가 IE8 일때는 document.documentElement.clientWidth 이걸로..			
			var browser_width = window.innerWidth || document.body.clientWidth;
			var bWidth = browser_width - availSize - 26; // 26 는 영역외의 짜투리 값
			$('#a').width(availSize);
			$('#b').width(bWidth);
		}
	}
	
	// 높이조절 이후 그리드 영역에 맞게 크기 변경
	$.each(GV_ARR_GRID, function() {
		var flag = true;
		var obj = $("#"+this.divId);
		while (flag) {
			obj = obj.parent();
			// 스플리터 화면일때
			if (obj.hasClass("split")) { 
				flag = false;
			
			// 단독일때
			} else if (obj.get(0).tagName.toUpperCase() == "BODY") { 
				flag = false;
			}
			
			// 그리드가 있는 화면의 프레임을 찾았을때
			if (flag == false) { 
				var obj_id = obj.get(0).id;
				if ($("#"+obj_id+" .scroll").position() != undefined) {
					
					var cbtBtnH  = $("#"+obj_id+" .cbt_btn").css("display") == "none" ? 0 : $("#"+obj_id+" .cbt_btn").height() + 8;
					var h_top    = $("#"+obj_id+" .scroll").position().top;
					var h_bottom = ($("#"+obj_id+" .cbt_btn").length ? cbtBtnH : 1);
					h_div        = $("#"+obj_id).height() - h_top - h_bottom;
					
					// 그리드가 들어가는 화면의 높이를 먼저 조정한다.
					$("#"+obj_id+" .scroll").height(h_div);
				
					// 그리드 좌우 2개 쓸때
					if ($(".grid_btn").length) {
						if ($("#"+obj_id+" .srhwrap").height() != undefined) h_top += $("#"+obj_id+" .srhwrap").height();
						else h_top += 11 + gfn_nvl($(".use_tit").height(),0);
						
						h_bottom = $("#"+this.divId).parent().children(".grid_btn").css("display") == "none" ? 0 : $("#"+this.divId).parent().children(".grid_btn").height() + 5;
						h_div    = $("#"+obj_id).height() - h_top - h_bottom;
					}
				}
				
				// 그리드의 높이를 조정한다.
				$("#"+this.divId).width("100%");
				//그리드가 1개
				if ($("#"+this.divId).hasClass("realgrid1")) {
					$("#"+this.divId).height(h_div);
				
				//그리드가 상하 2개
				} else {
					$("#"+this.divId).height(h_div/2-4);
				}
			}
		}
		
		try { this.objGrid.resetSize(); } catch (e) {}
		
	});
	
	$.each(GV_ARR_CHART, function() {
		try {
			$("#"+this.divId).height($("#"+this.divId).parent().height());
			$("#"+this.divId).highcharts().reflow();
		} catch(e) {}
	})
	
	/* 라디오, 체크박스 가로로 나오는 화면에서 갯수에 맞게 크기가 1/n이 되도록 하기 */
	var rdofl_length = $("#filterDv .rdofl").length;
	if (rdofl_length != undefined) {
		$("#filterDv .rdofl").each(function() {
			var rdofl_width = $(this).width();
			if (rdofl_width > 230) rdofl_width = 230;
			var rdofl_li_length = $(this).find("li").length;
			$(this).find("li").width(rdofl_width / rdofl_li_length - 9); // margin값 5, padding값 4 크기의 좌우 여백이 있기 때문에 각각에 대해 그만큼 사이즈를 작게 해야함.
		});
	}
}

