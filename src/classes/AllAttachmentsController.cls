public class AllAttachmentsController {
       private Case caseRec;
       public String response {get; set;}
       public String caseId {get; set;}
       public String finalResult{get; set;}
       public String caseProfileFinalResult{get; set;}
    
       public AllAttachmentsController (ApexPages.StandardController stdController) { 
           
           caseRec = (Case)stdController.getRecord();
           caseId = caseRec.Id;
           this.getRecord();  
       }
    
       public PageReference getFinishPage(){
               return new PageReference ('/'+ caseRec.Id);
       }
    
       public String changeNulToNA(String field) {
           if (field == 'null') {
               return 'NA';
           }
           return ''+field;
       }
    
       public void  getRecord() {
              SObject[] queryParentObject = [Select Id, CaseNumber, Subject, Description, AccountId, Account.Name, Type, Product__c, Reason, PotentialLiability__c, Origin, OwnerId, ContactId, CreatedById, LastModifiedById, Priority, Status,  IsClosed, IsDeleted, IsEscalated, SLAViolation__c, LastModifiedDate, CreatedDate, LastViewedDate, ClosedDate, EngineeringReqNumber__c,  
              (Select Id, AccountId, Subject, ActivityDate, LastModifiedDate, Status, Description, LastModifiedById, CreatedById, Priority, ActivityType, ActivitySubtype, OwnerId, WhoId, IsClosed, CreatedDate From OpenActivities order by LastModifiedDate desc), 
              (Select Id, CaseId, CreatedDate, OldValue, NewValue, CreatedById, IsDeleted, Field  From Histories order by CreatedDate desc),
              (Select Id, AccountId, Subject, ActivityDate, LastModifiedDate, Status, Description, LastModifiedById, CreatedById, Priority, ActivityType, ActivitySubtype, OwnerId, WhoId, IsClosed, CreatedDate from ActivityHistories order by LastModifiedDate desc),
              (Select Id, CaseId, SolutionId, CreatedDate, CreatedById, IsDeleted From CaseSolutions order by CreatedDate desc ),
              (Select Id, ParentId, CommentBody, LastModifiedDate, LastModifiedById, IsDeleted, IsPublished,CreatedById, CreatedDate, SystemModstamp From CaseComments order by LastModifiedDate desc), 
              (Select Id, Name, LastModifiedDate, CreatedDate, LastModifiedById, CreatedById, Description, OwnerId, IsDeleted, IsPrivate From Attachments order by LastModifiedDate desc)
              From Case where Id= :caseRec.Id order by LastModifiedDate desc];
           
              String caseProfileResult = '{';
              for (SObject parentRecord : queryParentObject) {
                  String key = '"' + this.changeNulToNA(''+parentRecord.get('Id')) + '"' +':';
                  
                  String profAct = '{"Element": "Case",';
                  profAct = profAct+'"CaseNumber":' + '"' + this.changeNulToNA(''+parentRecord.get('CaseNumber'))+ '"' +',';
                  profAct = profAct+'"Subject":' + '"' + this.changeNulToNA(''+parentRecord.get('Subject'))+ '"' +',';
                  profAct = profAct+'"Description":' + '"' + this.changeNulToNA(''+parentRecord.get('Description'))+ '"' + ',';
                  profAct = profAct+'"AccountId":' + '"' + this.changeNulToNA(''+parentRecord.get('AccountId'))+ '"' + ',';
                  profAct = profAct+'"AccountName":' + '"' + this.changeNulToNA(''+parentRecord.getSObject('Account').get('Name'))+ '"' + ',';
                  profAct = profAct+'"Type":' + '"' + this.changeNulToNA(''+parentRecord.get('Type'))+ '"' + ',';
                  profAct = profAct+'"Product":' + '"' + this.changeNulToNA(''+parentRecord.get('Product__c'))+ '"' + ',';
                  profAct = profAct+'"Reason":' + '"' + this.changeNulToNA(''+parentRecord.get('Reason'))+ '"' + ',';
                  profAct = profAct+'"Origin":' + '"' + this.changeNulToNA(''+parentRecord.get('Origin'))+ '"' + ',';
                  profAct = profAct+'"Priority":' + '"' + this.changeNulToNA(''+parentRecord.get('Priority'))+ '"' + ',';
                  profAct = profAct+'"Status":' + '"' + this.changeNulToNA(''+parentRecord.get('Status'))+ '"' + ',';
                  profAct = profAct+'"Closed":' + '"' + this.changeNulToNA(''+parentRecord.get('IsClosed'))+ '"' + ',';
                  profAct = profAct+'"Deleted":' + '"' + this.changeNulToNA(''+parentRecord.get('IsDeleted'))+ '"' + ',';
                  profAct = profAct+'"Escalated":' + '"' + this.changeNulToNA(''+parentRecord.get('IsEscalated'))+ '"' + ',';
                  profAct = profAct+'"PotentialLiability":' + '"' + this.changeNulToNA(''+parentRecord.get('PotentialLiability__c'))+ '"' + ',';
                  profAct = profAct+'"SLAViolation":' + '"' + this.changeNulToNA(''+parentRecord.get('SLAViolation__c'))+ '"' + ',';
                  profAct = profAct+'"LastViewedDate":' + '"' + this.changeNulToNA(''+parentRecord.get('LastViewedDate'))+ '"' + ',';
                  profAct = profAct+'"ClosedDate":' + '"' + this.changeNulToNA(''+parentRecord.get('ClosedDate'))+ '"' + ',';
                  
                  String contactId = ''+ parentRecord.get('ContactId');
                  Contact contactDetails = [Select name, email, MobilePhone, Phone from Contact where Id=:contactId];
                  profAct = profAct+'"ContactId":' + '"' + this.changeNulToNA(''+contactId) + '"' + ',';
                  profAct = profAct+'"ContactName":' + '"' + this.changeNulToNA(''+contactDetails.name) + '"' + ',';
                  profAct = profAct+'"ContactEmail":' + '"' + this.changeNulToNA(''+contactDetails.email) + '"' + ',';
                  profAct = profAct+'"ContactMobilePhone":' + '"' + this.changeNulToNA(''+contactDetails.MobilePhone) + '"' + ',';
                  profAct = profAct+'"ContactPhone":' + '"' + this.changeNulToNA(''+contactDetails.phone) + '"' + ',';
                          
                  String createdById = ''+ parentRecord.get('CreatedById');
                  User createByDetails = [Select name, email, MobilePhone, Phone from User where Id=:createdById];
                  profAct = profAct+'"CreatedById":' + '"' + this.changeNulToNA(''+createdById) + '"' + ',';
                  profAct = profAct+'"CreatedByName":' + '"' + this.changeNulToNA(''+createByDetails.name) + '"' + ',';
                  profAct = profAct+'"CreatedByEmail":' + '"' + this.changeNulToNA(''+createByDetails.email) + '"' + ',';
                  profAct = profAct+'"CreatedByMobilePhone":' + '"' + this.changeNulToNA(''+createByDetails.MobilePhone) + '"' + ',';
                  profAct = profAct+'"CreatedByPhone":' + '"' + this.changeNulToNA(''+createByDetails.phone) + '"' + ',';
                          
                  String modifiedById = ''+ parentRecord.get('LastModifiedById');
                  User modifiedByDetails = [Select name, email, MobilePhone, Phone from User where Id=:modifiedById];
                  profAct = profAct+'"ModifiedById":' + '"' + this.changeNulToNA(''+modifiedById) + '"' + ',';
                  profAct = profAct+'"ModifiedByName":' + '"' + this.changeNulToNA(''+modifiedByDetails.name) + '"' + ',';
                  profAct = profAct+'"ModifiedByEmail":' + '"' + this.changeNulToNA(''+modifiedByDetails.email) + '"' + ',';
                  profAct = profAct+'"ModifiedByMobilePhone":' + '"' + this.changeNulToNA(''+modifiedByDetails.MobilePhone) + '"' + ',';
                  profAct = profAct+'"ModifiedByPhone":' + '"' + this.changeNulToNA(''+modifiedByDetails.phone) + '"' + ',';
        
                  String ownerId = ''+ parentRecord.get('OwnerId');
                  User userDetails = [Select name, email, MobilePhone, Phone from User where Id=:ownerId];
                  profAct = profAct+'"OwnerId":' + '"' + this.changeNulToNA(''+ownerId) + '"' + ',';
                  profAct = profAct+'"OwnerName":' + '"' + this.changeNulToNA(''+userDetails.name) + '"' + ',';
                  profAct = profAct+'"OwnerEmail":' + '"' + this.changeNulToNA(''+userDetails.email) + '"' + ',';
                  profAct = profAct+'"OwnerMobilePhone":' + '"' + this.changeNulToNA(''+userDetails.MobilePhone) + '"' + ',';
                  profAct = profAct+'"OwnerPhone":' + '"' + this.changeNulToNA(''+userDetails.phone) + '"' + ',';
                  
                  profAct = profAct+'"EngineeringReqNumber":' + '"' + this.changeNulToNA(''+parentRecord.get('EngineeringReqNumber__c'))+ '"';
                  profAct = profAct + '}}';
                  
                  caseProfileResult = caseProfileResult + key + profAct;
              }
              caseProfileFinalResult = caseProfileResult;
           
              Set<String> taskEventIds = new Set<String>();
              Set<String> whoIds = new Set<String>();
              Set<String> userIds = new Set<String>();
                                 
              for (SObject parentRecord : queryParentObject) {
                  
                  SObject[] openActivities = parentRecord.getSObjects('OpenActivities');
                  if (openActivities != null) {
                      for (SObject childRecord : openActivities){
                          String taskEventId = ''+childRecord.get('Id');
                          taskEventIds.add(taskEventId);
                          // getting the user details from user table using  OwnerId
                          String whoId = ''+ childRecord.get('WhoId');
                          whoIds.add(whoId);
                          String createdById = ''+ childRecord.get('CreatedById');
                          userIds.add(createdById);
                          String modifiedById = ''+ childRecord.get('LastModifiedById');
                          userIds.add(modifiedById);
                          // getting the user details from user table using  OwnerId
                          String ownerId = ''+ childRecord.get('OwnerId');
                          userIds.add(ownerId);
                      }
                  }
                  
                  SObject[] activityHistories = parentRecord.getSObjects('ActivityHistories');
                  if (activityHistories != null) {
                      for (SObject childRecord : activityHistories){
                          String taskEventId = ''+childRecord.get('Id');
                          taskEventIds.add(taskEventId);
                          // getting the user details from user table using  OwnerId
                          String whoId = ''+ childRecord.get('WhoId');
                          whoIds.add(whoId);
                          String createdById = ''+ childRecord.get('CreatedById');
                          userIds.add(createdById);
                          String modifiedById = ''+ childRecord.get('LastModifiedById');
                          userIds.add(modifiedById);
                          // getting the user details from user table using  OwnerId
                          String ownerId = ''+ childRecord.get('OwnerId');
                          userIds.add(ownerId);
                      }
                  }
                  
                  SObject[] histories = parentRecord.getSObjects('Histories');
                  if (histories != null) {
                      for (SObject childRecord : histories){
                          String createdById = ''+ childRecord.get('CreatedById');
                          userIds.add(createdById);
                      }
                  }
                  
                  SObject[] caseSolutions = parentRecord.getSObjects('CaseSolutions');
                  if (caseSolutions != null) {
                      for (SObject childRecord : caseSolutions){
                          String createdById = ''+ childRecord.get('CreatedById');
                          userIds.add(createdById);
                      }
                  }
                  
                  SObject[] caseComments = parentRecord.getSObjects('CaseComments');
                  if (caseComments != null) {
                      for (SObject childRecord : caseComments){
                          String createdById = ''+ childRecord.get('CreatedById');
                          userIds.add(createdById);
                          String modifiedById = ''+ childRecord.get('LastModifiedById');
                          userIds.add(modifiedById);
                      }
                  }
                  
                  SObject[] attachments = parentRecord.getSObjects('Attachments');
                  if (attachments != null) {
                      for (SObject childRecord : attachments){
                          String createdById = ''+ childRecord.get('CreatedById');
                          userIds.add(createdById);
                          String modifiedById = ''+ childRecord.get('LastModifiedById');
                          userIds.add(modifiedById);
                      }
                  }
              }

              List<Attachment> attachmentRecords = [Select Id, ParentId, Name, LastModifiedDate, Description, IsDeleted, IsPrivate From Attachment where ParentId=:taskEventIds order by LastModifiedDate desc];
              Map<String, Map<String, Map<String, String>>> attachmentRecordPair = new Map<String, Map<String, Map<String, String>>>();
           
              if (attachmentRecords != null) {
                  for (Attachment record : attachmentRecords) {
                      String parId = ''+record.ParentId;
                      if (attachmentRecordPair.containsKey(parId)) {
                          Map<String, String> rec = new Map<String, String>();
                          rec.put('Id', ''+record.Id);
                          rec.put('Name', ''+record.Name);
                          rec.put('LastModifiedDate', ''+record.LastModifiedDate);
                          rec.put('Description', ''+record.Description);
                          rec.put('Deleted', ''+record.IsDeleted);
                          rec.put('Private', ''+record.IsPrivate);
                          attachmentRecordPair.get(parId).put(''+record.Id, rec);
                      } else {
                          Map<String, String> rec = new Map<String, String>();
                          rec.put('Id', ''+record.Id);
                          rec.put('Name', ''+record.Name);
                          rec.put('LastModifiedDate', ''+record.LastModifiedDate);
                          rec.put('Description', ''+record.Description);
                          rec.put('Deleted', ''+record.IsDeleted);
                          rec.put('Private', ''+record.IsPrivate);
                          Map<String, Map<String, String>> finalRec =  new Map<String, Map<String, String>>();
                          finalRec.put(''+record.Id, rec);
                          attachmentRecordPair.put(parId, finalRec);
                      }
                  }
              }
           
              List<Contact> contactRecords = [Select Id, name, email, phone, MobilePhone  from Contact where Id=:whoIds];
              Map<Id, Contact> contactRecordsPair = new Map<Id, Contact>(contactRecords);
           
              List<User> userRecords = [Select Id, name, email, phone, MobilePhone  from User where Id=:userIds];
              Map<Id, User> userRecordsPair = new Map<Id, User>(userRecords);
           
              string BaseURL = ApexPages.currentPage().getHeaders().get('Host');
              String result = '{';
                                
              for (SObject parentRecord : queryParentObject) {
                  // Id, AccountId, Subject, ActivityDate, LastModifiedDate, Status, Description, LastModifiedById, CreatedById, Priority, ActivityType,  ActivitySubtype, OwnerId, WhoId, IsClosed, CreatedDate
                  SObject[] openActivities = parentRecord.getSObjects('OpenActivities');
                  
                  if (openActivities != null) {
                      for (SObject childRecord : openActivities){
                          String key = '"' + this.changeNulToNA(''+childRecord.get('LastModifiedDate')) + '"' +':';
                          
                          String openAct = '{"Element":' + '"' + this.changeNulToNA(''+childRecord.get('ActivitySubtype'))+ '"' + ',';
                          openAct = openAct+'"LastModifiedDate":' + '"' + this.changeNulToNA(''+childRecord.get('LastModifiedDate'))+ '"' +',';
                          openAct = openAct+'"CreatedDate":' + '"' + this.changeNulToNA(''+childRecord.get('CreatedDate'))+ '"' +',';
                          openAct = openAct+'"Description":' + '"' + this.changeNulToNA(''+childRecord.get('Description'))+ '"' + ',';
                          openAct = openAct+'"AccountId":' + '"' + this.changeNulToNA(''+childRecord.get('AccountId'))+ '"' + ',';
                          openAct = openAct+'"Id":' + '"' + this.changeNulToNA(''+childRecord.get('Id'))+ '"' + ',';
                          openAct = openAct+'"Status":' + '"' + this.changeNulToNA(''+childRecord.get('Status'))+ '"' + ',';
                          openAct = openAct+'"Priority":' + '"' + this.changeNulToNA(''+childRecord.get('Priority'))+ '"' + ',';
                          openAct = openAct+'"ActivityType":' + '"' + this.changeNulToNA(''+childRecord.get('ActivityType'))+ '"' + ',';
                          openAct = openAct+'"ActivitySubtype":' + '"' + this.changeNulToNA(''+childRecord.get('ActivitySubtype'))+ '"' + ',';
                          openAct = openAct+'"Subject":' + '"' + this.changeNulToNA(''+childRecord.get('Subject'))+ '"' + ',';
                          openAct = openAct+'"Closed":' + '"' + this.changeNulToNA(''+childRecord.get('IsClosed'))+ '"' + ',';
                          openAct = openAct+'"ActivityDate":' + '"' + this.changeNulToNA(''+childRecord.get('ActivityDate'))+ '"' + ',';
                          openAct = openAct+'"ParentElement":"OpenActivities",';
                                                    
                          if (attachmentRecordPair.containsKey(''+childRecord.get('Id'))) {
                              openAct = openAct+'"AttachmentLink":' + (String)JSON.serialize(attachmentRecordPair.get(''+childRecord.get('Id'))) + ',';
                              //System.debug('kgdskfg***** : '+(String)JSON.serialize(attachmentRecordPair.get(''+childRecord.get('Id'))));
                          } else {
                              openAct = openAct+'"AttachmentLink":"NA",';
                          }
                          
                          // getting the user details from user table using  OwnerId
                          String whoId = ''+ childRecord.get('WhoId');
                          Contact contactDetails = contactRecordsPair.get(whoId);
                          openAct = openAct+'"CustomerId":' + '"' + this.changeNulToNA(''+whoId) + '"' + ',';
                          openAct = openAct+'"CustomerName":' + '"' + this.changeNulToNA(''+contactDetails.name) + '"' + ',';
                          openAct = openAct+'"CustomerEmail":' + '"' + this.changeNulToNA(''+contactDetails.email) + '"' + ',';
                          openAct = openAct+'"CustomerMobilePhone":' + '"' + this.changeNulToNA(''+contactDetails.MobilePhone) + '"' + ',';
                          openAct = openAct+'"CustomerPhone":' + '"' + this.changeNulToNA(''+contactDetails.phone) + '"' + ',';
                          
                          String createdById = ''+ childRecord.get('CreatedById');
                          User createByDetails = userRecordsPair.get(createdById);
                          openAct = openAct+'"CreatedById":' + '"' + this.changeNulToNA(''+createdById) + '"' + ',';
                          openAct = openAct+'"CreatedByName":' + '"' + this.changeNulToNA(''+createByDetails.name) + '"' + ',';
                          openAct = openAct+'"CreatedByEmail":' + '"' + this.changeNulToNA(''+createByDetails.email) + '"' + ',';
                          openAct = openAct+'"CreatedByMobilePhone":' + '"' + this.changeNulToNA(''+createByDetails.MobilePhone) + '"' + ',';
                          openAct = openAct+'"CreatedByPhone":' + '"' + this.changeNulToNA(''+createByDetails.phone) + '"' + ',';
                          
                          String modifiedById = ''+ childRecord.get('LastModifiedById');
                          User modifiedByDetails = userRecordsPair.get(modifiedById);
                          openAct = openAct+'"ModifiedById":' + '"' + this.changeNulToNA(''+modifiedById) + '"' + ',';
                          openAct = openAct+'"ModifiedByName":' + '"' + this.changeNulToNA(''+modifiedByDetails.name) + '"' + ',';
                          openAct = openAct+'"ModifiedByEmail":' + '"' + this.changeNulToNA(''+modifiedByDetails.email) + '"' + ',';
                          openAct = openAct+'"ModifiedByMobilePhone":' + '"' + this.changeNulToNA(''+modifiedByDetails.MobilePhone) + '"' + ',';
                          openAct = openAct+'"ModifiedByPhone":' + '"' + this.changeNulToNA(''+modifiedByDetails.phone) + '"' + ',';
        
                          // getting the user details from user table using  OwnerId
                          String ownerId = ''+ childRecord.get('OwnerId');
                          User userDetails = userRecordsPair.get(ownerId);
                          openAct = openAct+'"OwnerId":' + '"' + this.changeNulToNA(''+ownerId) + '"' + ',';
                          openAct = openAct+'"OwnerName":' + '"' + this.changeNulToNA(''+userDetails.name) + '"' + ',';
                          openAct = openAct+'"OwnerEmail":' + '"' + this.changeNulToNA(''+userDetails.email) + '"' + ',';
                          openAct = openAct+'"OwnerMobilePhone":' + '"' + this.changeNulToNA(''+userDetails.MobilePhone) + '"' + ',';
                          openAct = openAct+'"OwnerPhone":' + '"' + this.changeNulToNA(''+userDetails.phone) + '"';
                          
                          openAct = openAct+'},';
                          
                          result = result + key + openAct;
                      }
                  }
                  
                  // CaseId, CreatedDate, OldValue, NewValue, CreatedById, IsDeleted
                  SObject[] histories = parentRecord.getSObjects('Histories');
                  
                  if (histories != null) {
                      for (SObject childRecord : histories){
                          String key = '"' + childRecord.get('CreatedDate') + '"' +':';
                          
                          String history = '{"Element": "Histories",';
                          history = history+'"CaseId":' + '"' + this.changeNulToNA(''+childRecord.get('CaseId')) + '"' + ',';
                          history = history+'"Id":' + '"' + this.changeNulToNA(''+childRecord.get('Id')) + '"' + ',';
                          history = history+'"CreatedDate":' + '"' + this.changeNulToNA(''+childRecord.get('CreatedDate')) + '"' + ',';
                          history = history+'"NewValue":' + '"' + this.changeNulToNA(''+childRecord.get('NewValue')) + '"' +',';
                          history = history+'"OldValue":' + '"' + this.changeNulToNA(''+childRecord.get('OldValue')) + '"' + ',';
                          history = history+'"Deleted":' + '"' + this.changeNulToNA(''+childRecord.get('IsDeleted')) + '"' + ',';
                          history = history+'"Field":' + '"' + this.changeNulToNA(''+childRecord.get('Field')) + '"' + ',';
                          
                          String createdById = ''+ childRecord.get('CreatedById');
                          User createByDetails = userRecordsPair.get(createdById);
                          history = history+'"CreatedById":' + '"' + this.changeNulToNA(''+createdById) + '"' + ',';
                          history = history+'"CreatedByName":' + '"' + this.changeNulToNA(''+createByDetails.name) + '"' + ',';
                          history = history+'"CreatedByEmail":' + '"' + this.changeNulToNA(''+createByDetails.email) + '"' + ',';
                          history = history+'"CreatedByMobilePhone":' + '"' + this.changeNulToNA(''+createByDetails.MobilePhone) + '"' + ',';
                          history = history+'"CreatedByPhone":' + '"' + this.changeNulToNA(''+createByDetails.phone) + '"';
                          history = history+'},';
                          
                          result = result + key + history;
                      }
                  } 
                  
                  
                  //Id, AccountId, Subject, ActivityDate, LastModifiedDate, Status, Description, LastModifiedById, CreatedById, Priority, ActivityType,   ActivitySubtype, OwnerId, WhoId, IsClosed, CreatedDate
                  SObject[] activityHistories = parentRecord.getSObjects('ActivityHistories');
                  if (activityHistories != null) {
                      for (SObject childRecord : activityHistories){
                          String key = '"' + childRecord.get('LastModifiedDate') + '"' +':';
                          
                          String actHistories = '{"Element":' + '"' + this.changeNulToNA(''+childRecord.get('ActivitySubtype')) + '"' + ',';
                          actHistories = actHistories+'"Id":' + '"' + this.changeNulToNA(''+childRecord.get('Id')) + '"' +',';
                          actHistories = actHistories+'"Status":' + '"' + this.changeNulToNA(''+childRecord.get('Status')) + '"' +',';
                          actHistories = actHistories+'"Description":' + '"' + this.changeNulToNA(''+childRecord.get('Description')) + '"' +',';
                          actHistories = actHistories+'"LastModifiedDate":' + '"' + this.changeNulToNA(''+childRecord.get('LastModifiedDate')) + '"' + ',';
                          actHistories = actHistories+'"CreatedDate":' + '"' + this.changeNulToNA(''+childRecord.get('CreatedDate')) + '"' + ',';
                          actHistories = actHistories+'"Priority":' + '"' + this.changeNulToNA(''+childRecord.get('Priority')) + '"' + ',';
                          actHistories = actHistories+'"Subject":' + '"' + this.changeNulToNA(''+childRecord.get('Subject')) + '"' + ',';
                          actHistories = actHistories+'"ActivityType":' + '"' + this.changeNulToNA(''+childRecord.get('ActivityType')) + '"' + ',';
                          actHistories = actHistories+'"ActivitySubtype":' + '"' + this.changeNulToNA(''+childRecord.get('ActivitySubtype')) + '"' + ',';
                          actHistories = actHistories+'"Closed":' + '"' + this.changeNulToNA(''+childRecord.get('IsClosed')) + '"' + ',';
                          actHistories = actHistories+'"ActivityDate":' + '"' + this.changeNulToNA(''+childRecord.get('ActivityDate')) + '"' + ',';
                          actHistories = actHistories+'"ParentElement":"ActivityHistories",' ;
                          
                          if (attachmentRecordPair.containsKey(''+childRecord.get('Id'))) {
                              actHistories = actHistories+'"AttachmentLink":' + (String)JSON.serialize(attachmentRecordPair.get(''+childRecord.get('Id'))) + ',';
                          } else {
                              actHistories = actHistories+'"AttachmentLink":"NA",';
                          }
                          
                          // getting the user details from user table using  OwnerId
                          String whoId = ''+ childRecord.get('WhoId');
                          Contact contactDetails = contactRecordsPair.get(whoId);
                          actHistories = actHistories+'"CustomerId":' + '"' + this.changeNulToNA(''+whoId) + '"' + ',';
                          actHistories = actHistories+'"CustomerName":' + '"' + this.changeNulToNA(''+contactDetails.name) + '"' + ',';
                          actHistories = actHistories+'"CustomerEmail":' + '"' + this.changeNulToNA(''+contactDetails.email) + '"' + ',';
                          actHistories = actHistories+'"CustomerMobilePhone":' + '"' + this.changeNulToNA(''+contactDetails.MobilePhone) + '"' + ',';
                          actHistories = actHistories+'"CustomerPhone":' + '"' + this.changeNulToNA(''+contactDetails.phone) + '"' + ',';
                          
                          String createdById = ''+ childRecord.get('CreatedById');
                          User createByDetails = userRecordsPair.get(createdById);
                          actHistories = actHistories+'"CreatedById":' + '"' + this.changeNulToNA(''+createdById) + '"' + ',';
                          actHistories = actHistories+'"CreatedByName":' + '"' + this.changeNulToNA(''+createByDetails.name) + '"' + ',';
                          actHistories = actHistories+'"CreatedByEmail":' + '"' + this.changeNulToNA(''+createByDetails.email) + '"' + ',';
                          actHistories = actHistories+'"CreatedByMobilePhone":' + '"' + this.changeNulToNA(''+createByDetails.MobilePhone) + '"' + ',';
                          actHistories = actHistories+'"CreatedByPhone":' + '"' + this.changeNulToNA(''+createByDetails.phone) + '"' + ',';
                          
                          String modifiedById = ''+ childRecord.get('LastModifiedById');
                          User modifiedByDetails = userRecordsPair.get(modifiedById);
                          actHistories = actHistories+'"ModifiedById":' + '"' + this.changeNulToNA(''+modifiedById) + '"' + ',';
                          actHistories = actHistories+'"ModifiedByName":' + '"' + this.changeNulToNA(''+modifiedByDetails.name) + '"' + ',';
                          actHistories = actHistories+'"ModifiedByEmail":' + '"' + this.changeNulToNA(''+modifiedByDetails.email) + '"' + ',';
                          actHistories = actHistories+'"ModifiedByMobilePhone":' + '"' + this.changeNulToNA(''+modifiedByDetails.MobilePhone) + '"' + ',';
                          actHistories = actHistories+'"ModifiedByPhone":' + '"' + this.changeNulToNA(''+modifiedByDetails.phone) + '"' + ',';
                          
                          // getting the user details from user table using  OwnerId
                          String ownerId = ''+ childRecord.get('OwnerId');
                          User userDetails = userRecordsPair.get(ownerId);
                          actHistories = actHistories+'"OwnerId":' + '"' + this.changeNulToNA(''+ownerId) + '"' + ',';
                          actHistories = actHistories+'"OwnerName":' + '"' + this.changeNulToNA(''+userDetails.name) + '"' + ',';
                          actHistories = actHistories+'"OwnerPhone":' + '"' + this.changeNulToNA(''+userDetails.phone) + '"' + ',';
                          actHistories = actHistories+'"OwnerMobilePhone":' + '"' + this.changeNulToNA(''+userDetails.MobilePhone) + '"' + ',';
                          actHistories = actHistories+'"OwnerEmail":' + '"' + this.changeNulToNA(''+userDetails.email) + '"';
                          
                          actHistories = actHistories+'},';
                          
                          result = result + key + actHistories;
                      }
                  } 
                  
                  //CaseId, SolutionId, CreatedDate, CreatedById, IsDeleted
                  SObject[] caseSolutions = parentRecord.getSObjects('CaseSolutions');
                  if (caseSolutions != null) {
                      for (SObject childRecord : caseSolutions){
                          String key = '"' + childRecord.get('CreatedDate') + '"' +':';
                          
                          String caseSol = '{"Element": "CaseSolutions",';
                          caseSol = caseSol+'"SolutionId":' + '"' + this.changeNulToNA(''+childRecord.get('SolutionId')) + '"' + ',';
                          caseSol = caseSol+'"Id":' + '"' + this.changeNulToNA(''+childRecord.get('Id')) + '"' + ',';
                          caseSol = caseSol+'"CaseId":' + '"' + '"' + this.changeNulToNA(''+childRecord.get('CaseId')) + '"' + ',';
                          caseSol = caseSol+'"CreatedDate":' +  '"' + this.changeNulToNA(''+childRecord.get('CreatedDate')) + '"' + ',';
                          caseSol = caseSol+'"Deleted":' +  '"' + this.changeNulToNA(''+childRecord.get('IsDeleted')) + '"' + ',';
                          
                          String createdById = ''+ childRecord.get('CreatedById');
                          User createByDetails = userRecordsPair.get(createdById);
                          caseSol = caseSol+'"CreatedById":' + '"' + this.changeNulToNA(''+childRecord.get('CreatedById')) + '"' + ',';
                          caseSol = caseSol+'"CreatedByName":' + '"' + this.changeNulToNA(''+createByDetails.name) + '"' + ',';
                          caseSol = caseSol+'"CreatedByEmail":' + '"' + this.changeNulToNA(''+createByDetails.email) + '"' + ',';
                          caseSol = caseSol+'"CreatedByMobilePhone":' + '"' + this.changeNulToNA(''+createByDetails.MobilePhone) + '"' + ',';
                          caseSol = caseSol+'"CreatedByPhone":' + '"' + this.changeNulToNA(''+createByDetails.phone) + '"';
                          
                          caseSol = caseSol+'},';
                          
                          result = result + key + caseSol;
                      }
                  }
                  
                  //Id, ParentId, CommentBody, LastModifiedDate, LastModifiedById, IsDeleted, IsPublished,CreatedById, CreatedDate, SystemModstamp
                  SObject[] caseComments = parentRecord.getSObjects('CaseComments');
                  if (caseComments != null) {
                      for (SObject childRecord : caseComments){
                          String key = '"' + childRecord.get('LastModifiedDate') + '"' +':';
                          
                          String caseComm = '{"Element": "CaseComments",';
                          caseComm = caseComm+'"ParentId":' + '"' + this.changeNulToNA(''+childRecord.get('ParentId')) + '"' + ',';
                          caseComm = caseComm+'"CommentBody":' + '"' + this.changeNulToNA(''+childRecord.get('CommentBody')) + '"' + ',';
                          caseComm = caseComm+'"LastModifiedDate":' + '"' + this.changeNulToNA(''+childRecord.get('LastModifiedDate')) + '"' + ',';
                          caseComm = caseComm+'"CreatedDate":' + '"' + this.changeNulToNA(''+childRecord.get('CreatedDate')) + '"' + ',';
                          caseComm = caseComm+'"Id":' + '"' + this.changeNulToNA(''+childRecord.get('Id')) + '"' + ',';
                          caseComm = caseComm+'"Deleted":' + '"' + this.changeNulToNA(''+childRecord.get('IsDeleted')) + '"' + ',';
                          caseComm = caseComm+'"Published":' + '"' + this.changeNulToNA(''+childRecord.get('IsPublished')) + '"' + ',';

                          String createdById = ''+ childRecord.get('CreatedById');
                          User createByDetails = userRecordsPair.get(createdById);
                          caseComm = caseComm+'"CreatedById":' + '"' + this.changeNulToNA(''+childRecord.get('CreatedById')) + '"' + ',';
                          caseComm = caseComm+'"CreatedByName":' + '"' + this.changeNulToNA(''+createByDetails.name) + '"' + ',';
                          caseComm = caseComm+'"CreatedByEmail":' + '"' + this.changeNulToNA(''+createByDetails.email) + '"' + ',';
                          caseComm = caseComm+'"CreatedByMobilePhone":' + '"' + this.changeNulToNA(''+createByDetails.MobilePhone) + '"' + ',';
                          caseComm = caseComm+'"CreatedByPhone":' + '"' + this.changeNulToNA(''+createByDetails.phone) + '"' + ',';
                          
                          String modifiedById = ''+ childRecord.get('LastModifiedById');
                          User modifiedByDetails = userRecordsPair.get(modifiedById);
                          caseComm = caseComm+'"ModifiedById":' + '"' + this.changeNulToNA(''+childRecord.get('LastModifiedById')) + '"' + ',';
                          caseComm = caseComm+'"ModifiedByName":' + '"' + this.changeNulToNA(''+modifiedByDetails.name) + '"' + ',';
                          caseComm = caseComm+'"ModifiedByEmail":' + '"' + this.changeNulToNA(''+modifiedByDetails.email) + '"' + ',';
                          caseComm = caseComm+'"ModifiedByMobilePhone":' + '"' + this.changeNulToNA(''+modifiedByDetails.MobilePhone) + '"' + ',';
                          caseComm = caseComm+'"ModifiedByPhone":' + '"' + this.changeNulToNA(''+modifiedByDetails.phone) + '"';                       
                          caseComm = caseComm+'},';
                          
                          result = result + key + caseComm;
                      }
                  }
                  
                  //Id, Name, LastModifiedDate, Description, OwnerId, IsDeleted, IsPrivate
                  SObject[] attachments = parentRecord.getSObjects('Attachments');
                  if (attachments != null) {
                      for (SObject childRecord : attachments){
                          String key = '"' + childRecord.get('LastModifiedDate') + '"' +':';
                          
                          String attach = '{"Element": "Attachments",';
                          attach = attach+'"Id":' + '"' + this.changeNulToNA(''+childRecord.get('Id')) + '"' +',';
                          attach = attach+'"Name":' + '"' + this.changeNulToNA(''+childRecord.get('Name')) + '"' +',';
                          attach = attach+'"AttachmentLink":' + '"' + 'https://'+BaseURL+'/servlet/servlet.FileDownload?file='+ childRecord.get('Id') + '"' + ',';
                          attach = attach+'"Description":' + '"' + this.changeNulToNA(''+childRecord.get('Description')) + '"' + ',';
                          attach = attach+'"LastModifiedDate":' + '"' + this.changeNulToNA(''+childRecord.get('LastModifiedDate')) + '"' + ',';
                          attach = attach+'"CreatedDate":' + '"' + this.changeNulToNA(''+childRecord.get('CreatedDate')) + '"' + ',';
                          attach = attach+'"Deleted":' + '"' + this.changeNulToNA(''+childRecord.get('IsDeleted')) + '"' + ',';
                          attach = attach+'"Private":' + '"' + this.changeNulToNA(''+childRecord.get('IsPrivate')) + '"' + ',';
                          
                          String createdById = ''+ childRecord.get('CreatedById');
                          User createByDetails = userRecordsPair.get(createdById);
                          attach = attach+'"CreatedById":' + '"' + this.changeNulToNA(''+childRecord.get('CreatedById')) + '"' + ',';
                          attach = attach+'"CreatedByName":' + '"' + this.changeNulToNA(''+createByDetails.name) + '"' + ',';
                          attach = attach+'"CreatedByEmail":' + '"' + this.changeNulToNA(''+createByDetails.email) + '"' + ',';
                          attach = attach+'"CreatedByMobilePhone":' + '"' + this.changeNulToNA(''+createByDetails.MobilePhone) + '"' + ',';
                          attach = attach+'"CreatedByPhone":' + '"' + this.changeNulToNA(''+createByDetails.phone) + '"' + ',';
                          
                          String modifiedById = ''+ childRecord.get('LastModifiedById');
                          User modifiedByDetails = userRecordsPair.get(modifiedById);
                          attach = attach+'"ModifiedById":' + '"' + this.changeNulToNA(''+childRecord.get('LastModifiedById')) + '"' + ',';
                          attach = attach+'"ModifiedByName":' + '"' + this.changeNulToNA(''+modifiedByDetails.name) + '"' + ',';
                          attach = attach+'"ModifiedByEmail":' + '"' + this.changeNulToNA(''+modifiedByDetails.email) + '"' + ',';
                          attach = attach+'"ModifiedByMobilePhone":' + '"' + this.changeNulToNA(''+modifiedByDetails.MobilePhone) + '"' + ',';
                          attach = attach+'"ModifiedByPhone":' + '"' + this.changeNulToNA(''+modifiedByDetails.phone) + '"';
                                                  
                          attach = attach+'},';
                          
                          result = result + key + attach;
                      }
                  }
              }
              result = result.substring(0,result.length()-2);
              result = result+'}}';
              result = result.replace('\n', '<br/>');
              result = result.replaceAll('\\p{Cc}', ' ');
              finalResult = result;
       }
 }