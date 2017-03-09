// Converts a lead as a step in a Visual Workflow process
global class VWFCreateACR implements Process.Plugin {
    // This method runs when the step is reached in a Flow
    global Process.PluginResult invoke(Process.PluginRequest request) {
        // set up variables to store input parameters from the Flow
        //String leadID = (String) request.inputParameters.get('LeadID');
        String contactID = (String) request.inputParameters.get('ContactID');
        String accountID = (String) request.inputParameters.get('AccountID');
       // String convertedStatus = (String) request.inputParameters.get('ConvertedStatus');
        //Boolean overWriteLeadSource = (Boolean) request.inputParameters.get('OverwriteLeadSource');
        //Boolean createOpportunity = (Boolean) request.inputParameters.get('CreateOpportunity');        
        //String opportunityName = (String) request.inputParameters.get('ContactID');
        //Boolean sendEmailToOwner = (Boolean) request.inputParameters.get('SendEmailToOwner');
        Boolean sendEmailToOwner = Boolean.valueOf(request.inputParameters.get('SendEmailToOwner'));
        String roleID = (String) request.inputParameters.get('LeadRoleID');   
        
        // Set the default handling for booleans 
       /* if (overWriteLeadSource == null) overWriteLeadSource = false;
        if (createOpportunity == null) createOpportunity = false;*/
        if (sendEmailToOwner == null) sendEmailToOwner = false;
        
        // convert the lead by passing to a helper method
        Map<String,Object> result = new Map<String,Object>();
        result = createACR(contactID, accountID,sendEmailToOwner, roleID);
 
        return new Process.PluginResult(result); 
    }
    
    // This method describes this plugin, as well as its inputs and outputs to the Cloud Designer
    // NOTE: Implementing this method is what makes this class appear in the designer
    global Process.PluginDescribeResult describe() {
        // Set up plugin metadata
        Process.PluginDescribeResult result = new Process.PluginDescribeResult();
        result.description = 'The ACR Creation Flow Plug-in create an account_contact_role__c';
        result.tag = 'ACR Management';
        
        // create a list that stores both mandatory and optional *input* parameters from a Flow
        // NOTE: Only primitive types (STRING, NUMBER, etc) are supported at this time.
        // Collections are not currently supported
        result.inputParameters = new List<Process.PluginDescribeResult.InputParameter>{
            // Lead ID (mandatory)
            /*new Process.PluginDescribeResult.InputParameter('LeadID', 
                    Process.PluginDescribeResult.ParameterType.STRING, true),*/
            // Account Id (optional)
            new Process.PluginDescribeResult.InputParameter('AccountID', 
                    Process.PluginDescribeResult.ParameterType.STRING, true),
            // Contact ID (optional)
            new Process.PluginDescribeResult.InputParameter('ContactID', 
                    Process.PluginDescribeResult.ParameterType.STRING, false),            
            // Status to use once converted
            /*new Process.PluginDescribeResult.InputParameter('ConvertedStatus', 
                    Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter('OpportunityName', 
                    Process.PluginDescribeResult.ParameterType.STRING, false),
            new Process.PluginDescribeResult.InputParameter('OverwriteLeadSource', 
                    Process.PluginDescribeResult.ParameterType.BOOLEAN, false),
            new Process.PluginDescribeResult.InputParameter('CreateOpportunity', 
                    Process.PluginDescribeResult.ParameterType.BOOLEAN, false),*/
            new Process.PluginDescribeResult.InputParameter('SendEmailToOwner', 
                    Process.PluginDescribeResult.ParameterType.BOOLEAN, false),
            new Process.PluginDescribeResult.InputParameter('LeadRoleID', 
                    Process.PluginDescribeResult.ParameterType.String, true)                                                 
        };

        // Create a list that stores *output* parameters sent *to* your flow.
        result.outputParameters = new List<Process.PluginDescribeResult.OutputParameter>{
            // Account ID of the converted lead
            /*new Process.PluginDescribeResult.OutputParameter('AccountID', 
                    Process.PluginDescribeResult.ParameterType.STRING),
            // Contact ID of the converted lead
            new Process.PluginDescribeResult.OutputParameter('ContactID', 
                    Process.PluginDescribeResult.ParameterType.STRING),*/
            // Opportunity ID of the converted lead
            /*new Process.PluginDescribeResult.OutputParameter('OpportunityID', 
                    Process.PluginDescribeResult.ParameterType.STRING),*/
                    
            new Process.PluginDescribeResult.OutputParameter('ACRID', 
                    Process.PluginDescribeResult.ParameterType.STRING)                                   
        };

        return result;
    }
        
    /**
     * Implementation of the LeadConvert plugin
     * Converts a given lead with several options:
     * leadID - The ID of the lead to convert
     * contactID - 
     * accountID - ID of the Account to attach the converted Lead/Oppty/Contact to.
     * convertedStatus - 
     * overWriteLeadSource - 
     * createOpportunity - true if you want to create a new Opportunity upon conversion
     * opportunityName - Name of the new Opportunity.
     * sendEmailtoOwner - true if you are changing owners upon conversion and want to send an email to the new owner of the Oppty.
     *
     * returns: a Map with the following output:
     * AccountID - ID of the Account created or attached to upon conversion.
     * ContactID - ID of the contact created or attached to upon conversion.
     * OpportunityID - ID of the opportunity created upon conversion.
     */
    public Map<String,String> createACR (
                               String contactID,
                               String accountID,
                               Boolean sendEmailToOwner,
                               String leadRoleID                                
        ) {
        Map<String,String> result = new Map<String,String>();
                                
      
           
            
         
              Account_Contact_Role__c acr = new Account_Contact_Role__c();
                acr.Customer__c = accountID; 
                System.debug('****Wen'+acr.Customer__c);  
                acr.Contact__c = contactID;
                acr.Role__c = leadRoleID;
                System.debug('*****Wen'+acr.Contact__c);
                insert acr;
                result.put('ACRID', acr.id);               
         
        return result;
    }
        
        // Utility exception class
        //class ConvertLeadPluginException extends Exception {}

 		
 }