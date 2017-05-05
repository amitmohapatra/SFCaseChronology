/*
 * @Author : Amit Mohapatra
 * 
 * preparing json for case history table.
 */

public class CaseHistory extends CaseUtility {

	private String className = 'CaseHistory';

	public CaseHistory(CaseChronologyQueryResultBuilder res) {
		super(res);
	}

	/*
	 * preparing json for case history table.
	 * when case record is null return is null.
	 */
	public override String getResultJson() {

		try {
			System.debug(className + ' : (getResultJson) : Inside getResultJson()');
			SObject[] caseRecords = queryResult.getCaseRecords();

			if (caseRecords != null) {
				Map<String, Map<String, String>>  caseHistoryJson = new Map<String, Map<String, String>>();

				for (SObject parentRecord : caseRecords) {
					// Id, AccountId, Subject, ActivityDate, LastModifiedDate, Status, Description, 
					// LastModifiedById, CreatedById, Priority, ActivityType,  ActivitySubtype, OwnerId, WhoId, IsClosed, CreatedDate
					SObject[] openActivities = parentRecord.getSObjects('OpenActivities');

					if (openActivities != null) {
						for (SObject childRecord : openActivities){
							String datekey = this.changeNulToNA(''+childRecord.get('LastModifiedDate'));

							Map<String, String> openActivity = new Map<String, String>();

							openActivity.put('Element', this.changeNulToNA(''+childRecord.get('ActivitySubtype')));
							openActivity.put('LastModifiedDate', this.changeNulToNA(''+childRecord.get('LastModifiedDate')));
							openActivity.put('CreatedDate', this.changeNulToNA(''+childRecord.get('CreatedDate')));
							openActivity.put('Description', this.changeNulToNA(''+childRecord.get('Description')));
							openActivity.put('AccountId', this.changeNulToNA(''+childRecord.get('AccountId')));
							openActivity.put('Id', this.changeNulToNA(''+childRecord.get('Id')));
							openActivity.put('Status', this.changeNulToNA(''+childRecord.get('Status')));
							openActivity.put('Priority', this.changeNulToNA(''+childRecord.get('Priority')));
							openActivity.put('ActivityType', this.changeNulToNA(''+childRecord.get('ActivityType')));
							openActivity.put('ActivitySubtype', this.changeNulToNA(''+childRecord.get('ActivitySubtype')));
							openActivity.put('Subject', this.changeNulToNA(''+childRecord.get('Subject')));
							openActivity.put('Closed', this.changeNulToNA(''+childRecord.get('IsClosed')));
							openActivity.put('ActivityDate', this.changeNulToNA(''+childRecord.get('ActivityDate')));
							openActivity.put('ParentElement', 'OpenActivities');

							if (queryResult.getAttachmentRecords() != null) {
								if (queryResult.getAttachmentRecords().containsKey(''+childRecord.get('Id'))) {
									openActivity.put('AttachmentLink', (String)JSON.serialize(queryResult.getAttachmentRecords().get(''+childRecord.get('Id'))));
								} else {
									openActivity.put('AttachmentLink', 'NA');
								}
							}

							// getting the user details from user table using  OwnerId
							String whoId = ''+ childRecord.get('WhoId');
							if (queryResult.getContactRecords() != null) {
								if (queryResult.getContactRecords().containsKey(whoId)) {
									Contact contactDetails = queryResult.getContactRecords().get(whoId);
									openActivity.put('CustomerId', this.changeNulToNA(''+whoId));
									openActivity.put('CustomerName', this.changeNulToNA(''+contactDetails.name));
									openActivity.put('CustomerEmail', this.changeNulToNA(''+contactDetails.email));
									openActivity.put('CustomerMobilePhone', this.changeNulToNA(''+contactDetails.MobilePhone));
									openActivity.put('CustomerPhone', this.changeNulToNA(''+contactDetails.phone));
								}
							}

							String createdById = ''+ childRecord.get('CreatedById');
							if (queryResult.getUserRecords() != null) {
								if (queryResult.getUserRecords().containsKey(createdById)) {
									User createByDetails = queryResult.getUserRecords().get(createdById);
									openActivity.put('CreatedById', this.changeNulToNA(''+createdById));
									openActivity.put('CreatedByName', this.changeNulToNA(''+createByDetails.name));
									openActivity.put('CreatedByEmail', this.changeNulToNA(''+createByDetails.email));
									openActivity.put('CreatedByMobilePhone', this.changeNulToNA(''+createByDetails.MobilePhone));
									openActivity.put('CreatedByPhone', this.changeNulToNA(''+createByDetails.phone));
								}
							}


							String modifiedById = ''+ childRecord.get('LastModifiedById');
							if (queryResult.getUserRecords() != null) {
								if (queryResult.getUserRecords().containsKey(modifiedById)) {
									User modifiedByDetails = queryResult.getUserRecords().get(modifiedById);
									openActivity.put('ModifiedById', this.changeNulToNA(''+modifiedById));
									openActivity.put('ModifiedByName', this.changeNulToNA(''+modifiedByDetails.name));
									openActivity.put('ModifiedByEmail', this.changeNulToNA(''+modifiedByDetails.email));
									openActivity.put('ModifiedByMobilePhone', this.changeNulToNA(''+modifiedByDetails.MobilePhone));
									openActivity.put('ModifiedByPhone', this.changeNulToNA(''+modifiedByDetails.phone));
								}
							}

							// getting the user details from user table using  OwnerId
							String ownerId = ''+ childRecord.get('OwnerId');
							if (queryResult.getUserRecords() != null) {
								if (queryResult.getUserRecords().containsKey(ownerId)) {
									User userDetails = queryResult.getUserRecords().get(ownerId);
									openActivity.put('OwnerId', this.changeNulToNA(''+ownerId));
									openActivity.put('OwnerName', this.changeNulToNA(''+userDetails.name));
									openActivity.put('OwnerEmail', this.changeNulToNA(''+userDetails.email));
									openActivity.put('OwnerMobilePhone', this.changeNulToNA(''+userDetails.MobilePhone));
									openActivity.put('OwnerPhone', this.changeNulToNA(''+userDetails.phone));
								}
							}

							System.debug(className + ' : (getResultJson) : opencctivities -> '+ (String)Json.serialize(openActivity));
							caseHistoryJson.put(datekey, openActivity);
						}
					} else {
						System.debug(className + ' : (getResultJson) : openactivities -> null');
					}

					// CaseId, CreatedDate, OldValue, NewValue, CreatedById, IsDeleted
					SObject[] histories = parentRecord.getSObjects('Histories');
					if (histories != null) {
						for (SObject childRecord : histories){
							String dateKey = this.changeNulToNA(''+childRecord.get('CreatedDate'));
							Map<String, String> history = new Map<String, String>();

							history.put('Element', 'Histories');
							history.put('CaseId', this.changeNulToNA(''+childRecord.get('CaseId')));
							history.put('Id', this.changeNulToNA(''+childRecord.get('Id')));
							history.put('CreatedDate', this.changeNulToNA(''+childRecord.get('CreatedDate')));
							history.put('NewValue', this.changeNulToNA(''+childRecord.get('NewValue')));
							history.put('OldValue', this.changeNulToNA(''+childRecord.get('OldValue')));
							history.put('Deleted', this.changeNulToNA(''+childRecord.get('IsDeleted')));
							history.put('Field', this.changeNulToNA(''+childRecord.get('Field')));

							String createdById = ''+ childRecord.get('CreatedById');
							if (queryResult.getUserRecords() != null) {
								if (queryResult.getUserRecords().containsKey(createdById)) {
									User createByDetails = queryResult.getUserRecords().get(createdById);
									history.put('CreatedById', this.changeNulToNA(''+createdById));
									history.put('CreatedByName', this.changeNulToNA(''+createByDetails.name));
									history.put('CreatedByEmail', this.changeNulToNA(''+createByDetails.email));
									history.put('CreatedByMobilePhone', this.changeNulToNA(''+createByDetails.MobilePhone));
									history.put('CreatedByPhone', this.changeNulToNA(''+createByDetails.phone));
								}
							}

							System.debug(className + ' : (getResultJson) : histories -> '+ (String)Json.serialize(history));
							caseHistoryJson.put(datekey, history);
						}
					} else {
						System.debug(className + ' : (getResultJson) : histories -> null');
					} 


					//Id, AccountId, Subject, ActivityDate, LastModifiedDate, Status, Description, LastModifiedById, 
					//CreatedById, Priority, ActivityType,   ActivitySubtype, OwnerId, WhoId, IsClosed, CreatedDate
					SObject[] activityHistories = parentRecord.getSObjects('ActivityHistories');
					if (activityHistories != null) {
						for (SObject childRecord : activityHistories){
							String datekey = this.changeNulToNA(''+childRecord.get('LastModifiedDate'));
							Map<String, String> actHistory = new Map<String, String>();

							actHistory.put('Element', this.changeNulToNA(''+childRecord.get('ActivitySubtype')));
							actHistory.put('Id', this.changeNulToNA(''+childRecord.get('Id')));
							actHistory.put('Status', this.changeNulToNA(''+childRecord.get('Status')));
							actHistory.put('Description', this.changeNulToNA(''+childRecord.get('Description')));
							actHistory.put('LastModifiedDate', this.changeNulToNA(''+childRecord.get('LastModifiedDate')));
							actHistory.put('CreatedDate', this.changeNulToNA(''+childRecord.get('CreatedDate')));
							actHistory.put('Priority', this.changeNulToNA(''+childRecord.get('Priority')));
							actHistory.put('Subject', this.changeNulToNA(''+childRecord.get('Subject')));
							actHistory.put('ActivityType', this.changeNulToNA(''+childRecord.get('ActivityType')));
							actHistory.put('ActivitySubtype', this.changeNulToNA(''+childRecord.get('ActivitySubtype')));
							actHistory.put('Closed', this.changeNulToNA(''+childRecord.get('IsClosed')));
							actHistory.put('ActivityDate', this.changeNulToNA(''+childRecord.get('ActivityDate')));
							actHistory.put('ParentElement','ActivityHistories');

							if (queryResult.getAttachmentRecords() != null) {
								if (queryResult.getAttachmentRecords().containsKey(''+childRecord.get('Id'))) {
									actHistory.put('AttachmentLink', (String)JSON.serialize(queryResult.getAttachmentRecords().get(''+childRecord.get('Id'))));
								} else {
									actHistory.put('AttachmentLink', 'NA');
								}
							}

							// getting the user details from user table using  OwnerId
							String whoId = ''+ childRecord.get('WhoId');
							if (queryResult.getContactRecords() != null) {
								if (queryResult.getContactRecords().containsKey(whoId)) {
									Contact contactDetails = queryResult.getContactRecords().get(whoId);
									actHistory.put('CustomerId', this.changeNulToNA(''+whoId));
									actHistory.put('CustomerName', this.changeNulToNA(''+contactDetails.name));
									actHistory.put('CustomerEmail', this.changeNulToNA(''+contactDetails.email));
									actHistory.put('CustomerMobilePhone', this.changeNulToNA(''+contactDetails.MobilePhone));
									actHistory.put('CustomerPhone', this.changeNulToNA(''+contactDetails.phone));
								}
							}

							String createdById = ''+ childRecord.get('CreatedById');
							if (queryResult.getUserRecords() != null) {
								if (queryResult.getUserRecords().containsKey(createdById)) {
									User createByDetails = queryResult.getUserRecords().get(createdById);
									actHistory.put('CreatedById', this.changeNulToNA(''+createdById));
									actHistory.put('CreatedByName', this.changeNulToNA(''+createByDetails.name));
									actHistory.put('CreatedByEmail', this.changeNulToNA(''+createByDetails.email));
									actHistory.put('CreatedByMobilePhone', this.changeNulToNA(''+createByDetails.MobilePhone) );
									actHistory.put('CreatedByPhone', this.changeNulToNA(''+createByDetails.phone));
								}
							}

							String modifiedById = ''+ childRecord.get('LastModifiedById');
							if (queryResult.getUserRecords() != null) {
								if (queryResult.getUserRecords().containsKey(modifiedById)) {
									User modifiedByDetails = queryResult.getUserRecords().get(modifiedById);
									actHistory.put('ModifiedById', this.changeNulToNA(''+modifiedById));
									actHistory.put('ModifiedByName', this.changeNulToNA(''+modifiedByDetails.name));
									actHistory.put('ModifiedByEmail', this.changeNulToNA(''+modifiedByDetails.email));
									actHistory.put('ModifiedByMobilePhone', this.changeNulToNA(''+modifiedByDetails.MobilePhone));
									actHistory.put('ModifiedByPhone', this.changeNulToNA(''+modifiedByDetails.phone));
								}
							}

							// getting the user details from user table using  OwnerId
							String ownerId = ''+ childRecord.get('OwnerId');
							if (queryResult.getUserRecords() != null) {
								if (queryResult.getUserRecords().containsKey(ownerId)) {
									User userDetails = queryResult.getUserRecords().get(ownerId);
									actHistory.put('OwnerId', this.changeNulToNA(''+ownerId));
									actHistory.put('OwnerName', this.changeNulToNA(''+userDetails.name));
									actHistory.put('OwnerPhone', this.changeNulToNA(''+userDetails.phone));
									actHistory.put('OwnerMobilePhone', this.changeNulToNA(''+userDetails.MobilePhone));
									actHistory.put('OwnerEmail', this.changeNulToNA(''+userDetails.email));
								}
							}

							System.debug(className + ' : (getResultJson) : activityhistories -> '+ (String)Json.serialize(actHistory));
							caseHistoryJson.put(datekey, actHistory);
						}
					} else {
						System.debug(className + ' : (getResultJson) : histories -> null');
					} 

					//CaseId, SolutionId, CreatedDate, CreatedById, IsDeleted
					SObject[] caseSolutions = parentRecord.getSObjects('CaseSolutions');
					if (caseSolutions != null) {
						for (SObject childRecord : caseSolutions){
							String datekey = this.changeNulToNA(''+childRecord.get('CreatedDate'));
							Map<String, String> caseSol = new Map<String, String>();

							caseSol.put('Element', 'CaseSolutions'); 
							caseSol.put('SolutionId', this.changeNulToNA(''+childRecord.get('SolutionId')));
							caseSol.put('Id', this.changeNulToNA(''+childRecord.get('Id')));
							caseSol.put('CaseId', this.changeNulToNA(''+childRecord.get('CaseId'))); 
							caseSol.put('CreatedDate', this.changeNulToNA(''+childRecord.get('CreatedDate'))); 
							caseSol.put('Deleted', this.changeNulToNA(''+childRecord.get('IsDeleted'))); 

							String createdById = ''+ childRecord.get('CreatedById');
							if (queryResult.getUserRecords() != null) {
								if (queryResult.getUserRecords().containsKey(createdById)) {
									User createByDetails = queryResult.getUserRecords().get(createdById);
									caseSol.put('CreatedById', this.changeNulToNA(''+childRecord.get('CreatedById')));
									caseSol.put('CreatedByName', this.changeNulToNA(''+createByDetails.name));
									caseSol.put('CreatedByEmail', this.changeNulToNA(''+createByDetails.email));
									caseSol.put('CreatedByMobilePhone', this.changeNulToNA(''+createByDetails.MobilePhone));
									caseSol.put('CreatedByPhone', this.changeNulToNA(''+createByDetails.phone)); 
								}
							}

							System.debug(className + ' : (getResultJson) : casesolutions -> '+ (String)Json.serialize(caseSol));
							caseHistoryJson.put(datekey, caseSol);
						}
					} else {
						System.debug(className + ' : (getResultJson) : casesolutions -> null');
					} 

					//Id, ParentId, CommentBody, LastModifiedDate, LastModifiedById, IsDeleted, IsPublished,CreatedById, CreatedDate, SystemModstamp
					SObject[] caseComments = parentRecord.getSObjects('CaseComments');
					if (caseComments != null) {
						for (SObject childRecord : caseComments){
							String datekey = this.changeNulToNA(''+childRecord.get('LastModifiedDate'));
							Map<String, String> caseComm = new Map<String, String>();

							caseComm.put('Element', 'CaseComments');
							caseComm.put('ParentId', this.changeNulToNA(''+childRecord.get('ParentId')));
							caseComm.put('CommentBody', this.changeNulToNA(''+childRecord.get('CommentBody')));
							caseComm.put('LastModifiedDate', this.changeNulToNA(''+childRecord.get('LastModifiedDate')));
							caseComm.put('CreatedDate', this.changeNulToNA(''+childRecord.get('CreatedDate')));
							caseComm.put('Id', this.changeNulToNA(''+childRecord.get('Id')));
							caseComm.put('Deleted', this.changeNulToNA(''+childRecord.get('IsDeleted')));
							caseComm.put('Published', this.changeNulToNA(''+childRecord.get('IsPublished')));

							String createdById = ''+ childRecord.get('CreatedById');
							if (queryResult.getUserRecords() != null) {
								if (queryResult.getUserRecords().containsKey(createdById)) {
									User createByDetails = queryResult.getUserRecords().get(createdById);
									caseComm.put('CreatedById', this.changeNulToNA(''+childRecord.get('CreatedById')));
									caseComm.put('CreatedByName', this.changeNulToNA(''+createByDetails.name));
									caseComm.put('CreatedByEmail', this.changeNulToNA(''+createByDetails.email));
									caseComm.put('CreatedByMobilePhone', this.changeNulToNA(''+createByDetails.MobilePhone));
									caseComm.put('CreatedByPhone', this.changeNulToNA(''+createByDetails.phone));
								}
							}

							String modifiedById = ''+ childRecord.get('LastModifiedById');
							if (queryResult.getUserRecords() != null) {
								if (queryResult.getUserRecords().containsKey(modifiedById)) {
									User modifiedByDetails = queryResult.getUserRecords().get(modifiedById);
									caseComm.put('ModifiedById', this.changeNulToNA(''+childRecord.get('LastModifiedById')));
									caseComm.put('ModifiedByName', this.changeNulToNA(''+modifiedByDetails.name));
									caseComm.put('ModifiedByEmail', this.changeNulToNA(''+modifiedByDetails.email));
									caseComm.put('ModifiedByMobilePhone', this.changeNulToNA(''+modifiedByDetails.MobilePhone));
									caseComm.put('ModifiedByPhone', this.changeNulToNA(''+modifiedByDetails.phone));
								}
							}

							System.debug(className + ' : (getResultJson) : casecomments -> '+ (String)Json.serialize(caseComm));
							caseHistoryJson.put(datekey, caseComm);
						}
					} else {
						System.debug(className + ' : (getResultJson) : casecomments -> null');
					} 

					//Id, Name, LastModifiedDate, Description, OwnerId, IsDeleted, IsPrivate
					SObject[] attachments = parentRecord.getSObjects('Attachments');
					if (attachments != null) {
						for (SObject childRecord : attachments){
							String datekey = this.changeNulToNA(''+childRecord.get('LastModifiedDate'));
							Map<String, String> attach = new Map<String, String>();

							attach.put('Element', 'Attachments');
							attach.put('Id', this.changeNulToNA(''+childRecord.get('Id')));
							attach.put('Name', this.changeNulToNA(''+childRecord.get('Name')));
							attach.put('AttachmentLink', this.changeNulToNA(''+childRecord.get('Id')));
							attach.put('Description', this.changeNulToNA(''+childRecord.get('Description')));
							attach.put('LastModifiedDate', this.changeNulToNA(''+childRecord.get('LastModifiedDate')));
							attach.put('CreatedDate', this.changeNulToNA(''+childRecord.get('CreatedDate')));
							attach.put('Deleted', this.changeNulToNA(''+childRecord.get('IsDeleted')));
							attach.put('Private', this.changeNulToNA(''+childRecord.get('IsPrivate')));

							String createdById = ''+ childRecord.get('CreatedById');
							if (queryResult.getUserRecords() != null) {
								if (queryResult.getUserRecords().containsKey(createdById)) {
									User createByDetails = queryResult.getUserRecords().get(createdById);
									attach.put('CreatedById', this.changeNulToNA(''+childRecord.get('CreatedById')));
									attach.put('CreatedByName', this.changeNulToNA(''+createByDetails.name));
									attach.put('CreatedByEmail', this.changeNulToNA(''+createByDetails.email));
									attach.put('CreatedByMobilePhone', this.changeNulToNA(''+createByDetails.MobilePhone));
									attach.put('CreatedByPhone', this.changeNulToNA(''+createByDetails.phone));
								}
							}

							String modifiedById = ''+ childRecord.get('LastModifiedById');
							if (queryResult.getUserRecords() != null) {
								if (queryResult.getUserRecords().containsKey(modifiedById)) {
									User modifiedByDetails = queryResult.getUserRecords().get(modifiedById);
									attach.put('ModifiedById', this.changeNulToNA(''+childRecord.get('LastModifiedById')));
									attach.put('ModifiedByName', this.changeNulToNA(''+modifiedByDetails.name));
									attach.put('ModifiedByEmail', this.changeNulToNA(''+modifiedByDetails.email));
									attach.put('ModifiedByMobilePhone', this.changeNulToNA(''+modifiedByDetails.MobilePhone));
									attach.put('ModifiedByPhone', this.changeNulToNA(''+modifiedByDetails.phone));
								}
							}

							System.debug(className + ' : (getResultJson) : casecomments -> null');
							caseHistoryJson.put(datekey, attach);
						}
					} else {
						System.debug(className + ' : (getResultJson) : casecomments -> null');
					}
				}

				String finalResult = (String)JSON.serialize(caseHistoryJson);
				System.debug(className + ' : (getResultJson) : finalresult -> '+ finalResult);
				return finalResult;
			} else {
				System.debug(className + ' : (getResultJson) : caseRecord -> null');
				return null;
			}
		} catch(Exception e) {
			throw e;
		}
	}

}