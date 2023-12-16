## HDFS 2.x High Availability Cluster Architecture
In this blog, I am going to talk about HDFS 2.x High Availability Cluster Architecture and the procedure to set up an HDFS High Availability cluster. This is an important part of the Big Data course. The order in which the topics have been covered in this blog are as follows:

* HDFS HA Architecture
** Introduction
** NameNode Availability
** Architecture of HA
** Implementation of HA (JournalNode and Shared storage)
* How to set up HA (Quorum Journal Nodes) in a Hadoop cluster?

## Introduction:
The concept of High Availability cluster was introduced in Hadoop 2.x to solve the single point of failure problem in Hadoop 1.x. As you know from my previous blog that the HDFS Architecture follows Master/Slave Topology where NameNode acts as a master daemon and is responsible for managing other slave nodes called DataNodes. This single Master Daemon or NameNode becomes a bottleneck. Although, the introduction of Secondary NameNode did prevent us from data loss and offloading some of the burden of the NameNode but, it did not solve the availability issue of the NameNode.

## NameNode Availability:
If you consider the standard configuration of HDFS cluster, the NameNode becomes a single point of failure. It happens because the moment the NameNode becomes unavailable, the whole cluster becomes unavailable until someone restarts the NameNode or brings a new one.

The reasons for unavailability of NameNode can be:

* A planned event like maintenance work such has upgradation of software or hardware.
* It may also be due to an unplanned event where the NameNode crashes because of some reasons.
In either of the above cases, we have a downtime where we are not able to use the HDFS cluster which becomes a challenge. 

# HDFS HA Architecture:
Let us understand that how HDFS HA Architecture solved this critical problem of NameNode availability:

The HA architecture solved this problem of NameNode availability by allowing us to have two NameNodes in an active/passive configuration. So, we have two running NameNodes at the same time in a High Availability cluster:

* Active NameNode
* Standby/Passive NameNode.

