public class createDocController{

    User userObj = null;
    boolean updateUser = false;
    
    public boolean requestToken{get;set;}
    public createDocController(){
    System.debug('----Authentication start----');
        
    userObj = [select Id,GoogleAuthSessionToken__c from User where Id =:Userinfo.getUserId()];
    String token = ApexPages.currentPage().getParameters().get('sesstoken');
    system.debug('TOKEN NUM = ' + token);
    if(userObj.GoogleAuthSessionToken__c==null || userObj.GoogleAuthSessionToken__c==''){
         if(token!=null){
             userObj.GoogleAuthSessionToken__c = token;
             updateUser = true;
             System.debug('----Token Set to User----');
             //update userObj;
         }else{
             System.debug('----No Token ...Request Token----');
             requestToken = true;
         }
     }
    
        
     System.debug('----Authentication End----');
          }
          
          public void create(){  
     DocumentService service = new DocumentService();  
     service.setAuthSubToken(userObj.GoogleAuthSessionToken__c); 
     //DocumentEntry entry = new DocumentEntry();
     /* 
         DocumentEntry creates a googleDoc but I couldn't find the API for googleEntry. So I used Document class and then
         uploaded using DocumentService.
     */
     
     Document d = new Document();
     d.Name = 'myFile.txt';
     String myContent = 'abc';
     d.Body = Blob.valueOf(myContent);
     d.ContentType = 'text/plain';
     d.Type = 'txt';
     //insert d;
     GoogleData documents = service.getDocuments(); // list all documents
     //documents.dump();
//     GoogleData data = service.uploadDocument(myContent, d.Name, d.ContentType);
//     data.dump();
      //System.debug(data);
      }
}