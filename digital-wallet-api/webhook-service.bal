import ballerina/http;
import ballerina/log;

listener http:Listener webhookListener = new (8080);

service /passkit on webhookListener {

    resource function post events(http:Caller caller, http:Request req) returns error? {
        // Log incoming request
        log:printInfo("Received a webhook event from PassKit");

        // Extract JSON payload
        json|error payloadResult = req.getJsonPayload();
        if (payloadResult is error) {
            // Handle JSON parsing error
            log:printError("Failed to parse JSON payload: " + payloadResult.message());
            check caller->respond("Invalid JSON payload");
            return;
        }

        json payload = payloadResult;

        // Process the webhook event (You can handle specific events based on the payload)
        if (payload is map<json> && payload.hasKey("eventType")) {
            string eventType = payload["eventType"].toString();
            if eventType == "pass.updated" {
                log:printInfo("Processing pass update event");
                // Add your logic for handling pass updates
            } else if eventType == "pass.installed" {
                log:printInfo("Processing pass installed event");
                // Add your logic for handling pass installations
            }
        } else {
            log:printError("Invalid payload format or missing eventType");
            check caller->respond("Invalid payload");
            return;
        }

        // Send a response back to PassKit
        check caller->respond("Webhook event processed successfully");
    }
}
