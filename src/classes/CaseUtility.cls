/*
 * @Author : Amit Mohapatra
 * 
 * stores abstarct method and utility methods.
 */

public abstract class CaseUtility {
    
    protected CaseChronologyQueryResultBuilder queryResult;
    
    public CaseUtility(CaseChronologyQueryResultBuilder res) {
        this.queryResult = res;
    }
    
    /*
     * utility methods to convert null to 'NA'
     * 
     * @Param : {String}
     * @Return : {String}
     */ 
    protected String changeNulToNA(String field) {
        if (field == 'null') {
               return 'NA';
        }
        return field.trim().replace('"', '\'');
    }
    
    protected String convertLocalTimeZone(String queryDateTime) {
        if (queryDateTime != 'NA') {
            Datetime queryDate = datetime.valueOf(queryDateTime);
            String localTimeZoneId = UserInfo.getTimeZone().getID();
            String localDateTime = queryDate.format('yyyy-MM-dd HH:mm:ss', localTimeZoneId);
            return localDateTime;
        } else {
            return 'NA';
        }
    }

    public abstract String getResultJson();    
}