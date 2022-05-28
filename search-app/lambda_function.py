import boto3
import json
import requests
from requests_aws4auth import AWS4Auth
from haversine.haversine import haversine
import os

region = os.environ['region'] # For example, us-west-1
service = 'es'
credentials = boto3.Session().get_credentials()
awsauth = AWS4Auth(credentials.access_key, credentials.secret_key, region, service, session_token=credentials.token)

host = os.environ['opensearch_endpoint'] # The OpenSearch domain endpoint with https://
index = 'devoops'
url = host + '/' + index + '/_search'

# Lambda execution starts here
def lambda_handler(event, context):
    query = {
        "size": 1,
        "query": {
            "multi_match": {
                "query": str(event['truckerId']),  # 여기는 원하는 값을 넣으면 됩니다
                "fields": "truckerId"  # 여기는 원하는 colimn의 값
            }
        }
    }
            
    # Elasticsearch 6.x requires an explicit Content-Type header
    headers = { "Content-Type": "application/json" }

    # Make the signed HTTP request
    r = requests.get(url, auth=awsauth, headers=headers, data=json.dumps(query))
    
    departure = (float(event['departure']['latitude']), float(event['departure']['longitude']))
    destination = (float(event['destination']['latitude']), float(event['destination']['longitude']))
    
    r_json = r.json()['hits']['hits'][0]['_source']
    curr_location = (float(r_json['location']['lat']), float(r_json['location']['lon']))
    
    depart_curr = haversine(departure, curr_location, unit='km')
    curr_dest = haversine(curr_location, destination, unit='km')
    distance_in_progress_percentage = round(100 * depart_curr / (depart_curr + curr_dest), 2)
    # Create the response and add some extra content to support CORS
    response = {
        "statusCode": 200,
        "headers": {
            "Access-Control-Allow-Origin": '*'
        },
        "isBase64Encoded": False
    }

    # Add the search results to the response
    response['body'] = {
        "trukerId": r_json['truckerId'],
        "curr_location": str(r_json['location']),
        "distance_in_progress_percentage": str(distance_in_progress_percentage)+'%'
    }
    return response