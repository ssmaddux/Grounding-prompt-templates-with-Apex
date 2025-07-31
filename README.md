# How to Call a Salesforce Prompt Template from Apex: Key Learnings

## Overview
Prompt Templates in Salesforce allow you to generate AI-powered content (like emails, field completions, or summaries) using Apex code. This document summarizes the steps and best practices for integrating Prompt Templates with Apex, based on our project experience.

---

## Table of Contents
1. [Understand Prompt Template Types](#1-understand-prompt-template-types)
2. [Structure Your Apex Class](#2-structure-your-apex-class)
3. [Key Rules and Gotchas](#3-key-rules-and-gotchas)
4. [How to Test Your Code](#4-how-to-test-your-code)
5. [Summary](#5-summary)

---

## 1. Understand Prompt Template Types
Salesforce supports several prompt template types, each with its own required inputs and outputs. These are referred to as `capabilityType` in our code:
- **Sales Email**: `PromptTemplateType://einstein_gpt__salesEmail`
- **Field Completion**: `PromptTemplateType://einstein_gpt__fieldCompletion`
- **Record Summary**: `PromptTemplateType://einstein_gpt__recordSummary`
- **Custom Flex Template**: `FlexTemplate://template_API_Name`

Each type expects specific input and output variable names and data types. The `capabilityType` parameter in the `@InvocableMethod` annotation must match the template type being used.

---

## 2. Structure Your Apex Class
Your Apex class must:
- Be `public` and use `with sharing`.
- Contain an `@InvocableMethod` with the correct `capabilityType`.
- Use inner `Request` and `Response` classes to define inputs and outputs.

### Example: Sales Email Template
```apex
public with sharing class ContactPropertyInterestService {
    @InvocableMethod(
        capabilityType='PromptTemplateType://einstein_gpt__salesEmail'
    )
    public static List<Response> getContactsPropertyInterest(List<Request> requests) {
        Request input = requests[0];
        Contact contact = input.recipient;
        Property__c property = input.relatedObject;
        // ...build responseData...
        List<Response> responses = new List<Response>();
        Response res = new Response();
        res.Prompt = responseData;
        responses.add(res);
        return responses;
    }
    public class Request {
        @InvocableVariable public User sender;
        @InvocableVariable public Contact recipient;
        @InvocableVariable public Property__c relatedObject;
    }
    public class Response {
        @InvocableVariable public String Prompt;
    }
}
```

### Example: Field Completion Template
```apex
public with sharing class aiFieldGenerator {
    @InvocableMethod(
        capabilityType='PromptTemplateType://einstein_gpt__fieldCompletion'
    )
    public static List<Response> getAccountsDetails(List<Request> requests) {
        Request input = requests[0];
        Account account = (Account)input.RelatedEntity;
        // ...build responseData...
        List<Response> responses = new List<Response>();
        Response res = new Response();
        res.Prompt = responseData;
        responses.add(res);
        return responses;
    }
    public class Request {
        @InvocableVariable public Account RelatedEntity;
    }
    public class Response {
        @InvocableVariable public String Prompt;
    }
}
```

---

## 3. Key Rules and Gotchas
- **Input/Output Names Matter**: The names and types of your `@InvocableVariable` properties must match Salesforce's requirements for the template type. For example, `RelatedEntity` for field completion, `Prompt` for output.
- **Use the Correct Data Type**: For field completion, `RelatedEntity` must be a concrete SObject type (e.g., `Account`), not generic `SObject`.
- **Return a List**: Your method must return a `List<Response>`, even if you only have one response.
- **One Request at a Time**: Prompt templates typically send a single request per invocation, so you can safely use `requests[0]`.
- **Deployment Errors**: If you get errors about missing or invalid input/output, double-check your property names and types.
- **Debugging**: Use `System.debug` to log inputs and outputs during testing. Check Salesforce logs for detailed error messages.

---

## 4. How to Test Your Code
You can test your invocable method using anonymous Apex:
```apex
Account acc = [SELECT Id, Name, Industry, Type FROM Account LIMIT 1];
aiFieldGenerator.Request req = new aiFieldGenerator.Request();
req.RelatedEntity = acc;
List<aiFieldGenerator.Request> reqList = new List<aiFieldGenerator.Request>{ req };
List<aiFieldGenerator.Response> respList = aiFieldGenerator.getAccountsDetails(reqList);
System.debug(respList[0].Prompt);
```

### Tips for Testing
- Test with different SObject types to ensure flexibility.
- Use meaningful test data to verify the output.
- Check Salesforce logs for any runtime errors or unexpected behavior.

---

## 5. Summary
- Always follow the required input/output structure for your template type.
- Use concrete SObject types for field completion.
- Name your output variable `Prompt` for compatibility.
- Test with anonymous Apex to verify your logic.

By following these steps, you can successfully call and ground Salesforce Prompt Templates from Apex.

# Salesforce DX Project: Next Steps

Now that you’ve created a Salesforce DX project, what’s next? Here are some documentation resources to get you started.

## How Do You Plan to Deploy Your Changes?

Do you want to deploy a set of changes, or create a self-contained application? Choose a [development model](https://developer.salesforce.com/tools/vscode/en/user-guide/development-models).

## Configure Your Salesforce DX Project

The `sfdx-project.json` file contains useful configuration information for your project. See [Salesforce DX Project Configuration](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_config.htm) in the _Salesforce DX Developer Guide_ for details about this file.

## Read All About It

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)
