ul, ol {
	margin:0;
	padding:0;
	list-style-type: none;
}
html, body {
	margin:0;
	padding:0;
}

/*

GRID

*/
/*
	Variable Grid System.
	Learn more ~ http://www.spry-soft.com/grids/
	Based on 960 Grid System - http://960.gs/

	Licensed under GPL and MIT.
*/

/*
  Forces backgrounds to span full width,
  even if there is horizontal scrolling.
  Increase this if your layout is wider.

  Note: IE6 works fine without this fix.
*/

body {
  min-width: 960px;
}

/* Containers
----------------------------------------------------------------------------------------------------*/
.container_12 {
	margin-left: auto;
	margin-right: auto;
	width: 960px;
}

/* Grid >> Global
----------------------------------------------------------------------------------------------------*/


.grid_1,
.grid_2,
.grid_3,
.grid_4,
.grid_5,
.grid_6,
.grid_7,
.grid_8,
.grid_9,
.grid_10,
.grid_11,
.grid_12 {
	display:inline;
	float: left;
	position: relative;
	margin-left: 10px;
	margin-right: 10px;
}



.push_1, .pull_1,
.push_2, .pull_2,
.push_3, .pull_3,
.push_4, .pull_4,
.push_5, .pull_5,
.push_6, .pull_6,
.push_7, .pull_7,
.push_8, .pull_8,
.push_9, .pull_9,
.push_10, .pull_10,
.push_11, .pull_11,
.push_12, .pull_12 {
	position:relative;
}


/* Grid >> Children (Alpha ~ First, Omega ~ Last)
----------------------------------------------------------------------------------------------------*/

.alpha {
	margin-left: 0;
}

.omega {
	margin-right: 0;
}

/* Grid >> 12 Columns
----------------------------------------------------------------------------------------------------*/


.container_12 .grid_1 {
	width:60px;
}

.container_12 .grid_2 {
	width:140px;
}

.container_12 .grid_3 {
	width:220px;
}

.container_12 .grid_4 {
	width:300px;
}

.container_12 .grid_5 {
	width:380px;
}

.container_12 .grid_6 {
	width:460px;
}

.container_12 .grid_7 {
	width:540px;
}

.container_12 .grid_8 {
	width:620px;
}

.container_12 .grid_9 {
	width:700px;
}

.container_12 .grid_10 {
	width:780px;
}

.container_12 .grid_11 {
	width:860px;
}

.container_12 .grid_12 {
	width:940px;
}

/* custom grid and container */

.container_2 .custom_grid_1 {
	width:340px;
	float:left;
	padding:0;
	margin:30px 0 0;
}
.container_2 .custom_grid_1:first-child {
	margin-right: 20px;
}



/* Prefix Extra Space >> 12 Columns
----------------------------------------------------------------------------------------------------*/


.container_12 .prefix_1 {
	padding-left:80px;
}

.container_12 .prefix_2 {
	padding-left:160px;
}

.container_12 .prefix_3 {
	padding-left:240px;
}

.container_12 .prefix_4 {
	padding-left:320px;
}

.container_12 .prefix_5 {
	padding-left:400px;
}

.container_12 .prefix_6 {
	padding-left:480px;
}

.container_12 .prefix_7 {
	padding-left:560px;
}

.container_12 .prefix_8 {
	padding-left:640px;
}

.container_12 .prefix_9 {
	padding-left:720px;
}

.container_12 .prefix_10 {
	padding-left:800px;
}

.container_12 .prefix_11 {
	padding-left:880px;
}



/* Suffix Extra Space >> 12 Columns
----------------------------------------------------------------------------------------------------*/


.container_12 .suffix_1 {
	padding-right:80px;
}

.container_12 .suffix_2 {
	padding-right:160px;
}

.container_12 .suffix_3 {
	padding-right:240px;
}

.container_12 .suffix_4 {
	padding-right:320px;
}

.container_12 .suffix_5 {
	padding-right:400px;
}

.container_12 .suffix_6 {
	padding-right:480px;
}

.container_12 .suffix_7 {
	padding-right:560px;
}

.container_12 .suffix_8 {
	padding-right:640px;
}

.container_12 .suffix_9 {
	padding-right:720px;
}

.container_12 .suffix_10 {
	padding-right:800px;
}

