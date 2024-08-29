# Stop containers with Cassandra nodes
printf 'Stopping containers ...\n'
docker stop "$(docker container ls -aqf 'name=cassandra-node1')"
printf 'Containers are stopped\n\n'

# Delete the containers
printf 'Deleting containers ...\n'
docker rm "$(docker container ls -aqf 'name=cassandra-node1')"
printf 'Containers are deleted\n\n'

# Delete network created for Cassandra
docker network rm my-cassandra-network
printf 'Cluster is successfully deleted:\n'
docker ps
