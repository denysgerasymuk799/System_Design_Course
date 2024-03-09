import json
import time
import logging
import pandas as pd

from datetime import datetime
from kafka import KafkaProducer

from config import *


logging.basicConfig(level=logging.INFO)


def on_send_error(exc_info):
    print(f'ERROR Producer: Got errback -- {exc_info}')


class KafkaDataProducer:
    def __init__(self, bootstrap_servers):
        self.producer = KafkaProducer(
            bootstrap_servers=bootstrap_servers,
            api_version=(0, 10, 1),
            acks='all',
            retries=3,
            max_in_flight_requests_per_connection=1,
            value_serializer=lambda x: json.dumps(x).encode('utf-8')
        )

    def send_data(self, topic_name, df):
        for index, row in df.iterrows():
            message = {
                'message_id': index + 1,
                'order': row['order'],
                'id': row['id'],
                'date': row['date'],
                'time': row['time'],
                'url': row['url'],
                'visitCount': row['visitCount'],
                'typedCount': row['typedCount'],
                'transition': row['transition'],
                'sending_datetime': datetime.now().strftime("%d-%m-%Y, %H:%M:%S.%f")
            }
            self.producer.send(topic_name, value=message).add_errback(on_send_error)
            self.producer.flush()
            logging.info(f'Sent record #{index + 1} to Kafka')

            if (index + 1) == 200:
                return


if __name__ == "__main__":
    # Read the dataset
    history_df = pd.read_csv(DATASET_LOCATION)
    # Partition it on messages and send to a topic
    data_producer = KafkaDataProducer(KAFKA_SERVER)
    data_producer.send_data(TOPIC_NAME, history_df)