.container_12 .suffix_11 {
	padding-right:880px;
}



/* Push Space >> 12 Columns
----------------------------------------------------------------------------------------------------*/


.container_12 .push_1 {
	left:80px;
}

.container_12 .push_2 {
	left:160px;
}

.container_12 .push_3 {
	left:240px;
}

.container_12 .push_4 {
	left:320px;
}

.container_12 .push_5 {
	left:400px;
}

.container_12 .push_6 {
	left:480px;
}

.container_12 .push_7 {
	left:560px;
}

.container_12 .push_8 {
	left:640px;
}

.container_12 .push_9 {
	left:720px;
}

.container_12 .push_10 {
	left:800px;
}

.container_12 .push_11 {
	left:880px;
}



/* Pull Space >> 12 Columns
----------------------------------------------------------------------------------------------------*/


.container_12 .pull_1 {
	left:-80px;
}

.container_12 .pull_2 {
	left:-160px;
}

.container_12 .pull_3 {
	left:-240px;
}

.container_12 .pull_4 {
	left:-320px;
}

.container_12 .pull_5 {
	left:-400px;
}

.container_12 .pull_6 {
	left:-480px;
}

.container_12 .pull_7 {
	left:-560px;
}

.container_12 .pull_8 {
	left:-640px;
}

.container_12 .pull_9 {
	left:-720px;
}

.container_12 .pull_10 {
	left:-800px;
}

.container_12 .pull_11 {
	left:-880px;
}




/* `Clear Floated Elements
----------------------------------------------------------------------------------------------------*/

/* http://sonspring.com/journal/clearing-floats */

.clear {
  clear: both;
  display: block;
  overflow: hidden;
  visibility: hidden;
  width: 0;
  height: 0;
}

/* http://www.yuiblog.com/blog/2010/09/27/clearfix-reloaded-overflowhidden-demystified */

.clearfix:before,
.clearfix:after {
  content: '\0020';
  display: block;
  overflow: hidden;
  visibility: hidden;
  width: 0;
  height: 0;
}

.clearfix:after {
  clear: both;
}

/*
  The following zoom:1 rule is specifically for IE6 + IE7.
  Move to separate stylesheet if invalid CSS is a problem.
*/

.clearfix {
  zoom: 1;
}

/* ====== media ====== */
.media, .media > .bd {overflow:hidden; _overflow:visible; zoom:1;}
.media > .img {float:left; margin-right: 10px;}
.media > .img img{display:block;}

/*
	repel object
*/
.repel_object {
	overflow: hidden;	
}
.repel_object > .ro_left  {
	float:left;
}
.repel_object > .ro_right {
	float:right;
}

.table_object {
	display: table;
}
.table_object > .to_cell {
	display: table-cell;
	vertical-align: middle;
}

/*
	text_object
	used as a container for richtext
*/
.text_object {

}
.text_object p:first-child {
	margin-top:0;
}
.text_object p {
	font-size: 13px;
}
.text_object > img {
	max-width:500px;
	height:auto;
}
.text_object strong {
	font-weight: bold;
}
.text_object a {
	text-decoration: underline;
	color:#000;
}
.text_object a:hover,
.text_object a:active {
	text-decoration: none;
	color:#959595;
}

.error {
	color:#cf4b4b;
	font-size:12px;
}


body {
	font-size: 13px;
	color: #767676;
	font-family: "Trebuchet MS", Helvetica, sans-serif;
	line-height: 1.3em;
	color:#000;
	background: url("https://cs7.salesforce.com/resource/1366096159000/youbio_stripes") repeat-x top left;
}

h1, h2, h3 {
	color:#000;
}
h1 {
	line-height: 26px;
}

h2 {
	line-height: 26px;
}



a {
	text-decoration: none;
}

.dim {
	color:#a3a3a3;
}

.breadcrumb {
	width:100%;
	display: inline-block;
}
.breadcrumb li {
	float:right;
	background: url("https://cs7.salesforce.com/resource/1366096112000/youbio_small_arrow") no-repeat 0 4px;
	padding-left:10px;
	margin-left:10px;
}
.breadcrumb li a {
	color:#000;
	font-size:12px;
}
.breadcrumb li a:hover,
.breadcrumb li a:active {
	color:#959595;
}


