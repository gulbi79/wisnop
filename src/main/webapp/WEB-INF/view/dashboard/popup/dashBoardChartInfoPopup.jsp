<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>Dashboard Chart Info</title>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
    <jsp:param name="popupYn" value="Y"/>
</jsp:include>
<style>
.modal{

    height: 100%;
    left: 0;
    position: fixed;
    top: 0;
    width: 100%;
    display:flex;
    flex-direction:column;
    overflow:hidden;

}

.modal_header{

    height:90px;
    padding-top:5px;
    padding-bottom:0;
    padding-left: 17px;
    padding-right: 17px;
    
}

.modal_content{
    
    height:auto;
    overflow-y:hidden;
    padding: 10px 15px 10px 15px;
    flex:1;
    display:flex;
    flex-direction:column
}


.modal_footer{

    height:30px;
}

.modal_footer > .modal_Btn_Container
{
    
    padding:2px;
    text-align:center;
}

.modal_footer > .modal_Btn_Container > .btn_box
{
       
    padding-right:5px;

}



.modal_footer > .modal_Btn_Container > .btn_box > .button
{
  background-color: #F5F5F5; 
  border: none;
  color: black;
  padding: 2px;
  text-align: center;
  text-decoration: none;
  display: inline-block;
  font-size: 12px;
  cursor: pointer; 
  border-radius: 4px;
}

.modal_footer > .modal_Btn_Container > .btn_box > .button:hover
{
  background-color: #0F4C81;
  color:white; 
}




.modal_header > .pupupInfo_title{
    
    font-size:xx-large;
    font-weight:bold;
    display:block;
    padding-top:5px;
    padding-left:0;
    padding-right:5px;
    padding-bottom:5px;
    text-align:left;
    position:relative;
    
 }

.modal_header > .pupupInfo_etc{
    border-top:   1px solid #ccc!important;
    border-bottom:   1px solid #ccc!important;
    position:relative;
    padding:2px;
    
    display:block;
    height:25px;
}

.modal_header > .pupupInfo_etc > .writer_container{

    padding-top:2px;
    padding-left:2px;
    padding-right:5px;
    padding-bottom:2px;
    line-height:18px;
    height:20px;
    float:left;
    vertical-align:middle;
}

.modal_header > .pupupInfo_etc > .regDate_container{
    
    padding-top:2px;
    padding-left:5px;
    padding-right:2px;
    padding-bottom:2px;
    line-height:18px;
    height:20px;
    float:left;
    vertical-align:middle;
}

.modal_header > .pupupInfo_etc > .postingPeriod_container{
    
    padding:2px;
    line-height:18px;
    height:20px;
    float:right;
    vertical-align:middle;
}



.modal_header > .pupupInfo_etc > .writer_container > p{

    padding-top:2px;
    padding-left:0;
    padding-right:0;
    padding-bottom:2px;
    font-size:12px;
    display:inline-block;

}


.modal_header > .pupupInfo_etc > .writer_container > #popupWriter{
    
    padding-top:2px;
    padding-left:0;
    padding-right:0;
    padding-bottom:2px;
    font-size:12px;
    text-align:left;
    display:inline-block;

 }










.modal_header > .pupupInfo_etc > .postingPeriod_container > p{
    
    padding-top:2px;
    padding-left:0;
    padding-right:0;
    padding-bottom:2px;
    font-size:12px;
    display:inline-block;

}



.modal_header > .attachedFile{
    display:block;
    border-bottom: 1px solid #ccc!important;
    padding-top: 2px;
    padding-bottom: 2px;
}

.modal_header > .attachedFile > ul{
    
       
}
.modal_header > .attachedFile > ul > li{

    
    line-height:13px;
    font-size:12px;
    
    padding-top: 5px;
    padding-right: 5px;
    padding-left: 0;
    padding-bottom:5px;
}
.modal_header > .attachedFile > ul > li > a{

    
    border-left: 6px solid #ccc!important;
    display:inline-block;
    
}
.modal_header > .attachedFile > ul > li > a > p{

    padding-left: 5px;
    position:relative;
}




</style>


