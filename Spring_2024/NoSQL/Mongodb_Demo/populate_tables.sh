docker run --rm -it --network my-mongo-network \
    --mount type=bind,source="$(pwd)"/mongosh_scripts,target=/mongosh_scripts \
    mongo \
    mongosh mongo-node1:27017 -f /mongosh_scripts/populate_collections.js

printf 'Collections are created and populated\n'
