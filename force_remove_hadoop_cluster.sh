#!/bin/bash

MASTER_HOSTNAME="rk8-master"
ALL_HOSTS="rk8-master rk8-slave rk8-node01 rk8-node02 rk8-node03"
# MASTER_HOSTNAME="rk9-master"
# $MASTER_HOSTNAME="rk9-master rk9-slave rk9-node01 rk9-node02 rk9-node03"
# MASTER_HOSTNAME="co7-master"
# ALL_HOSTS="co7-master co7-slave co7-node01 co7-node02 co7-node03"


ssh root@$MASTER_HOSTNAME su "hadoop -c 'hadoop-daemon.sh stop zkfc'"
ssh root@$MASTER_HOSTNAME su "hadoop -c 'stop-all.sh'"

# for i in `echo "rk8-master rk8-slave rk8-node01 rk8-node02 rk8-node03"`
for i in `echo "$ALL_HOSTS"`
do
    ssh root@$i "groupdel hadoop; userdel hadoop"
    ssh root@$i "rm -rf /home/hadoop/* /tmp/*hadoop-hadoop-*.pid /usr/local/apache-zookeeper* /usr/local/kafka* /var/lib/zookeeper /var/log/zookeeper"
    ssh root@$i "rm -rf /home/hadoop /home/zookeeper"
    ssh root@$i "systemctl stop zookeeper"
    ssh root@$i "killall java"
    ssh root@$i "rm -rf /var/lib/zookeeper /var/log/zookeeper /tmp/zookeeper"
    ssh root@$i "sync; echo 3 > /proc/sys/vm/drop_caches"
done
#    ssh root@$i "rm -rf /home/hadoop/* /tmp/*hadoop-hadoop-*.pid /usr/local/apache-zookeeper* /usr/local/kafka* /var/lib/zookeeper /var/log/zookeeper"
