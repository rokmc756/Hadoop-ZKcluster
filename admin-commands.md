## Check All Service State
$ hdfs haadmin -getAllServiceState
rk9-node01:9000                                    standby
rk9-node02:9000                                    active


## To print out the namenodes use this command:
$ hdfs getconf -namenodes


## To print out the secondary namenodes:
$ hdfs getconf -secondaryNameNodes


## To print out the backup namenodes:
$ hdfs getconf -backupNodes


## Create test file
$ hdfs dfs -mkdir -p /data/pxf_examples

echo 'Prague,Jan,101,4875.33
Rome,Mar,87,1557.39
Bangalore,May,317,8936.99
Beijing,Jul,411,11600.67' > /tmp/pxf_hdfs_simple.txt

$ hdfs dfs -put /tmp/pxf_hdfs_simple.txt /data/pxf_examples/
$ hdfs dfs -cat /data/pxf_examples/pxf_hdfs_simple.txt
$ hdfs dfsadmin -report


## Set Replica Count
$ hdfs dfs -setrep -w 3 /data
$ hdfs dfs -setrep -R 2 /data


## List File Block Corrupted
$ hdfs fsck -list-corruptfileblocks


## FSCK
$ hdfs fsck /data -delete


## FSCK
$ hdfs fsck /data -locations -blocks -files


## Test
$ hadoop fs -text hdfs://rk9-node01:8020//data/pxf_examples/pxf_hdfs_simple.txt
text: Call From co7-master.jtest.pivotal.io/192.168.0.81 to rk9-master:8020 failed on connection exception: java.net.ConnectException: Connection refused; For more details see:  http://wiki.apache.org/hadoop/ConnectionRefused


## Test
$ hadoop fs -text hdfs://rk9-master:9000/data/pxf_examples/pxf_hdfs_simple.txt
Prague,Jan,101,4875.33
Rome,Mar,87,1557.39
Bangalore,May,317,8936.99
Beijing,Jul,411,11600.67


# Test
$ hdfs dfsadmin -triggerBlockReport rk9-node03:50020
Triggering a full block report on rk9-node03:50020.


# Test
$ hdfs dfsadmin -triggerBlockReport rk9-node03:50010
triggerBlockReport error: java.io.EOFException: End of File Exception between local host is: "rk9-master.jtest.pivotal.io/192.168.2.191"; destination host is: "rk9-node03":50010; : java.io.EOFException; For more details see:  http://wiki.apache.org/hadoop/EOFException


# Test
$ hdfs dfsadmin -triggerBlockReport rk9-node03.jtest.pivotal.io:50010
triggerBlockReport error: java.io.EOFException: End of File Exception between local host is: "rk9-master.jtest.pivotal.io/192.168.2.191"; destination host is: "rk9-node03.jtest.pivotal.io":50010; : java.io.EOFException; For more details see:  http://wiki.apache.org/hadoop/EOFException

# 50010 should be added in firewalld for finding BlockLocation searched by hdfs client which is pxf client in this case.

