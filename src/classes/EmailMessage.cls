/*
 * @Author : Amit Mohapatra
 * 
 * Email message service on exception.
 */
public class EmailMessage {
    
    private List<String> sendingTo;
    private List<String> sendingToBccAdd;
    private List<String> sendingToccAdd;
    private String body = 'Error happend';
    private String subject = 'Exception in Chronology Code';
    
    public EmailMessage() {
        this.sendingTo = new List<String>();
        this.sendingToBccAdd = new List<String>();
        this.sendingToccAdd = new List<String>();
        sendingTo.add('amit.mohapatra@concur.com');
    }
        
    public EmailMessage setToAddress(List<String> toAddr) {
        sendingTo = toAddr;
        return this;
    }
    
    public EmailMessage setBccAddress(List<String> bccAddr) {
        sendingToBccAdd = bccAddr;
        return this;
    }
    
    public EmailMessage setCcAddress(List<String> ccAddress) {
        sendingToccAdd = ccAddress; 
        return this;
    }
    
    public EmailMessage setSubject(String sub) {
        subject = sub;
        return this;
    }
    
    public EmailMessage setBody(Map<String, String> erorrMessage) {
        String msg = 'Hi<br/><br/><table>';
        
        for (String key : erorrMessage.keySet()) {
            String val = erorrMessage.get(key);
            String t = '<tr><td>'+key+'</td><td>'+val+'</td></tr>';
            msg = msg + t;
        }
        msg = msg + '</table></br></br>Thanks</br>Service-Innovation';
        body = msg;
        return this;
    }
    
    public void send() {
        Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
        
        if (sendingTo != null || sendingTo.size() > 0) {
            semail.setToAddresses(sendingTo);
        }
        
        if (sendingToBccAdd != null || sendingToBccAdd.size() > 0) {
            semail.setBccAddresses(sendingToBccAdd);
        }
        
        if (sendingToccAdd != null || sendingToccAdd.size() > 0) {
            semail.setCcAddresses(sendingToccAdd);
        }
        
        semail.setSubject(subject);
        semail.setHtmlBody(body);

        Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail});
        
        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: '+ results[0].errors[0].message);
        }  
    }
    
}