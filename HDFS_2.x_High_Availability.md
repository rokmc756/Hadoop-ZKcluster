## HDFS 2.x High Availability Cluster Architecture
This page is about HDFS 2.x High Availability Cluster Architecture and the procedure to set up an HDFS High Availability cluster. This is an important part of the Big Data course. The order in which the topics have been covered in this blog are as follows:

### HDFS HA Architecture
* Introduction
* NameNode Availability
* Architecture of HA
* Implementation of HA (JournalNode and Shared storage)
## How to set up HA (Quorum Journal Nodes) in a Hadoop cluster?

## Introduction:
The concept of High Availability cluster was introduced in Hadoop 2.x to solve the single point of failure problem in Hadoop 1.x. As you know from my previous blog that the HDFS Architecture follows Master/Slave Topology where NameNode acts as a master daemon and is responsible for managing other slave nodes called DataNodes. This single Master Daemon or NameNode becomes a bottleneck. Although, the introduction of Secondary NameNode did prevent us from data loss and offloading some of the burden of the NameNode but, it did not solve the availability issue of the NameNode.

## NameNode Availability:
If you consider the standard configuration of HDFS cluster, the NameNode becomes a single point of failure. It happens because the moment the NameNode becomes unavailable, the whole cluster becomes unavailable until someone restarts the NameNode or brings a new one.

The reasons for unavailability of NameNode can be:

* A planned event like maintenance work such has upgradation of software or hardware.
* It may also be due to an unplanned event where the NameNode crashes because of some reasons.
In either of the above cases, we have a downtime where we are not able to use the HDFS cluster which becomes a challenge. 

## HDFS HA Architecture:
Let us understand that how HDFS HA Architecture solved this critical problem of NameNode availability:

The HA architecture solved this problem of NameNode availability by allowing us to have two NameNodes in an active/passive configuration. So, we have two running NameNodes at the same time in a High Availability cluster:

* Active NameNode
* Standby/Passive NameNode.
![alt text](https://github.com/rokmc756/hadoop-zkcluster/blob/main/roles/hadoop/images/HDFS-HA-Architecture-Edureka-768x473.png)

If one NameNode goes down, the other NameNode can take over the responsibility and therefore, reduce the cluster down time. The standby NameNode serves the purpose of a backup NameNode (unlike the Secondary NameNode) which incorporate failover capabilities to the Hadoop cluster. Therefore, with the StandbyNode, we can have automatic failover whenever a NameNode crashes (unplanned event) or we can have a graceful (manually initiated) failover during the maintenance period. 

There are two issues in maintaining consistency in the HDFS High Availability cluster:

* Active and Standby NameNode should always be in sync with each other, i.e. They should have the same metadata. This will allow us to restore the Hadoop cluster to the same namespace state where it got crashed and therefore, will provide us to have fast failover.
* There should be only one active NameNode at a time because two active NameNode will lead to corruption of the data. This kind of scenario is termed as a split-brain scenario where a cluster gets divided into smaller cluster, each one believing that it is the only active cluster. To avoid such scenarios fencing is done. Fencing is a process of ensuring that only one NameNode remains active at a particular time.

## Implementation of HA Architecture:
Now, you know that in HDFS HA Architecture, we have two NameNodes running at the same time. So, we can implement the Active and Standby NameNode configuration in following two ways:

* Using Quorum Journal Nodes
* Shared Storage using NFS
Let us understand these two ways of implementation taking one at a time:

1. Using Quorum Journal Nodes:
![alt text](https://github.com/rokmc756/hadoop-zkcluster/blob/main/roles/hadoop/images/JournalNode-HDFS-HA-Architecture-Edureka-768x440.png)

* The standby NameNode and the active NameNode keep in sync with each other through a separate group of nodes or daemons -called JournalNodes. The JournalNodes follows the ring topology where the nodes are connected to each other to form a ring. The JournalNode serves the request coming to it and copies the information into other nodes in the ring.This provides fault tolerance in case of JournalNode failure. 
* The active NameNode is responsible for updating the EditLogs (metadata information) present in the JournalNodes.
* The StandbyNode reads the changes made to the EditLogs in the JournalNode and applies it to its own namespace in a constant manner.
* During failover, the StandbyNode makes sure that it has updated its meta data information from the JournalNodes before becoming the new Active NameNode. This makes the current namespace state synchronized with the state before failover.
* The IP Addresses of both the NameNodes are available to all the DataNodes and they send their heartbeats and block location information to both the NameNode. This provides a fast failover (less down time) as the StandbyNode has an updated information about the block location in the cluster.

## Fencing of NameNode:
Now, as discussed earlier, it is very important to ensure that there is only one Active NameNode at a time. So, fencing is a process to ensure this very property in a cluster. 

* The JournalNodes performs this fencing by allowing only one NameNode to be the writer at a time.
* The Standby NameNode takes over the responsibility of writing to the JournalNodes and forbid any other NameNode to remain active.
* Finally, the new Active NameNode can perform its activities safely.

2. Using Shared Storage:
![alt text](https://github.com/rokmc756/hadoop-zkcluster/blob/main/roles/hadoop/images/Shared-Storage-HDFS-HA-Architecture-Edureka-768x344.png)

* The StandbyNode and the active NameNode keep in sync with each other by using a shared storage device. The active NameNode logs the record of any modification done in its namespace to an EditLog present in this shared storage. The StandbyNode reads the changes made to the EditLogs in this shared storage and applies it to its own namespace.
* Now, in case of failover, the StandbyNode updates its metadata information using the EditLogs in the shared storage at first. Then, it takes the responsibility of the Active NameNode. This makes the current namespace state synchronized with the state before failover.
* The administrator must configure at least one fencing method to avoid a split-brain scenario.
* The system may employ a range of fencing mechanisms. It may include killing of the NameNode’s process and revoking its access to the shared storage directory.
* As a last resort, we can fence the previously active NameNode with a technique known as STONITH, or “shoot the other node in the head”. STONITH uses a specialized power distribution unit to forcibly power down the NameNode machine.
## Automatic Failover:
Failover is a procedure by which a system automatically transfers control to secondary system when it detects a fault or failure. There are two types of failover:

## Graceful Failover
In this case, we manually initiate the failover for routine maintenance.

## Automatic Failover
In this case, the failover is initiated automatically in case of NameNode failure (unplanned event).

Apache Zookeeper is a service that provides the automatic failover capability in HDFS High Availabilty cluster. It maintains small amounts of coordination data, informs clients of changes in that data, and monitors clients for failures. Zookeeper maintains a session with the NameNodes. In case of failure, the session will expire and the Zookeeper will inform other NameNodes to initiate the failover process. In case of NameNode failure, other passive NameNode can take a lock in Zookeeper stating that it wants to become the next Active NameNode.

The ZookeerFailoverController (ZKFC) is a Zookeeper client that also monitors and manages the NameNode status. Each of the NameNode runs a ZKFC also. ZKFC is responsible for monitoring the health of the NameNodes periodically.

Now that you have understood what is High Availability in a Hadoop cluster, it’s time to set it up. To set up High Availability in Hadoop cluster you have to use Zookeeper in all the nodes.

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

If you wish to master HDFS and Hadoop, check out the specially curated Big Data certification course by Edureka. Click on the button below to get started.