/*
	icons
*/
.icon {
	display: inline-block;
}

.icon_comment {
	width:14px;
	height: 13px;
	background:url("https://cs7.salesforce.com/resource/1366107945000/youbio_icon_comment") no-repeat 0 0;
}
.icon_comment.large {
	width:20px;
	height: 19px;
	background:url("https://cs7.salesforce.com/resource/1366276840000/youbio_icon_comment_large") no-repeat 0 0;
}
.icon_like {
	width:29px;
	height: 30px;
	background:url("https://cs7.salesforce.com/resource/1366107896000/youbio_icon_like") no-repeat 0 -30px;
}
.icon_like.is-liked{
	background-position: 0 0;
}
.icon_like.small {
	width:20px;
	height: 21px;
	background:url("https://cs7.salesforce.com/resource/1366118019000/youbio_icon_like_small") no-repeat 0 0;
}
.icon_like.small.is-liked{
	background-position: 0 -21px;
}
.icon_facebook,
.icon_twitter {
	cursor: pointer;
	width:22px;
	height: 22px;
	background:url("https://cs7.salesforce.com/resource/1366276733000/youbio_icon_facebook") no-repeat 0 0;
}
.icon_twitter {
	background:url("https://cs7.salesforce.com/resource/1366276805000/youbio_icon_twitter") no-repeat 0 0;
}
.icon_facebook:hover,
.icon_twitter:hover,
.icon_twitter:active,
.icon_facebook:active {
	background-position: 0 -22px;
}
/*
	buttons
*/
.btn,
input[type=button] {
	background-color:#89cf4b;
	color:#fff;
	display: block;
	text-decoration: none;
	cursor: pointer;
	padding:8px 0 8px;
	text-align: center;
}
.btn:hover,
input[type=button]:hover {
	background-color: #d2d2d2;
}
.btn:active,
input[type=button]:active {
	background-color: #bbbaba;
}
input[type=button] {
	border:none;
	width: 100%;
}

.IWLPostIdeaSubmitButtons > input {
	float: right;
	width: auto;
	padding: 10px 20px;
}
/*
	text inputs
*/
input[type=text] {
	border:1px solid #dadada;
	padding:12px 12px 8px;
	width:677px;
	color:#a9a9a9;
	font-size:12px;


	-moz-box-shadow: inset 2px 2px 10px #e8e8e8);
	-webkit-box-shadow: inset 2px 2px 10px #e8e8e8;
	box-shadow: inset 2px 2px 10px #e8e8e8;

	/*filter: progid:DXImageTransform.Microsoft.Blur(PixelRadius=3,MakeShadow=true,ShadowOpacity=0.30);
	-ms-filter: "progid:DXImageTransform.Microsoft.Blur(PixelRadius=3,MakeShadow=true,ShadowOpacity=0.30)";
	zoom: 1;*/
} 



#wrapper{
	width: 960px;
	margin:0 auto;
	padding-top:5px;
	overflow: hidden;
	padding-bottom:50px;
}

#header {
	overflow: hidden;
}
#header .breadcrumb {
	margin-top:20px;
}


#body-wrap .grid_3 {
	border-top:2px solid #d2d2d2;
	padding-top:20px;
}

#body-wrap .grid_9 .grid_3 {
	border-top:none;
}

/*
	facebook box
*/
.facebook_box {
	margin-bottom:50px;
}
.facebook_box .btn {
	margin-top:15px;
	height:30px;
	line-height: 24px;
	display: block;
	background-color:#37589a;
	color:#fff;
	padding:0;
	text-align: left;
}
.facebook_box .btn span {
	border-right:1px solid #5f79ae;
	padding:0 10px;
	margin-right:10px;
	display: inline-block;
	font-size: 20px;
	position: relative;
	top:3px;
}
.facebook_box .btn:hover {
	background-color: #4b67a1;
}
.facebook_box .btn:active {
	background-color:#4b67a1
	-moz-box-shadow: inset 0 0 10px #0e295f;
   	-webkit-box-shadow: inset 0 0 10px #0e295f;
   	box-shadow: inset 0 0 10px #0e295f;
}

