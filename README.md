## WHat is Hadoop Zookeeper Cluster
The hadoop-zkcluster is ansible playbook to deploy Hadoop/Hive and Zookeeper cluster on Baremetal, Virtual Machines and Cloud Infrastructure.
It implements HDFS HA architecture described at the below doc and you could see details about how it works.
* https://www.edureka.co/blog/how-to-set-up-hadoop-cluster-with-hdfs-high-availability/

The intention of this playbook is to deploy Hadoop Cluster quickly in order to reproduce or simulate issues which occurs between Greenplum Database and PXF.

## Where is Haddop Zookeeper from and what / how is it changed?
The hadoop-zkcluster has been developing based on hadoop-ansible project - https://github.com/pippozq/hadoop-ansible. pippozq! Thanks for sharing it.
The ansible role for zookeepr is added, variables of many roles is integrated into role/hadoop/var/main.yml and hosts/host is removed and ansible-host is added instead for efficiency and convenience.

As the below two variables in group_vars/all.yml is added many hosts could be automatically configured conveniently.
```
zkservers_list: "{{ groups['all'] | map('extract', hostvars, ['ansible_fqdn']) | map('regex_replace', '$', ':2181') | join(',') }}"
qjournal_list: "{{ groups['all'] | map('extract', hostvars, ['ansible_hostname']) | map('regex_replace', '$', '.jtest.pivotal.io:8485') | join(';') }}"
```
In role of haddop a few playbooks are added / modified to start hdfs services and seperate whether these are defined or not in deploly-hadoop-zookeeper.yml playbook.

## Supported versions of Platform and OS
These are only confirmed as the latest version currently and other version will be done or added soon or later
* CentOS 7.x, Rocky Linux 7.x, 8.x, 9.x
* openjdk-1.8
* Hadoop 3.3.1 ~ 4
* Hive 3.1.2
* ansible-zookeeper 3.7.0

## Prerequiste
Use DNS Server or update /etc/hosts for all servers.
Passworless SSH for hadoop, root for ansible hosts may help to control.

## How to configure ansible-hosts, role/hadoop/var/main.yml to deploy hadoop-zkcluster?
#### 1) Configure hostname / ip addresses and username to run for ansible-hosts
```
$ vi ansible-hosts
[all:vars]
ssh_key_filename="id_rsa"
remote_machine_username="jomoon"
remote_machine_password="changeme"

[master]
rk9-node01 ansible_ssh_host=192.168.0.71 zk_id=1

[standby]
rk9-node02 ansible_ssh_host=192.168.0.72 zk_id=2

[workers]
rk9-node03 ansible_ssh_host=192.168.0.73 zk_id=3 rm_ids=rm1
rk9-node04 ansible_ssh_host=192.168.0.74 zk_id=4 rm_ids=rm2
rk9-node05 ansible_ssh_host=192.168.0.75 zk_id=5 rm_ids=rm3

# These are your zookeeper cluster nodes
[zk_servers]
rk9-node01 ansible_ssh_host=192.168.0.71 zk_id=1
rk9-node02 ansible_ssh_host=192.168.0.72 zk_id=2
rk9-node03 ansible_ssh_host=192.168.0.73 zk_id=3 rm_ids=rm1
rk9-node04 ansible_ssh_host=192.168.0.74 zk_id=4 rm_ids=rm2
rk9-node05 ansible_ssh_host=192.168.0.75 zk_id=5 rm_ids=rm3

[database]
rk9-node06 ansible_ssh_host=192.168.0.76

[hive]
rk9-node01 ansible_ssh_host=192.168.0.71 zk_id=1

```
#### 2) Configure user/group, hadoop version and location to download in group_vars/all.yml
```
$ vi group_vars/all.yml
ansible_ssh_pass: "changeme"
ansible_become_pass: "changeme"

hadoop:
  user: hadoop
  group: hadoop
  domain: "jtest.pivotal.io"
  hdfs_port: 9000
  base_path: "/home/hadoop"
  download: true
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
    ipaddr0: "192.168.0.7"
    ipaddr1: "192.168.1.7"
    ipaddr2: "192.168.2.7"
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
```
$ vi roles/zookeeper/vars/main.yml
package_download_path : "/tmp"
zookeeper:
  version: 3.8.0
  installation_path: /usr/local
  download_zookeeper: false
  download_mirror: http://apache.rediris.es/zookeeper
  configuration:
    port: 2181
    log_path: /var/log/zookeeper
    data_dir: /var/lib/zookeeper
    tick_time: 2000
    init_limit: 5
    sync_limit: 2
    max_client_cnxns: 100
    max_session_timeout: 180000
  use_internal_zookeeper: 1
