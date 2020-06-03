public class leadUploadCtrl {
    
    @AuraEnabled
    public static List<String> createJob() {
        
        List<String> myList = new List<String>();
        
        Job__c job = new Job__c(Name='Valvoline Demo',Status__c='Uploaded',Account__c='0015w00002BYgWTAA1',Date_Uploaded__c=Date.today());
        insert job;
        
        Id recID = job.Id;
        Job__c recJob = [SELECT id, JobID__c, id_reference__c FROM Job__c WHERE id = :recId];
        
        recJob.JobID__c = recJob.id_reference__c;
        update recJob;
        
        myList.add(recID);
        myList.add(recJob.JobID__c);
        system.debug('ID LIST: ' + myList);
        return myList;
    }
    
	@AuraEnabled
    public static String POST(Blob file, String jobID) {
        
        Http h = new Http();
        String fileName = 'leads.csv';
        String url = 'https://ck-vioc-demo.herokuapp.com/leads/' + jobID;
        String separationString = 'KPK2s6MHMyKWgl2K4xLOe76yaihfOnYQ';
		String str = file.toString();
        // decode 
		Blob decodedBlob = EncodingUtil.base64Decode(str);
		// convert to string
		String result = decodedBlob.toString();
        
        // assemble the body payload
		String header = '--' + separationString + '\nContent-Disposition: form-data; name="file"; filename="' + fileName + '"\nContent-Type: application/octet-stream\n\n';
		//String body = EncodingUtil.base64Encode(file) + '\n';
		String body = result + '\n';
		String footer = '--' + separationString + '--';
		String bodyPayload = header + body + footer;
        system.debug('PAYLOAD: ' + bodyPayload);

        HttpRequest req = new HttpRequest();
        req.setHeader('Content-Type', 'multipart/form-data; boundary=' + separationString);
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setBody(bodyPayload);
        system.debug('REQUEST: ' + req);

        // Send the request, and return a response
        HttpResponse res = h.send(req);
        System.debug(res.getBody());
        return res.getBody();
    }
}