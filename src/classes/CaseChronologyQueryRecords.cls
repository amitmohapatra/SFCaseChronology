/*
 * @Authot : Amit Mohapatra
 * 
 * This class is responsible for maintaing queries.
 * methods returns query result from db.
 */
public class CaseChronologyQueryRecords {

	Private static String className = 'CaseChronologyQueryRecords';

	private CaseChronologyQueryRecords(){}

	/**
	 * Predefined query accepting a valid case Id to return all the records
	 * related to the corresponding case as SObject.
	 *
	 * @param  caseId {String}.
	 * @return Case related records as SObject. if {@param null} then return null.
	 */
	public static SObject[] getCaseRecords(String caseId) {

		try {
			SObject[] caseRecords = null;
			System.debug(className + ' : (getCaseRecords) -> ' + 'case Id is : '+caseId);

			if (caseId != null) {
				caseRecords = [Select Id, ParentId, CaseNumber, Subject, Description, AccountId, Account.Name, 
				               Type, Product__c, Reason, PotentialLiability__c, Origin, OwnerId, ContactId,
				               CreatedById, LastModifiedById, Priority, Status,  IsClosed, IsDeleted, IsEscalated,
				               SLAViolation__c, LastModifiedDate, CreatedDate, ClosedDate, EngineeringReqNumber__c,
				               (Select Id, AccountId, Subject, ActivityDate, LastModifiedDate, Status, Description, LastModifiedById, 
				            		   CreatedById, Priority, ActivityType, ActivitySubtype, OwnerId, WhoId, IsClosed, CreatedDate 
				            		   From OpenActivities order by LastModifiedDate desc), 
				               (Select Id, CaseId, CreatedDate, OldValue, NewValue, CreatedById, IsDeleted, Field  
				            		   From Histories order by CreatedDate desc),
				               (Select Id, AccountId, Subject, ActivityDate, LastModifiedDate, Status, Description, LastModifiedById, 
				            		   CreatedById, Priority, ActivityType, ActivitySubtype, OwnerId, WhoId, IsClosed, CreatedDate 
				            		   from ActivityHistories order by LastModifiedDate desc),
				               (Select Id, CaseId, SolutionId, CreatedDate, CreatedById, IsDeleted 
				            		   From CaseSolutions order by CreatedDate desc ),
				               (Select Id, ParentId, CommentBody, LastModifiedDate, LastModifiedById, IsDeleted, IsPublished,CreatedById, 
				            		   CreatedDate, SystemModstamp From CaseComments order by LastModifiedDate desc), 
				               (Select Id, Name, LastModifiedDate, CreatedDate, LastModifiedById, CreatedById, Description, 
				            		   OwnerId, IsDeleted, IsPrivate From Attachments order by LastModifiedDate desc)
				               From Case where Id= :caseId order by LastModifiedDate desc];

			}
			return caseRecords;
		} catch(Exception e) {
			throw e;
		}

	}

	/**
	 * Predefined query accepting valid ids (Task or Event of case) to return all the attachment records
	 * related to the corresponding ids as list if records.
	 *
	 * @param  Ids {Set}.
	 * @return Attachment related records as SObject. if {@param nullor empy set} then return null.
	 */
	public static List<Attachment> getAttachmentRecords(Set<String> Ids) {

		try {
			List<Attachment> attachmentRecords = null;
			System.debug(className + ' : (getAttachmentRecords) -> ' + 'Ids are : '+Ids);

			if (Ids != null && Ids.size() > 0) {
				attachmentRecords = [Select Id, ParentId, Name, LastModifiedDate, Description, IsDeleted, IsPrivate 
				                     From Attachment where ParentId=:Ids order by LastModifiedDate desc];
			}
			System.debug(className + ' : (getAttachmentRecords) : finished');
			return attachmentRecords;
		} catch(Exception e) {
			throw e;
		}
	}
    
    /**
	 * Predefined query accepting a valid case Id to return all the records
	 * related to the corresponding case as SObject.
	 *
	 * @param  ParentCaseId {String}.
	 * @return Case related records as SObject. if {@param null} then return null.
	 */
	public static Case getParentCaseRecord(String ParentCaseId) {

		try {
			Case parentCaseRecords = null;
			System.debug(className + ' : (getParentCaseRecord) -> ' + 'Parent Id is : '+ParentCaseId);

			if (ParentCaseId != null) {
				parentCaseRecords = [Select Id, CaseNumber From Case where Id= :ParentCaseId order by LastModifiedDate desc];
			}
			System.debug(className + ' : (getParentCaseRecord) : finished');
			return parentCaseRecords;
		} catch(Exception e) {
			throw e;
		}
	}

	/**
	 * Predefined query accepting valid ids (Task or Event of case) to return all the attachment records
	 * related to the corresponding ids as list if records.
	 *
	 * @param  Ids {Set}.
	 * @return Attachment related records as SObject. if {@param null or empty set} then return null.
	 */
	public static List<Contact> getContactRecords(Set<String> Ids) {

		try {
			List<Contact> contactRecords = null;
			System.debug(className + ' : (getContactRecords) -> ' + 'Ids are : '+Ids);

			if ((Ids != null) && (Ids.size() > 0)) {
				contactRecords = [Select Id, name, email, phone, MobilePhone, MailingCountry  from Contact where Id=:Ids];
			}
			return contactRecords;
		} catch(Exception e) {
			throw e;
		}
	}

	/**
	 * Predefined query accepting valid ids (Task or Event of case) to return all the attachment records
	 * related to the corresponding ids as list if records.
	 *
	 * @param  Ids {Set}.
	 * @return Attachment related records as SObject. if {@param null or empty set} then return null.
	 */
	public static List<User> getUserRecords(Set<String> Ids) {

		try {
			List<User> userRecords = null;
			System.debug(className + ' : (getUserRecords) -> ' + 'Ids are : '+Ids);

			if ((Ids != null) && (Ids.size() > 0)) {
				userRecords = [Select Id, name, email, phone, MobilePhone, User.UserRole.Name, User.UserRole.Id from User where Id=:Ids];
			}
			return userRecords;
		} catch(Exception e) {
			throw e;
		}
	}

}