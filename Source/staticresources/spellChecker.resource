// hide home component
spch_hideSidebarModule = function(objectToChange){
  var elem = document.getElementById('SpellCheckerHomePageElement'); 

  while(elem != null) {
    if(elem.className.indexOf('sidebarModule ') != -1) {
      elem.style.display="none";
      break;
    }
    elem = elem.parentNode;
  }

}

// dynamically load javascript
spch_loadScript = function(url, callback) {
  var script = document.createElement("script");
  script.type = "text/javascript";
  if (script.readyState) { //IE
    script.onreadystatechange = function() {
      if (script.readyState == "loaded" || script.readyState == "complete") {
        script.onreadystatechange = null;
        callback();
      }
    };
  } else { //Others
    script.onload = function () {
      callback();
    };
  }
  script.src = url;
  document.getElementsByTagName("head")[0].appendChild(script);
}

spch_initialize = function(url){

  spch_hideSidebarModule();

  if (window.location.pathname == "/_ui/core/email/author/EmailAuthor") {
    if (typeof jQuery == 'undefined'){
      spch_loadScript(url, function(){      
        spch_insertButtons();
      });
    } else {
      spch_insertButtons();
    }
  } 
}

// when spell checking is finished we need to update hidden c1r1_edit_value element
spch_handleSpellWindowFinish = function(mCtrl){
  if (mCtrl && mCtrl.contentWindow && typeof(mCtrl.contentWindow.setValue) == 'function' && typeof(mCtrl.contentWindow.getEditValueName) == 'function'){
    var elemc1r1 = mCtrl.contentDocument.getElementById("c1r1");
    if (elemc1r1){
      mCtrl.contentWindow.setValue(mCtrl.contentWindow.getEditValueName("c1r1"), elemc1r1.innerHTML);
    }
  }
}

// call external script (spch.js) to popup spell checker window
spch_doSpellCheck = function(id){
  var nObj = document.getElementById(id);
  if (nObj && typeof(handleSpellWindowOnLoad) == 'function'){
    handleSpellWindowOnLoad = function(objectToChange){};
    
    doSpell({
        ctrl:id,lang:'da_DK',title:'Check Spelling',intLang:'da_DK',onFinish:spch_handleSpellWindowFinish
      }
      , '/servlet/SProxyWrapper'
      , document.location.protocol + '//' + 'spell-chi.salesforce.com/spellcheck'
      , 'There is nothing to check'
      , 'We are sorry,our spellchecker currently does not support the browser you are using. Please upgrade your browser.'
    );
  }
}

// insert Spell Checking buttons into SF page
spch_insertButtons = function(){
  var j$ = jQuery.noConflict();  
  j$(document).ready(function(){
    var spchContentFrame = j$("#contentFrame");
    if (spchContentFrame.length > 0 && typeof(handleSpellWindowOnLoad) == 'function'){
      var spch;
      var spchButtonRow = j$("#topButtonRow");    
      if (spchButtonRow.length == 1){
        var spchInputs = j$("#topButtonRow input");
        if (spchInputs.length > 0){
          if (j$("input[name='spell']").length == 0){
            spch = j$('<input>').attr({ name : "spell", type : "button", title : "Check Spelling (New Window)", value : "Stavekontrol" }).addClass("btn");
            spch.click(function(){
              spch_doSpellCheck('contentFrame');
            });
            spchInputs.last().before(spch);
          }
        }
      }
      var spchButtonRowBottom = j$("#bottomButtonRow");
      if (spchButtonRowBottom.length == 1 && spch){
        var spchInputs = j$("#bottomButtonRow input");
        if (spchInputs.length > 0){
          if (j$("#bottomButtonRow input[name='spell']").length == 0){
            spch = spch.clone();
            spch.click(function(){
              spch_doSpellCheck('contentFrame');
            });
            spchInputs.last().before(spch);
          }
        }
      }
    }
  });
}
