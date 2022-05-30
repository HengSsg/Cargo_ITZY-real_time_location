## API Info.

`Request`
GET /delivery/{truckerId}

`Response`
```
{
    "statusCode": 200,
    "headers": {
        "Access-Control-Allow-Origin": "*"
    },
    "isBase64Encoded": false,
    "body": {
        "trukerId": "888888",
        "delivery-status": "shipping",
        "curr_location": "{'lat': 37.3044668, 'lon': 127.0422522}",
        "distance_in_progress_percentage": "50.03%"
    }
}
```