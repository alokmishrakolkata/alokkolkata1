@RestResource(urlMapping='/TestRest/*')
global  class MyRestSerice {

     
  @HttpGet
    global static void doPost() {
        /*RestRequest req = RestContext.request;
        RestResponse res= RestContext.response;
        
        Blob bPl = req.requestBody;
        String strMsg = String.valueOf(bPl);
        
        res.statusCode = 200;
        
        res.responseBody = bPl;*/
        
        RestContext.response.addHeader('Content-Type', 'text/plain');
        String name = RestContext.request.params.get('name');
        RestContext.response.responseBody = Blob.valueOf('Hello '+name);
    }
    
     @HttpPost
    global static void testPost() {
        RestRequest req = RestContext.request;
        RestResponse res= RestContext.response;
        
        Blob bPl = req.requestBody;
        String strMsg = req.requestBody.toString();
        System.debug('+++++ : ' + strMsg);
        res.addHeader('Content-Type', 'text/plain');

        res.statusCode = 200;
        
        res.responseBody = bPl;
        
    }

    /*
    String strURL = 'http://172.17.32.236:8080/soa-infra/services/default/projHelloOAGTest/samplebpel_client_ep';
//String strURL = 'https://mysandbox-free-12415f14c3a-124e539428a-128afd3c183.cs9.force.com/services/apexrest/TestRest?name=alok';
//String strURL = 'http://172.17.32.236:8080/soa-infra/services/default/projHelloOAGTest/samplebpel_client_ep';
Http h = new Http();
HttpRequest req = new HttpRequest();
req.setEndpoint(strURL);
req.setMethod('GET');
HttpResponse res = h.send(req);
System.debug( res.getBody());
    */
}