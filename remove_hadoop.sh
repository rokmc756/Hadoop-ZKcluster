#!/bin/bash

ssh root@mdw7 su "hadoop -c 'hadoop-daemon.sh stop zkfc'"
ssh root@mdw7 su "hadoop -c 'stop-all.sh'"

for i in `echo "mdw7 smdw7 sdw7-01 sdw7-02 sdw7-03"`
do
    ssh root@$i "rm -rf /home/hadoop/* /tmp/*hadoop-hadoop-*.pid"
    ssh root@$i "systemctl stop zookeeper"
    ssh root@$i "killall java"
    ssh root@$i "sync; echo 3 > /proc/sys/vm/drop_caches"
done

