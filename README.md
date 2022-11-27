# Project Structure
1. `/lambdas`: This directory contains the code for the AWS Lambdas that handle the GET/POST requests to the Amazon APIGateway.
2. `/mobile`: This directory contains the Flutter application. 

I made the decision to add a backend API where each the information for each device is synced with Amazon DynamoDB via its device ID. 