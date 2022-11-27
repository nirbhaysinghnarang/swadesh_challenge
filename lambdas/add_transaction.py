import json
import json
import logging
import boto3
from decimal import Decimal
import time 
logger = logging.getLogger()
logger.setLevel(logging.INFO)


class DecimalEncoder(json.JSONEncoder):
  def default(self, obj):
    if isinstance(obj, Decimal):
      return str(obj)
    return json.JSONEncoder.default(self, obj)


def lambda_handler(event, context):
    body = json.loads(event.get("body"), parse_float=Decimal)
    deviceId = event["queryStringParameters"]['id']
    logger.info(deviceId)
    accHolderName = body.get("accHolderName")
    accNo = body.get("accNo")
    routingNo = body.get("routingNo")
    amount = body.get("amount")
    desc = body.get("desc")
    purposeCode = body.get("purposeCode")
    
    
    if (None in [accHolderName, accNo, routingNo, amount, purposeCode]):
        return build_response(400, json.dumps("Missing fields."))
        
    dynamodb = boto3.resource("dynamodb")
    table = dynamodb.Table("transactions")
    
    response = table.get_item(Key={'deviceId': deviceId})
    item = response["Item"]

    
    transaction = {
        "accHolderName":accHolderName,
        "accNo":Decimal(accNo),
        "routingNo":Decimal(routingNo),
        "amount":Decimal(amount),
        "desc":desc,
        "purposeCode":purposeCode,
        "initTime":Decimal(time.time())
    }
    try:
        item["transactions"].append(transaction)
    except:
        item["transactions"] = [transaction]
        
        
    table.put_item(Item=item)
    return build_response(200, (transaction))
    
    
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
