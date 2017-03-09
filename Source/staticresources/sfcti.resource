//These are the Javascript functions that pertain to Salesforce.com's CTI integration.

//Note: this Javascript supports a maximum of 5 phone lines.

//The running counter that keeps browsers from trying to cache the dynamic HTML
var counter=0;
//Flag that indicates whether to use the sfdc log window to log problems
var debug=false;
//This is the flag indicating whether to continue awaiting events
var awaitEvents = false;
//This is the last response we received from the local server (so we don't update the UI in case we get the same response twice in a row)
var lastResponseText = '';
//This is the unique page ID of this page, used by the HTTP server to determine whether this page needs updating.
var pageId;
//This is the array of timer IDs
var timerIds = new Array(100);
//This is an array of the times in the timers
var timerCurrentSeconds = new Array(100);
//This is the count of timers
var timerCount = 0;
//The maximum number of supported lines
var maxLines = 5;
//An array of comments for each line
var comments = new Array(maxLines);
//An array of boolean flags indicating whether the comments field on each line is active
var commentsActive = new Array(maxLines);
//Flag that indicates whether to use HTTP in getting events.
//If this is set to FALSE, then it is assumed that a client app will be controlling the browser via COM.
var useHttp = false;
//This is the request that is used to await events.
var awaitRequestObject = null;
//This is the request that is used to send messages, like when a button is clicked.
var messageRequestObject = null;
//Flag that indicates whether we should do a screen pop when a call is received.
var allowScreenPop = false;
//The base URL of the client-side adapter -- we're not using it in this release
//var localHttp = 'http://localhost:7332';
var localHttp = '';
//Click to dial disabled array
var disabledDNs = new Array();
//Click to dial enabled array
var enabledDNs = new Array();
//Keeps track of whether click to dial has been enabled
var clickToDialEnabled = false;
//holds prev pop url
var prevPopUrl = '';
document._pageId = new Date().getTime();

if (document.addEventListener) {
    //ff
    document.addEventListener('focus', setFocused, false);
} else if (document.attachEvent) {
    //ie
    window.attachEvent('onfocus', setFocused);
}

function setFocused(e) {            
    setCookie('lastActivePage', document._pageId);
}

//Initializes the softphone
function initSoftphone(inputPageId) {
    if (inputPageId==null || inputPageId=="") {
        pageId = Math.random() * 10000000000000000;
    } else pageId = inputPageId;
    for (var i=0;i<maxLines;i++) {
        commentsActive[i]=false;
    }
    setInterval('updateTimers()',1000);
    var hiddenRefresh = document.getElementById('softphoneRefresh');
    if (hiddenRefresh!=null) {
        hiddenRefresh.src=UserContext.getUrl('/img/cti_refresh.gif');
    }
    if (awaitEvents) awaitEvent();
}

//Enables HTTP mode.
function enableHttp()
{
    useHttp = true;
    awaitRequestObject = getRequestObject();
    messageRequestObject = getRequestObject();
}

//Sends an update comments message for the given line
function updateComments(baseUrl, lineNumber, comments) {
    sendCTIMessage(baseUrl+'?LINE_NUMBER='+lineNumber+'&VALUE=' + escape(comments));
}

//Sends an update comments message for the given line (post-1.0RC2)
function updateCommentsByCallId(baseUrl, callObjectId, comments) {
    sendCTIMessage(baseUrl+'?CALL_OBJECT_ID='+escape(callObjectId)+'&VALUE=' + escape(comments));
}

//Sets comments for a line to active
function setCommentsActive(lineNumber,comments) {
    if (commentsActive[lineNumber]==true && comments[lineNumber]!=comments) {
        //If the line is active and the comments are different, then the user must have updated the comments
        sendCTIMessage(localHttp+'/UPDATE_COMMENTS?LINE_NUMBER='+lineNumber+'&VALUE=' + escape(comments[lineNumber]));
        return;
    }

    if (commentsActive[lineNumber]==false) {
        //If the line is not currently active, then it's a new call, and we should update the comments
        lineActive[lineNumber]=true;
        comments[lineNumber]=comments;
    }
}

