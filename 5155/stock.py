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

def get_data():
    data = {}

    data["PortfolioID"] = random_portfolio_id()
    data["TargetProfit"] = random_target_profit()
    data["RealizedProfitLoss"] = random_realized_profit_loss()
    data["UnrealizedProfitLoss"] = random_unrealized_profit_loss()

    return json.dumps(data)

def main():
    producer = KafkaProducer(
        bootstrap_servers=['bootstrap.foobar.com:443'],
        security_protocol='SSL',
        ssl_cafile='./cert/ca.crt',
        ssl_certfile='./cert/user.crt',
        ssl_keyfile='./cert/user.key',
        linger_ms=950
    )

    for _ in range(20000):
        data = {}
        data["Timestamp"] = random_timestamp()
        for _ in range(160):
            data["PortfolioID"] = random_portfolio_id()
            data["TargetProfit"] = random_target_profit()
            data["RealizedProfitLoss"] = random_realized_profit_loss()
            data["UnrealizedProfitLoss"] = random_unrealized_profit_loss()

            json_data = json.dumps(data)
            producer.send('quine', bytes(f'{json_data}','UTF-8'))
        
            print(json_data)
        
        time.sleep(1)


if __name__ == "__main__":
    main()