java:
  version: 1.8.0.352
  installation_path: /usr/lib/jvm/java-1.8.0-openjdk
  build: b08
  platform: x86_64
  priority: 100
#  download_mirror: http://download.oracle.com/otn-pub/java/jdk
#  download_cookies: "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie"
~~ snip
```
#### 4) Configure varialbes such as download location, versions, install/config path, informations of postgresql databbase for Hive in role/hive/var/main.yml
```
$ vi group_vars/all.yml
hive:
  user: "{{ hadoop.user }}"
  group: "{{ hadoop.group }}"
  download: true
  firewall: false
  major_version: 3
  minor_version: 1
  patch_version: 3
  bin_type: tar.gz
  download_url: "https://dlcdn.apache.org/hive"
  base_path: "{{ hadoop.base_path }}"
  default_path: "/user/hive"
  tmp_path: "{{ hadoop.base_path }}/hive/tmp"
  server_port: 10000
  hwi_port: 9999
  metastore_port: 9083
  net:
    type: "virtual"                # Or Physical
    gateway: "192.168.0.1"
    ipaddr0: "192.168.0.7"
    ipaddr1: "192.168.1.7"
    ipaddr2: "192.168.2.7"
~~  snip
postgres:
  firewall: false
  net:
    type: "virtual"                # Or Physical
    gateway: "192.168.0.1"
    ipaddr0: "192.168.0.7"
    ipaddr1: "192.168.1.7"
    ipaddr2: "192.168.2.7"
~~ snip
```
#### 5) The below query file is useful to remove all tables in hive database before running playbook.
```
$ vi drop_all_tables.sql
CREATE FUNCTION drop_all_tables() RETURNS void AS $$
DECLARE
    tmp VARCHAR(512);
DECLARE names CURSOR FOR
    select tablename from pg_tables where schemaname='public';
BEGIN
  FOR stmt IN names LOOP
    tmp := 'DROP TABLE '|| quote_ident(stmt.tablename) || ' CASCADE;';
    RAISE NOTICE 'notice: %', tmp;
    EXECUTE 'DROP TABLE '|| quote_ident(stmt.tablename) || ' CASCADE;';
  END LOOP;
  RAISE NOTICE 'finished .....';
END;

$$ LANGUAGE plpgsql;

select drop_all_tables();```
```

## Run to remove tables in a specific database
```
$ psql -h 192.168.0.76 -U hive_user -d hive_testdb -p 5432 -f drop_all_tables.sql
```

## How to Install and Deploy Hadoop Cluster
```
$ make hadoop r=install
```
## How to Install and Deploy Postgres Database
```
$ make postgres r=install
```
## How to Install and Deploy Hive
```
$ make hive r=install
```
## How to Install and Deploy Spark
```
$ make spark r=install
```
## How to Install and Deploy Ganglia
```
$ make ganglia r=install
```


## How to Deploy All Software Components for Hadoop at Once
```
$ make deploy
```


## How to Uninstall Ganglia
```
$ make ganglia r=uninstall
```
## How to Uninstall Hbase
```
$ make hbase r=uninstall
```
## How to Uninstall Spark
```
$ make spark r=uninstall
```
## How to uninstall Hive
```
$ make hive r=uninstall
```
## How to Uninstall Postgres Database
```
$ make postgres r=uninstall
```
## How to Uninstall Hadoop
```
$ make hadoop r=uninstall
```

## How to Destroy All Software Components for Hadoop at Once
```
$ make destory
```


## Planning
A few variables for yarn-resource-manager, etc in group_vars/all.yml need to modify to arrange at once.

## License
GNU General Public License v3.0

## References
https://hadoop.apache.org/docs/r2.7.1/hadoop-project-dist/hadoop-hdfs/HDFSHighAvailabilityWithQJM.html