.facebook_box_user_data {
	margin-bottom:50px;
}
.facebook_box_user_data img {
	width:60px;
	height: 60px;
	overflow: hidden;
}
.facebook_box_user_data span {
	display:inline-block;
}
.facebook_box_user_data a {
	color:#000;
	background: url("https://cs7.salesforce.com/resource/1366096112000/youbio_small_arrow") no-repeat 0 2px;
	padding-left:10px;
	display: block;
	width: 100%;
	margin-top:15px;
}
.facebook_box_user_data a:hover,
.facebook_box_user_data a:active {
	color:#959595;
}
/*
	main navigation
*/

.navigation {
	margin-bottom:40px;
}
.navigation > h3 {
	margin:0;
	padding:0;
	border-bottom:1px solid #dedede;
}
.navigation li {
	margin:0;
	padding:0;
	border-bottom:1px solid #dedede;
}
.navigation li a {
	background: url("https://cs7.salesforce.com/resource/1366096344000/youbio_list_arrow") no-repeat 0 10px;
	padding:10px 0 10px 20px;
	display: block;
	color:#000;
}
.navigation li a:hover,
.navigation li a:active {
	background-position: 5px 10px;
	background-color:#dbdbdb;
}

/*
	content box
*/
.content_box {
	position: relative;
	padding-bottom:5px;
	border-bottom:1px solid #d2d2d2;
	height: 245px;
	overflow: hidden;
}


.content_box > span {
	display:inline-block;
	font-size:10px;
	margin:5px 0;
}
.content_box > p {
	margin:0 0 10px;
}
.content_box .text_container {
	height: 164px;
	overflow:hidden;
}
.content_box .text_container > h2 {
	padding:0;
	margin:0 0 20px;
}
.content_box .text_container > h2 > a {
	color:#000;
}
.content_box > h3 {
	padding:0 0 4px 0;
	margin:0;
	border-bottom:1px solid #d2d2d2;
}
.content_box .text_object {
	font-style:normal;
}

/*
	Share box
*/
.share_box {
	overflow: hidden;
	position: absolute;
	bottom:10px;
	width:100%;
}
.share_box span {
	float:right;
	display: inline-block;
	height: 30px;
	line-height: 30px;
	font-size: 12px;
}
.share_box span .icon {
	margin-left:5px;
	float:right;
	cursor: pointer;
}
.share_box span:first-child {
	float:left;
}
.share_box span:first-child .icon {
	margin-left:0px;
	margin-right:5px;
	float:left;
	position: relative;
	top:7px;
}


/*
	Social box
*/
.social_box {
	overflow: hidden;
}
.social_box span {
	overflow: hidden;
	display: block;
	text-align: right;
	margin-top:9px;
	height: 21px;
	line-height: 21px;
	font-size: 11px;
}
.social_box span:first-child {
	margin-top:20px;
	height: 13px;
	line-height: 13px;
}
.container_2 .custom_grid_1 .social_box span:first-child i {
	margin-left:10px;
}
.social_box span i {
	float:right;
	margin-left:5px;
	cursor: pointer;
}

.grid_9 .social_box span {
	overflow: hidden;
	display: block;
	text-align: right;
	margin-top:9px;
	height: 30px;
	line-height: 30px;
	font-size: 11px;
}
.grid_9 .social_box span:first-child {
	overflow: hidden;
	display: block;
	text-align: right;
	margin-top:9px;
	height: 21px;
	line-height: 21px;
	font-size: 11px;
}
.grid_9 .social_box span:first-child i {
	margin-left:20px;
}


/*
	comment
	extents list-item
*/

.comment {

} 
.grid_9 .list_item.comment {
	min-height: 60px;
	height: auto;
}
.grid_9 .list_item.comment .date {
	font-size: 10px;
	font-style: italic;
	display: inline-block;
	margin-bottom:5px;
}

