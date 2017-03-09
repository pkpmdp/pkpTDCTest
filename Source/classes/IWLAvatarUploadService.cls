global class IWLAvatarUploadService {
	
	
	/**
	* This  method allows an application to update the user avatar created with an IWLUploadAvatar Widget, by either creating a new one,
	* updating the existing one or simply deleting the avatar. It first creates an attachment, and its id is returned upon successful calling. 
	* Then, an @future method is called so that the avatar becomes a Document and the user is updated.
	* @param userId the Id of the user whom Avatar image must be updated.
	* @param avatarTitle The name of the document that will hold the user's avatar image.
	* @param attachmentId the Id of the attachment that holds the information for the user's avatar image. 
	*        If null, the service will attempt to delete the existing avatar image for the user. 
	* 
	* @return [If content != null] The id of the new document created to hold the avatar image of the user, or null if there was a problem with the process
	* @return [If content == null] The id of the previous document created to hold the avatar image of the user, if any, or null if there was a problem with the process.
	*/
	public static String updateUserAvatar(User updatingUser, Attachment tempAttachment, String avatarsFolderDevName) {
		
		SecurityManager.canUpdate(User.IWLAvatarId__c);
		SecurityManager.canCreate(Attachment.sObjectType);
		
		
		String oldAvatarId = updatingUser.IWLAvatarId__c;				
		
		insert tempAttachment;
		updatingUser.IWLAvatarId__c = tempAttachment.Id;
		update updatingUser;
		doUpdateUserAvatar(updatingUser.Id, tempAttachment.Id, avatarsFolderDevName, oldAvatarId);
		
		//return the user's avatar document id.
		return tempAttachment.Id; 
	}
	
	/**
	* This method starts the delete process for the user avatar.
	* @param u the user to which the deletion process applies.
	* @return null string if the process started successfully. 
	*/
	public static String deleteUserAvatar(User u) {
		SecurityManager.canUpdate(User.IWLAvatarId__c);
		String userAvatarId = u.IWLAvatarId__c;
		u.IWLAvatarId__c = null;
		update u;
		doDeleteUserAvatar(u.Id, userAvatarId);
		return null; 
	}
	
	/**
	* This future method does the actual avatar deletion, by searching for a document with id = avatarDocumentId
	* and created by the user with id = userId. 
	* @param userId the Id of the user doing the deletion.
	* @param avatarDocumentId the id of the document that represents the user's avatar image.
	*/
	@future 
	private static void doDeleteUserAvatar(String userId, String avatarDocumentId) {
		
		List<User> matchingUsers = [Select Id, IWLAvatarId__c from User where Id = :userId limit 1];
		if (matchingUsers == null || matchingUsers.size() == 0) { return; } //the user does not exist
		User u = matchingUsers.get(0);
		
		//Attempt to delete the existing avatar
		if (u != null && avatarDocumentId != null) {
			
			//Get the existing User's avatar document, if any
			try { 
				List<Document> existingAvatarDoc = [Select Id from Document where Id = :avatarDocumentId and CreatedById = :u.Id limit 1];
			
				//Attempt to delete the previous avatar image.
				if (existingAvatarDoc != null && existingAvatarDoc.size() > 0) {
					try { delete existingAvatarDoc; } catch (Exception ex) { /* Do nothing with this exception, we do not mind why the avatar document is not deletable*/ } 
				}
			} catch (Exception invalidIdEx) {
				//The id is invalid for document, so we must look for an attachment:
				List<Attachment> existingAvatarAtt = [Select Id from Attachment where Id = :avatarDocumentId and CreatedById = :u.Id limit 1];
			
				//Attempt to delete the previous avatar image.
				if (existingAvatarAtt != null && existingAvatarAtt.size() > 0) {
					try { delete existingAvatarAtt; } catch (Exception ex) { /* Do nothing with this exception, we do not mind why the avatar document is not deletable*/ } 
				}
			}
			
		}

	}  
	
	/**
	* This method does the actual update of the user's avatar by creating a document from a previously uploaded avatar. 
	* @param userId the id of the user to which we need to associate the new avatar.
	* @param attachmentId the id of the temporary attachment that  holds the image for the user avatar.
	* @param avatarsFolderDevName Developer Name of the folder that stores the avatars.
	* @param oldAvatarId the id of the previously existing user's avatar image, if any.
	*/ 
	@future
    private static void doUpdateUserAvatar(String userId, String attachmentId, String avatarsFolderDevName, String oldAvatarId) {
		
    	List<User> matchingUsers = [Select Id, IWLAvatarId__c from User where Id = :userId limit 1];
		if (matchingUsers == null || matchingUsers.size() == 0) { return; } //the user does not exist
		
		User updatingUser = matchingUsers.get(0);
		
		List<Attachment> tempAvatarImageList = [Select Id, Body, Name from Attachment where Id = :attachmentId and CreatedById = :updatingUser.Id limit 1];
		if (tempAvatarImageList == null || tempAvatarImageList.size() == 0) { return; } //the attachment does not exist
		
		
		if (oldAvatarId != null) {
			//Get the existing User's avatar document, if any
			List<Document> existingAvatar = [Select Id from Document where Id = :oldAvatarId and CreatedById = :updatingUser.Id limit 1];
			//Attempt to delete the previous avatar image.
			if (existingAvatar != null && existingAvatar.size() > 0) {
				try { delete existingAvatar; } catch (Exception ex) { /* Do nothing with this exception, we do not mind why the avatar document is not deletable*/ } 
			}	
		}		
		
		String folderId = [Select Id from Folder where DeveloperName = :avatarsFolderDevName limit 1].Id; 
		
		Attachment tempAvatar = tempAvatarImageList.get(0);
		
		//create the document to hold the image and insert in DB
		
		Document avatarDocument = new Document(FolderId = folderId, Name=tempAvatar.Name, Body=tempAvatar.Body, IsPublic = true);
		insert avatarDocument;
				
		//update the user with the new avatar document id.		
		updatingUser.IWLAvatarId__c = avatarDocument.Id;
		update updatingUser;
		delete tempAvatarImageList;
    }
    
  	@isTest
	static void testUpdateUserAvatar() {
		Test.startTest();
		
		IWLWidget__c widgetRecord = IWLTestUtilities.createIWLWidget('IWLTESTAvatarUploadServiceTEst30871431418847', IWLCodeSettings.AvatarUploadRecordTypeName, null, false, null, null, null, true); 
			
		String userId = UserInfo.getUserId();
		Attachment a = new Attachment(ParentId = widgetRecord.Id, Name = '[IWLTEST] My Own Avatar!', Body=Encodingutil.base64Decode('9812038140248740174902'));
		User u = [Select Id, IWLAvatarId__c from User where Id = :userId];
		
		String documentId = IWLAvatarUploadService.updateUserAvatar(u, a, IWLCodeSettings.AvatarUploadFolderDevname);
		
		System.assert(documentId != null);
		
		documentId = IWLAvatarUploadService.deleteUserAvatar(u);
		Test.stopTest();
	}
	
	
}