import requests
from datetime import datetime
import time
from dotenv import load_dotenv
import os 
import json

# load .env
load_dotenv()
endpoint = os.environ.get('endpoint')

def lat_lon_generator(): # 파이썬 generator 입니다. 보통 함수의 반환은 return인데 generator는 yield인 것이 특징입니다.
    # departure
    lat=35.182818
    lon=129.140716
    # destination 35.237818 / 129.195716
    while True:
        lat+=round(0.00055,7)
        lon+=round(0.00055,7)
        lat=round(lat, 7)
        lon=round(lon, 7)
        yield lat, lon

def iter_func(iter_num, gen, url, headers):
    for i in range(iter_num):
        print("=== iteration : ", i+1, " ===")
        curr_loc = next(gen)
        # data = str({"truckerId": "444444","@timestamp_utc": datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%S.%f')[:-3]+'Z',"location": {"lat": curr_loc[0],"lon": curr_loc[1]}})
        data = str({"truckerId": "595959","@timestamp_utc": datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%S.%f')[:-3]+'Z',"location": {"lat": curr_loc[0],"lon": curr_loc[1]}})
        print("data:", data, type(data))
        r = requests.post(url=url, headers=headers, json=json.loads(data.replace("'", "\"")))
        print("status: ", r.status_code)
        print("response: ", r.text)
        time.sleep(2.5) # 0.5초 쉬고~
        print()

if __name__ == '__main__':
    iter_num=100
    lat_lon_gen = lat_lon_generator()
    url = endpoint
    headers = { "Content-Type": "application/json" }
    iter_func(iter_num, lat_lon_gen, url, headers)