# Stop containers with Mongo nodes
printf 'Stopping containers ...\n'
docker stop "$(docker container ls -aqf 'name=mongo-node1')"
printf 'Containers are stopped\n\n'

# Delete the containers
printf 'Deleting containers ...\n'
docker rm "$(docker container ls -aqf 'name=mongo-node1')"
printf 'Containers are deleted\n\n'

# Delete network created for Mongo
docker network rm my-mongo-network
printf 'Cluster is successfully deleted:\n'
docker ps
