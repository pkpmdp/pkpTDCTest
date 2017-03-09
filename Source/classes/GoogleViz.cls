/*
    Copyright (c) 2008 salesforce.com, inc.
    All rights reserved.
    
    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions
    are met:
    
    1. Redistributions of source code must retain the above copyright
       notice, this list of conditions and the following disclaimer.
    2. Redistributions in binary form must reproduce the above copyright
       notice, this list of conditions and the following disclaimer in the
       documentation and/or other materials provided with the distribution.
    3. The name of the author may not be used to endorse or promote products
       derived from this software without specific prior written permission.
    
    THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR
    IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
    OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
    IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, 
    INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
    NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
    DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
    THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
    THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
    
    Utility class for collecting a google auth sub session token for use with all 
    Google Data API's

*/
public class GoogleViz {

/*
Official, up-to-date information can be found here: http://code.google.com/apis/visualization/documentation/reference.html

These comments may be out of date compared to the information found at the above url.

These comments describe the current format of the JSON needed to create a DataTable 
in the Google Visualization API js library.

It does not describe the structure of the whole JSON response, 
which includes also status, error info (when relevant), signature, and more.

The JSON is to be used as a single parameter to the DataTable constructor, as follows:

// This is the string generated by the server.
var responseStr = '...'; 

// Create an object out of the string. 
// Note that the extra parentheses are needed to avoid known eval problems.
var dataTableJson = eval('(' + responseStr + ')'); 
// Construct a DataTable object from the response
var dataTable = new google.visualization.DataTable(dataTableJson); 

// ... and you are ready to continue:
var container = document.getElementById('chart');
var chart = new google.visualization.AreaChart(container);
chart.draw(dataTable, options);


* - Note that this example is only a snippet, and to activate 
it you need to also load the the API from the loader, having the specified div,
 and a bit more.
Please refer to the docs at http://code.google.com/apis/visualization for more info.

The JSON DataTable data structure:
The json should be a js object with only two properties: 'cols' and 'rows'. Each of these properties is an array (described later):
{cols: [<columns>], rows: [<rows>]}
*/

/*
Column structure:
Each column is an object, containing the following properties:
* id: 
    - String. 
    - Optional. 
    - This is the id of the column. Should be unique in this data table. 
      Preferably be simple (alphanumeric) so later on you don't have to escape it with backticks when you refer to it. 

* label: 
    - String. 
    - Optional. 
    This is the label of the column, and some visualizations (like table, and some charts) actually display it to the users.

* type
   - String. 
   - Mandatory. 
   - This is the type of this column, must be from one of the following gviz types:
            'boolean' - JavaScript boolean value ('true' or 'false'). Example value: v:'true'
            'number' - JavaScript number value. Example values: v:7 , v:3.14, v:-55
            'string' - JavaScript string value. Example value: v:'hello'
            'date' - JavaScript Date object (zero-based month), with the time truncated. Example value: v:new Date(2008, 0, 15)
            'datetime' - JavaScript Date object including the time. Example value: v:new Date(2008, 0, 15, 14, 30, 45)
            'timeofday' - Array of three numbers and an optional fourth, representing hour (0 indicates midnight), minute, second, 
            and optional millisecond. Example values: v:[8, 15, 0], v: [6, 12, 1, 144]
*/ 

