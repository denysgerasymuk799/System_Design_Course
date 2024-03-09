# Create network for a Mongo cluster
docker network create my-mongo-network
printf 'Network my-mongo-network is created\n\n'

# Clean previous runs if exist
printf 'Deleting containers with mongo if exist ...\n'
docker rm "$(docker container ls -aqf 'name=mongo-node1')"
printf 'Containers are deleted\n\n'

# Create a Mongo cluster.
# Note that sleep is necessary for nodes to find each other and create a cluster
printf 'Creating a Mongo cluster ...\n'
docker run -p 27017:27017 --name mongo-node1 \
  --network my-mongo-network \
  -d mongo:latest
sleep 30  # Wait when the cluster will be up
printf 'Node 1 is up\n\n'

printf 'Mongo cluster is created: \n'

docker ps
