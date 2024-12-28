Install Dependencies and Deploy

Install the Serverless Framework globally:
npm install -g serverless

Install the required Node.js packages:
npm install

Deploy the Serverless App:
serverless deploy

This will:

Deploy the Lambda functions.
Create the DynamoDB table.
Set up the API Gateway endpoint.
Deploy the static frontend to S3 (if configured).

Final Structure

The frontend will be served from S3, and you can access it through the S3 URL or CloudFront if configured.

The backend API can be accessed via the API Gateway endpoint, and the Lambda function will handle requests to interact with DynamoDB.

Access the Application

Once deployed, your API Gateway URL will look like https://<your-api-id>.execute-api.us-east-1.amazonaws.com/dev/create-item.
The frontend will be available at the S3 URL or CloudFront URL.