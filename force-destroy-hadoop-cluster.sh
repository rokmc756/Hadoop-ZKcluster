#!/bin/bash

MASTER_HOSTNAME="rk9-node01"
ALL_HOSTS="rk9-node01 rk9-node02 rk9-node03 rk9-node04 rk9-node05"

# MASTER_HOSTNAME="rk9-master"
# $MASTER_HOSTNAME="rk9-master rk9-slave rk9-node01 rk9-node02 rk9-node03"
# MASTER_HOSTNAME="co7-master"
# ALL_HOSTS="co7-master co7-slave co7-node01 co7-node02 co7-node03"

sshpass -p "changeme" ssh root@$MASTER_HOSTNAME su "hadoop -c 'hadoop-daemon.sh stop zkfc'"
sshpass -p "changeme" ssh root@$MASTER_HOSTNAME su "hadoop -c 'stop-all.sh'"


for i in `echo "$ALL_HOSTS"`
do

    echo $i

    sshpass -p "changeme" ssh root@$i "groupdel hadoop; userdel hadoop"

    sshpass -p "changeme" ssh root@$i "rm -rf /home/hadoop"

    sshpass -p "changeme" ssh root@$i "rm -rf /home/zookeeper"

    sshpass -p "changeme" ssh root@$i "systemctl stop zookeeper"

    sshpass -p "changeme" ssh root@$i "killall java"

    sshpass -p "changeme" ssh root@$i "rm -rf /var/lib/zookeeper /var/log/zookeeper /tmp/zookeeper"

    sshpass -p "changeme" ssh root@$i "rm -rf /home/hadoop/* /tmp/*-hadoop-*.pid /usr/local/apache-zookeeper* /usr/local/kafka* /var/lib/zookeeper /var/log/zookeeper"

    sshpass -p "changeme" ssh root@$i "sync; echo 3 > /proc/sys/vm/drop_caches"

    echo $i

done

# sshpass -p "changeme" ssh root@$i "rm -rf /home/hadoop/* /tmp/*hadoop-hadoop-*.pid /usr/local/apache-zookeeper* /usr/local/kafka* /var/lib/zookeeper /var/log/zookeeper"