function setCommentsInactive(lineNumber) {
    sendCTIMessage(localHttp+'/UPDATE_COMMENTS?LINE_NUMBER='+lineNumber+'&VALUE=' + escape(comments[lineNumber]));
}

function getRequestObject()
{
    var requestObject=null;
    // branch for native XMLHttpRequest object
    if(window.XMLHttpRequest) {
        try {
            requestObject = new XMLHttpRequest();
        } catch(e) {
            requestObject = null;
        }
    // branch for IE/Windows ActiveX version
    } else if(window.ActiveXObject) {
        try {
            requestObject = new ActiveXObject("Msxml2.XMLHTTP");
        } catch(e) {
            try {
                requestObject = new ActiveXObject("Microsoft.XMLHTTP");
            } catch(e) {
                requestObject = null;
            }
        }
    }
    return requestObject;
}

//Loads an XML document asynchronously using the given URL and handler function, and optionally the input request object
//(the request object parameter fosters reuse of requests, which works around an IE memory leak when creating new requests)
function loadXMLDoc(url,handler,requestObject,onerrorhandler) {
    if (useHttp) {
        var xmlhttp = null;

        if (requestObject!=null) {
            xmlhttp=requestObject;
        } else {
            xmlhttp=getRequestObject();
        }

        if(xmlhttp!=null) {
            xmlhttp.abort();
            if (handler!=null) xmlhttp.onreadystatechange = function() { handler(xmlhttp); };
            xmlhttp.open("GET", url, true);
            xmlhttp.send("");
        } else {
            log("xmlhttp is null.");
        }
    }
}

//Makes an MM:SS time string
function makeTimeString(minutes, seconds)
{
    var strMinutes = new String(minutes);
    var strSeconds = new String(seconds);
    if (strMinutes.length==1) strMinutes = '0'+strMinutes;
    if (strSeconds.length==1) strSeconds = '0'+strSeconds;
    return strMinutes + ':' + strSeconds;
}

//Register a timer for updating
function registerTimer(timerId,timerMinutes,timerSeconds) {
    var timerPosition = -1;
    for (i=0;i<timerCount;i++) {
        var tempTimerId = timerIds[i];
        if (timerId==tempTimerId) {
            //The timer's already in the array
            timerPosition = i;
            break;
        }
    }

    if (timerPosition==-1) {
        //We didn't find the timer.  Add it now.
        if (timerCount<100) {
            //Limit of 100 timers (there really will never be more than 3 or 4 on a page anyway).
            timerIds[timerCount] = timerId;
            timerPosition = timerCount;
            timerCount++;
        }
    }

    timerCurrentSeconds[timerPosition]= timerMinutes*60 + timerSeconds;

    var timerSpan = document.getElementById(timerId);
    if (timerSpan!=null) {
        timerSpan.innerHTML=makeTimeString(timerMinutes,timerSeconds);
    }
}

//Add a second to all the timers on the page
function updateTimers() {
    for (i=0;i<timerCount;i++) {
        var timerId = timerIds[i];
        var timerSpan = document.getElementById(timerId);
        if (timerSpan!=null) {
            timerCurrentSeconds[i]+=1;
            var timerMinutes = Math.floor(timerCurrentSeconds[i] / 60);
            var timerSeconds = timerCurrentSeconds[i] % 60;
            timerSpan.innerHTML=makeTimeString(timerMinutes,timerSeconds);
        }
    }
}

function attachObjectToCall(baseUrl, lineNumber) {
    if (currentEntityId!=null && currentEntityDevName!=null) {
        var url = baseUrl + '/ATTACH_OBJECT?LINE_NUMBER=' + lineNumber + '&OBJECT=' + currentEntityDevName + '&ID=' + currentEntityId + '&NAME=' + escape(currentEntityName) + '&LABEL=' + currentEntityLabel + '&PLURAL_LABEL=' + currentEntityPluralLabel;
        sendCTIMessage(url);
    }
}

