#!/bin/bash

HOSTS="co7-master co7-slave co7-node01 co7-node02 co7-node03"
# zone_name="public"

for i in `echo $HOSTS`
do
    # For 3.x
    ssh root@$i "systemctl stop firewalld"
done

exit


NN_HOSTS="co7-master co7-slave"
DN_HOSTS="co7-node01 co7-node02 co7-node03"
# zone_name="public"

for i in `echo $NN_HOSTS`
do
    # For 3.x
    ssh root@$i "systemctl start firewalld"
    ssh root@$i "firewall-cmd --add-port=9870/tcp --zone=public --permanent"
    ssh root@$i "firewall-cmd --reload"
    ssh root@$i "firewall-cmd --zone=public --list-ports"

done

for i in `echo $DN_HOSTS`
do
    # For 3.x
    ssh root@$i "systemctl start firewalld"
    ssh root@$i "firewall-cmd --add-port=9864/tcp --zone=public --permanent"
    ssh root@$i "firewall-cmd --add-port=9866/tcp --zone=public --permanent"
    ssh root@$i "firewall-cmd --add-port=9867/tcp --zone=public --permanent"
    ssh root@$i "firewall-cmd --reload"
    ssh root@$i "firewall-cmd --zone=public --list-ports"

done
exit

for i in `echo $HOSTS`
do
    # For 3.x
    # name nodes
    ssh root@$i "firewall-cmd --zone=public --add-port=9871/tcp"
    ssh root@$i "firewall-cmd --zone=public --add-port=9870/tcp"
    ssh root@$i "firewall-cmd --zone=public --add-port=9820/tcp"
    ssh root@$i "firewall-cmd --zone=public --add-port=9000/tcp"
    
    # Secondary NN
    ssh root@$i "firewall-cmd --zone=public --add-port=9869/tcp"
    ssh root@$i "firewall-cmd --zone=public --add-port=9868/tcp"

    # Datanode
    ssh root@$i "firewall-cmd --zone=public --add-port=9867/tcp"
    ssh root@$i "firewall-cmd --zone=public --add-port=9866/tcp"
    ssh root@$i "firewall-cmd --zone=public --add-port=9865/tcp"
    ssh root@$i "firewall-cmd --zone=public --add-port=9864/tcp"
    ssh root@$i "firewall-cmd --reload"
done

exit

# https://vnvn31.tistory.com/entry/Hadoop-23%EB%B2%84%EC%A0%84-port-list-%EC%A0%95%EB%A6%AC
#
for i in `echo $HOSTS`
do
    # For 2.x
    # name nodes
    ssh root@$i "firewall-cmd --zone=public --add-port=50470/tcp"
    ssh root@$i "firewall-cmd --zone=public --add-port=50070/tcp"
    ssh root@$i "firewall-cmd --zone=public --add-port=8020/tcp"
    ssh root@$i "firewall-cmd --zone=public --add-port=9000/tcp"
    
    # Secondary NN
    ssh root@$i "firewall-cmd --zone=public --add-port=50091/tcp"
    ssh root@$i "firewall-cmd --zone=public --add-port=50090/tcp"

    # Datanode
    ssh root@$i "firewall-cmd --zone=public --add-port=50020/tcp"
    ssh root@$i "firewall-cmd --zone=public --add-port=50010/tcp"
    ssh root@$i "firewall-cmd --zone=public --add-port=50475/tcp"
    ssh root@$i "firewall-cmd --zone=public --add-port=50075/tcp"
    ssh root@$i "firewall-cmd --reload"
done
