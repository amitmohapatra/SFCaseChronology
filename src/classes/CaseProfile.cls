/*
 * @Author : Amit Mohapatra
 * 
 * preparing json for case profile table.
 */
public class CaseProfile extends CaseUtility {

	private String className = 'CaseProfile';

	public CaseProfile(CaseChronologyQueryResultBuilder res) {
		super(res);
	}

	/*
	 * preparing json for case profile table.
	 * when case record is null return is null.
	 */
	public override String getResultJson() {
		try {
			System.debug(className + ' : (getResultJson) : Inside getResultJson()');
			SObject[] caseRecords = queryResult.getCaseRecords();

			if (caseRecords != null) {
				Map<String, Map<String, String>>  caseProfileJson = new Map<String, Map<String, String>>();

				for (SObject parentRecord : caseRecords) {
					String idKey = this.changeNulToNA(''+parentRecord.get('Id'));
					Map<String, String> profileElements = new Map<String, String>();

					profileElements.put('Element', 'Case');
					profileElements.put('CaseNumber', this.changeNulToNA(''+parentRecord.get('CaseNumber')));
					profileElements.put('Subject', this.changeNulToNA(''+parentRecord.get('Subject')));
					profileElements.put('Description', this.changeNulToNA(''+parentRecord.get('Description')));
					profileElements.put('AccountId', this.changeNulToNA(''+parentRecord.get('AccountId')));
					profileElements.put('AccountName', this.changeNulToNA(''+parentRecord.getSObject('Account').get('Name')));
					profileElements.put('Type', this.changeNulToNA(''+parentRecord.get('Type')));
					profileElements.put('Product', this.changeNulToNA(''+parentRecord.get('Product__c')));
					profileElements.put('Reason', this.changeNulToNA(''+parentRecord.get('Reason')));
					profileElements.put('Origin', this.changeNulToNA(''+parentRecord.get('Origin')));
					profileElements.put('Priority', this.changeNulToNA(''+parentRecord.get('Priority')));
					profileElements.put('Status', this.changeNulToNA(''+parentRecord.get('Status')));
					profileElements.put('Closed', this.changeNulToNA(''+parentRecord.get('IsClosed')));
					profileElements.put('Deleted', this.changeNulToNA(''+parentRecord.get('IsDeleted')));
					profileElements.put('Escalated', this.changeNulToNA(''+parentRecord.get('IsEscalated')));
					profileElements.put('PotentialLiability', this.changeNulToNA(''+parentRecord.get('PotentialLiability__c')));
					profileElements.put('EngineeringReqNumber', this.changeNulToNA(''+parentRecord.get('EngineeringReqNumber__c')));
					profileElements.put('SLAViolation', this.changeNulToNA(''+parentRecord.get('SLAViolation__c')));
					//profileElements.put('LastViewedDate', this.changeNulToNA(''+parentRecord.get('LastViewedDate')));
					profileElements.put('ClosedDate', this.changeNulToNA(''+parentRecord.get('ClosedDate')));
                    profileElements.put('CreatedDate', this.changeNulToNA(''+parentRecord.get('CreatedDate')));
                    profileElements.put('LastModifiedDate', this.changeNulToNA(''+parentRecord.get('LastModifiedDate')));
                    
                    if (queryResult.getParentCaseRecord() != null) {
                        profileElements.put('ParentCaseNumber', this.changeNulToNA(''+queryResult.getParentCaseRecord().ParentId));
                    } else {
                        profileElements.put('ParentCaseNumber', 'NA');
                    }
                    
                    SObject[] caseComments = parentRecord.getSObjects('CaseComments');
					if (caseComments != null) {
						for (SObject childRecord : caseComments){
							profileElements.put('CaseCommentsLastModifiedDate', this.changeNulToNA(''+childRecord.get('LastModifiedDate')));
							profileElements.put('CaseCommentsCreatedDate', this.changeNulToNA(''+childRecord.get('CreatedDate')));
                        }
                    } else {
                        profileElements.put('CaseCommentsLastModifiedDate', 'NA');
					    profileElements.put('CaseCommentsCreatedDate', 'NA');
                    }

					String contactId = ''+ parentRecord.get('ContactId');
					if (queryResult.getContactRecords() != null) {
						if (queryResult.getContactRecords().containsKey(contactId)) {
							Contact contactDetails = queryResult.getContactRecords().get(contactId);
							profileElements.put('ContactId', this.changeNulToNA(''+contactId));
							profileElements.put('ContactName', this.changeNulToNA(''+contactDetails.name));
							profileElements.put('ContactEmail', this.changeNulToNA(''+contactDetails.email));
							profileElements.put('ContactMobilePhone', this.changeNulToNA(''+contactDetails.MobilePhone));
							profileElements.put('ContactPhone', this.changeNulToNA(''+contactDetails.phone));
                            profileElements.put('BillingCountry', this.changeNulToNA(''+contactDetails.MailingCountry));
						}
					}

					String createdById = ''+ parentRecord.get('CreatedById');
					if (queryResult.getUserRecords() != null) {
						if (queryResult.getUserRecords().containsKey(createdById)) {
							User createByDetails = queryResult.getUserRecords().get(createdById);
							profileElements.put('CreatedById', this.changeNulToNA(''+createdById));
							profileElements.put('CreatedByName', this.changeNulToNA(''+createByDetails.name));
							profileElements.put('CreatedByEmail', this.changeNulToNA(''+createByDetails.email));
							profileElements.put('CreatedByMobilePhone', this.changeNulToNA(''+createByDetails.MobilePhone));
							profileElements.put('CreatedByPhone', this.changeNulToNA(''+createByDetails.phone));
						}
					}

					String modifiedById = ''+ parentRecord.get('LastModifiedById');
					if (queryResult.getUserRecords() != null) {
						if (queryResult.getUserRecords().containsKey(modifiedById)) {
							User modifiedByDetails = queryResult.getUserRecords().get(modifiedById);
							profileElements.put('ModifiedById', this.changeNulToNA(''+modifiedById));
							profileElements.put('ModifiedByName', this.changeNulToNA(''+modifiedByDetails.name));
							profileElements.put('ModifiedByEmail', this.changeNulToNA(''+modifiedByDetails.email));
							profileElements.put('ModifiedByMobilePhone', this.changeNulToNA(''+modifiedByDetails.MobilePhone));
							profileElements.put('ModifiedByPhone', this.changeNulToNA(''+modifiedByDetails.phone));
						}
					}

					String ownerId = ''+ parentRecord.get('OwnerId');
					if (queryResult.getUserRecords() != null) {
						if (queryResult.getUserRecords().containsKey(ownerId)) {
							User userDetails = queryResult.getUserRecords().get(ownerId);
							profileElements.put('OwnerId', this.changeNulToNA(''+ownerId));
							profileElements.put('OwnerName', this.changeNulToNA(''+userDetails.name));
							profileElements.put('OwnerEmail', this.changeNulToNA(''+userDetails.email));
							profileElements.put('OwnerMobilePhone', this.changeNulToNA(''+userDetails.MobilePhone));
							profileElements.put('OwnerPhone', this.changeNulToNA(''+userDetails.phone));
                            profileElements.put('OwnerRole', this.changeNulToNA(''+userDetails.UserRole.Name));
						}
					}

					System.debug(className + ' : (getResultJson) : caseFields ('+this.changeNulToNA(''+parentRecord.get('CaseNumber'))+ ') -> '+ (String)Json.serialize(profileElements));
					caseProfileJson.put(idKey, profileElements);
				}

				String finalResult = (String)JSON.serialize(caseProfileJson);
				System.debug(className + ' : (getResultJson) : finalResult -> '+finalResult);
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