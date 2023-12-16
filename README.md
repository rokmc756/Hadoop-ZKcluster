## WHat is Hadoop Zookeeper Cluster
Hadoop-zkcluster is ansible playbook to deploy Hadoop / Hive and Zookeeper cluster on Baremetal, Virtual Machines and Cloud Infrastructure.
It implements HDFS HA architecture described at the below doc and you could see details about how it works.
* https://www.edureka.co/blog/how-to-set-up-hadoop-cluster-with-hdfs-high-availability/

## Where is Haddop Zookeeper from and what / how is it changed?
Hadoop-zkcluster has been developing based on hadoop-ansible project - https://github.com/pippozq/hadoop-ansible. pippozq! Thanks for sharing it.
The ansible role for zookeepr is added, variables of many roles is integrated into group_vars/all.yml and hosts/host is removed and ansible-host is added instead for efficiency and convenience.

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

## How to configure ansible-hosts, group_vars/all deploy hadoop-zkcluster?
#### 1) Configure hostname / ip addresses and username to run for ansible-hosts
```
$ vi ansible-hosts
[all:vars]
ssh_key_filename="id_rsa"
remote_machine_username="jomoon"
remote_machine_password="changeme"

[master]
rk8-master ansible_ssh_host=192.168.0.171 zk_id=1

[standby]
rk8-slave ansible_ssh_host=192.168.0.172 zk_id=2

[workers]
rk8-node01 ansible_ssh_host=192.168.0.173 zk_id=3
rk8-node02 ansible_ssh_host=192.168.0.174 zk_id=4
rk8-node03 ansible_ssh_host=192.168.0.173 zk_id=5

# These are your zookeeper cluster nodes
[zk_servers]
rk8-master ansible_ssh_host=192.168.0.171 zk_id=1
rk8-slave ansible_ssh_host=192.168.0.172 zk_id=2
rk8-node01 ansible_ssh_host=192.168.0.173 zk_id=3
rk8-node02 ansible_ssh_host=192.168.0.174 zk_id=4
rk8-node03 ansible_ssh_host=192.168.0.175 zk_id=5

[hive] # hive nodes
rk8-master ansible_ssh_host=192.168.0.171 zk_id=1
```
#### 2) Configure user/group, hadoop version and location to download in role/hadoop/vars/main.yml
```
$ vi roles/hadoop/vars/main.yml
---
user: "hadoop"
group: "hadoop"

master_ip: "{{ hostvars[groups['master'][0]]['ansible_eth0']['ipv4']['address'] }}"
master_hostname: "{{ hostvars[groups['master'][0]].ansible_hostname }}"
standby_master_ip: "{{ hostvars[groups['standby'][0]]['ansible_eth0']['ipv4']['address'] }}"
standby_master_hostname: "{{ hostvars[groups['standby'][0]].ansible_hostname }}"

# download_path: "/Users/jomoon/Downloads"
download_hadoop: false
download_path: "/tmp"
hadoop_version: "3.3.5"
hadoop_path: "/home/hadoop"
hadoop_config_path: "/home/hadoop/hadoop-{{hadoop_version}}/etc/hadoop"
hadoop_tmp: "/home/hadoop/tmp"
hadoop_dfs_name: "/home/hadoop/dfs/name"
hadoop_dfs_data: "/home/hadoop/dfs/data"
hadoop_log_path: "/home/hadoop/hadoop_logs"
hadoop_journalnode_path: "/home/hadoop/journalnode/data"

hadoop_create_path:
  - "{{ hadoop_tmp }}"
  - "{{ hadoop_dfs_name }}"
  - "{{ hadoop_dfs_data }}"
  - "{{ hadoop_log_path }}"
  - "{{ hadoop_journalnode_path }}"
~~ snip
```
#### 3) Configure version / location to download & install / log_path / data_path of apache-zookeeper/java
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
$ vi roles/hive/vars/main.yml
---
# Hive basic vars
download_path: "/Users/jomoon/Downloads"
hive_version: "3.1.2"
hive_path: "/home/hadoop"
hive_config_path: "/home/hadoop/apache-hive-{{hive_version}}-bin/conf"
hive_tmp: "/home/hadoop/hive/tmp"

hive_create_path:
  - "{{ hive_tmp }}"

hive_warehouse: "/user/hive/warehouse"
hive_scratchdir: "/user/hive/tmp"
hive_querylog_location: "/user/hive/log"

hive_hdfs_path:
  - "{{ hive_warehouse }}"
  - "{{ hive_scratchdir }}"
  - "{{ hive_querylog_location }}"

hive_logging_operation_log_location: "{{ hive_tmp }}/{{ user }}/operation_logs"

# database
db_type: "postgres"
hive_connection_driver_name: "org.postgresql.Driver"
# hive_connection_host: "172.16.251.33"
hive_connection_host: "192.168.0.81"
hive_connection_port: "5432"
hive_connection_dbname: "bdrdemo"
hive_connection_user_name: "bdrsync"
hive_connection_password: "changeme"
hive_connection_url: "jdbc:postgresql://{{ hive_connection_host }}:{{ hive_connection_port }}/{{hive_connection_dbname}}?ssl=false"
~~ snip
```
#### 5) The below query file is useful to remove all tables in hive database before running playboot.
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
$ psql -h 192.168.0.81 -U bdrsync -d bdrdemo -p 5432 -f drop_all_tables.sql
```

## How to install and deploy hadoop cluster
```
$ make install
```

## How to undeply and uninstall hadoop cluster
```
$ make uninstall
```

## Planning
A few variables for yarn-resource-manager, etc in group_vars/all.yml need to modify to arrange at once.

## License
GNU General Public License v3.0

## References
https://hadoop.apache.org/docs/r2.7.1/hadoop-project-dist/hadoop-hdfs/HDFSHighAvailabilityWithQJM.html
