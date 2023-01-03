var bYearFnc = function() {
	var date = new Date();
	date.setYear(date.getFullYear()-3);
	var sYear = date.getFullYear();
	var date2 = new Date();
	date2.setYear(date2.getFullYear()+3);
	var eYear = date2.getFullYear();
	var bYear = sYear+":"+eYear;
	return bYear;
}

var datepicker_resional_kr = { // Default regional settings
    closeText: '종료', // Display text for close link
    prevText: '이전', // Display text for previous month link
    nextText: '다음', // Display text for next month link
    currentText: '오늘', // Display text for current month link
    monthNames: ['1월','2월','3월','4월','5월','6월', '7월','8월','9월','10월','11월','12월'], // Names of months for drop-down and formatting
    monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'], // For formatting
    dayNames: ['일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일'], // For formatting
    dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'], // For formatting
    dayNamesMin: ['일','월','화','수','목','금','토'], // Column headings for days starting at Sunday
    weekHeader: '주', // Column header for week of the year
    dateFormat: 'yy-mm-dd', // See format options on parseDate
    firstDay: 0, // The first day of the week, Sun = 0, Mon = 1, ...
    isRTL: false, // True if right-to-left language, false if left-to-right
    showMonthAfterYear: false, // True if the year select precedes month, false for month then year
    showOtherMonths: true,
    showButtonPanel: true,
    changeMonth: true,
    changeYear: true,
    showWeek: true,
    yearRange: bYearFnc(),
    //yearRange: "2000:2050",
    //minDate: "-3y",
    //maxDate: "+1y",
    calculateWeek : function(date) {
    	var baseDt = new Date(date);
    	baseDt.setDate(baseDt.getDate() + 3);
    	var onejan = new Date(baseDt.getFullYear(),0,1);
    	var addDay = onejan.getDay() > 3 ? 0 : 1;
    	//return Math.ceil((((baseDt - onejan) / 86400000) + onejan.getDay()+addDay)/7);
    	return Math.round((((baseDt - onejan) / 86400000) + onejan.getDay()+addDay)/7);
    },
    yearSuffix: '' // Additional text to append to the year in the month headers
    /*
	selectOtherMonths: true,
	gotoCurrent: true,
	autoSize: true
	//showButtonPanel: true,
	*/
};

var monthpicker_resional_kr = { // Default regional settings
		dateFormat: 'yy-mm',
		yearSuffix: '',      // Additional text to append to the year in the month headers
		prevText: 'Prev',   // Display text for previous month link
		nextText: 'Next',   // Display text for next month link
		//changeYear :true,
		monthNames: ['1월','2월','3월','4월','5월','6월', '7월','8월','9월','10월','11월','12월'], // Names of months for drop-down and formatting
		monthNamesShort: ['1월','2월','3월','4월','5월','6월', '7월','8월','9월','10월','11월','12월'], // For formatting
		yearRange: bYearFnc(),
};

