public inherited sharing class ServiceCaseQueueService {   
  
    @AuraEnabled (cacheable=true)
    public static List<Case> getUserCases () {
        List <Case> findCases = new List <Case>();
        findCases = [SELECT AccountId, Priority, Owner.Name, CreatedDate, CaseNumber, Origin, Status, Owner.Id, currenUser__c
                    FROM Case WITH SECURITY_ENFORCED
                    ORDER BY currenUser__c, Priority ASC, CreatedDate DESC
                    LIMIT 25
                    ];
        System.debug(findCases);
        return findCases;
    }
    
    @AuraEnabled (cacheable=false)
    public static void updateCase (String caseNumber, String caseStatus) {
        System.debug(caseNumber);
        System.debug(caseStatus);
        Case findCase = [SELECT Id, AccountId, Priority, Owner.Name, CreatedDate, CaseNumber, Origin, Status 
                    FROM Case 
                    WHERE CaseNumber =: caseNumber LIMIT 1];
        findCase.Status = caseStatus;
        update findCase;
        System.debug('newCase'+findCase);        
    }

    @AuraEnabled (cacheable=false)
    public static List<Case> getUserCasesNew () {
        List <Case> findCases = new List <Case>();
        findCases = [SELECT AccountId, Priority, Owner.Name, CreatedDate, CaseNumber, Origin, Status, currenUser__c 
                    FROM Case WITH SECURITY_ENFORCED
                    ORDER BY currenUser__c, Priority ASC, CreatedDate DESC
                    LIMIT 25];
        System.debug(findCases);
        return findCases;
    }
}