Performance testing
Instructions on how to test the performance of your CDH4 cluster.

SSH into one of the machines.
Change to the hdfs user: sudo su - hdfs
Set HADOOP_MAPRED_HOME: export HADOOP_MAPRED_HOME=/usr/lib/hadoop-mapreduce
cd /usr/lib/hadoop-mapreduce
TeraGen and TeraSort
hadoop jar hadoop-mapreduce-examples.jar teragen -Dmapred.map.tasks=1000 10000000000 /tera/in to run TeraGen
hadoop jar hadoop-mapreduce-examples.jar terasort /tera/in /tera/out to run TeraSort
DFSIO
hadoop jar hadoop-mapreduce-client-jobclient-2.0.0-cdh4.6.0-tests.jar TestDFSIO -write
Bootstrapping
Paste your public SSH RSA key in bootstrap/ansible_rsa.pub and run bootstrap.sh to bootstrap the nodes specified in bootstrap/hosts. See bootstrap/bootstrap.yml for more information.

