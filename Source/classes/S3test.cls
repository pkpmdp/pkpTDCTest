@isTest(SeeAllData=true)
public class S3test { 
    
    //S3
    //test method for class S3 tejas
    static testMethod void test_S3() {
        S3.LoggingSettings logstng = new S3.LoggingSettings();
        S3.Grant grnt = new S3.Grant();
        S3.ListBucketResponse_element lstBktRespEle = new S3.ListBucketResponse_element();
        S3.ListBucketResult lstBktRslt = new S3.ListBucketResult();
        S3.CopyObjectResult copyObjRslt = new S3.CopyObjectResult();
        S3.ListAllMyBucketsList lstAllMyBkt = new S3.ListAllMyBucketsList();
        S3.MetadataEntry metaDataEntry = new S3.MetadataEntry();
        S3.GetBucketAccessControlPolicyResponse_element getBktAcsCntrlPoliRespEle = new S3.GetBucketAccessControlPolicyResponse_element();
        S3.GetObjectResponse_element getObjRespEle = new S3.GetObjectResponse_element();
        S3.AmazonS3 s = new S3.AmazonS3();
        S3 controller = new S3();
        S3.GetBucketLoggingStatus_element getBktLogStsEle = new S3.GetBucketLoggingStatus_element();
        S3.GetObjectExtended_element getObjExtndEle = new S3.GetObjectExtended_element();
        S3.PostResponse_element postRespEle = new S3.PostResponse_element();
        S3.GetBucketAccessControlPolicy_element getBktAcsContrlPoliEle = new S3.GetBucketAccessControlPolicy_element();
        S3.ListAllMyBucketsEntry lstAllMyBktE = new S3.ListAllMyBucketsEntry();
        S3.CreateBucketResult createBktRslt = new S3.CreateBucketResult();
        S3.ListEntry lstEntry = new S3.ListEntry();
        S3.PutObjectInlineResponse_element putObjInResEle = new S3.PutObjectInlineResponse_element();
        S3.DeleteObject_element delObjEle = new S3.DeleteObject_element();
        S3.ListAllMyBucketsResult lstAllMyBktRslts = new S3.ListAllMyBucketsResult();
        S3.ListAllMyBucketsResponse_element lstAllMyBktRespEle = new S3.ListAllMyBucketsResponse_element();
        S3.GetObjectExtendedResponse_element getObjExtndRespEle = new S3.GetObjectExtendedResponse_element();
        S3.CreateBucketResponse_element createBkRespEle = new S3.CreateBucketResponse_element();
        S3.Status status = new S3.Status();
        S3.DeleteBucket_element delBktEle = new S3.DeleteBucket_element();
        S3.SetObjectAccessControlPolicy_element setObjAcsCntrlPoli = new S3.SetObjectAccessControlPolicy_element();
        S3.GetObjectAccessControlPolicyResponse_element getObjAcsCntrlPoliRespEle = new S3.GetObjectAccessControlPolicyResponse_element();
        S3.SetBucketLoggingStatus_element setBktLogStsEle = new S3.SetBucketLoggingStatus_element();
        S3.PrefixEntry preEntry = new S3.PrefixEntry();
        S3.DeleteObjectResponse_element delObjRespEle = new S3.DeleteObjectResponse_element();
        S3.SetBucketAccessControlPolicy_element setBktAcsCntrlPoliEle = new S3.SetBucketAccessControlPolicy_element();
        S3.GetBucketLoggingStatusResponse_element getBktLogStsRespEle = new S3.GetBucketLoggingStatusResponse_element();
        S3.ListAllMyBuckets_element lstAllMyBktEle = new S3.ListAllMyBuckets_element();
        S3.SetBucketLoggingStatusResponse_element setBktLogStsRespEle = new S3.SetBucketLoggingStatusResponse_element();
        S3.PutObjectResult putObjRes = new S3.PutObjectResult();
        S3.GetObjectAccessControlPolicy_element getObjAcsCntrlPoliEle = new S3.GetObjectAccessControlPolicy_element();
        S3.BucketLoggingStatus bktLogSts = new S3.BucketLoggingStatus();
        S3.GetObject_element getObjEle = new S3.GetObject_element();
        S3.Group_x grpX = new S3.Group_x();
        S3.AccessControlList acsCntrlLst = new S3.AccessControlList();
        S3.CopyObjectResponse_element copyObjRespEle = new S3.CopyObjectResponse_element();
        S3.CanonicalUser canoUsr = new S3.CanonicalUser();
        S3.Result reslt = new S3.Result();
        S3.AmazonCustomerByEmail amazonCustByEml = new S3.AmazonCustomerByEmail();
        S3.PutObjectResponse_element putObjRespEle = new S3.PutObjectResponse_element();
        S3.SetObjectAccessControlPolicyResponse_element setObjAcsCntrlPoliRespEle = new S3.SetObjectAccessControlPolicyResponse_element();
        S3.User_x userX = new S3.User_x();
        S3.ListBucket_element lstBktEle = new S3.ListBucket_element();
        S3.GetObjectResult getObjRslt = new S3.GetObjectResult();
        S3.PutObjectInline_element putObjInlEle = new S3.PutObjectInline_element();
        S3.LocationConstraint locConstrain = new S3.LocationConstraint();
        S3.CopyObject_element copyObjEle = new S3.CopyObject_element();
        S3.CreateBucket_element createBktEle = new S3.CreateBucket_element();
        S3.PutObject_element putObjEle = new S3.PutObject_element();
        S3.AccessControlPolicy acsCntrlPoli = new S3.AccessControlPolicy();
        S3.CreateBucketConfiguration createBktConfig = new S3.CreateBucketConfiguration();
        S3.DeleteBucketResponse_element delBktRespEle = new S3.DeleteBucketResponse_element();
        S3.SetBucketAccessControlPolicyResponse_element setBktAcsCntrlPoliRespEle = new S3.SetBucketAccessControlPolicyResponse_element();
        S3.S3Request s3Req = new S3.S3Request();        
    }

}