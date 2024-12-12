trigger OpportunityTrigger on Opportunity (before update,after update, before delete) {

  // Prevent recursive updates
  if (OpportunityTriggerHandler.isTriggerExecuted) {

      return;
  }
  OpportunityTriggerHandler.isTriggerExecuted = true;

  //Before update
  if (Trigger.isBefore && Trigger.isUpdate) {

    for (Opportunity opp : Trigger.new){

      if (opp.Amount <=5000) {
        opp.addError('Opportunity amount must be greater than 5000');
      }
    }

  }

  // Before Delete
  if (Trigger.isBefore && Trigger.isDelete){

    Set<Id> accountId = new Set<Id>();
    
    for(Opportunity opp : Trigger.old) {
      if (opp.StageName == 'Closed Won' &&
          opp.AccountId != null){

            accountId.add(opp.AccountId);
           }
    }
 
    //query the accounts with the matching Id from the set
    Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, Industry 
                                                      FROM Account WHERE Id IN :accountId ]);

    // iterate  through the opportunities to check the conditions before deleting
    for (Opportunity opp : Trigger.old) {
      if(opp.StageName == 'Closed Won') {
        Account relatedAccount = accountMap.get(opp.AccountId);
        if (relatedAccount !=null && relatedAccount.Industry == 'Banking'){
          // prevent deletion and add an error message 
          opp.addError('Cannot delete closed opportunity for a banking account that is won');
        }
      }
    }
  }

  //after update

  if(Trigger.isAfter && Trigger.isUpdate){

    // Create a set to store account IDs from updated opportunities
      Set<Id> accountIds = new Set<Id>();
  
      // Collect account IDs from updated opportunities
      for (Opportunity opp : Trigger.new) {
          if (opp.AccountId != null) {
              accountIds.add(opp.AccountId);
          }
      }
  
      // Query contacts with the title 'CEO' for the relevant accounts
      Map<Id, Id> ceoContactsMap = new Map<Id, Id>();
      if (!accountIds.isEmpty()) {
          for (Contact contact : [SELECT Id, AccountId FROM Contact WHERE Title = 'CEO' AND AccountId IN :accountIds]) {
              // Add the first contact with title 'CEO' per account to the map
              if (!ceoContactsMap.containsKey(contact.AccountId)) {
                  ceoContactsMap.put(contact.AccountId, contact.Id);
              }
          }
      }
  
      // Update the primary contact on opportunities
      List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
      for (Opportunity opp : Trigger.new) {
          if (opp.AccountId != null && ceoContactsMap.containsKey(opp.AccountId)) {
              Opportunity updatedOpportunity = new Opportunity(Id = opp.Id, Primary_Contact__c = ceoContactsMap.get(opp.AccountId));
              opportunitiesToUpdate.add(updatedOpportunity);
          }
      }
  
      // Perform the update on opportunities
      if (!opportunitiesToUpdate.isEmpty()) {
          update opportunitiesToUpdate;
      }
  }
     OpportunityTriggerHandler.isTriggerExecuted = false;
  

      }
    

  

