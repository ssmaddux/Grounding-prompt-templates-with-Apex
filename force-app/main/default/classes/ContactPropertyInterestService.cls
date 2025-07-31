public with sharing class ContactPropertyInterestService {
    @InvocableMethod(
        capabilityType='PromptTemplateType://einstein_gpt__salesEmail'
    )
    public static List getContactsPropertyInterest(
        List requests
    ) {
        // Retrieve inputs
        Request input = requests[0];
        Contact contact = input.recipient;
        Property__c property = input.relatedObject;
        
        // Compute responseData taking into account inputs....
        
        // Create expected response
        List responses = new List();
        Response res = new Response();
        res.Prompt = responseData;
        responses.add(res);
        return responses;
    }

    // Class that represents the template inputs that are passed to the class
    public class Request {
        @InvocableVariable
        public User sender;
        @InvocableVariable
        public Contact recipient;
        @InvocableVariable
        public Property__c relatedObject;
    }

    // Class that represents the data that will be added to the template
    // when it's resolved
    public class Response {
        @InvocableVariable
        public String Prompt;
    }
}