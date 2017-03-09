function showAvatarEdit() {
	jQuery('.IWLUploadAvatarWidgetViewProfileImage').hide();
	jQuery('.IWLUploadAvatarWidgetViewProfileImageEdit').show();
	
}

function hideAvatarEdit() {
	jQuery('.IWLUploadAvatarWidgetViewProfileImageEdit').hide();
	jQuery('.IWLUploadAvatarWidgetViewProfileImage').show();

}

jQuery(document).ready( function() {
	
	/*jQuery('.IWLListviewItemAttributeValue').each(function(index) {
if( $(this).text() == 'N/A' ) $(this).text('100')
});*/
	
	jQuery('.IWLDetailViewItemAttributeValue').each(function(index) {
if( $(this).text() == 'N/A' ) $(this).text('100')
}); 

/*jQuery('.IWLSlideshowItemRating').each(function(index) {
if( $(this).text() == 'N/A' ) $(this).text('100')
});*/ 

jQuery('.IWLListviewItemFeedSizeLabel').html('Comments');

});

