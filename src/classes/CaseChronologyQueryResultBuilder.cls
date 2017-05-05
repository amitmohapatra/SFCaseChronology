/*
 * @Author : Amit Mohapatra
 * 
 * This Builder class responsible for building result from query.
 * It helps to query table at onc and store the result into map or list for accsess.
 * So, avoid calling query in loops. Also the inner class has control 
 *                                 to make the sequence of query call.
 * 
 * sequence :
 *     1st step - get result of the master case query.
 *     2nd step - get the required ids from master queries to run child queries at once.
 *     3rd step - run child queries.
 *     prepareExecutionSequence() do the above steps.
 * 
 */

public class CaseChronologyQueryResultBuilder {

	private QueryExecutor queryResults;

	private CaseChronologyQueryResultBuilder(QueryExecutor res) {
		this.queryResults = res;
	}

	public SObject[] getCaseRecords() {
		return this.queryResults.getCaseRecords();
	}

	public Map<String, Map<String, Map<String, String>>> getAttachmentRecords() {
		return this.queryResults.getchildAttachmentRecords();
	}

	public Map<Id, Contact> getContactRecords() {
		return this.queryResults.getContactRecords();
	}

	public Map<Id, User> getUserRecords() {
		return this.queryResults.getuserRecords();
	}
    
    public Case getParentCaseRecord() {
        return this.queryResults.getParentCaseRecords();
    }

	/*
	 * Inner class for building query result.
	 */

	public class QueryExecutor {
		private String className = 'CaseChronologyQueryResultBuilder.QueryExecutor';
		private Case caseRecord;
		private SObject[] caseQueryResult;
		private Set<String> taskEventIds = new Set<String>();
		private Set<String> whoIds = new Set<String>();
		private Set<String> userIds = new Set<String>();
		private Map<String, Map<String, Map<String, String>>> attachmentRecordPair = new Map<String, Map<String, Map<String, String>>>();
		private Map<Id, Contact> contactRecordsPair = new Map<Id, Contact>();
		private Map<Id, User> userRecordsPair = new Map<Id, User>();
        private Case parentCaseRecords;

		public QueryExecutor(Case rec) {
			this.caseRecord = rec;
		}

		public SObject[] getCaseRecords() {
			return this.caseQueryResult;
		}

		public Map<String, Map<String, Map<String, String>>> getchildAttachmentRecords() {
			return this.attachmentRecordPair;
		}

		public Map<Id, Contact> getContactRecords() {
			return this.contactRecordsPair;
		}

		public Map<Id, User> getuserRecords() {
			return this.userRecordsPair;
		}
        
        public Case getParentCaseRecords() {
			return this.parentCaseRecords;
		}

		/*
		 * call the master query and get the result.
		 */
		private QueryExecutor queryMasterCase() {
			try {
				System.debug(this.className + ' : queryMasterCase() : inside the function');
				this.caseQueryResult = CaseChronologyQueryRecords.getCaseRecords(this.caseRecord.Id);

				if (this.caseQueryResult != null) {
					this.fetchRelatedIds();
				} else {
					System.debug(this.className + ' : queryMasterCase() : caseQueryResult is null');
				}
				return this;
			} catch(Exception e) {
				throw e;
			}
		}

