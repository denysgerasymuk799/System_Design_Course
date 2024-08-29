import os
import sys
import uuid
import json
import time
import logging
import pathlib

from datetime import datetime
from dotenv import load_dotenv
from pymongo import MongoClient
from kafka import KafkaConsumer

from config import *

logging.basicConfig(level=logging.INFO)


def on_send_error(exc_info):
    print(f'ERROR Producer: Got errback -- {exc_info}')


def connect_to_mongodb(collection_name, secrets_path: str = pathlib.Path(__file__).parent.joinpath('.', 'secrets.env')):
    load_dotenv(secrets_path)  # Take environment variables from .env

    # Provide the mongodb atlas url to connect python to mongodb using pymongo
    connection_string = os.getenv("CONNECTION_STRING")
    # Create a connection using MongoClient. You can import MongoClient or use pymongo.MongoClient
    client = MongoClient(connection_string)
    collection = client[os.getenv("DB_NAME")][collection_name]

    return client, collection


class KafkaConsumerService:
    def __init__(self, bootstrap_servers, topic_name):
        self.consumer_uuid = str(uuid.uuid4())
        self.kafka_consumer = KafkaConsumer(
            topic_name,
            group_id='grp1',
            bootstrap_servers=bootstrap_servers,
            api_version=(0, 10, 1),
            value_deserializer=lambda v: json.loads(v.decode('utf-8')),
            consumer_timeout_ms=10
        )
        self.client, self.collection = connect_to_mongodb(EXPERIMENT_FOLDER_NAME)

    def start_processing(self):
        try:
            while True:
                try:
                    for msg_obj in self.kafka_consumer:
                        msg = msg_obj.value
                        print("Processing msg with message_id =", msg['message_id'])
                        time.sleep(1)
                        size_in_mb = sys.getsizeof(msg) / 1024 / 1024
                        self.collection.insert_one({
                            'reddit_id': msg['id'],
                            'sending_datetime': msg['sending_datetime'],
                            'processing_datetime': datetime.now().strftime("%d-%m-%Y, %H:%M:%S.%f"),
                            'size_in_mb': size_in_mb,
                            'configuration': CONFIGURATION_FOLDER_NAME,
                            'consumer_uuid': self.consumer_uuid,
                        })
                except ValueError as e:
                    logging.error(f'Error occurred: {e}')
        except ValueError as _:
            self.client.close()


if __name__ == "__main__":
    kafka_consumer = KafkaConsumerService('kafka_broker1:9092', TOPIC_NAME)
    kafka_consumer.start_processing()