 public class col { 
    public col() {}
    public col(string idd ) {id = idd;}
    public col(string idd, string l ) {id = idd; label = l; }
    public col(string idd, string l, string ct ) {id = idd; label = l; ctype =  ct;}
    public string ctype,id,label; 
    public string toJsonString() { 
        return '{id: "' + id + '", label: "' + label + '", type: "' + ctype + '"}';
    }
 }


/*
Row structure:
Each row is an array of cells. The number of cells should match the number of columns.
A cell can be an object as described below, or a null, 
so if you have a row with null values, you can just skip them in the array. 
For example, if there are 3 columns, and in  a certain row the first two 
cells are nulls, you can specify: [ , , {v: '3rd cell value'}]
*/
 public class row { 
    public list<cell> cells = new list<cell>{}; 
    public row() {} 
    public row(list<cell> c) { cells = c; } 
    public string toJsonString() { 
        system.assert( cells.size() > 0, ' no cells found in row');
        string ret = '{c:['; 
        for( cell cc: cells) { 
            ret += cc.toJsonString() + ','; 
        }   
        ret = ret.substring( 0, ret.length() - 1 ) + ']}';
        return ret; 
    }
 } 
 
 
/*Cell structure: Each cell is an object with two optional values:

v: Value. Optional. If does not exists, or contains null, then the cell is assumed to be a null cell. Otherwise, the value type should match the column type, in the following mapping: 
 
  boolean: A javascript boolean value: true, false
  number: A javascript number: 2, -3.2
  string: A javascript string: 'some value'
  date: A javascript Date: new Date(2008, 1, 28, 0, 31, 26) 
  datetime: A javascript Date: new Date(2008, 1, 28, 0, 31, 26)
  timeofday: A javascript array of 3 or 4 numbers: [hours, minutes, seconds] or 
  [hours, minutes, seconds, milliseconds] 
  
f: Formatted value. String. Optional. The formatted value of this cell. Used by some visualizations (like table, and more). If the formatted value is not defined (or it is null), and is asked for, there is a default formatting that depends on the column type. 

 */
 public class cell { 
    JSONObject obj = new JsonObject();  
    date dt; 
    datetime dtm; 
    /*timeofday*/ 
    //string f; 
    public cell( ) { }
    public cell( string s) { // plain string
        obj.putOpt( 'v', new JSONObject.value( s ) );   
    }
    public cell( Boolean bo) {  // decimal or number 
        obj.putOpt( 'v', new JSONObject.value( bo ) );   
    }
    public cell( Decimal dec) {  // decimal or number 
        obj.putOpt( 'v', new JSONObject.value( dec ) );  
    }
    public cell( Date d ) {  // decimal or number 
        dt = d;
        obj.putOpt( 'f', new JSONObject.value( d.format() ) );  
    }
    public cell( integer i, string s) {  // number value and formated value
        obj.putOpt( 'v', new JSONObject.value( i ) );
        obj.putOpt( 'f', new JSONObject.value( s ) );   
    }
    public cell( string val, string formattedVal) {  
       obj.putOpt( 'v', new JSONObject.value( val ) );
       obj.putOpt( 'f', new JSONObject.value(formattedVal ) );   
    }
    public cell( date d, string s) {  // number value and formated value
        // {v: new Date(2008, 3, 30, 0, 31, 26), f: '4/30/08 12:31 AM'}
        dt = d;
        obj.putOpt( 'f', new JSONObject.value( s ) );   
    }
    public cell( datetime d) {  // number value and formated value
        dtm = d;
        obj.putOpt( 'f', new JSONObject.value( d.format() ) );  
    }
    // TODO datetime , string
    // TODO timeofday , string 
    public string toJsonString() { 
        string ret = 'null';    
        if ( dtm != null ) {
            ret = '{v: '+googleviz.dateToJavaScript(dtm)+ ', f: "'+ 
             obj.getString('f') + '"}'; 
        } else 
        if ( dt != null ) {
            ret = '{v: '+googleviz.dateToJavaScript(dt)+ ', f: "'+ 
             obj.getString('f') + '"}'; 
        } else 
        if ( obj != null ) {
            ret =  obj.ValuetoString();     
        }
        return ret;
    }
    
 } 
 
 public list<row> rowCollection = new list<row>{}; 
 public list<col> cols = new list<col>{}; 
 
 public void addRow( row r ) { rowCollection.add( r) ; } 
 
 // helper to return a Google JSON string from a date
 public static string dateToJavaScript(date dd) { 
    string ret = 'new Date(' + dd.year() + ', ' + (dd.month()-1) + ', ' + dd.day() + ', 0, 0, 0)';  
    //system.debug( ret ); 
    return ret;
 } 
 public static string dateToJavaScript(datetime dtm) { 
    string ret = 'new Date(' + 
    dtm.year() + ', ' + (dtm.month()-1) + ', ' + dtm.day() + 
    ', '+dtm.hour() +', '+ dtm.minute() +', ' + dtm.second() + ')'; 
    //system.debug( ret ); 
    return ret;
 }
 
// helper to return a Google JSON string from a datetime
 public static string dateToGVizDate(datetime d) { 
    GoogleViz.cell dt = new GoogleViz.cell( (DateTime)d );
    string ret = dt.toJsonString();
    return ret;
 } 
 
