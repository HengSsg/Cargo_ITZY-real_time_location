# Getting Started with devops-01-Final-TeamE-cargoitzy

# TECH

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

# 시나리오 
시나리오
화물운송 1등 기업 센디는 화물용달 예약 서비스를 제공합니다. 예약을 성공적으로 진행한 후,<br/>
화물 용달이 실제로 운송중일 경우, 고객은 이러한 운송 정보를 실시간으로 파악할 수 있어야 합니다.

# 요구사항
소비자는 예약 후, 매칭이 이루어진 드라이버의 실시간 정보를 받아올 수 있어야 합니다.<br/>
드라이버 전용 앱은 별도로 구성하며, 위치 데이터 스트림이 JSON 형식으로 실시간으로 전송되어야 합니다.<br/>
스트림 데이터 처리는 Kinesis Data Stream, Kinesis Data Firehose 사용을 고려해볼 수 있습니다.<br/>
드라이버 위치 정보에 대한 로그는 Elasticsearch를 이용합니다.<br/>
서비스 간의 연결은 서버리스 형태로 구성해야 합니다.<br/>




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