//Disposes of any open CTI requests
function disposeRequests() {
    if (awaitRequestObject!=null) {
        awaitRequestObject.abort();
        awaitEvents = false;
    }
    if (messageRequestObject!=null) messageRequestObject.abort();
}

//Awaits an event from a local CTI adapter
function awaitEvent() {
    counter++;
    loadXMLDoc(localHttp+'/AWAIT_EVENT?PAGEID='+pageId+'&COUNTER='+counter+'&INSTANCE='+window.location.host+'&SID='+getCookie('sid'),handleAwaitEvent,awaitRequestObject);
}

//Handles the event when one arrives from the local CTI adapter
function handleAwaitEvent(request) {
    if (request.readyState == 4) {
        try {
            if (request.status==200) {
                document.getElementById('softphone').innerHTML = request.responseText;
            }
            if (request.status!=204) {
                //If the status is 204, then a button issued this thread -- don't spawn a new await event.
                awaitEvent(pageId);
            }
        } catch(e) {
            //We errored out.  The client app may not be up.
            //Give it a second, then try again
            setTimeout('awaitEvent(pageId)',1000);
        }
    }
}
var prevCTIHiddenValue = '';


function makeRequest(url, parameters) {
      http_request = false;
      if (window.XMLHttpRequest) { // Mozilla, Safari,...
         http_request = new XMLHttpRequest();
         if (http_request.overrideMimeType) {
         	// set type accordingly to anticipated content type
            //http_request.overrideMimeType('text/xml');
            http_request.overrideMimeType('text/html');
         }
      } else if (window.ActiveXObject) { // IE
         try {
            http_request = new ActiveXObject("Msxml2.XMLHTTP");
         } catch (e) {
            try {
               http_request = new ActiveXObject("Microsoft.XMLHTTP");
            } catch (e) {}
         }
      }
      if (!http_request) {
         alert('Cannot create XMLHTTP instance');
         return false;
      }
      http_request.onreadystatechange = alertContents;
      http_request.open('GET', url + parameters, true);
      http_request.send(null);
   }
   
   
   function alertContents() {
      if (http_request.readyState == 4) {
         if (http_request.status == 200) {
            //alert(http_request.responseText);
            result = http_request.responseText;
            document.getElementById('myspan').innerHTML = result;            
         } else {
            alert('There was a problem with the request.' +http_request.status);
         }
      }
   }
   


//This function creates an XMLHTTPRequest to send the message to the server and ignores the response.
//It is intended for CTI commands.
function sendCTIMessage(url) {
    var commandHidden = document.getElementById('softphoneCommand');
alert('this is the softphoneCommand1: ' + commandHidden);
alert('this is the softphoneCommand2: ' + parent.getElementById('softphoneCommand'));
    url = url ? UserContext.getUrl(url) : url;
    try {
        if (commandHidden!=null) {
            if (prevCTIHiddenValue == url) {
                // firefox event doesn't get triggered, we need to force a flush
                flush = true;
            }
            
            prevCTIHiddenValue = commandHidden.value;
            commandHidden.value = url;            
   
            // flush the value for ff
            if (isFirefox && flush) {
                commandHidden.value = '';
            }
        } else if (this.window!=window.parent && window.parent.sendCTIMessage) {
            //We may be in a frame or popup -- iterate up through the stack of parents until we find the hidden input
            alert('sending from the parent');
            window.parent.sendCTIMessage(url);
        }
    } catch (exceptionObj) {
      alert('no access'+exceptionObj);
        //Well, an exception occurred.  We may have tried to hit a page where there is no access.
      }
    //This call will do nothing unless we're in HTTP mode
    loadXMLDoc(url,function(request) { },messageRequestObject);
}

