### WHat is Hadoop-ZKcluster
The Hadoop-ZKcluster is Ansible Playbook to Deploy Hadoop and Zookeeper Cluster and Hbase/Hive/Spark/Ganglia on Baremetal, Virtual Machines and Cloud Infrastructure.
The intention of this playbook is to deploy Hadoop Cluster quickly in order to reproduce or simulate issues which occurs between Greenplum Database and PXF.

### Hadoop-ZKcluster Architecture
It implements HDFS HA architecture described at the below link and Hadoop-ZKcluster Architecture and you could see details about how it works.
* https://www.edureka.co/blog/how-to-set-up-hadoop-cluster-with-hdfs-high-availability/

#### HDFS HA Architecture
The HDFS HA Architecture solve critical problem of NameNode availability by allowing us to have two NameNodes in an active/passive configuration.
So, there are two running NameNodes at the same time in a High Availability cluster:
- Active NameNode
- Standby/Passive NameNode.
<p align="center">
<img src="https://github.com/rokmc756/Hadoop-ZKcluster/blob/main/roles/hadoop/images/HDFS-HA-Architecture-Edureka-768x473.png" width="70%" height="70%">
</p>
If one NameNode goes down, the other NameNode can take over the responsibility and therefore, reduce the cluster down time. The standby NameNode serves the purpose of a backup NameNode (unlike the Secondary NameNode) which incorporate failover capabilities to the Hadoop cluster.<br>
<br>
Therefore, with the StandbyNode, we can have automatic failover whenever a NameNode crashes (unplanned event) or we can have a graceful (manually initiated) failover during the maintenance period.<br>
<br>
There are two issues in maintaining consistency in the HDFS High Availability cluster
Active and Standby NameNode should always be in sync with each other, i.e. They should have the same metadata. This will allow us to restore the Hadoop cluster to the same namespace state where it got crashed and therefore, will provide us to have fast failover.
There should be only one active NameNode at a time because two active NameNode will lead to corruption of the data. This kind of scenario is termed as a split-brain scenario where a cluster gets divided into smaller cluster, each one believing that it is the only active cluster.
<br>
To avoid such scenarios fencing is done. Fencing is a process of ensuring that only one NameNode remains active at a particular time.<br>

#### Implementation of HA Architecture
Now, you know that in HDFS HA Architecture, we have two NameNodes running at the same time. So, we can implement the Active and Standby NameNode configuration in following two ways:
* Using Quorum Journal Nodes
* Shared Storage using NFS
Let us understand these two ways of implementation taking one at a time
##### Using Quorum Journal Nodes
<p align="center">
<img src="https://github.com/rokmc756/Hadoop-ZKcluster/blob/main/roles/hadoop/images/JournalNode-HDFS-HA-Architecture-Edureka-768x440.png" width="80%" height="80%">
</p>
The standby NameNode and the active NameNode keep in sync with each other through a separate group of nodes or daemons -called JournalNodes.
The JournalNodes follows the ring topology where the nodes are connected to each other to form a ring.
The JournalNode serves the request coming to it and copies the information into other nodes in the ring.This provides fault tolerance in case of JournalNode failure.
The active NameNode is responsible for updating the EditLogs (metadata information) present in the JournalNodes.
The StandbyNode reads the changes made to the EditLogs in the JournalNode and applies it to its own namespace in a constant manner.
During failover, the StandbyNode makes sure that it has updated its meta data information from the JournalNodes before becoming the new Active NameNode.
This makes the current namespace state synchronized with the state before failover.
The IP Addresses of both the NameNodes are available to all the DataNodes and they send their heartbeats and block location information to both the NameNode.
This provides a fast failover (less down time) as the StandbyNode has an updated information about the block location in the cluster.

#### Fencing of NameNode
Now, as discussed earlier, it is very important to ensure that there is only one Active NameNode at a time. So, fencing is a process to ensure this very property in a cluster. 

The JournalNodes performs this fencing by allowing only one NameNode to be the writer at a time.
The Standby NameNode takes over the responsibility of writing to the JournalNodes and forbid any other NameNode to remain active.
Finally, the new Active NameNode can perform its activities safely.

##### Using Shared Storage
<p align="center">
<img src="https://github.com/rokmc756/Hadoop-ZKcluster/blob/main/roles/hadoop/images/Shared-Storage-HDFS-HA-Architecture-Edureka-768x344.png" width="80%" height="80%">
</p>
The StandbyNode and the active NameNode keep in sync with each other by using a shared storage device.
The active NameNode logs the record of any modification done in its namespace to an EditLog present in this shared storage.
The StandbyNode reads the changes made to the EditLogs in this shared storage and applies it to its own namespace.
Now, in case of failover, the StandbyNode updates its metadata information using the EditLogs in the shared storage at first.
Then, it takes the responsibility of the Active NameNode. This makes the current namespace state synchronized with the state before failover.
The administrator must configure at least one fencing method to avoid a split-brain scenario.
The system may employ a range of fencing mechanisms. It may include killing of the NameNode’s process and revoking its access to the shared storage directory.
As a last resort, we can fence the previously active NameNode with a technique known as STONITH, or “shoot the other node in the head”.
STONITH uses a specialized power distribution unit to forcibly power down the NameNode machine.