/*
	active comment
*/
.grid_9 .list_item.comment.is_active {
	min-height: auto;
	height: auto;
}
.grid_9 .list_item.comment.is_active .to_cell {
	vertical-align: bottom;
}
.grid_9 .list_item.comment.is_active .headgroup {
	margin-top:10px;
	margin-bottom:20px;
}
.grid_9 .list_item.comment.is_active .headgroup h1 {
	margin:0;
}
.grid_9 .list_item.comment.is_active .headgroup .to_cell {
	vertical-align: middle;
}
.grid_9 .list_item.comment.is_active .headgroup .to_cell {
	vertical-align: middle;
	width:85px;
	padding-left:20px;
	border-left:1px solid #d2d2d2;
}
.grid_9 .list_item.comment.is_active .headgroup .to_cell:first-child {
	vertical-align: top;
	width:580px;
	padding-right:10px;
	border-left:none;
	padding-left:0;
}
.grid_9 .list_item.comment.is_active .headgroup .social_box span {
	height: 30px;
	line-height: 30px;
	margin-top:0;
}
.grid_9 .list_item.comment.is_active .headgroup .social_box .icon {
	float: right;
}
.grid_9 .list_item.comment.is_active .headgroup .icon_like {
	margin-left:10px;
	height: 30px;
}
.grid_9 .list_item.comment.is_active .headgroup .ro_left,
.grid_9 .list_item.comment.is_active .headgroup .ro_right {
	width:22px;
}
.grid_9 .list_item.comment.is_active .headgroup .ro_right {
	margin-right:20px;
}
.grid_9 .list_item.comment.is_active .text_object {
	border-bottom: 2px solid #d2d2d2;
	padding:20px 0;
}
.grid_9 .list_item.comment.is_active .comment_action {
	padding:15px 0 0;
	height: 32px;
	line-height: 32px;
}
.grid_9 .list_item.comment.is_active .comment_action .ro_left {
	width:530px;

}
.grid_9 .list_item.comment.is_active .comment_action .social_box,
.grid_9 .list_item.comment.is_active .comment_action .social_box i {
	float:left;
	color:#a3a3a3;
}
.grid_9 .list_item.comment.is_active .comment_action .social_box span {
	font-size: 16px;
	margin-top:4px;
}
.grid_9 .list_item.comment.is_active .comment_action .social_box i {
	margin-left:0;
	margin-right: 10px;
}
.grid_9 .list_item.comment.is_active .comment_action .btn {
	padding: 8px 35px;
	line-height: 13px;
}
.grid_9 .list_item.comment .text_object {
	font-size:13px;
	font-style: italic;
}	


/*
	comment by yousee
*/

.grid_9 .list_item.comment.yousee .text_object p {
	font-weight: bold;
}


