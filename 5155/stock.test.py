import time
import json
import random

from kafka import KafkaProducer


def random_timestamp():
    return round(time.time())

def random_portfolio_id():
    return round(random.uniform(0, 200))

def random_target_profit():
    return round(random.uniform(0, 100), 1)

def random_realized_profit_loss():
    return round(random.uniform(0, 100), 1)

def random_unrealized_profit_loss():
    return round(random.uniform(0, 100), 1)

def get_json_data():
    data = {}

    data["Timestamp"] = random_timestamp()
    data["PortfolioID"] = random_portfolio_id()
    data["TargetProfit"] = random_target_profit()
    data["RealizedProfitLoss"] = random_realized_profit_loss()
    data["UnrealizedProfit(Loss)"] = random_unrealized_profit_loss()

    return json.dumps(data)

def main():
    # producer = KafkaProducer(
    #     bootstrap_servers=['bootstrap.myingress.com:443'],
    #     security_protocol='SSL',
    #     ssl_cafile='./cert/ca.crt',
    #     ssl_certfile='./cert/user.crt',
    #     ssl_keyfile='./cert/user.key',
    # )

    for _ in range(20000):
        json_data = get_json_data()
        # producer.send('test', bytes(f'{json_data}','UTF-8'))
        print(f"Sensor data is sent: {json_data}")
        time.sleep(2)


if __name__ == "__main__":
    main()

# sudo apt install python3-pip
# pip install kafka-python
# python3 stock.test.py
# {"temperature": 13.2, "humidity": 14.2, "wind": 15.4, "soil": 16.4}