		/*
		 * retriving ids from master query result for making child query call.
		 */
		private void fetchRelatedIds() {
			try {
				System.debug(this.className + ' : fetchRelatedIds() : inside the function');

				for (SObject parentRecord : this.caseQueryResult) {
					String parentContactId = ''+ parentRecord.get('ContactId');
					if (parentContactId != null) {
						whoIds.add(parentContactId);
					}

					String ParentCreatedById = ''+ parentRecord.get('CreatedById');
					if (ParentCreatedById != null) {
						userIds.add(ParentCreatedById);
					}

					String parentModifiedById = ''+ parentRecord.get('LastModifiedById');
					if (parentModifiedById != null) {
						userIds.add(parentModifiedById);
					}

					String parentOwnerId = ''+ parentRecord.get('OwnerId');
					if (parentOwnerId != null) {
						userIds.add(parentOwnerId);
					}

					SObject[] openActivities = parentRecord.getSObjects('OpenActivities');
					if (openActivities != null) {
						for (SObject childRecord : openActivities){
							String taskEventId = ''+childRecord.get('Id');
							if (taskEventId != null) {
								taskEventIds.add(taskEventId);
							}

							String whoId = ''+ childRecord.get('WhoId');
							if (whoId != null) {
								whoIds.add(whoId);
							}

							String createdById = ''+ childRecord.get('CreatedById');
							if (createdById != null) {
								userIds.add(createdById);
							}

							String modifiedById = ''+ childRecord.get('LastModifiedById');
							if (modifiedById != null) {
								userIds.add(modifiedById);
							}

							String ownerId = ''+ childRecord.get('OwnerId');
							if (ownerId != null) {
								userIds.add(ownerId);
							}
						}
					} else {
						System.debug(this.className + ' : fetchRelatedIds() : openActivities -> null');
					}

					SObject[] activityHistories = parentRecord.getSObjects('ActivityHistories');
					if (activityHistories != null) {
                        
						for (SObject childRecord : activityHistories){
                            
							if (childRecord.get('Id') != null) {
								taskEventIds.add(''+childRecord.get('Id'));
							}

							if (childRecord.get('WhoId') != null) {
								whoIds.add(''+childRecord.get('WhoId'));
							}

							if (childRecord.get('CreatedById') != null) {
								userIds.add(''+childRecord.get('CreatedById'));
							}

							if (childRecord.get('LastModifiedById') != null) {
								userIds.add(''+childRecord.get('LastModifiedById'));
							}

							if (childRecord.get('OwnerId') != null) {
								userIds.add(''+childRecord.get('OwnerId'));
							}
						}
					} else {
						System.debug(this.className + ' : fetchRelatedIds() : activityHistories -> null');
					}

					SObject[] histories = parentRecord.getSObjects('Histories');
					if (histories != null) {
						for (SObject childRecord : histories){
							if (childRecord.get('CreatedById') != null) {
								userIds.add(''+childRecord.get('CreatedById'));
							}
						}
					} else {
						System.debug(this.className + ' : fetchRelatedIds() : histories -> null');
					}

					SObject[] caseSolutions = parentRecord.getSObjects('CaseSolutions');
					if (caseSolutions != null) {
						for (SObject childRecord : caseSolutions){
							if (childRecord.get('CreatedById') != null) {
								userIds.add(''+childRecord.get('CreatedById'));
							}
						}
					} else {
						System.debug(this.className + ' : fetchRelatedIds() : caseSolutions -> null');
					}

					SObject[] caseComments = parentRecord.getSObjects('CaseComments');
					if (caseComments != null) {
						for (SObject childRecord : caseComments) {
							if (childRecord.get('CreatedById') != null) {
								userIds.add(''+childRecord.get('CreatedById'));
							}
							if (childRecord.get('LastModifiedById') != null) {
								userIds.add(''+childRecord.get('LastModifiedById'));
							}
						}
					} else {
						System.debug(this.className + ' : fetchRelatedIds() : caseComments -> null');
					}

					SObject[] attachments = parentRecord.getSObjects('Attachments');
					if (attachments != null) {
						for (SObject childRecord : attachments) {
							if (childRecord.get('CreatedById') != null) {
								userIds.add(''+childRecord.get('CreatedById'));
							}
                            
							if (childRecord.get('LastModifiedById') != null) {
								userIds.add(''+childRecord.get('LastModifiedById'));
							}
						}
					} else {
						System.debug(this.className + ' : fetchRelatedIds() : attachments -> null');
					}
				}
			} catch(Exception e) {
				throw e;
			}
		}

