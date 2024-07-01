import boto3
import logging
import os


# Initialize the logger
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Initialize AWS clients
ec2 = boto3.client('ec2')
sns = boto3.client('sns')

# Environment variables
INSTANCE_ID = os.getenv('INSTANCE_ID')
SNS_TOPIC_ARN = os.getenv('SNS_TOPIC_ARN')

def lambda_handler(event, context):
    try:
        # Restart the EC2 instance
        ec2.reboot_instances(InstanceIds=[INSTANCE_ID])
        logger.info(f"Restarted EC2 instance: {INSTANCE_ID}")
        
        # Send SNS notification
        sns.publish(
            TopicArn=SNS_TOPIC_ARN,
            Message=f"EC2 instance {INSTANCE_ID} has been restarted due to high response time on /api/data endpoint.",
            Subject="EC2 Instance Restart Notification"
        )
        logger.info("SNS notification sent.")
    except Exception as e:
        logger.error(f"Error: {str(e)}")
        raise e
