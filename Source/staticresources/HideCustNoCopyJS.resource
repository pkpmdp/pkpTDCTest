var j$ = jQuery.noConflict();

var elem = j$('#HideCustNoCopyHomePageElement');
if (elem != null && elem.parent().parent().hasClass('sidebarModule')) {
    elem.parent().parent().hide();
}

function myDocReady() {
    // Hide Account.Customer_No_Copy__c field on any standard page layout
    var row = j$('#00ND00000052l7t_ileinner').parents("tr:first");
    if (row != null) {
        row.hide();
    }
}

j$(document).ready(function () {
    if (window.addEventListener) {
        window.addEventListener('load', myDocReady, false);
    } else if (window.attachEvent) {
        window.attachEvent('onload', myDocReady);
    }
});