/*
	CTA box
*/
.cta_box {
	padding:5px 10px;
	height:241px;
	
	-moz-box-shadow: 0px 0px 2px 1px #dddddd;
  	-webkit-box-shadow: 0px 0px 2px 1px #dddddd;
  	box-shadow: 0px 0px 2px 1px #dddddd;
  	
  	-webkit-border-radius: 2px; 
  	-moz-border-radius: 2px; 
  	border-radius: 2px;

  	background-color: #ededed; 
	background-image: -webkit-gradient(linear, 0% 0%, 0% 100%, from(#ededed), to(#fff));
	background-image: -webkit-linear-gradient(top, #ededed, #fff); 
	background-image:    -moz-linear-gradient(top, #ededed, #fff);
	background-image:     -ms-linear-gradient(top, #ededed, #fff);
	background-image:      -o-linear-gradient(top, #ededed, #fff);
}
.cta_box > h2 {
	height: auto;
	margin:0 0 20px;
}
.cta_box > p {
	margin:0 0 10px;
}
/*
	cta box extented
*/
.cta_box.ext {
	height: 260px;
}
.cta_box.ext > h2 {

}
.cta_box.ext > h2 > img{
	display:block;
	margin:0 auto;
}



/*
	list item
*/
.custom_grid_1 > h3 {
	margin:0;
	padding:0;
	border-bottom:1px solid #dedede;
}

.list_item {
	width:100%;
	padding:10px 0;
	border-bottom: 1px solid #dedede;
	min-height: 60px;
	height: auto;	
}
.list_item > .img {
	width:60px;
}
.list_item > .media > img.img  {
	width:60px;
	height: 60px;
	overflow: hidden;
}
.list_item > .bd {
	overflow: hidden;
}
.list_item .ro_left {
	width:195px;
}
.list_item .list_item_meta {
	font-size: 10px;
}
.list_item .list_item_meta h2 a {
	color:#000;
}
.list_item h4 {
	font-size: 13px;
	margin:0;
	padding:0;
}
.list_item h4 > a {
	color:#000;
}
.list_item p {
	font-size: 13px;
	
}  
/*
	list-item in grid_9
*/
.grid_9 .list_item {
	min-height: 150px;
	border-bottom:2px solid #d2d2d2;;
}
.grid_9 .list_item:first-child {
	border-top: 0;
}
.grid_9 .list_item .ro_left {
	width:550px;
}
.grid_9 .list_item .to_cell{
	height: 60px;
}
.grid_9 .list_item.yousee {
	padding-left:10px;
	margin-left:-10px;
	padding-right:10px;
	margin-right:-10px;
	margin-top:-2px;
	background-color:#dbdbdb;
	border-bottom: none;
}
.grid_9 .list_item h2 {
	font-size:22px;
}
.grid_9 .list_item .text_object {
	display: block;
	overflow: hidden;
	max-height: 240px;
	font-size:13px;
}

/*
	list-item in custom grid
*/
.grid_9 .custom_grid_1 .list_item {
	min-height: 60px;
	height: auto;
	border-bottom:1px solid #d2d2d2;
}
.grid_9 .custom_grid_1 .list_item:first-child {
	border-top:none;
}		
.grid_9 .custom_grid_1 .list_item .ro_left {
	width:195px;
}





/* yousee specific -  copy/paste from yousee site */
.column { float: left; display: block; overflow: hidden; }
/* --- BottomNavigation --- */
#bottomnavigation { background: #232323; overflow: auto; color: #fff; padding: 20px 0; }
#bottomnavigation .wrapper {
	width:960px;
	margin:0 auto;
}

#bottomnavigation h3 { color: #fff; font-size: 16px; margin-bottom: 10px; }

#bottomnavigation li { float: none; width: 145px; margin-left:0px; border-bottom: 1px solid #383838; }
#bottomnavigation li a { display: block; color: #fff; padding: 5px 1px /*w-bug*/; font-size: 11px; }

#bottomnavigation .column { width: 140px; margin-right: 61px; text-align: left; }
#bottomnavigation .column.last { margin-right: 0; }

/* --- FooterNavigation --- */
#footer .hnav { text-align: center; }
#footer .hnav li { background: url(/img/hnav_divider.png) no-repeat right top; display: inline; float: none !important; }
#footer .hnav li.last { background: none !important; }
#footer .hnav li a { font-size: 12px; font-weight: normal; color: #fff; display: inline; padding-right:15px;padding-left:15px;}

#footer { background:#2e2e2e url(http://yousee.dk/img/redesign2013/bg_footer_youSeeStripes_new.png) repeat-x; display: block; height: 72px; }

#footer .footerBG{
    background-image:url(http://yousee.dk/img/redesign2013/footerYellowStripeBG.png);
    background-position:849px 0px;
    background-repeat:no-repeat;

    display:block;
    height:35px;
    width:978px;
    margin:auto;
    position:relative;
    top:21px;
}









#body-wrap{

}
#leftsidebar{
	width: 200px;
	min-height: 540px;
	float: left;
	background-color: #F5F5F5;
	display: block;
	overflow: hidden;
	padding: 5px 10px;
	border: 1px solid #d8dcdd;
}
#container{
	background-color: #FFFFFF;
    display: block;
    float: left;
    margin: 20px 15px;
    min-height: 500px;
    overflow: hidden;
    padding: 5px 0px;
    width: 755px;
}
.menu ul {
	margin: 0;
	padding: 10px 10px 0px 10px;
	background-color: #F5F5F5;
	border: 1px solid #fff;
	border-bottom: 1px solid #d8dcdd;
}
.menu{
	margin: 0;
	padding: 0;
}
.menu li, .menu .selected {
	color: #767676;
	font-weight: bold;
	line-height: 1.9em;
	list-style: none;
	display: inline;
	padding: 5px 20px;
	background-color: #F5F5F5;
	border: 1px solid #F5F5F5;
	border-bottom: 1px solid #d8dcdd;
}
.menu .selected {
	color: #000;
	background-color: #fff;
	border: 1px solid #d8dcdd;
	border-bottom: 1px solid #fff;
}
#rightsidebar{
	width: 272px;
	float: right;
	background-color: #fff;
	display: block;
	overflow: hidden;
	margin: 25px 0px;
}
#rightsidebar .module{
	background-color: #F5F5F5;
	display: block;
	overflow: hidden;
	padding: 20px 20px;
	margin-top: 10px;
	-webkit-border-radius: 2px;
	-moz-border-radius: 2px;
	border-radius: 2px;
	border: 1px solid #d8dcdd;
	width:230px;
}
.followusImage {
	margin-left: 10px;
	margin-right:10px;
	cursor:pointer;
}
#rightsidebar h2{ font-size: 14px; text-transform: uppercase; border-bottom: 3px double #ccc; margin: 0px 0px 5px 0px; padding-bottom: 10px; }
#userimage{
	width:150px; 
	height:150px;
	margin: 10px 0px;
	border: 2px solid #fff !important;
	-moz-box-shadow: 0 0 3px #BBB;
	-webkit-box-shadow: 0 0 3px #BBB;
	box-shadow: 0 0 3px #BBB;
}
#user{ float: auto; display: inline-block; margin: 10px 22px; }
#leftsidebar ul {
	list-style: none;
	margin: 0;
	padding: 0;
	border-bottom: 1px solid #ccc;
}
#leftsidebar li, #leftsidebar li:hover {
	padding: 5px 5px 5px 20px;
	line-height: 2em;
	margin: 1px 1px;
	border-top: 1px solid #ccc;
}
#leftsidebar li:hover, #leftsidebar .selected {
	background-color: #fff;
}



