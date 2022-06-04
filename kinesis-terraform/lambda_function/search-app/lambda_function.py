import boto3
import json
import requests
from requests_aws4auth import AWS4Auth
from haversine.haversine import haversine
import os
import re

region = os.environ['region'] # For example, us-west-1
service = 'es'
credentials = boto3.Session().get_credentials()
awsauth = AWS4Auth(credentials.access_key, credentials.secret_key, region, service, session_token=credentials.token)

host = os.environ['opensearch_endpoint'] # The OpenSearch domain endpoint with https://

index = 'location'
url = host + '/' + index + '/_search'
print("=====url=====", url)

# Get the service resource.
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('DeliverINFO')

# Lambda execution starts here
def lambda_handler(event, context):
    # 1. dynamoDB GET
    dynamo_data = table.get_item(
                                Key={
                                        'truckerId': str(event['truckerId'])
                                    }
                                )
    status = dynamo_data['Item']['delivery-status'] #.replace(" ", "")
    departure = json.loads(re.sub(r"\s", "", dynamo_data['Item']['departure']))
    destination = json.loads(re.sub(r"\s", "", dynamo_data['Item']['destination']))
    
    print("====status====",status)
    # 2. Opensearch GET
    query = {
            "size": 1,
            "sort": {
                "@timestamp_utc": {
                  "order": "desc"
                }
              },
            "query": {
                "multi_match": {
                    "query": str(event['truckerId']),  # 여기는 원하는 값을 넣으면 됩니다
                    "fields": "truckerId"  # 여기는 원하는 column의 값
                }
            }
    }
                
    # Elasticsearch 6.x requires an explicit Content-Type header
    headers = { "Content-Type": "application/json" }

    # Make the signed HTTP request
    r = requests.get(url, auth=awsauth, headers=headers, data=json.dumps(query))
    
    dep_location = (float(departure['latitude']), float(departure['longitude']))
    des_location = (float(destination['latitude']), float(destination['longitude']))
    print(r.status_code)
    try: # opensearch에 data가 없는 경우 
        curr_json = r.json()['hits']['hits'][0]['_source']
        curr_location = (float(curr_json['location']['lat']), float(curr_json['location']['lon']))
        depart_curr = haversine(dep_location, curr_location, unit='km')
        curr_dest = haversine(curr_location, des_location, unit='km')
        
        distance_in_progress_percentage = round(100 * depart_curr / (depart_curr + curr_dest), 2)
    except:
        print("Not Number!")
        distance_in_progress_percentage = 0
    # curr_json = r.json()['hits']['hits'][0]['_source']
    
    
    
    if (distance_in_progress_percentage >= 5)&(status=='preparing'):
        dynamo_data = table.put_item(
                                Item={
                                        'truckerId': str(event['truckerId']),
                                        'delivery-status': 'shipping',
                                        'departure': str(departure).replace("'", "\""), # 이 값은 나중에 json으로 처리됩니다. key나 value에 쌍따옴표를 붙이는 처리를 추가합니다.
                                        'destination': str(destination).replace("'", "\"")
                                    }
                                )
        status = 'shipping'
    
    if (distance_in_progress_percentage > 98)&(status=='shipping'):
        dynamo_data = table.put_item(
                                Item={
                                        'truckerId': str(event['truckerId']),
                                        'delivery-status': 'finish',
                                        'departure': str(departure).replace("'", "\""),
                                        'destination': str(destination).replace("'", "\"")
                                    }
                                )
        status = 'finish'

    response = {
            "statusCode": 200,
            "headers": {
                "Access-Control-Allow-Origin": '*'
            },
            "isBase64Encoded": False
        }
    print("====status====")
    print(status) 
    if status == 'preparing':
        response['body'] = {
            "truckerId": str(event['truckerId']),
            "delivery-status": 'preparing',
            "curr_location": 'Unable to identify the location',
            "distance_in_progress_percentage": '0'
        }
    elif status == 'shipping':
        response['body'] = {
            "truckerId": curr_json['truckerId'],
            "delivery-status": 'shipping',
            "curr_location": str(curr_json['location']),
            "distance_in_progress_percentage": str(distance_in_progress_percentage)+'%'
        }
    elif status == 'finish':
        response['body'] = {
            "truckerId": curr_json['truckerId'],
            "delivery-status": 'finish',
            "curr_location": str(curr_json['location']),
            "distance_in_progress_percentage": str(distance_in_progress_percentage)+'%'
        }
    
    return response