#### Automatic Failover
Failover is a procedure by which a system automatically transfers control to secondary system when it detects a fault or failure. There are two types of failover:
1) Graceful Failover: In this case, we manually initiate the failover for routine maintenance.
2) Automatic Failover: In this case, the failover is initiated automatically in case of NameNode failure (unplanned event).

Apache Zookeeper is a service that provides the automatic failover capability in HDFS High Availabilty cluster.
It maintains small amounts of coordination data, informs clients of changes in that data, and monitors clients for failures.
Zookeeper maintains a session with the NameNodes. In case of failure, the session will expire and the Zookeeper will inform other NameNodes to initiate the failover process.
In case of NameNode failure, other passive NameNode can take a lock in Zookeeper stating that it wants to become the next Active NameNode.
The ZookeerFailoverController (ZKFC) is a Zookeeper client that also monitors and manages the NameNode status. Each of the NameNode runs a ZKFC also.
ZKFC is responsible for monitoring the health of the NameNodes periodically.
Now that you have understood what is High Availability in a Hadoop cluster,
it’s time to set it up. To set up High Availability in Hadoop cluster you have to use Zookeeper in all the nodes.

The daemons in Active NameNode are:
* Zookeeper
* Zookeeper Fail Over controller
* JournalNode
* NameNode

The daemons in Standby NameNode are:
* Zookeeper
* Zookeeper Fail Over controller
* JournalNode
* NameNode

The daemons in DataNode are:
* Zookeeper
* JournalNode
* DataNode

### Where is Haddop Zookeeper from and what / how is it changed?
The hadoop-zkcluster has been developing based on hadoop-ansible project - https://github.com/pippozq/hadoop-ansible. pippozq! Thanks for sharing it.
The ansible role for zookeepr is added, variables of many roles is integrated into role/hadoop/var/main.yml and hosts/host is removed and ansible-host is added instead for efficiency and convenience.

### Supported versions of Platform and OS
These are only confirmed as the latest version currently and other version will be done or added soon or later
* CentOS 7.x, Rocky Linux 7.x, 8.x, 9.x
* openjdk-1.8 and 1.11 and 1.17
* Hadoop 3.3.1 ~ 6
* Hive 4.0.1
* Hbase 2.6.0
* Spark 3.5.4
* Ganglia
* Zookeeper 3.9.3

### Prerequiste
Use DNS Server or update /etc/hosts for all servers.
Passworless SSH for hadoop, root for ansible hosts may help to control.

### How to configure ansible-hosts, role/hadoop/var/main.yml to deploy hadoop-zkcluster?
##### 1) Configure hostname / ip addresses and username to run for ansible-hosts
```yaml
$ vi ansible-hosts-rk9
[all:vars]
ssh_key_filename="id_rsa"
remote_machine_username="jomoon"
remote_machine_password="changeme"

[master]
rk9-node01 ansible_ssh_host=192.168.2.191 zk_id=1

[standby]
rk9-node02 ansible_ssh_host=192.168.2.192 zk_id=2

[workers]
rk9-node03 ansible_ssh_host=192.168.2.193 zk_id=3 rm_ids=rm1
rk9-node04 ansible_ssh_host=192.168.2.194 zk_id=4 rm_ids=rm2
rk9-node05 ansible_ssh_host=192.168.2.195 zk_id=5 rm_ids=rm3

# These are your zookeeper cluster nodes
[zk_servers]
rk9-node01 ansible_ssh_host=192.168.2.191 zk_id=1
rk9-node02 ansible_ssh_host=192.168.2.192 zk_id=2
rk9-node03 ansible_ssh_host=192.168.2.193 zk_id=3 rm_ids=rm1
rk9-node04 ansible_ssh_host=192.168.2.194 zk_id=4 rm_ids=rm2
rk9-node05 ansible_ssh_host=192.168.2.195 zk_id=5 rm_ids=rm3

[database]
rk9-node06 ansible_ssh_host=192.168.2.196 zk_id=6

[hive]
rk9-node01 ansible_ssh_host=192.168.2.191 zk_id=1 rm_ids=rm1
```

