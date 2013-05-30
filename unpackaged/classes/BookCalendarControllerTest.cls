public  class BookCalendarControllerTest {
	
	public static testmethod void t1(){
		PageReference pageRef = Page.bookCalendarSlot;
        Test.setCurrentPage(pageRef);
  		Profile profile = [select id from profile where name='System Administrator'];
        UserRole testRole=new UserRole(name='Test');
        insert testRole;
        User testUser = new User(alias = 'standt', email='standarduser@testorg.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = profile.Id, 
            timezonesidkey='America/Los_Angeles', username='testKam@testorg.com',UserRoleId=testRole.Id);
  		
        ApexPages.currentPage().getParameters().put('sesstoken', 'CJ3pqczuBBCpgI2pBw');
        System.runAs(testUser){
        	Test.startTest();
			BookCalendarController cntrl = new BookCalendarController();
			cntrl.blockCalendar();
			Test.stopTest();
        }
	}

}