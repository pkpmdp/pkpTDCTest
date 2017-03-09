var oldHiOff = window.hiOff;
window.hiOff = function(elem){
    if(typeof event == "undefined"){
        oldHiOff(elem);
        return ;
    }
    if(!elem){
        return ;
    }
    
    var toElementCurrent = event.toElement;
    if(!toElementCurrent){
        setTimeout(function(){oldHiOff(elem)}, 1);
        return ;
    }

    while(toElementCurrent.tagName != 'TR'){
        toElementCurrent = toElementCurrent.parentElement;
        if(!toElementCurrent){
            setTimeout(function(){oldHiOff(elem)}, 1);
            return ;
        }
    }
    
    if(elem != toElementCurrent){
        setTimeout(function(){oldHiOff(elem)}, 1);
    }
}