var isDialing=false; // we togggle this variable in the onmouseover and onmouseout events of the dialpad buttons
var focusedDnElement=null; // we set this when a dialpad number field gets/loses focus

// This function is for use with the CTI Dialpad.  It takes the number button that was clicked
// and adds its digit to the edit box.
function addDialpadNumber(number, dialpadEditId) {
    var placeholderStr = "#number#";
    var dialpadEdit = document.getElementById(dialpadEditId);
    var dnFieldFocused = focusedDnElement==dialpadEdit;
    dialpadEdit.focus();

    if (document.selection) {
        // If the dialpad field was in focus prior to this event, then we'll insert at the cursor position
        // otherwise, just insert at the end.
        if (dnFieldFocused) {
            var r = document.selection.createRange();
            var txtRange = dialpadEdit.createTextRange();

            // fill with placeholder so we can detect the position of the selected text
            r.text = placeholderStr;
            var pos = dialpadEdit.value.indexOf(placeholderStr) + 1;

            dialpadEdit.value = dialpadEdit.value.replace(placeholderStr, number);

            // explicitly set the cursor position because sometimes it gets lost by the browser
            txtRange.moveStart("character", pos);
            txtRange.collapse();
            txtRange.select();
        } else {
            dialpadEdit.value = dialpadEdit.value + number;
        }
    } else if (dialpadEdit.selectionStart || dialpadEdit.selectionStart == 0) {
        var startPos = dialpadEdit.selectionStart;
        var endPos = dialpadEdit.selectionEnd;
        dialpadEdit.value = dialpadEdit.value.substring(0, startPos) + number + dialpadEdit.value.substring(endPos, dialpadEdit.value.length);
        
        // explicitly set the cursor position because the browser ate it
        dialpadEdit.setSelectionRange(startPos+1, startPos+1);   
    } else {
        dialpadEdit.value = dialpadEdit.value + number;
    }
}

//This function handles a button that is attached to a form.
//It translates the URL to the form http://host/BUTTONID?FORM1ID=VALUE1&FORM2ID=VALUE2
//Finally, it submits that URL to sendCTIMessage().
//The buttonUrl should be a single string pointing to the base URL of the button with no query string.
//The formItems parameter should be a comma-separated list of IDs of editboxes, checkboxes, and listboxes that exist on the page.
//So formItems should be of the form 'list1,checkbox1,editbox1'
function formButtonClick(buttonUrl, formItems) {
    if (formItems!=null && formItems.length>0) {
        buttonUrl = buttonUrl+'?';
        var formItemArray = formItems.split(',');
        for (i=0;i<formItemArray.length;i++) {
            var itemId = formItemArray[i];
            var item = document.getElementById(itemId);
            if (item!=null) {
                //We put the name here instead of the id because the ids are unique per line number, but the names aren't
                //(and we want the more generic name in this case)
                buttonUrl+=item.name+'=';
                var type = item.type;
                if (type=="radio" || type=="checkbox") {
                    buttonUrl += item.checked?'true':'false';
                } else {
                    buttonUrl += escape(item.value);
                }
                if (i!=formItemArray.length-1) {
                    //More params on the way...
                    buttonUrl += '&';
                }
            }
        }
    }
    sendCTIMessage(buttonUrl);
}

function setAllowScreenPop(allow)
{
    allowScreenPop = allow;
}

