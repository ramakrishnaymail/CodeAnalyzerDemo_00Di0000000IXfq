public with sharing class BookCalendarController {
    
    //Added Comments for testing
    public String subject{get;set;}
    public String description{get;set;}
    public Datetime startDateTime{get;set;} 
    public Datetime endDateTime{get;set;} 
    public Integer duration{get;set;}
    
    User userObj = null;
    boolean updateUser = false;
    
    public boolean requestToken{get;set;}
    
    
    
    public BookCalendarController(){
        
        System.debug('----Inside Controller----');
        
        userObj = [select Id,GoogleAuthSessionToken__c from User where Id =:Userinfo.getUserId()];
        String token = ApexPages.currentPage().getParameters().get('sesstoken');
        
        if((userObj.GoogleAuthSessionToken__c==null || userObj.GoogleAuthSessionToken__c=='')){
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
    }
    
    public void blockCalendar(){
        
        
        CalendarService service = new CalendarService();  
        service.setAuthSubToken(userObj.GoogleAuthSessionToken__c); 
        list<GoogleData.Calendar> cals = null;
        If(!Test.isRunningTest()){
        GoogleData feed = service.getAllCalendarsFeed();
        cals = GoogleData.calendarFactory(feed.entries);
        }
        
        GoogleData.Calendar cal = null;
        
        if(cals!=null && !cals.isEmpty()){
            cal = cals.get(0);
        }
        
        event newEvent = new Event(
        subject = subject,
        description = description,
        ActivityDateTime = startDateTime,
        EndDateTime = endDateTime
        //DurationInMinutes = duration
        );
        //newEvent.EndDateTime
        
        
        xmldom.element entry = service.insertEvent( cal, newEvent );  
        entry.dumpAll(); 
        
        if(updateUser){
            Database.update(userObj);
            
            updateUser=false;
            System.debug('---User Updated---');
        }
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Updated Google Calendar.');
        ApexPages.addMessage(myMsg);
        System.debug('---Calendar Entry Made---');
    }
    
     
}