.IWLUploadAvatarWidgetViewProfileImage {
	margin-bottom:10px;
}

.IWLUploadAvatarWidgetViewProfileImageEdit {
	margin-bottom:10px;

}

.IWLSearchWidgetViewSearchThemes, .IWLSearchWidgetViewSearchIdeas {
	margin-bottom:20px;
	height: 40px;
	min-height:40px;
}

.IWLListviewWidgetViewIdeasList .IWLListviewItemRatingContainer {
	display:none !important;
}

.IWLListviewWidgetViewIdeasListHome .IWLListviewItemRatingContainer  {
	display:none !important;
}
.IWLSearchWrapper {
	width:195px;
}
.IWLSearchQueryInput, .IWLSearchQueryInput:hover{
	width: 140px !important;	
	border: none;
	padding: 2px 2px !important;
	margin: 5px 5px !important;
}
.IWLSlideshowWidgetViewMainSlideshow{
	margin-bottom: 20px;
}	
.IWLSlideshowWidgetView {
	width: 100%;
}

.IWLdetailViewIdeaThemeDetail {
    margin-top: 20px;
}

.IWLdetailViewIdeaDetail {
    left: 50%;
    margin-left: -360px;
    margin-top: 20px;
}

.categoriesSeparator {
	display:inline-block; 
	margin: 0 8px !important;
}

.IWLListviewRelatedTopic, .IWLDetailViewRelatedTopic {
    display: inline-block;
    
}

.IWLDetailViewItemAttributeValue.IWLDetailViewItemContent strong {
    font-weight: bold;
}

.IWLDetailViewItemAttributeValue.IWLDetailViewItemContent em{
    font-style:italic;
}

.IWLDetailViewItemAttributeValue.IWLDetailViewItemContent strong em{
    font-weight: bold;
    font-style:italic;
}

.IWLDetailViewItemAttributeValue.IWLDetailViewItemContent em strong {
    font-weight: bold;
    font-style:italic;
}
.IWLSlideshowItemAttributeContainer.IWLSlideshowItemRatingContainer {
	    left: 320px !important; 
}

.IWLSlideshowItemAttributeLabel {
    display: none;
}

.IWLSlideshowItemAttributeLabel.IWLSlideshowItemRatingLabel {
    display: inline-block !important;
    float:none !important;
}

.IWLSlideshowItemRating {
    float: left;
    display:inline-block !important;
}
.IWLSlideshowIdeaTheme .htmlDetailElementDiv {
	max-width: 310px;
    overflow: hidden;
}

.IWLSlideshowIdea .htmlDetailElementDiv {
    max-width: 470px;
}

.IWLListviewNextPage {
	display: inline-block;
	float:right;
	margin:20px 0px;
}
.IWLListviewPrevPage {
	display: inline-block;
	float:left;
	margin:20px 0px;	
}

