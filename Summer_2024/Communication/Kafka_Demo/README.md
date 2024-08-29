# Kafka Demo

## How to run it?

* Change EXPERIMENT_FOLDER_NAME and CONFIGURATION_FOLDER_NAME variables in `./consumer/config.py` for a new experiment

* Configure the number of partitions, consumers, and producers in `./docker-compose.yaml`

* Execute the following command to produce/consume messages:
```shell
./Kafka_Demo$ docker-compose up --build
```

* Wait 30-200 seconds depending on the configuration when 200 messages will be processed

* Run `./report_aggregation/Report_Aggregation.ipynb` with a `save_locally` flag = True in the `get_experiment_results()` function and replace EXPERIMENT_FOLDER_NAME on your experiment name


## Notes

* To speed up an experiment with different configurations, producers send 200 messages in total

* Consumers save processing time and metadata in the mongodb deployed with docker compose

* Results for all configurations are located in `./results/experiment_1/exp_results.csv`

* You can rerun `./report_aggregation/Report_Aggregation.ipynb` to reproduce the plots

* All system configurations processed 200 messages:

![processed_messages](https://github.com/denysgerasymuk799/UCU_DE_Data_Streaming/assets/42843889/f3068cf6-5b17-4753-8e6f-b2df0b0ec720)


## Throughput of the system in Mbps

![throughput](https://github.com/denysgerasymuk799/UCU_DE_Data_Streaming/assets/42843889/d6c2ccdd-fa4a-4073-a02d-4f956bf575e9)


## Latency of message processing

![latency](https://github.com/denysgerasymuk799/UCU_DE_Data_Streaming/assets/42843889/92fb43b7-49a2-49a2-83a8-b4d1f081dde9)
