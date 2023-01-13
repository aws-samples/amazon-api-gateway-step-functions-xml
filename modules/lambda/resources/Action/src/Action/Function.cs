using System;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.Net;
using System.Threading;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Linq;
using Amazon;
using Amazon.Lambda.Core;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;


// Assembly attribute to enable the Lambda function's JSON input to be converted into a .NET class.
[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.SystemTextJson.DefaultLambdaJsonSerializer))]

namespace Action
{

    public class Function
    {

        private static string ACTION_NAME = "Action01";

        [LambdaSerializer(typeof(Amazon.Lambda.Serialization.Json.JsonSerializer))]
        public async Task<object> FunctionHandler(object inputEvent, ILambdaContext context)
        {

            LambdaLogger.Log("CONTEXT: " + JsonConvert.SerializeObject(context));
            LambdaLogger.Log("EVENT: " + JsonConvert.SerializeObject(inputEvent));

            JObject jsonEvent = JObject.Parse(JsonConvert.SerializeObject(inputEvent));

            try {
                // get step function event and translate into c# variables
                string xmlPayload = jsonEvent.GetValue("xmlPayload").ToString();
                LambdaLogger.Log("xmlPayload: " + xmlPayload);

                string processedXmlPayload = ProcessPayload(xmlPayload);

                var ReturnData = new
                {
                    statusCode = 200,
                    body = new
                    {
                        actionStatus = "SUCCESS",
                        actionResult = processedXmlPayload
                    },
                    headers = new Dictionary<string, string> { { "Content-Type", "application/json" } },
                };

                LambdaLogger.Log($"Return Data>>:");
                LambdaLogger.Log(JsonConvert.SerializeObject(ReturnData));

                return ReturnData;
            }
            catch (Amazon.Lambda.AmazonLambdaException ex)
            {
                // LambdaLogger.Log($"ERROR>>: {ex.ToString()}");
                var actionResponse = new
                {
                    actionStatus = "ERROR",
                    actionResult = "None"
                };

                jsonEvent[ACTION_NAME + "Event"] = JsonConvert.SerializeObject(actionResponse);

                var ReturnData = new
                {
                    statusCode = 500,
                    body = jsonEvent,
                    headers = new Dictionary<string, string> { { "Content-Type", "application/json" } },
                };

                return ReturnData;
            }
        }

        private string ProcessPayload(string xmlPayload) {
            XDocument doc = XDocument.Parse(xmlPayload);
            
            XElement xmlElem = new XElement("Lambda"); 
            xmlElem.Add(new XAttribute("name", "aws lambda addition")); 
            xmlElem.Add(new XElement("Message", "Hello from AWS Lambda")); 
            
            doc.Element("rootElement").Add(xmlElem);
            LambdaLogger.Log("######### Processed XML #########");
            LambdaLogger.Log(doc.ToString());
            LambdaLogger.Log("#################################");
            return doc.ToString();
        }
    }
}