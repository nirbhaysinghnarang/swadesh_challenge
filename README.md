# Project Structure
1. `/lambdas`: This directory contains the code for the AWS Lambdas that handle the GET/POST requests to the Amazon APIGateway.
2. `/mobile`: This directory contains the Flutter application. 

To display proficiency with your backend stack, I made the decision to add a backend API where each the information for each device is synced with Amazon DynamoDB via its device ID. 

## Testing
1. To test the mobile app, `cd` into `/mobile` and then run `flutter test integration_test`.
2. To test the backend API, `cd` into `/lambdas` and then run `python test.py`.


## Test Plan
###  For mobile:
  1. Run the app
  2. Count the number of transactions that are currently processings.
  3. Initiate a new transaction.
  4. Verify that there is one more processing transaction.

### For the API:
  1. Generate a list of random ids to simulate physical device ids.
  2. Initialise the information for each id in DynamoDB, using the GET request.
  3. Given a number of transactions to perform, perform those transactions, keeping track of the amount in each transaction, as a running sum.
  4. Verify that the sum of transactions stored on the backend is the same as the sum above.

[Simulator Screen Recording](https://www.youtube.com/watch?v=ZLzxdcht66E)
