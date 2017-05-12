/**
 * @Author : Amit Mohapatra
 * 
 * The class initialized when someone click on case Chronlogy button on UI.
 * In constructor the page object is typed cast to Case Object.
 * 
 * Two methods :
 *      redirectToCase() : This method helps to go back to case page from chronology view.
 *      getCaseJsonString() : This method returns json string for table population.
 */
public class CaseController {
    
    private Case caseRecord;
    private String className = 'CaseController';
    private String jsonResult;
    private String currentURL;
    
    public CaseController (ApexPages.StandardController stdController) {
        System.debug(className+' : [CaseController()] : '+ 'Inside case controller constructer');
        caseRecord = (Case)stdController.getRecord();
        System.debug(className+' : [CaseController()] : case Id - '+ caseRecord.Id);
        currentURL = ApexPages.currentPage().getUrl();
        System.debug(className+' : [CaseController()] : url is - '+ currentURL);
        this.prepareCaseJsonString();
    }
    
    /*
     * This method helps to redirect back to case page from chronology page.
     */
    public PageReference redirectToCase(){
        System.debug(className+' : [redirectToCase()] : case Id '+ caseRecord.Id);
        if (caseRecord.Id != null) {
           return new PageReference ('/'+ caseRecord.Id);
        } else {
            Map<String, String> errorMsg = new Map<String, String>();
		    errorMsg.put('ClassName : ', className);
		    errorMsg.put('MethodName : ', 'redirectToCase');
			errorMsg.put('ErrorMessage : ', 'May be issue with case record. Id not found. </br>Unable to redirecting to case page.');
			ReUsable.showErrorMessage();
			new EmailMessage().setBody(errorMsg).send();
			System.debug('May be issue with case record. Id not found. </br>Unable to redirecting to case page.');
            return null;
        }
    }
    
    public String getJsonResult() {
        return this.jsonResult;
    }
    
    /*
     * Gives the json string for table population.
     */
    public void prepareCaseJsonString() {
        try {
            System.debug(className+' : [prepareCaseJsonString()] : inside the method. case Id : '+ caseRecord.Id);
            this.jsonResult = new CaseManager().executeQuery(caseRecord).getJson();
        } catch (Exception e) {
            Map<String, String> errorMsg = new Map<String, String>();
            errorMsg.put('UserName  :  ', ''+UserInfo.getName());
            errorMsg.put('UserEmail  :  ', ''+UserInfo.getUserEmail());
            errorMsg.put('OrganizationId  :  ', ''+UserInfo.getOrganizationId());
            errorMsg.put('OrganizationName  :  ', ''+UserInfo.getOrganizationName());
            errorMsg.put('CaseId  :  ', ''+caseRecord.Id);
		    errorMsg.put('Cause  :  ', ''+e.getCause());
		    errorMsg.put('LineNumber  :  ', ''+e.getLineNumber());
			errorMsg.put('ErrorMessage  :  ', e.getMessage());
            errorMsg.put('StackTrace  :  ', e.getStackTraceString());
			ReUsable.showErrorMessage();
			new EmailMessage().setBody(errorMsg).send();
			System.debug('FATAL_ERROR : '+errorMsg);
        }
    }
}