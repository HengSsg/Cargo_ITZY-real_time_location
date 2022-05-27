| Function | Method | Endpoint | Code | request | response |
|---|---|---|---|---|---|
|출발도착상태생성| PUT | /status | 200 | { truckerId: "888888", status: "N"} | { } |
|Stream데이터 생성|POST| /stream | 200 | {"truckerId":"588866", "@timestamp_utc": "2022-05-17T08:02:55.567Z", "location": {"lat": 37.3044668, "lon": 127.0422522}} | { } |
|화물배송정보조회| GET | /delivery/:truckerId  | 200 | N/A |   |