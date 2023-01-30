import time
import json
import random
import pandas as pd

from kafka import KafkaProducer

config_ob = open('./config.json')
config = json.load(config_ob)

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
    producer = KafkaProducer(bootstrap_servers=['localhost:9092'])
    csvReader = pd.read_csv('A.csv', index_col=0)

    for row_index, row in csvReader.iterrows():
        tags = row[0]
        fieldvalue = row
        dict_row = row.to_dict()
        print(dict_row)

        print(dict_row)
        producer.send('stock', bytes(f'{json.dumps(dict_row)}','UTF-8'))
        print(f"Sensor data is sent: {dict_row}")
        time.sleep(5)


if __name__ == "__main__":
    main()