| Function | Method | Endpoint | Code | request | response |
|---|---|---|---|---|---|
|Stream데이터 생성|POST| /location | 200 |{<br>"truckerId":"39393939",<br>s"@timestamp_utc": "2022-06-02T08:02:55.567Z",<br>"location": {"lat": 335.237818, "lon": 129.195716}<br>} | {<br>"SequenceNumber":"49630065528552029787469327725776108371145403556639539202",<br>"ShardId":"shardId-000000000000"<br>} |
|화물배송정보조회| GET | /delivery/:{truckerId}  | 200 | N/A |{<br>"statusCode": 200,<br>"headers": {"Access-Control-Allow-Origin": "*"<br>},<br>"isBase64Encoded": false,<br>"body": {<br>"truckerId": "393939",<br>"delivery-status": "finish",<br>"curr_location": "{'lat': 35.237818, 'lon': 129.195716}",<br>"distance_in_progress_percentage": "100.0%"<br>}<br>}|
