public with sharing class AccountHelper {

    // use method to set the Rating
    public static void setHotRating(Account acc) {
        if (!String.isBlank(acc.Phone) ||
            !String.isBlank(acc.Website) ||
            !String.isBlank(acc.Fax)) {
            acc.Rating = 'Hot';
        }
    }
    //use this method to validate shipping fields are not blank
    public static void validateShippingFields(Account acc) {

        if (String.isBlank(acc.ShippingStreet) ||
            String.isBlank(acc.ShippingCity) ||
            String.isBlank(acc.ShippingState) ||
            String.isBlank(acc.ShippingPostalCode) ||
            String.isBlank(acc.ShippingCountry)) {
            acc.addError('Please make sure there are no empty shipping fields');
    
    }
}

// method to copy shipping fields into billing fields
public static void copyShippingToBillingIfValid(Account acc) {
    if (!String.isBlank(acc.ShippingStreet) &&
        !String.isBlank(acc.ShippingCity) &&
        !String.isBlank(acc.ShippingState) &&
        !String.isBlank(acc.ShippingPostalCode) &&
        !String.isBlank(acc.ShippingCountry)) {
        acc.BillingStreet = acc.ShippingStreet;
        acc.BillingCity = acc.ShippingCity;
        acc.BillingState = acc.ShippingState;
        acc.BillingPostalCode = acc.ShippingPostalCode;
        acc.BillingCountry = acc.ShippingCountry;
    }

}
}