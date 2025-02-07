## WHat is Hadoop Zookeeper Cluster
The Hadoop-ZKcluster is Ansible Playbook to Deploy Hadoop and Zookeeper Cluster and Hbase/Hive/Spark/Ganglia on Baremetal, Virtual Machines and Cloud Infrastructure.
It implements HDFS HA architecture described at the below doc and you could see details about how it works.
* https://www.edureka.co/blog/how-to-set-up-hadoop-cluster-with-hdfs-high-availability/

The intention of this playbook is to deploy Hadoop Cluster quickly in order to reproduce or simulate issues which occurs between Greenplum Database and PXF.


## Hadoop-ZKcluster Architecture
![alt text](https://github.com/rokmc756/Hadoop-ZKcluster/blob/main/roles/hadoop/images/HDFS-HA-Architecture-Edureka-768x473.png)
![alt text](https://github.com/rokmc756/Hadoop-ZKcluster/blob/main/roles/hadoop/images/JournalNode-HDFS-HA-Architecture-Edureka-768x440.png)
![alt text](https://github.com/rokmc756/Hadoop-ZKcluster/blob/main/roles/hadoop/images/Shared-Storage-HDFS-HA-Architecture-Edureka-768x344.png)


## Where is Haddop Zookeeper from and what / how is it changed?
The hadoop-zkcluster has been developing based on hadoop-ansible project - https://github.com/pippozq/hadoop-ansible. pippozq! Thanks for sharing it.
The ansible role for zookeepr is added, variables of many roles is integrated into role/hadoop/var/main.yml and hosts/host is removed and ansible-host is added instead for efficiency and convenience.

As the below two variables in group_vars/all.yml is added many hosts could be automatically configured conveniently.
```yaml
zkservers_list: "{{ groups['all'] | map('extract', hostvars, ['ansible_fqdn']) | map('regex_replace', '$', ':2181') | join(',') }}"
qjournal_list: "{{ groups['all'] | map('extract', hostvars, ['ansible_hostname']) | map('regex_replace', '$', '.jtest.pivotal.io:8485') | join(';') }}"
```
In role of haddop a few playbooks are added / modified to start hdfs services and seperate whether these are defined or not in deploly-hadoop-zookeeper.yml playbook.

## Supported versions of Platform and OS
These are only confirmed as the latest version currently and other version will be done or added soon or later
* CentOS 7.x, Rocky Linux 7.x, 8.x, 9.x
* openjdk-1.8 and 1.11 and 1.17
* Hadoop 3.3.1 ~ 6
* Hive 3.1.2
* ansible-zookeeper 3.7.0

## Prerequiste
Use DNS Server or update /etc/hosts for all servers.
Passworless SSH for hadoop, root for ansible hosts may help to control.

## How to configure ansible-hosts, role/hadoop/var/main.yml to deploy hadoop-zkcluster?
#### 1) Configure hostname / ip addresses and username to run for ansible-hosts
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

#### 2) Configure user/group, hadoop version and location to download in group_vars/all.yml
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

#### 3) Configure version / location to download & install / log_path / data_path of Zookeeper
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

## How to Install and Deploy Hadoop Zookeeper Cluster
```yaml
$ make hadoop r=disable s=firewall
$ make hadoop r=create s=user
$ make hadoop r=fetch s=key
$ make hadoop r=add s=key
$ make hadoop r=setup s=hadoop
$ make hadoop r=config s=hadoop
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

## How to Uninstall Hadoop
```yaml
$ make hadoop r=stop s=hadoop
$ make hadoop r=remove s=hadoop
$ make hadoop r=remove s=key
$ make hadoop r=remove s=user
$ make hadoop r=remove s=user
$ make hadoop r=enable s=firewall

or
For at once
$ make hadoop r=uninstall s=all
```

# How to Start and Stop Hadoop Service
```yaml
$ make hadoop r=start s=hdfs

or
$ make hadoop r=stop s=hdfs
```

- roles/hive/README.md
- role/hbase/README.md
- role/spark/README.md
- role/ganglia/README.md


## Planning
- [ ] A few variables for yarn-resource-manager, etc in group_vars/all.yml need to modify to arrange at once.
- [ ] hdfs getconf -secondaryNameNodes : Incorrect configuration: secondary namenode address dfs.namenode.secondary.http-address is not configured.
- [ ] Need to fix issue that starting gmond got network(eth2) failed
~~~

## License
GNU General Public License v3.0


## References
- https://hadoop.apache.org/docs/r2.7.1/hadoop-project-dist/hadoop-hdfs/HDFSHighAvailabilityWithQJM.html
- https://github.com/locp/ansible-role-cassandra
- https://github.com/wireapp/ansible-cassandra

