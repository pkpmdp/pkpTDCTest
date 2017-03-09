/** hide self left-sidebar module if it is not needed*/
function Kundelog_HideSidebarModule()  {
	var j$  = jQuery.noConflict();
	var customerId=Kundelog_GetObjectId();
	if (customerId==null){
	    var elem  = j$('#KundelogHomePageElement');
	     while (elem  && elem.length  > 0)  {
	        if (elem.hasClass('sidebarModule'))  {
	            elem.css('display', 'none');
	             break;
	        }
	        elem  = elem.parent();
	    }
	}
	else{
	  j$('#KundeLogFrameId').attr('src','/apex/CustomerLog?id='+customerId);
	}
}

/** get customer or case id from URL*/
function Kundelog_GetObjectId(){
  if (location.pathname != null && (location.pathname.indexOf('/001')==0 || location.pathname.indexOf('/003')==0 || location.pathname.indexOf('/500')==0)&& (location.pathname.length==16 || location.pathname.length==19)){
    return location.pathname.substring(1);
  }
  else if(location.pathname != null && location.pathname.indexOf('/a0F/e')==0){
		var startPattern='CF00N20000001Wv4U_lkid=';
		var endPattern='&';
		var startIndex = location.search.indexOf(startPattern)+startPattern.length;
		var endIndex = location.search.indexOf(endPattern,startIndex);
		if (endIndex==-1){
			endIndex = location.search.length;
		}
		var finding=location.search.substring(startIndex,endIndex);
		if (finding != null && (finding.length==15 || finding.length==18)){
			return finding;
		}
	}
  return null;
}


Kundelog_HideSidebarModule();
