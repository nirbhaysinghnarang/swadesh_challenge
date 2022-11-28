import requests
import random
import string
import json
import uuid
import functools


BASE_URL = "https://w6nwswt8dh.execute-api.us-east-1.amazonaws.com/staging/transactions"

def _generate_ids(size):
  """
  Generates a list of unique ids to represent device ids.
  """
  return [str(uuid.uuid4()) for _ in range(size)]

def test():
  """
  Runs the test suite
  """
  #Number of devices to test with
  test_suite_size = 3

  #Number of transactions per device.
  transaction_size = 5
  ids = _generate_ids(test_suite_size)

  for _id in ids:
    accumulator = 0
    print(f"Creating device id {_id}\n")
    create_item(_id)
    for _ in range(transaction_size):
      accumulator+=float(post_transaction(_id))
    sum_trans = get_sum(_id)
    # Assert that the sum of transactions stored in the database is equal to the 
    # sum of transactions made via the POST requests.
    assert(sum_trans==accumulator)
    print(f"Test case for {_id} passed. Expected USD {sum_trans}.\n")


def random_transaction():
  """
  Generate a random transaction.
  """
  return {
        "accHolderName":''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(100)),
        "accNo":''.join(random.choice(string.digits) for _ in range(12)),
        "routingNo":''.join(random.choice(string.digits) for _ in range(9)),
        "amount":random.randint(100,999)/100,
        "desc":''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(100)),
        "purposeCode":random.choice([
          "P1301 - Inward remittance from NRI ",
          "P1302 - Personal gifts and donations",
          "P1306 - Receipts / Refund of taxes"
        ])
    }
  
def create_item(_id):
  """
  Make a GET request that returns JSON to represent the information for a new device.
  """
  url = f"{BASE_URL}?id={_id}"
  resp = json.loads(requests.get(url).text)
  assert (resp["transactions"]==[])
  assert(resp['userBalance']=='1000')
  print(resp['deviceId'], _id)
  assert(resp['deviceId']==_id)
  assert(resp['new']=='True')

  print(f"Created {_id} with success")

def post_transaction(id):
  """
  Make a post request to simulate a transaction request
  """
  url=f"{BASE_URL}?id={id}"
  body = random_transaction()
  requests.post(url, data=json.dumps(body))
  print(f'Post transaction with amount {body["amount"]} to id {id}')
  return body["amount"]


def get_sum(id):
  """
  Get the sum of all transactions for a given device.
  """
  url = f"{BASE_URL}?id={id}"
  user = json.loads(requests.get(url).text)
  transactions = user['transactions']
  return functools.reduce((lambda acc, trans: acc+float(trans['amount'])), transactions, 0)



def __main__():
  print(f"\n{'*'*10}Starting Test Suite{'*'*10}\n")
  test()
  print(f"\n{'*'*10}Test Suite Successful{'*'*10}\n")

if __name__=="__main__":
  __main__()