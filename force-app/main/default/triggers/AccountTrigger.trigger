trigger AccountTrigger on Account (before insert, after insert) {

  if (Trigger.isBefore && Trigger.isInsert) {
      for (Account acc : Trigger.new) {
          // Set AccountType to Hot
            AccountHelper.setRatingAndType(acc);
        // Validate and copy shipping fields using helper methods
            AccountHelper.validateShippingFields(acc);
            AccountHelper.copyShippingToBillingIfValid(acc);
    }
  } 

  if (Trigger.isAfter && Trigger.isInsert) {
    List<Contact> contactsToInsert = new List<Contact>();

    for (Account acc : Trigger.new) {
      Contact con = new Contact();
      con.AccountId = acc.Id;
      con.LastName = 'DefaultContact';
      con.Email = 'default@email.com';
      contactsToInsert.add(con);

    }
    if(!contactsToInsert.isEmpty()){

      try {
      
        insert contactsToInsert;
        System.debug('Successfully inserted Contacts.');
      } catch (Exception e ) {
        System.debug('Error during Contact insertion: ' + e.getMessage());
      }
    }
  }
}
  
