public without sharing class AccountCasesPdfCtrl {

    public List<Case> casesFinded {get; set;}

    public AccountCasesPdfCtrl(){
        getAccountCasesPrevWeek();
    }
    
    public void getAccountCasesPrevWeek() {
        casesFinded = [SELECT CaseNumber,Owner.Name, Priority, Origin, Status, Account.Name
                    FROM Case
                    WHERE CreatedDate  = LAST_WEEK
                    ORDER BY Account.Name];         
       
    }

}