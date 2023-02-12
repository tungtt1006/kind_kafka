import time
import json
import random

from kafka import KafkaProducer


def random_temp_cels():
    return round(random.uniform(-10, 50), 1)

def random_humidity():
    return round(random.uniform(0, 100), 1)

def random_wind():
    return round(random.uniform(0, 10), 1)

def random_soil():
    return round(random.uniform(0, 100), 1)

def get_json_data():
    data = {}

    data["temperature"] = random_temp_cels()
    data["humidity"] = random_humidity()
    data["wind"] = random_wind()
    data["soil"] = random_soil()

    return json.dumps(data) 

def main():
    producer = KafkaProducer(
        bootstrap_servers=['bootstrap.myingress.com:443'],
        security_protocol='SSL',
        ssl_cafile='./cert/ca.crt',
        ssl_certfile='./cert/user.crt',
        ssl_keyfile='./cert/user.key',
    )

    for _ in range(20000):
        json_data = get_json_data()
        producer.send('test', bytes(f'{json_data}','UTF-8'))
        print(f"Sensor data is sent: {json_data}")
        time.sleep(5)


if __name__ == "__main__":
    main()

# sudo apt install python3-pip
# pip install kafka-python
# python3 stock.test.py
# {"temperature": 13.2, "humidity": 14.2, "wind": 15.4, "soil": 16.4}