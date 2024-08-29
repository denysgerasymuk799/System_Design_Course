docker run --rm -it --network my-cassandra-network \
    --mount type=bind,source="$(pwd)"/cql_files,target=/cql_files \
    cassandra \
    cqlsh cassandra-node1 -f /cql_files/ddl.cql

printf 'Tables are created\n'

docker run --rm -it --network my-cassandra-network \
    --mount type=bind,source="$(pwd)"/cql_files,target=/cql_files \
    cassandra \
    cqlsh cassandra-node1 -f /cql_files/populate_tables.cql

printf 'Tables are populated\n'