		/*
		 * getting the attachments using ids.
		 */
		private QueryExecutor prepareChildAttachmentResult() {
			try {
				System.debug(this.className + ' : prepareChildAttachmentResult() : inside function');
				List<Attachment> attachmentRecords = CaseChronologyQueryRecords.getAttachmentRecords(taskEventIds);

				if (attachmentRecords != null) {
					for (Attachment record : attachmentRecords) {
						String parId = ''+record.ParentId;

						if (attachmentRecordPair.containsKey(parId)) {
							Map<String, String> rec = new Map<String, String>();
							rec.put('Id', ''+record.Id);
                            String nme = ''+record.Name;
							rec.put('Name', nme.trim().replace('"', '\''));
							rec.put('LastModifiedDate', ''+record.LastModifiedDate);
                            String description = ''+record.Description;
							rec.put('Description', description.trim().replace('"', '\''));
							rec.put('Deleted', ''+record.IsDeleted);
							rec.put('Private', ''+record.IsPrivate);
							attachmentRecordPair.get(parId).put(''+record.Id, rec);
						} else {
							Map<String, String> rec = new Map<String, String>();
							rec.put('Id', ''+record.Id);
                            String nme = ''+record.Name;
							rec.put('Name', nme.trim().replace('"', '\''));
							rec.put('LastModifiedDate', ''+record.LastModifiedDate);
                            String description = ''+record.Description;
							rec.put('Description', description.trim().replace('"', '\''));
							rec.put('Deleted', ''+record.IsDeleted);
							rec.put('Private', ''+record.IsPrivate);
							Map<String, Map<String, String>> finalRec =  new Map<String, Map<String, String>>();
							finalRec.put(''+record.Id, rec);
							attachmentRecordPair.put(parId, finalRec);
						}
					}
				} else {
					System.debug(this.className + ' : prepareChildAttachmentResult() : attachmentRecords -> null');
					attachmentRecordPair = null;
				}
				return this;
			} catch(Exception e) {
				throw e;
			}
		}

		private QueryExecutor prepareContactRecords()  {
			try {
				System.debug(this.className + ' : prepareContactRecords() : inside function');

				List<Contact> contactRecords = null;

				if (whoIds != null && whoIds.size() > 0) {
					contactRecords = CaseChronologyQueryRecords.getContactRecords(whoIds);
				}

				if (contactRecords != null) {
					contactRecordsPair = new Map<Id, Contact>(contactRecords); 
				} else {
					System.debug(this.className + ' : prepareContactRecords() : contactRecordsPair -> null');
					contactRecordsPair = null;
				}
				return this;
			} catch(Exception e) {
				throw e;
			}
		}

		private QueryExecutor prepareUserRecords() {
			try {
				System.debug(this.className + ' : prepareUserRecords() : inside function');

				List<User> userRecords = null;
				if (userIds != null && userIds.size() > 0) {
					userRecords = CaseChronologyQueryRecords.getUserRecords(userIds);
				}

				if (userRecords != null) {
					userRecordsPair = new Map<Id, User>(userRecords);
				} else {
					System.debug(this.className + ' : prepareUserRecords() : userRecordsPair -> null');
					userRecordsPair = null;
				}
				return this;
			} catch(Exception e) {
				throw e;
			}
		}
        
        /*
		 * call the master query and get the result.
		 */
		private QueryExecutor queryParentCase() {
			try {
				System.debug(this.className + ' : queryParentCase() : inside the function');

				if (this.caseQueryResult != null) {
                    if (this.caseQueryResult[0].get('ParentId') != null) {
                        parentCaseRecords = CaseChronologyQueryRecords.getParentCaseRecord(''+this.caseQueryResult[0].get('ParentId'));
                    }
				} else {
					System.debug(this.className + ' : queryParentCase() : caseQueryResult.ParentId is null');
				}
				return this;
			} catch(Exception e) {
				throw e;
			}
		}

		private void prepareExecutionSequence() {
			try {
				System.debug(this.className + ' : prepareExecutionSequence() : inside function');
				this.queryMasterCase().prepareChildAttachmentResult().prepareContactRecords().prepareUserRecords().queryParentCase();
				System.debug(this.className + ' : prepareExecutionSequence() : completed');
			} catch(Exception e) {
				throw e;
			}
		}

		public CaseChronologyQueryResultBuilder build() {
            try {
			    System.debug(this.className + ' : build() : inside function');
			    this.prepareExecutionSequence();
                System.debug(this.className + ' : build() : completed');
			    return new CaseChronologyQueryResultBuilder(this);
            } catch(Exception e) {
				throw e;
			}
		}
	}

}