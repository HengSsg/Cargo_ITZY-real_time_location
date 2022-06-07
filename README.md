# Getting Started with devops-01-Final-TeamE-cargoitzy
<div align="center">
<img src="https://img.shields.io/badge/Node.js-339933?style=flat-square&logo=Node.js&logoColor=white"/>
<img src="https://img.shields.io/badge/JavaScript-F7DF1E?style=flat-square&logo=JavaScript&logoColor=white"/>
<img src="https://img.shields.io/badge/Python-3776AB.svg?&style=flat-square&logo=Python&logoColor=white"/>
<img src="https://img.shields.io/badge/Amazon AWS-232F3E?style=flat-square&logo=Amazon%20AWS&logoColor=white"/>
<img src="https://img.shields.io/badge/OpenSearch-005EB8.svg?&style=flat-square&logo=OpenSearch&logoColor=white"/>
<img src="https://img.shields.io/badge/AWS Lambda-FF9900.svg?&style=flat-square&logo=AWS Lambda&logoColor=white"/>
<img src="https://img.shields.io/badge/Amazon DynamoDB-4053D6.svg?&style=flat-square&logo=Amazon DynamoDB&logoColor=white"/>
<img src="https://img.shields.io/badge/Amazon S3-569A31.svg?&style=flat-square&logo=Amazon S3&logoColor=white"/>
<img src="https://img.shields.io/badge/Terraform-7B42BC?style=flat-square&logo=Terraform&logoColor=white"/>
</div>


## Team
| 이름   | GitHub                                            |
| ------ | ------------------------------------------------- |
| 이승연 | [@seungyeoniii](https://github.com/seungyeoniii)  |
| 우재무 | [@Jaemoooo](https://github.com/Jaemoooo)          |
| 김정원 | [@devopskims](https://github.com/devopskims)      |
| 박형석 | [@HengSgg](https://github.com/HengSgg)            |


## API_Documentation
| Function | Method | Endpoint | Code | request | response |
|---|---|---|---|---|---|
|Stream데이터 생성|POST| /location | 200 |{<br>"truckerId":"39393939",<br>s"@timestamp_utc": "2022-06-02T08:02:55.567Z",<br>"location": {"lat": 335.237818, "lon": 129.195716}<br>} | {<br>"SequenceNumber":"49630065528552029787469327725776108371145403556639539202",<br>"ShardId":"shardId-000000000000"<br>} |
|화물배송정보조회| GET | /delivery/:{truckerId}  | 200 | N/A |{<br>"statusCode": 200,<br>"headers": {"Access-Control-Allow-Origin": "*"<br>},<br>"isBase64Encoded": false,<br>"body": {<br>"truckerId": "393939",<br>"delivery-status": "finish",<br>"curr_location": "{'lat': 35.237818, 'lon': 129.195716}",<br>"distance_in_progress_percentage": "100.0%"<br>}<br>}|
