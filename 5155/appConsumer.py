# Import KafkaConsumer from Kafka library
from kafka import KafkaConsumer

# Import sys module
import sys

# Initialize consumer variable
consumer = KafkaConsumer (
    'quine-output',
    bootstrap_servers = 'bootstrap.foobar.com:443',
    security_protocol='SSL',
    ssl_cafile='./cert/ca.crt',
    ssl_certfile='./cert/user.crt',
    ssl_keyfile='./cert/user.key'
)

# Read and print message from consumer
for msg in consumer:
    print("Topic Name=%s,Message=%s"%(msg.topic,msg.value))

# Terminate the script
sys.exit()

# sudo apt install python3-pip
# pip install kafka-python
# python3 stock.test.py