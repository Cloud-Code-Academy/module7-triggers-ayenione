trigger AccountTrigger on Account (before insert, after insert) {

  if (Trigger.isBefore && Trigger.isInsert) {
    System.debug('### Before Insert Trigger Invoked');
     for (Account acc : Trigger.new) {
      if (String.isBlank(acc.Type)) {
      acc.Type = 'Prospect';
      System.debug('### Set Type to Prospect for Account: ' + acc.Name);

      } 
    }

  if (Trigger.isBefore && Trigger.isAfter){
       // Validate and copy shipping fields using helper methods
    for (Account acc : Trigger.new) {
       AccountHelper.validateShippingFields(acc);

       AccountHelper.copyShippingToBillingIfValid(acc);
    }
  } 

     }
  if (Trigger.isBefore)   {
        for (Account acc : Trigger.new){
          AccountHelper.setHotRating(acc);
         }
        }
  
  if(Trigger.isAfter && Trigger.isInsert) {
    System.debug('### After Insert Trigger Invoked');
  
    List<Contact> contactsToInsert = new List<Contact>();

    for (Account acc : Trigger.new) {
      System.debug('### Processing Account: ' + acc.Id);

      Contact con = new Contact();
      con.AccountId = acc.Id;
      con.LastName = 'DefaultContact';
      con.Email = 'default@email.com';
      contactsToInsert.add(con);

    }
    System.debug('### Total Contacts to Insert: ' + contactsToInsert.size());


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
  
