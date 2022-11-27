import json
import json
import logging
import boto3
import datetime
from decimal import Decimal

logger = logging.getLogger()
logger.setLevel(logging.INFO)


class DecimalEncoder(json.JSONEncoder):
  def default(self, obj):
    if isinstance(obj, Decimal):
      return str(obj)
    return json.JSONEncoder.default(self, obj)


def lambda_handler(event, context):
    deviceId = event["queryStringParameters"]['id']
    dynamodb = boto3.resource("dynamodb")
    table = dynamodb.Table("transactions")
    try:
        response = table.get_item(Key={'deviceId': deviceId})
        item = response["Item"]
    except:
        item = {
            "transactions":[],
            "userBalance":Decimal(1000),
            'deviceId':deviceId
        }
        table.put_item(Item=item)
        item["new"]="True"
    return build_response(200, (item))
    
    
"""
This function adds correct headers to API response
"""
def build_response(statusCode, val):
    return {
        'statusCode': statusCode,
        'headers': {
            'Access-Control-Allow-Origin': '*',
            'Content-Type': 'application/json'
        },
        'body': json.dumps(val, cls=DecimalEncoder)
    }