// Function to pop screen to object when search returns only 1 result for incoming call
// Don't pop if we are currently editing some object.
function screenPop(id, callObjectId) {
    var isSomeEditMode = false;
    // For regular detail pages. editPage handles regular edit pages.
    if (typeof getMainFrame == "undefined") {//This is a regular detail page        
        if (window.sfdcPage != null){
            // If we are inline editing, don't pop
            isSomeEditMode = window.sfdcPage.editMode;
        }
    } else { // we are in agent console
        // lets make sure
        if (typeof(srcMain)!='undefined') {
            var mainFrame = getMainFrame();
            if (mainFrame!=null) {
                // There are 2 scenarios here
                if (mainFrame.contentWindow.sfdcPage != null){
                    // First - If we are inline editing and this is a detail page
                    // sfdcPage is of DetailPage type and editMode is defined.
                    if (typeof(mainFrame.contentWindow.sfdcPage.editMode)!='undefined') {
                        isSomeEditMode = mainFrame.contentWindow.sfdcPage.editMode;
                    } else { isSomeEditMode = true; } // Second - This an edit page in the main window of the agent console. 
                    // We can't check editPage in functions.js because its not set in the agent console.
                }	                
            }
        }
    }
    if (id != null && allowScreenPop && !editPage && !isSomeEditMode && id.indexOf('005') != 0 && getCookie('lastActivePage') == document._pageId) {
        goToObject(id);
    }
}
 
//On a regular page, navs the page to the url.  In Agent Console, navs the main frame to the url.
function goToUrl(targetUrl) {
    if (typeof(srcMain)!='undefined')
    {
        var mainFrame = getMainFrame();

        // note (BJY): user contentWindow.location.href, don't use src
        if (mainFrame!=null && mainFrame.contentWindow.location.href.indexOf(targetUrl)==-1) {
            srcMain(setParam(targetUrl,Desktop.IS_DESKTOP,'mn'));
        }
    } else {
        var url = window.location.href;
        if (url.indexOf(targetUrl)==-1) {
            window.location = UserContext.getUrl(targetUrl);
        }
    }
}

//On a regular page, navs the page to the ID.  In Agent Console, navs the main frame to the ID.
// Now that we have visualforce pages, this id can also be a visualforce page of an undefined length 
function goToObject(id) {
    if (prevPopUrl.indexOf(id) == -1) {
        prevPopUrl = id;
        goToUrl('/'+id);
    }
}

//This function is a workaround for the fact that SilkTest doesn't seem to like
//this javascript running in-place in the OnChange event of the dropdown
function getSelectedAgentStatus()
{
    var agentStatus = document.getElementById('agentStatus');
    if (agentStatus!=null) {
        return agentStatus.options[agentStatus.selectedIndex].value;
    }
    return '';
}

//Automatically clicks the button with the specified ID
function clickButton(buttonId)
{
    var button = document.getElementById(buttonId);
    if (button!=null) {
        button.click();
    }
}

//Toggles a call log twisty and sends a message to the CTI adapter noting the new status
function toggleTwisty(divId,imageId,upImageUrl,downImageUrl,command)
{
    var divElement = document.getElementById(divId);
    var imageElement = document.getElementById(imageId);
    if (divElement!=null && imageElement!=null)
    {
        if (divElement.style.display=="block") {
            divElement.style.display="none";
            imageElement.src = upImageUrl;
        } else {
            divElement.style.display="block";
            imageElement.src = downImageUrl;
        }
    }
    sendCTIMessage(command);
}

// register click to dial number spans
function registerClickToDialEnabled(span) {
    enabledDNs.push(span);
    span.style.display = clickToDialEnabled ? "block" : "none";
}

function registerClickToDialDisabled(span) {
    disabledDNs.push(span);
    span.style.display = clickToDialEnabled ? "none" : "block";
}

function toggleClickToDial(show) {
    cleanupClickToDial()
    // only change links on the first time toggle is called
    if (clickToDialEnabled != show) {
        clickToDialEnabled = show;
        for (var i=0;i<enabledDNs.length;i++) {
                enabledDNs[i].style.display = show ? "block" : "none";
                disabledDNs[i].style.display = show ? "none" : "block";
        }
    }
}

// In agent console, some click to dials leave scope as an agent navigates between pages.
// This function to cleans up out-of-scope click to dials
function cleanupClickToDial() {
    var activeEnabledDNs = new Array();
    var activeDisabledDNs = new Array();

    for (var i=0;i<enabledDNs.length;i++) {
        try {
            // test whether this DN is in scope
            enabledDNs[i].style;
            activeEnabledDNs.push(enabledDNs[i]);
            activeDisabledDNs.push(disabledDNs[i]);
        } catch(e) {
        }
    }
    enabledDNs = activeEnabledDNs;
    disabledDNs = activeDisabledDNs;
}