 // helper to return a Google JSON string from a date
 public static string dateToGVizDate(date d) { 
    GoogleViz.cell dt = new GoogleViz.cell( (Date)d );
    string ret = dt.toJsonString();
    return ret;
 } 
   
 public string toJSONString() { 
    string ret = '{cols: ['; 
    for( col c: cols) { ret += c.toJsonString() + ',' ; }
    ret = ret.substring( 0, ret.length() - 1 ) + '], ';
    ret += 'rows: [';
    system.assert( rowCollection.size() > 0 , 'no rows found in object ');
    for( row r: rowCollection) { 
        ret += r.toJsonString() + ','; 
    }
    ret = ret.substring( 0, ret.length() - 1 ) + ']}';
    ret = ret.replaceAll('\'','');
    ret = ret.replaceAll('\\p{Cntrl}','');
    return ret; 
 }
 
 /* Reference JSON String from: http://code.google.com/apis/visualization/documentation/reference.html#DataTable
    
    {
       cols: [{id: 'task', label: 'Task', type: 'string'},
                {id: 'hours', label: 'Hours per Day', type: 'number'}],
       rows: [{c:[{v: 'Work'}, {v: 11}]},
              {c:[{v: 'Eat'}, {v: 2}]},
              {c:[{v: 'Commute'}, {v: 2}]},
              {c:[{v: 'Watch TV'}, {v:2}]},
              {c:[{v: 'Sleep'}, {v:7, f:'7.000'}]}
             ]
     }
 */
 
 
 public static testmethod void GoogleReferenceJSONStringTest1() {
    String googleRefernceJSONString = '{cols: [{id: "task", label: "Task", type: "string"},{id: "hours", label: "Hours per Day", type: "number"}], ' + 
                                      'rows: [{c:[{v: "Work"},{v: "11"}]},{c:[{v: "Eat"},{v: "2"}]},{c:[{v: "Commute"},{v: "2"}]},' + 
                                      '{c:[{v: "Watch TV"},{v: "2"}]},{c:[{v: "Sleep"},{v: "7"}]}]}';
    
    GoogleViz gv = new GoogleViz();
    
    gv.cols = new list<GoogleViz.col> { 
        new GoogleViz.Col('task','Task','string'),
        new GoogleViz.Col('hours','Hours per Day','number')
    };
    
    GoogleViz.row r1 = new GoogleViz.row();
    r1.cells.add ( new GoogleViz.cell( 'Work' ) );
    r1.cells.add ( new GoogleViz.cell( '11' ) );
    gv.addRow( r1 );
    
    GoogleViz.row r2 = new GoogleViz.row();
    r2.cells.add ( new GoogleViz.cell( 'Eat' ) );
    r2.cells.add ( new GoogleViz.cell( '2' ) );
    gv.addRow( r2 );
    
    GoogleViz.row r3 = new GoogleViz.row();
    r3.cells.add ( new GoogleViz.cell( 'Commute' ) );
    r3.cells.add ( new GoogleViz.cell( '2' ) );
    gv.addRow( r3 );
    
    GoogleViz.row r4 = new GoogleViz.row();
    r4.cells.add ( new GoogleViz.cell( 'Watch TV' ) );
    r4.cells.add ( new GoogleViz.cell( '2' ) );
    gv.addRow( r4 );
    
    GoogleViz.row r5 = new GoogleViz.row();
    r5.cells.add ( new GoogleViz.cell( 'Sleep' ) );
    r5.cells.add ( new GoogleViz.cell( '7' ) );
    gv.addRow( r5 );
    
    System.assertEquals(googleRefernceJSONString, gv.toJSONString());
 }
 
/* Reference JSON String *adapted* from: http://code.google.com/apis/visualization/documentation/reference.html#DataTable
    {
      cols: [{id: 'A', label: 'NEW A', type: 'string'},
             {id: 'B', label: 'B-label', type: 'number'},
             {id: 'C', label: 'C-label', type: 'date'}
            ],
      rows: [{c:[{v: 'a'}, {v: 1.0}, {v: new Date(2008, 1, 28, 0, 31, 26), f: '2/28/08 12:31 AM'}]},
             {c:[{v: 'b'}, {v: 2.0}, {v: new Date(2008, 2, 30, 0, 31, 26), f: '3/30/08 12:31 AM'}]},
             {c:[{v: 'c'}, {v: 3.0}, {v: new Date(2008, 3, 30, 0, 31, 26), f: '4/30/08 12:31 AM'}]}
            ]
    }
 
 
 {c:[{v: "a"},{v: "1"},{v: new Date(2008, 1, 28, 0, 31, 26), f: "2/28/2008 12:31 AM"}]},
 {c:[{v: "b"},{v: "2"},{v: new Date(2008, 2, 30, 0, 21, 26), f: "3/30/2008 12:21 AM"}]},
 {c:[{v: "c"},{v: "3"},{v: new Date(2008, 3, 30, 0, 31, 26), f: "4/30/2008 12:31 AM"}]}]}*/
 
