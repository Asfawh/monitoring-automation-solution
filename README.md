# Monitoring and Automation Solution

This repository contains a solution for monitoring and automatically resolving performance issues in a web application.

## Sumo Logic Query

The `sumo_logic_query.txt` file contains a query to identify log entries where the response time of the `/api/data` endpoint exceeds 3 seconds. An alert is triggered if more than 5 such entries are detected within a 10-minute window.

## Lambda Function

The `lambda_function` directory contains a Python script for an AWS Lambda function that restarts a specified EC2 instance and sends a notification to an SNS topic when triggered by the Sumo Logic alert.

## Terraform Configuration

The `terraform` directory contains Terraform scripts to deploy the necessary infrastructure, including the EC2 instance, Lambda function, and SNS topic.

## Deployment

1. Clone the repository
2. Navigate to the `terraform` directory
3. Initialize Terraform: `terraform init`
4. Apply the configuration: `terraform apply`

This will deploy the EC2 instance, Lambda function, and SNS topic.

## Testing

Trigger the Lambda function using the AWS Management Console or CLI to ensure it restarts the EC2 instance and sends a notification.
