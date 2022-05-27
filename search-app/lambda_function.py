import boto3
import json
import requests
from requests_aws4auth import AWS4Auth
import os

region = os.environ['region'] # For example, us-west-1
service = 'es'
credentials = boto3.Session().get_credentials()
awsauth = AWS4Auth(credentials.access_key, credentials.secret_key, region, service, session_token=credentials.token)

host = os.environ['aws_opensearch_endpoint'] # The OpenSearch domain endpoint with https://
index = 'devoops'
url = host + '/' + index + '/_search'

# Lambda execution starts here
def lambda_handler(event, context):
    print("=====event=====", event)
    
    query = {
        # "size": 25,
        "query": {
            "multi_match": {
                "query": str(event),  # 여기는 원하는 값을 넣으면 됩니다
                "fields": "truckerId"  # 여기는 원하는 colimn의 값
            }
        }
    }
    # Elasticsearch 6.x requires an explicit Content-Type header
    headers = { "Content-Type": "application/json" }

    # Make the signed HTTP request
    r = requests.get(url, auth=awsauth, headers=headers, data=json.dumps(query))

    # Create the response and add some extra content to support CORS
    response = {
        "statusCode": 200,
        "headers": {
            "Access-Control-Allow-Origin": '*'
        },
        "isBase64Encoded": False
    }

    # Add the search results to the response
    response['body'] = r.text
    print("[debug]response\n", response)
    
    return response