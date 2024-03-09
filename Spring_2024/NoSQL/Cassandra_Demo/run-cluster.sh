# Create network for Cassandra cluster
docker network create my-cassandra-network
printf 'Network my-cassandra-network is created\n\n'

# Clean previous runs if exist
printf 'Deleting containers with cassandra if exist ...\n'
docker rm "$(docker container ls -aqf 'name=cassandra-node1')"
printf 'Containers are deleted\n\n'

# Create Cassandra cluster.
# Note that sleep is necessary for nodes to find each other and create a cluster
printf 'Creating Cassandra cluster ...\n'
docker run -p 9042:9042 --name cassandra-node1 \
  --network my-cassandra-network \
  -v "$(pwd)/cassandra.yaml:/etc/cassandra/cassandra.yaml" \
  -d cassandra:latest
sleep 60
printf 'Node 1 is up\n\n'

printf 'Cassandra cluster is created: \n'

docker ps
