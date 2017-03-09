var j$ = jQuery.noConflict();
var valAgentStatus = '';
var valAgentContextId = '';
var hrefButtonCTI = '/apex/CTICallRegistration';
var hrefContextIdArg = '?ContextId=';
var popupCallReg = null;
var popupCookie = 'CTI_CallReg';

function CTI_setCookie(name, value, days) {
	var expires = "";
	if (days) {
		var date = new Date();
		date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
		expires = "; expires=" + date.toGMTString();
	}
	document.cookie = name + "=" + value + expires + "; path=/";
	CTI_Log('CTI_setCookie' + ' : ' + name + ' : ' + value + ' : ' + days);
}
function CTI_getCookie(name) {
	var ret = null;
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for (var i = 0; i < ca.length; i++) {
		var c = ca[i];
		while (c.charAt(0) == ' ') {
			c = c.substring(1, c.length);
		}
		if (c.indexOf(nameEQ) == 0) {
			ret = c.substring(nameEQ.length, c.length);
		}
	}
	CTI_Log('CTI_getCookie' + ' : ' + name + ' : ' + ret);
	return ret;
}
function CTI_deleteCookie(name) {
	CTI_Log('CTI_deleteCookie' + ' : ' + name);
	CTI_setCookie(name, "", - 1);
} 

/**        hide self left-sidebar module      */
function CTI_HideSidebarModule() {
	var elem = j$('#CTICallRegistrationHomePageElement');
	while (elem && elem.length > 0) {
		if (elem.hasClass('sidebarModule')) {
			elem.css('display', 'none');
			break;
		}
		elem = elem.parent();
	}
}

/**        add to onload event queue      */
function CTI_AddOnload(myfunc) {
	if (window.addEventListener) {
		window.addEventListener('load', myfunc, false);
	} else if (window.attachEvent) {
		window.attachEvent('onload', myfunc);
	}
} 

/**        focus poped-up window      */
function CTI_Focus() {
	CTI_Log('CTI_Focus ' + ' : ' + (popupCallReg == null ? 'null' : popupCallReg.closed));
	if (popupCallReg != null && !popupCallReg.closed) {
		popupCallReg.focus();
	}
} 

/** start timer loop      - check for CTI button href changes      - check for agent state in dropdown list -> if 'Call Registration' show popup (end of call)      */
function CTI_Timer() { 
	/** check drop-down if there is Call Registration string, if so popup window with BEGIN_CTI href         */
	var valAgentStatusNew = j$('#agentStatus').val(); /*console.log("agentStatus: %s", valAgentStatusNew);  */
	if (valAgentStatusNew != valAgentStatus) {
		valAgentStatus = valAgentStatusNew;
		if (valAgentStatusNew != null) {
			if (valAgentStatusNew.indexOf('CALL_REG') == 0) {
				valAgentContextId = j$('#agentStatus').text();
				CTI_Popup(hrefButtonCTI + hrefContextIdArg + valAgentContextId, valAgentContextId);
			}
		}
	} 
	
	/** if popup was closed, sent notification back to CTI        */
	if (popupCallReg != null) {
		try {
			if (popupCallReg.closed) {
				popupCallReg = null;
			}
		} catch (e) {
			CTI_Log('popupCallReg.closed exception' + ' : ' + e);
		}
		if (popupCallReg == null) {
			sendCTIMessage('/UNLOCK' + hrefContextIdArg + CTI_getCookie(popupCookie + valAgentContextId));
			CTI_Log('sendCTIMessage : ' + '/UNLOCK' + hrefContextIdArg + CTI_getCookie(popupCookie + valAgentContextId));
			CTI_deleteCookie(popupCookie + valAgentContextId);
		}
	}
	setTimeout(CTI_Timer, 100);
} 

/**        log into JavaScript console      */
function CTI_Log(str) { /*window.console && console.log(str);*/
}

/**        show CTI Call Registration popup      */
function CTI_Popup(elem_href, contextId) { /*console.log("CTI_Popup: %s : %d : %x", elem_href, scti, popupCallReg);*/
	CTI_Log('CTI_Popup' + ' : ' + elem_href + ' : ' + contextId);
	if (elem_href != null && elem_href.length) {
		if (CTI_getCookie(popupCookie + contextId) != contextId) {
			CTI_setCookie(popupCookie + contextId, contextId, 1);
			sendCTIMessage('/CALL_REG_POPUP' + hrefContextIdArg + contextId);
			CTI_Log('sendCTIMessage : ' + '/CALL_REG_POPUP' + hrefContextIdArg + contextId);
		}
		
		var width = Math.round(j$(window).width() * 0.9);
		if (width > 1024) {
			width = 1024;
		}
		var height = Math.round(j$(window).height() * 1);
		if (height > 900) {
			height = 900;
		}
		var left = (screen.width / 2) - (width / 2);
		var top = (screen.height / 2) - (height / 2) - 30;
		if (top < 0) {
			top = 0;
		}
		try {
			popupCallReg = window.open('', CTI_ContextIdToWindowName(contextId), 'menubar=0,resizable=1,scrollbars=1,width=' + width + ',height=' + height + ',top=' + top + ',left=' + left);
			if (popupCallReg != null && popupCallReg.location == 'about:blank') {
				popupCallReg.location = elem_href;
			}
		} catch (e) {
			CTI_Log('CTI_Popup Exception' + ' : ' + e);
		}
	
		CTI_Focus();
	}
} 

/**        remove white space characters      */
function CTI_ContextIdToWindowName(valAgentContextId) {
	return valAgentContextId.replace(/[^a-zA-Z0-9]/gi, '');
}

/**        onload event handler      */
function CTI_OnLoad() { /**          listen for CTI button click, instead of default behavior, open popup        */
	j$('a[id*="BEGIN_CTI"]').live('click', function () {
		var href = j$(this).attr('href');
		valAgentContextId = '';
		var index = href.indexOf(hrefContextIdArg);
		if (index >= 0) {
			var indexEnd = href.indexOf('&', index);
			valAgentContextId = indexEnd > index ? href.substring(index + hrefContextIdArg.length, indexEnd) : href.substring(index + hrefContextIdArg.length);
		}
		CTI_Popup(href, valAgentContextId);
		return false;
	});
	CTI_Timer();
}

function onAfterSendCTIMessage(url) { /*alert(url);*/
}

var oldSendCTIMessage = sendCTIMessage;
sendCTIMessage = function () {
	if (typeof onBeforeSendCTIMessage === 'function') onBeforeSendCTIMessage.apply(this, arguments);
	var sendCTIMessageResult = oldSendCTIMessage.apply(this, arguments);
	if (typeof onAfterSendCTIMessage === 'function') onAfterSendCTIMessage.apply(this, arguments);
	return sendCTIMessageResult;
};
CTI_HideSidebarModule();
CTI_AddOnload(CTI_OnLoad);