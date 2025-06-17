# Get Data Center Name
# nodetool describecluster | grep "Data Centers" -A1 | sed 1d | awk '{print $1}'

cqlsh -u cassandra -p changeme -f sql/01-create-key.sql

