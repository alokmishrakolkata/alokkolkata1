@RestResource(urlMapping='/MyTest/*')
global class TestService{

    @HttpPost
    global static void doPost(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Blob bPl = req.requestBody;
        System.debug('+++++ : request body is : ' + String.valueOf(bPl));
        
        res.responseBody = bPl;
        res.statusCode = 200;
        
    }
}