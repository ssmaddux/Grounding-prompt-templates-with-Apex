// Run this in the Execute Anonymous window or VS Code terminal
Account acc = [SELECT Id, Name, Industry, Type FROM Account LIMIT 1];
aiFieldGenerator.Request req = new aiFieldGenerator.Request();
req.RelatedEntity = acc;
List<aiFieldGenerator.Request> reqList = new List<aiFieldGenerator.Request>{ req };
List<aiFieldGenerator.Response> respList = aiFieldGenerator.getAccountsDetails(reqList);
System.debug(respList[0].Prompt);