##### 2) Configure user/group, hadoop version and location to download in group_vars/all.yml
```yaml
$ vi group_vars/all.yml
~~snip
_hadoop:
  user: hadoop
  group: hadoop
  domain: "jtest.pivotal.io"
  hdfs_port: 9000
  base_path: "/home/hadoop"
  download: false
  firewall: false
  download_path: /tmp
  major_version: "3"
  minor_version: "3"
  patch_version: "6"
  bin_type: "tar.gz"
  download_url: "https://dlcdn.apache.org/hadoop/common"
  net:
    type: "virtual"                # Or Physical
    gateway: "192.168.0.1"
    ipaddr0: "192.168.0.19"
    ipaddr1: "192.168.1.19"
    ipaddr2: "192.168.2.19"
  dashboard:
    port: 9870
  dfs:
    namenode_httpport: 9001
    nameservices: "ha-cluster"
  yarn:
    cluster_id: "my-yarn-cluster"
    resmgr_port: 8040
    resmgr_scheduler_port: 8030
    resmgr_webapp_port: 8088
    resmgr_tracker_port: 8025
    resmgr_admin_port: 8141
~~ snip
```

##### 3) Configure version / location to download & install / log_path / data_path of Zookeeper
```yaml
$ vi group_vars/all.yml
~~ snip
_zookeeper:
  user: zookeeper
  group: zookeeper
  major_version: 3
  minor_version: 9
  patch_version: 3
  base_path: /usr/local
  download: false
  download_url: http://apache.rediris.es/zookeeper
  download_path: /tmp
  config:
    port: 2181
    log_path: /usr/local/apache-zookeeper/log
    data_dir: /usr/local/apache-zookeeper/data
    tick_time: 2000
    init_limit: 5
    sync_limit: 2
  use_internal_zookeeper: false
  # log_path: /var/log/zookeeper
  # data_dir: /var/lib/zookeeper
  net:
    type: "virtual"                # Or Physical
    gateway: "192.168.0.1"
    ipaddr0: "192.168.0.19"
    ipaddr1: "192.168.1.19"
    ipaddr2: "192.168.2.19"
~~ snip
_jdk:
  oss:
    install: true
    jvm_home: "/usr/lib/jvm"
    major_version: 1
    minor_version: 8
    patch_version: 0
    # 1.8.0
    # 11.0.4
    # 17.0.2
  oracle:
    install: false
    jvm_home: "/usr/lib/jvm"
    major_version: 13
    minor_version: 0
    patch_version: 2
    download: false
~~ snip
```

### Download All Software Binaries
```yaml
$ make download
```

### How to Install and Deploy Hadoop Zookeeper Cluster
```yaml
$ make hadoop r=disable s=firewall
$ make hadoop r=create s=user
$ make hadoop r=fetch s=key
$ make hadoop r=add s=key
$ make hadoop r=setup s=serivce
$ make hadoop r=config s=serivce
$ make hadoop r=start s=journal
$ make hadoop r=format s=master
$ make hadoop r=start s=master
$ make hadoop r=copy s=metadata
$ make hadoop r=bootstrap s=standby
$ make hadoop r=start s=standby
$ make hadoop r=start s=datanode
$ make hadoop r=format s=zkfc
$ make hadoop r=start s=yarn
$ make hadoop r=start s=yrm

or
# For at once
$ make hadoop r=install s=all
```

### How to Uninstall Hadoop
```yaml
$ make hadoop r=stop s=service
$ make hadoop r=remove s=config
$ make hadoop r=remove s=key
$ make hadoop r=remove s=user
$ make hadoop r=remove s=user
$ make hadoop r=enable s=firewall

or
For at once
$ make hadoop r=uninstall s=all
```

### How to Start and Stop Hadoop Service
```yaml
$ make hadoop r=start s=cluster

or
$ make hadoop r=stop s=cluster
```

### Relervent Services
* [Hive](https://github.com/rokmc756/Hadoop-ZKcluster/blob/main/roles/hive/README.md)
* [HBase](https://github.com/rokmc756/Hadoop-ZKcluster/blob/main/roles/hbase/README.md)
* [Spark](https://github.com/rokmc756/Hadoop-ZKcluster/blob/main/roles/spark/README.md)
* [Cassandra](https://github.com/rokmc756/Hadoop-ZKcluster/blob/main/roles/cassandra/README.md)
* [Ganglia](https://github.com/rokmc756/Hadoop-ZKcluster/blob/main/roles/ganglia/README.md)

### Planning
- [ ] A few variables for yarn-resource-manager, etc in group_vars/all.yml need to modify to arrange at once.
- [ ] hdfs getconf -secondaryNameNodes : Incorrect configuration: secondary namenode address dfs.namenode.secondary.http-address is not configured.
- [ ] Need to fix issue that starting gmond got network(eth2) failed

### License
GNU General Public License v3.0

### References
- https://hadoop.apache.org/docs/r2.7.1/hadoop-project-dist/hadoop-hdfs/HDFSHighAvailabilityWithQJM.html
- https://github.com/locp/ansible-role-cassandra
- https://github.com/wireapp/ansible-cassandra

