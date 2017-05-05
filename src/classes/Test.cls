public class Test {
    public String response {get; set;}
    public Test() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://52.36.58.80/sf-chronology-ui/api/data?caseID=sahioohog');
        req.setMethod('GET');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        response = res.getBody();
    }
}