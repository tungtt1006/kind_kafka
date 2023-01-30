# Imports
from datetime import datetime
from influxdb_client import InfluxDBClient, Point, WritePrecision
from influxdb_client.client.write_api import SYNCHRONOUS
import json
import pandas as pd
import time
from kafka import KafkaConsumer


def main():
    # Loading config parameters.
    config_ob = open('./config.json')
    config = json.load(config_ob)

    # Reading a CSV file
    csvReader = pd.read_csv(config['filepath'], index_col=0)

    # Connecting to Influx DB using client and sending data
    with InfluxDBClient(url=config['url'], token=config['token'], org=config['org']) as client:
        write_api = client.write_api(write_options=SYNCHRONOUS)

        # Iterating through rows
        for row_index, row in csvReader.iterrows():
            tags = row[0]
            fieldvalue = row
            dict_row = row.to_dict()
            print(dict_row)
            json_body = [
                {
                    "measurement": "test-pricedata",
                    "fields": dict_row
                }
            ]
            write_api.write(config['bucket'], config['org'], record=json_body)
            # (Optional) Wait time for writing to Influx DB.
            time.sleep(1)


if __name__ == '__main__':
    main()