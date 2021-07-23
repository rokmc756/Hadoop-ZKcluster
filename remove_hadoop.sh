#!/bin/bash

ssh root@mdw6 su "hadoop -c 'hadoop-daemon.sh stop zkfc'"
ssh root@mdw6 su "hadoop -c 'stop-all.sh'"

for i in `echo "mdw6 smdw6 sdw6-01 sdw6-02 sdw6-03"`
do
    ssh root@$i "rm -rf /home/hadoop/* /tmp/*hadoop-hadoop-*.pid"
    ssh root@$i "systemctl stop zookeeper"
    ssh root@$i "killall java"
    ssh root@$i "sync; echo 3 > /proc/sys/vm/drop_caches"
done