  public static testmethod void GoogleReferenceJSONStringTest2() {
    String googleRefernceJSONString = '{cols: [{id: "A", label: "NEW A", type: "string"},' +
                                              '{id: "B", label: "B-label", type: "number"},' + 
                                              '{id: "C", label: "C-label", type: "date"}], ' +
                                       'rows: [{c:[{v: "a"},{v: "1"},{v: new Date(2008, 1, 28, 0, 31, 26), f: "28-02-2008 00:31"}]},' + 
                                              '{c:[{v: "b"},{v: "2"},{v: new Date(2008, 2, 30, 0, 31, 26), f: "30-03-2008 00:31"}]},' + 
                                              '{c:[{v: "c"},{v: "3"},{v: new Date(2008, 3, 30, 0, 31, 26), f: "30-04-2008 00:31"}]}]}';
    
    GoogleViz gv = new GoogleViz();
    
    gv.cols = new list<GoogleViz.col> { 
        new GoogleViz.Col('A','NEW A','string'),
        new GoogleViz.Col('B','B-label','number'),
        new GoogleViz.Col('C','C-label','date')
    };
    
    GoogleViz.row r1 = new GoogleViz.row();
    r1.cells.add ( new GoogleViz.cell( 'a' ) );
    r1.cells.add ( new GoogleViz.cell( '1' ) );
    r1.cells.add ( new GoogleViz.cell( DateTime.newInstance(2008, 2, 28, 0, 31, 26) ) );
    gv.addRow( r1 );
    
    GoogleViz.row r2 = new GoogleViz.row();
    r2.cells.add ( new GoogleViz.cell( 'b' ) );
    r2.cells.add ( new GoogleViz.cell( '2' ) );
    r2.cells.add ( new GoogleViz.cell( DateTime.newInstance(2008, 3, 30, 0, 31, 26) ) );
    gv.addRow( r2 );
    
    GoogleViz.row r3 = new GoogleViz.row();
    r3.cells.add ( new GoogleViz.cell( 'c' ) );
    r3.cells.add ( new GoogleViz.cell( '3' ) );
    r3.cells.add ( new GoogleViz.cell( DateTime.newInstance(2008, 4, 30, 0, 31, 26) ) );
    gv.addRow( r3 );
    
    gv.toJSONString();
 }
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 public static  testmethod void escapeTest() { 
    row r = new row();
    cell cc = new cell('bad\'data with \n\t control char\'s');  
    GoogleViz gv = new GoogleViz(); 
    gv.cols = new list<col> { new GoogleViz.Col('B','b','string') };
    gv.addRow(new row( new list<cell> {cc} ));
    string assert = '{cols: [{id: "B", label: "b", type: "string"}], rows: [{c:[{v: "baddata with  control chars"}]}]}';            
    
    //System.debug('EXPECTED = ' + assert);
    //System.debug('ACTUAL   = ' + gv.toJSONString());
    
    system.assertEquals(assert, gv.toJsonString(), 'toss control and single quotes');
 }

