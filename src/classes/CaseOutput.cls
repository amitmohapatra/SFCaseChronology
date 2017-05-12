/*
 * @Author : Amit Mohapatra
 * 
 * This class accumulate all case related json  or other format(not now)
 * to make one single result.
 */
public class CaseOutput implements Output {

	private String className = 'CaseOutput';
	private CaseChronologyQueryResultBuilder queryResult;

	public CaseOutput(CaseChronologyQueryResultBuilder res) {
		this.queryResult = res;
	}
    
    /*
     * manage to get all json from differnt source and bind  it to a single json.
     */

	public String getJson() {
		try {
			System.debug(className+' : getJson() : inside function');

			Map<String, String> result = new Map<String, String>();
     
			String caseHistoryJson = new CaseHistory(queryResult).getResultJson();
			result.put('caseHistory', caseHistoryJson);
			String caseProfileJson = new CaseProfile(queryResult).getResultJson();
			result.put('caseProfile', caseProfileJson);
			String caseresult = (String)Json.serialize(result);
			System.debug(className+' : getJson() : result -> '+ caseresult);
			return caseresult;
		} catch(Exception e) {
			throw e;
		}

	}

}