// This is called from the onclick event on a click-to-dial link
// in order to disable the link temporarily (5 seconds)
function disableClicked(clickToDialLink, title) {
    origOnClickFunc = clickToDialLink.onclick;
    clickToDialLink.onclick = function(){ return false; };
    origColor = clickToDialLink.style.color;
    clickToDialLink.style.color = "gray";
    clickToDialLink.title = title;
    // switch the visible click to dial icons
    for (i=0; i<clickToDialLink.childNodes.length; i++) {
        if (clickToDialLink.childNodes[i].src) {
            clickToDialLink.childNodes[i].style.display = (clickToDialLink.childNodes[i].style.display=="none") ? "inline" : "none";
        }
    }
    // re-enable the link after some timeout
    window.setTimeout(function() {enableClicked(clickToDialLink, origOnClickFunc, origColor);}, 5000);
}

// This is called to re-enable a temporarily-disabled click-to-dial link
function enableClicked(clickToDialLink, origOnClickFunc, origColor) {
    clickToDialLink.onclick = origOnClickFunc;
    clickToDialLink.style.color = origColor;
    clickToDialLink.title = "";
    // switch the visible click to dial icons
    for (i=0; i<clickToDialLink.childNodes.length; i++) {
        if (clickToDialLink.childNodes[i].src) {
            clickToDialLink.childNodes[i].style.display = (clickToDialLink.childNodes[i].style.display=="none") ? "inline" : "none";
        }
    }
}

// This is called when a dialpad is shown to determine whether its edit box should get the focus
function checkDialpadFocus(dialpadId) {
    //This cookie gets set to false by the XSLT if no dialpad is present in it
    var dialpadShown = getCookie("dialpadShown");
    if (dialpadShown!="true") {
        var dialpadEdit = document.getElementById(dialpadId);
        if (dialpadEdit!=null) {
            //The select shouldn't be necessary, but it seems to be the only way we can actually give the edit box focus
            dialpadEdit.focus();
            dialpadEdit.select();
            setCookie("dialpadShown","true");
        }
    }
}

// This is called when there exists an unsaved previous call log
function registerUnsavedCallLog(callObjectId,entityIds)
{
    setCookie(callObjectId,entityIds);
}

// This is called on every CTI UI refresh to determine if we need to update the activity history
function updateCallLogInHistory(callObjectId)
{
    var entityId = null;
    var pageObject = null;

    var entityIds = getCookie(callObjectId);
    if (entityIds!="" && entityIds!=null) {
        deleteCookie(callObjectId);

        //First see if we're in agent console
        if (typeof getMainFrame!="undefined") {
            //We're in agent console -- use the main frame
            var mainFrame = getMainFrame();
            if (mainFrame!=null) {
                pageObject = mainFrame.contentWindow.sfdcPage;
                entityId = mainFrame.contentWindow.currentEntityId;
            }
        } else {
            //This is a regular detail page
            pageObject = window.sfdcPage;
            entityId = currentEntityId;
        }

        if (pageObject!=null && entityIds.indexOf(entityId)>-1) {
            var rl = pageObject.getRelatedListById(entityId+"_RelatedHistoryList");

            if (rl!=null) {
                pageObject.makeRLAjaxRequest(null, rl.listId);
            }
        }
    }
}

/**
 * This is called by s.gif onload hook in CTI*.xslt
 * Insert any actions that should be made on EVERY softphone UI refresh here.
 **/
function softphoneRefreshHook(attrib_loggedIn) {
    toggleClickToDial(attrib_loggedIn);

    // Whenever the softphone is repainted, let the console resize itself
    if (typeof(resizeFramesToFit)!='undefined') {
        resizeFramesToFit()
    }
}