 public static  testmethod void rowTest() { 
    row r = new row();
    cell cc = new cell(); 
    cell boo = new Cell(false);
    cell i = new Cell(1.0);
    cell d = new Cell( System.today());
    cell dt = new Cell ( system.now() );
 
    system.assert( dt.toJsonString()  != null );
    GoogleViz v = new GoogleViz(); 
    v.cols = new list<col> { 
        new GoogleViz.Col('A','New at\'s \nA','t'),
        new GoogleViz.Col('B','B label','n') };
    
    r = new row( new list<cell> {boo,i} );
    
    v.addRow(r);
    //system.debug(v.toJSONString());
 
 }
 
 public static  testmethod void test_col() { 
    
    GoogleViz.Col cl = new GoogleViz.Col('A'); 
    cl = new GoogleViz.Col('A','New A'); 
    cl.ctype = 'string';
    //system.debug(cl.toJsonString());
    cl = new GoogleViz.Col('A','New A','string'); 
    //system.debug(cl.toJsonString());
    
    GoogleViz gv = new GoogleViz(); 
    gv.cols = new list<col> { new GoogleViz.Col('A','New A','string'),
         new GoogleViz.Col('B','B label','number') };
    
    row rr = new row();
    
    GoogleViz.cell ctmp = new GoogleViz.cell('a');
    
    rr.cells.add ( ctmp );      
    rr.cells.add ( new GoogleViz.cell( 3, '3ish' ) ); // {v: 3.0, f: '3'}
    
    // {v: new Date(2008, 3, 30, 0, 31, 26), f: '4/30/08 12:31 AM'}
    rr.cells.add ( new GoogleViz.cell( Date.newInstance(2008,3,30), '4/30/08 12:31 AM' ) );
    
    gv.rowCollection.add( rr ); 
    
    string assert = '{cols: [{id: "A", label: "New A", type: "string"},{id: "B", label: "B label", type: "number"}], rows: [{c:[{v: "a"},{v: 3,f: "3ish"},{v: new Date(2008, 2, 30, 0, 0, 0), f: "4/30/08 12:31 AM"}]}]}';              
    //System.debug('EXPECTED = ' + assert);
    //System.debug('ACTUAL   = ' + gv.toJSONString());
    system.assertEquals( assert , gv.toJSONString() );
    
 }

    
 
 public static  testmethod void test_unparsing2() { 
    JSONObject.value va = new JSONObject.value('str'); 
    system.assert( va.valueToString()  == '"str"' );
    
    system.assert( 
        dateToJavaScript(Date.newInstance(2008,1,30)) == 'new Date(2008, 0, 30, 0, 0, 0)', 
        ' dateToJavaScript  failed' );
 
    system.assert( GoogleViz.dateToJavaScript( System.now()) != null);
    
    GoogleViz v = new GoogleViz(); 
    GoogleViz.Col cl = new GoogleViz.Col(); 
    cl.id = 'A';  
    cl.label = 'NEW A';
    cl.ctype = 'string';
    //system.debug(cl);
    //system.debug(cl.toJsonString());
    string col_str = '{id: "A", label: "NEW A", type: "string"}';
    system.assert( col_str == cl.toJsonString() );
    
    //system.debug( jsonobject.instance( col_str ) );
 }
  
 
 public static  testmethod void test_junparsing() { 
    try_json( '{id:"A"}');
    try_json( '{label:"NEW A"}');
    try_json( '{type:"string"}'); 
    try_json( '{type:12}');
    try_json( '{type:true}');
    try_json( '{type:false}');
    try_json( '{a:[{v: "c"}, {v: 3}]}');
 }
 
 // helper to parse and un parse json testing the results
 public static void try_json(string s) {    
    s = s.replaceAll(' ','');
    jsonobject j = jsonobject.instance(s);
    string jstring = j.valueToString().replaceAll(' ','');  
    //system.debug(s +'>>'+ jstring);
    // remove white space for the comparison
    system.assert( s == jstring, 'mis match in parsing');
 
    
 } 
 
}