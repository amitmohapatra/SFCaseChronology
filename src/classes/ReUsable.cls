public class ReUsable {
    
    public static void showErrorMessage() {
        PageReference pageRef = ApexPages.CurrentPage();
        ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Oops.. an error occurred while processing your request. We have dispatched an email to the administrator with the error details. The issue will be fixed shortly.'); 
        ApexPages.addMessage(errorMsg);
    }

}