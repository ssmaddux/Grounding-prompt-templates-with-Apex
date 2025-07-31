public with sharing class aiFieldGenerator {
    @InvocableMethod(
        capabilityType='PromptTemplateType://einstein_gpt__fieldCompletion'
    )
    public static List<Response> getAccountsDetails(List<Request> requests) {
        // Retrieve inputs
        Request input = requests[0];
        Account account = (Account)input.RelatedEntity;
        String responseData;
        if (account != null) {
            responseData = 'Account Details:\n'
                + 'Name: ' + account.Name + '\n'
                + 'Industry: ' + account.Industry + '\n'
                + 'Type: ' + account.Type + '\n'
                + 'Id: ' + account.Id;
        } else {
            responseData = 'No Account record found in RelatedEntity input.';
        }
        List<Response> responses = new List<Response>();
        Response res = new Response();
        res.Prompt = responseData;
        responses.add(res);
        return responses;
    }

    public class Request {
        @InvocableVariable
        public Account RelatedEntity;
    }

    public class Response {
        @InvocableVariable
        public String Prompt;
    }
}