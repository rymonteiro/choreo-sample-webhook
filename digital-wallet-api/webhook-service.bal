import ballerina/http;
import ballerina/log;

listener http:Listener webhookListener = new (8080);

service /passkit on webhookListener {

    resource function post events(http:Caller caller, http:Request req) returns error? {
        // Log incoming request
        log:printInfo("Received a webhook event from PassKit");

        // Extract JSON payload
        json payload = check req.getJsonPayload();
        log:printInfo("Payload received: " + payload.toString());

        // Process the webhook event (You can handle specific events based on the payload)
        if (payload.hasKey("eventType")) {
            string eventType = check payload.eventType.toString();
            if eventType == "pass.updated" {
                log:printInfo("Processing pass update event");
                // Add your logic for handling pass updates
            } else if eventType == "pass.installed" {
                log:printInfo("Processing pass installed event");
                // Add your logic for handling pass installations
            }
        }

        // Send a response back to PassKit
        check caller->respond("Webhook event processed successfully");
    }
}