</head>
<body>
    
    <div class="modal">
        <div class="modal_header">
            <input id="popupTitle" class="pupupInfo_title" type="text" readonly="readonly" size="40" />
            <div class="pupupInfo_etc">
                <div class="writer_container">
                    <img src="${ctx}/statics/images/common/ico_home.gif" alt="">
                    <input id="popupWriter"  type="text" readonly="readonly" size="40" />
                    
                </div>
                 
            </div>
             
        </div>
        
        <div class="modal_content">
            
                <div id="toolbar">
        
                    <span class="ql-formats">
                      <select class="ql-font"></select>
                      <select class="ql-size"></select>
                    </span>
                    <span class="ql-formats">
                      <button class="ql-bold"></button>
                      <button class="ql-italic"></button>
                      <button class="ql-underline"></button>
                      <button class="ql-strike"></button>
                    </span>
                    <span class="ql-formats">
                      <select class="ql-color"></select>
                      <select class="ql-background"></select>
                    </span>
                    <span class="ql-formats">
                      <button class="ql-script" value="sub"></button>
                      <button class="ql-script" value="super"></button>
                    </span>
                    <span class="ql-formats">
                      <button class="ql-header" value="1"></button>
                      <button class="ql-header" value="2"></button>
                      <button class="ql-blockquote"></button>
                      <button class="ql-code-block"></button>
                    </span>
                    <span class="ql-formats">
                      <button class="ql-list" value="ordered"></button>
                      <button class="ql-list" value="bullet"></button>
                      <button class="ql-indent" value="-1"></button>
                      <button class="ql-indent" value="+1"></button>
                    </span>
                    <span class="ql-formats">
                      <button class="ql-direction" value="rtl"></button>
                      <select class="ql-align"></select>
                    </span>
                    <span class="ql-formats">
                      <button class="ql-link"></button>
                      <button class="ql-image"></button>
        
                    </span>
                    <span class="ql-formats">
                      <button class="ql-clean"></button>
                    </span>                          
      
                </div><!-- end of toolbar div --> 
                <div id="quill">  
                </div>
                
        
        </div>
    
        <div class="modal_footer">
            <div class="modal_Btn_Container">
                
                <div class="btn_box">
                    <button type="button"   onclick="fn_close_noMore();" class="button">닫기</button>
                    <button type="button" onclick="fn_save();" class="button">저장</button>
                </div>
                
            </div>
            
        </div>
            
    </div><!-- end of modal div -->
    <script type="text/javascript">
    
    
    
    var fileNo; 
    var result = null;
        
    
    var quill;
    
    
    $("document").ready(function () {
        
        fn_loadNoticeBoardPopupContents();
        
        fn_init_TextInfo();
        
        fn_quill_init();
                    
        //fn_attachedFileRender();
        
        
        
    });
    
    
    

        function fn_quill_init(){
            
            quill = new Quill('#quill', {
                  modules:{
                      toolbar: '#toolbar'
                  },
                  theme: 'snow'  // or 'bubble'
                }); // end of quill defition
                
              //quill js content가 존재할 경우,
                if(FORM_SEARCH.rtnList[0].CONTENT != undefined)
                {
                    quill.setContents(JSON.parse(FORM_SEARCH.rtnList[0].CONTENT));
                        
                }
                //quill js content가 없을 경우,
                else
                {
                
                	quill.setContents([{ insert: '\n' }]);
                	
                }
                
                
                quill.enable(true);
                
                //$('#toolbar').hide();   
            
            
        }
    
    
        function fn_init_TextInfo(){
            
            $('#popupTitle').val(FORM_SEARCH.rtnList[0].NM_ID);
            $('#popupWriter').val(FORM_SEARCH.rtnList[0].URL);
            
        }
    
        
        
        function fn_loadNoticeBoardPopupContents(){
            
        	/*
            fileNo = "${param.FILE_NO}";
            if (gfn_isNull(fileNo)) {
                fileNo = "";
            }
            */
            
            FORM_SEARCH = {};
            
            FORM_SEARCH.CHART_ID = "${param.chartId}";
            
            
            //FORM_SEARCH.FILE_NO = fileNo
            FORM_SEARCH._mtd = "getList";
            FORM_SEARCH.tranData = [
               
        	   {outDs:"rtnList",_siq:"dashboard.chartInfo.dashboardChart"}
              
        	   ]
                //,{outDs:"fileList",_siq:"common.file"}
                
            
            var pMap = {
                    type: 'post', // POST 로 전송
                    async: false,
                    contentType: 'application/json',
                    data:JSON.stringify(FORM_SEARCH),
                    dataType: 'json',
                    url: "${ctx}/biz/obj.do",
                    
                    success:function(data) {
                        FORM_SEARCH.rtnList = data.rtnList;
                        
                        //FORM_SEARCH.fileList = data.fileList;
                        
                    },
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader("AJAX",true);
                        gfn_setAjaxCsrf(xhr);
                    }
                }
                $.ajax(pMap);
            
        }       
    
        
        function fn_save(){
        	   var userID = "${sessionScope.userInfo.userId}";
        	   FORM_SEARCH = {};
               
               FORM_SEARCH.CHART_ID = "${param.chartId}";
               FORM_SEARCH.USER_ID =userID;
               FORM_SEARCH.CONTENT  = JSON.stringify(quill.getContents());
               FORM_SEARCH.sqlId = "dashboard.chartInfo.content";
               //FORM_SEARCH.FILE_NO = fileNo
               //FORM_SEARCH._mtd = "getList";
               //FORM_SEARCH.tranData = [
               //  {outDs:"rtnList",_siq:"dashboard.chartInfo.content"}
               //,{outDs:"fileList",_siq:"common.file"}
               //    ];
               
               var pMap = {
                       type: 'post', // POST 로 전송
                       async: false,
                       contentType: 'application/json',
                       data:JSON.stringify(FORM_SEARCH),
                       dataType: 'json',
                       url: "${ctx}/common/CRUD.do",
                       
                       success:function(data) {
                           FORM_SEARCH.rtnList = data.rtnList;
                           window.close();
                           if (opener && opener.fn_popupCallback) {
                               opener.fn_popupCallback();
                           }
                           //FORM_SEARCH.fileList = data.fileList;
                           
                       },
                       beforeSend: function(xhr) {
                           xhr.setRequestHeader("AJAX",true);
                           gfn_setAjaxCsrf(xhr);
                       }
                   }
                   $.ajax(pMap);
        	
        }
        
        
        
        function fn_attachedFileRender(){
            
            
            if(FORM_SEARCH.fileList.length>0){
                
                
                $('#attachedFile').append('<ul id="attachedFileUl"></ul>');
                
                for(i=0;i<FORM_SEARCH.fileList.length;i++)
                {
                    $('#attachedFileUl').append('<li><a href="#" onclick="fn_file_download('+(i+1)+');" ><p>'+FORM_SEARCH.fileList[i].FILE_NM_ORG+'</p></a> </li>')
                    fn_formGen(i,FORM_SEARCH.fileList[i].FILE_NO,FORM_SEARCH.fileList[i].FILE_SEQ);
                }
                
                $('.modal_header').height($('#popupTitle').outerHeight(true)+$('.pupupInfo_etc').outerHeight(true)+$('#attachedFile').outerHeight(true));
            
                
                
            }
            else
            {
                $('#attachedFile').css('display','none');
            }
            
        }
        
        //파일다운로드 위한 form, hidden element 생성
        function fn_formGen(i,fileNo,fileSeq){
            
            
            var formId = "_fileDownFrm"+(i+1);
            
            var formHtml = '<form id="'+formId+'"></form>';
            $("body").append(formHtml);
            
            
            $("#"+formId).append('<input type="hidden" name="FILE_NO" value="'+fileNo+'" />');
        
            $("#"+formId).append('<input type="hidden" name="FILE_SEQ" value="'+fileSeq+'" />');
            
            $("#"+formId).attr("method","post");
            $("#"+formId).attr("action","${ctx}/file/download.do");
            
            
            
        }
        
        
        function fn_file_download(id){
            
            var formId = "_fileDownFrm"+id;
            
            $("#"+formId).submit();
            
        }
        
        
        //Cookie Setting
        function setCookie(cookie_name, value, days) {
          
            var exdate = new Date();
            exdate.setDate(exdate.getDate() + days);
            // 설정 일수만큼 현재시간에 만료값으로 지정
            var cookie_value = escape(value) + ((days == null) ? '' : ';path=/; expires=' + exdate.toUTCString());
            document.cookie = cookie_name + '=' + cookie_value;
         
        }
        
        function getCookie(key) {
            var result = null;
            var cookie = document.cookie.split(';');
            cookie.some(function (item) {
                // 공백을 제거
                item = item.replace(' ', '');
         
                var dic = item.split('=');
         
                if (key === dic[0]) {
                    result = dic[1];
                    
                    return true;    // break;
                }
            });
            return result;
        }
        
        
        
    //fn_close_noMore()
    
        function fn_close_noMore()
        {
        
            setCookie("${param.NOTICE_ID}","end",100);

            window.close();
        }
    
    

    
    
    
</script>
</body>
</html>