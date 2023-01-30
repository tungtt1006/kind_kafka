from influxdb import InfluxDBClient
import pandas as pd
csvReader = pd.read_csv('A.csv', index_col=0)

client = InfluxDBClient('localhost', 8086, 'root', 'root', 'stock')
client.drop_database('stock')
client.create_database('stock')

for row_index, row in csvReader.iterrows():
    tags = row[0]
    fieldvalue = row
    dict_row = row.to_dict()
    print(dict_row)
    json_body = [
        {
            "measurement": "cpu_load_short",

            "fields": dict_row
        }
    ]

    print(json_body)


    client.write_points(json_body)
    result = client.query('select * from cpu_load_short')

    # print("Result: {0}".format(result))



