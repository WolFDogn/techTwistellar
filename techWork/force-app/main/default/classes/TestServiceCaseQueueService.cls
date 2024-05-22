@isTest
public without sharing class TestServiceCaseQueueService {
    
    @isTest 
    public static void TestCaseRecord(){  
        Case cas = new Case(Status = 'New', Origin = 'Phone');    
        insert cas;
        Test.startTest();
        List<Case> testDataCases = ServiceCaseQueueService.getUserCases();
        system.assertEquals(cas.Status, testDataCases[0].Status);
        System.debug('expect'+cas.Status + 'actual' + testDataCases[0].Status);
        Test.stopTest();
    }
    @isTest 
    public static void TestCaseUpdate(){  
        Account acc = new Account(Name = 'Test');
        Contact con = new Contact(FirstName='test1',LastName='test2',Email='abc@xyz.com');
        insert acc;
        insert con;
        Case cas = new Case(Status = 'New', Origin = 'Phone', ContactId = con.Id, AccountId = acc.Id);    
        insert cas;
        Case findCase = [SELECT CaseNumber FROM Case];
        System.debug(findCase.CaseNumber);
        Test.startTest();
        ServiceCaseQueueService.updateCase(findCase.CaseNumber, 'Working');
        Test.stopTest();
    
    }
    @isTest 
    public static void TestCaseRecordNew(){  
        Case cas = new Case(Status = 'New', Origin = 'Phone');    
        insert cas;
        Test.startTest();
        List<Case> testDataCases = ServiceCaseQueueService.getUserCasesNew();
        system.assertEquals(cas.Status, testDataCases[0].Status);
        System.debug('expect'+cas.Status + 'actual' + testDataCases[0].Status);
        Test.stopTest();
    }
}