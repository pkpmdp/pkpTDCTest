var j$ = jQuery.noConflict();

var elem = j$('#MovePermHomePageElement');
if (elem != null && elem.parent().parent().hasClass('sidebarModule')) {
    elem.parent().parent().hide();
}

function myDocReady() {
    if (j$('#00N20000001WyWe_ilecell') != null && j$('#00N20000001XAKi_ilecell') != null && j$('#00N20000001WyWk_ilecell') != null && j$('#00N20000001XAKn_ilecell') != null) {

        var hasFieldsInOrder = j$('#00N20000001WyWe_ilecell').next().next().attr('id') == '00N20000001WyWk_ilecell' && j$('#00N20000001XAKi_ilecell').next().next().attr('id') == '00N20000001XAKn_ilecell';

        if (hasFieldsInOrder) {
            //START - Join and move Permission and NoThankyou fields            	
            var rowPerm = j$('#00N20000001WyWe_ilecell').parents("tr:first");
            var rowPermUpdated = j$('#00N20000001XAKi_ilecell').parents("tr:first");

            rowPermUpdated.after('<tr id="newRowPerm"></tr>');
            var newRowPerm = j$('#newRowPerm');

            newRowPerm.after('<tr id="newRowNoThankyou"></tr>');
            var newRowNoThankyou = j$('#newRowNoThankyou');

            var thanksLabelTD = j$('#00N20000001WyWk_ilecell').prev().detach();
            var thanksDataTD = j$('#00N20000001WyWk_ilecell').detach();
            var permLabelTD = j$('#00N20000001WyWe_ilecell').prev().detach();
            var permDataTD = j$('#00N20000001WyWe_ilecell').detach();
            var thanksUpdatedTD = j$('#00N20000001XAKn_ilecell').detach();
            var permUpdatedTD = j$('#00N20000001XAKi_ilecell').detach();

            newRowPerm.append('<td id="ph1ID">&nbsp;</td>');
            newRowPerm.append('<td id="ph2ID">&nbsp;</td>');
            newRowPerm.append(permLabelTD);

            newRowPerm.append('<td><table cellpadding="0px" cellspacing="0px" width="100%"><tr id="myTr"></tr></table></td>');
            var myTr = j$('#myTr');
            myTr.append(permDataTD);
            myTr.append(permUpdatedTD);

            newRowNoThankyou.append('<td>&nbsp;</td>');
            newRowNoThankyou.append('<td>&nbsp;</td>');

            newRowNoThankyou.append(thanksLabelTD);

            newRowNoThankyou.append('<td><table cellpadding="0px" cellspacing="0px" width="100%"><tr id="myTr1"></tr></table></td>');
            var myTr1 = j$('#myTr1');
            myTr1.append(thanksDataTD);
            myTr1.append(thanksUpdatedTD);

            rowPerm.unbind();
            rowPermUpdated.unbind();
            rowPerm.remove();
            rowPermUpdated.remove();
            //END - Join and move Permission and NoThankyou fields

            //START - Shift left column fields two rows above
            var myTable = j$('#newRowPerm').parents("table:first");
            myTable.attr("id", "myTable");

            var myTbody = j$('#newRowPerm').parents("tbody:first");
            myTbody.attr("id", "myTbody");
            var rowCount = myTbody.children().length;

            var isFlag = false; //flag for working area
            var lastRow = j$('#myTable tr:last');
            var lastRowIndex = lastRow.index();

            var indexOfPermissionField = newRowPerm.index();

            var addedRowsCount = lastRowIndex - indexOfPermissionField + 1;
            //remove bottom line in last row
            if (addedRowsCount > 0) {
                var lastRowTd1 = j$('#myTable tr:last td:eq(0)');
                var lastRowTd2 = j$('#myTable tr:last td:eq(1)');
                var lastRowTd3 = j$('#myTable tr:last td:eq(2)');
                var lastRowTd4 = j$('#myTable tr:last td:eq(3)');

                lastRowTd1.removeClass('last');
                lastRowTd2.removeClass('last');
                lastRowTd3.removeClass('last');
                lastRowTd4.removeClass('last');
            }

            // add template rows
            for (i = 0; i < addedRowsCount; i++) {
                lastRow.after('<tr id="templateRow' + i + '"></tr>');
                lastRow = j$('#templateRow' + i);
            }
            var handledRowIndex = 0;
            var actualRow = null;

            var col1Array = new Array(2 * addedRowsCount);
            var col2Array = new Array(2 * addedRowsCount);

            var col1Index = 0;
            var col2Index = 0;

            var x = new Array(addedRowsCount);

            for (var i = 0; i < addedRowsCount; i++) {
                x[i] = new Array(4);
            }

            myTbody.children().each(function (currentRowIndex, currentRowElement) {

                //process rows below Permission field
                if (currentRowIndex >= indexOfPermissionField && handledRowIndex < addedRowsCount) {
                    //loop through TDs
                    var shift = 0;
                    j$(currentRowElement).children().each(function (columnIndex) {

                        var currentTD = j$(this);
                        if (currentTD.attr("colspan") != undefined) {
                            shift++;
                            x[handledRowIndex][columnIndex] = currentTD;
                        } else {
                            x[handledRowIndex][columnIndex + shift] = currentTD;
                        }



                    });
                    handledRowIndex++;
                }
            });
            //left column except first two rows
            for (var row = 0; row < addedRowsCount; row++) {
                for (var col = 0; col < 4; col++) {
                    if (row > 1 && col < 2) {
                        j$('#templateRow' + (row - 2)).append(x[row][col]);
                    }
                }
            }
            //left column first two rows
            for (var row = 0; row < addedRowsCount; row++) {
                for (var col = 0; col < 4; col++) {
                    if ((col == 0 && row == 0) || (col == 0 && row == 1) || (col == 1 && row == 0) || (col == 1 && row == 1)) {
                        j$('#templateRow' + (addedRowsCount - (row + 1))).append(x[row][col]);
                    }
                }
            }
            //right column
            for (var row = 0; row < addedRowsCount; row++) {
                for (var col = 0; col < 4; col++) {
                    if ((col == 2 || col == 3)) {
                        if (x[row][col] == undefined) {} else {
                            j$('#templateRow' + row).append(x[row][col]);
                        }
                    }
                }
            }
            //remove original rows
            var decrement = addedRowsCount - 1;
            for (var i = 0; i < addedRowsCount; i++) {
            	var n = indexOfPermissionField + decrement--;
            	j$('#myTable > tbody > tr:eq('+n+')').remove();
            }
            
            //remove empty rows if exist
            lastRow = j$('#myTable tr:last');
              lastRowIndex = lastRow.index();
            
            var secondOfLastIndex = lastRowIndex - indexOfPermissionField - 1;
            var secondOfLastRow = j$('#templateRow'+ secondOfLastIndex);
				
				    if(lastRow.find("td").eq(3).hasClass('empty')){
					    lastRow.remove();
				    } 				
				
    				if( secondOfLastRow.find("td").eq(3).hasClass('empty')){
    					secondOfLastRow.remove();
    				} 				
	            
          	//add style class last
            j$('#myTable tr:last td:eq(0)').addClass('last');
            j$('#myTable tr:last td:eq(1)').addClass('last');
            j$('#myTable tr:last td:eq(2)').addClass('last');
            j$('#myTable tr:last td:eq(3)').addClass('last');
            
            //END - Shift left column fields two rows above
        }
    }
}

function addLoadEvent(func) {
    var oldonload = window.onload;
    if (typeof
    window.onload != 'function') {
        window.onload = func;
    } else {
        window.onload = function () {
            if (oldonload) {
                oldonload();
            }
            func();
        }
    }
}

addLoadEvent(myDocReady);