#  Project Description
-  운송상태를 포함한 화물 드라이버 위치 추적 시스템

## Tech

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

## Architecture

![image](https://user-images.githubusercontent.com/98450173/172277436-14203943-bc73-484a-b60a-a0451f9c648d.png)

### 1. API Gateway
`POST /location`<br/> 
![image](https://user-images.githubusercontent.com/98450173/172278998-9b01fdb3-b2c7-4f19-bf01-bd7fa44525a2.png)<br/>
동기적으로 rest api를 사용하기 위해서 gateway를 사용했고 일대일로 요청/응답(PutRecord)

### 2. Kinesis Data Stream 
실시간 위치 정보를 수집하고 순서에 따라 저장

### 3. Kinesis Data Firehose
Kinesis Data Stream으로부터 record를 받아(GetRecord) 실시간 데이터 처리 및 전송

### 4. Opensearch 
실시간 데이터 저장 및 검색과 같이 다양한 사용 사례에 사용

### 5. API Gateway
`GET /delivery/{:truckerId}`<br/>
![image](https://user-images.githubusercontent.com/98450173/172279131-f17e61a6-5538-494a-8966-2c7b80fc5ac1.png)

### 6, 7, 8, 9.
Lambda OpenSearch에서 받아온드라이버의 위치정보와 DynamoDB에서 받아온 출발지와 도착지의 위치정보를 비교하여 운송상태를 다시 DynamoDB에 저장.


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
