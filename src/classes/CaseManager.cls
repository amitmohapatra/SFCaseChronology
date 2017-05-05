/*
 * @Author : Amit Mohapatra
 * 
 * Casemanager managse the method call and makes code clean. 
 */
public class CaseManager {
    
    private String className = 'CaseManager';
    
    public CaseManager(){}
    
    /*
     * @param : {Case}
     */
    public Output executeQuery(Case rec) {
        try {
            System.debug(className + ' : executeQuery() : inside the method');
            CaseChronologyQueryResultBuilder queryResult = new CaseChronologyQueryResultBuilder.QueryExecutor(rec).build();
            return new CaseOutput(queryResult);
        } catch(Exception e) {
			throw e;
	    }
    }
}