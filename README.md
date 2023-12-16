## WHat is Hadoop Zookeeper Cluster
Hadoop-zkcluster is ansible playbook to deploy Hadoop / Hive and Zookeeper cluster on Baremetal, Virtual Machines and Cloud Infrastructure.
It implements HDFS HA architecture described at the below doc and you could see details about how it works.
https://www.edureka.co/blog/how-to-set-up-hadoop-cluster-with-hdfs-high-availability/


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
1. Configure hostname / ip addresses and username to run for ansible-hosts
```
[all:vars]
ssh_key_filename="id_rsa"
remote_machine_username="jomoon"
remote_machine_password="changeme"

[master] # primary namenode
mdw6 ansible_ssh_host=192.168.0.61 zk_id=1

[standby] # secondary namenode
smdw6 ansible_ssh_host=192.168.0.62 zk_id=2

[workers] # data nodes
sdw6-01 ansible_ssh_host=192.168.0.63 zk_id=3
sdw6-02 ansible_ssh_host=192.168.0.64 zk_id=4
sdw6-03 ansible_ssh_host=192.168.0.65 zk_id=5

[hive] # hive nodes
mdw6 ansible_ssh_host=192.168.0.61 zk_id=1

[zk_servers]
mdw6 ansible_ssh_host=192.168.0.61 zk_id=1
smdw6 ansible_ssh_host=192.168.0.62 zk_id=2
sdw6-01 ansible_ssh_host=192.168.0.63 zk_id=3
sdw6-02 ansible_ssh_host=192.168.0.64 zk_id=4
sdw6-03 ansible_ssh_host=192.168.0.65 zk_id=5
```
### 2) Configure user / group, hadoop / java version and location to download in groups/all.yml
```
user: "hadoop"
group: "hadoop"

# java version
jvm_home: "/usr/lib/jvm"
java_packages:
 - "java-1.8.0-openjdk"
 - "java-1.8.0-openjdk-devel"

download_path: "/Users/pivotal/Downloads"
hadoop_version: "3.3.1"
```
### 3) configure version / location to download & install / log_path / data_path of apache-zookeeper/java
```
package_download_path : "/tmp"
zookeeper:
  version: 3.7.0
  installation_path: /usr/local
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
  version: 1.8.0.181-7
  installation_path: /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.181-7.b13.el7.x86_64
```
### 4) Configure varialbes such as download location, versions, install/config path,
* informations of postgresql databbase for Hive in role/hive/var/main.yml
```
download_path: "/Users/pivotal/Downloads"
hive_version: "3.1.2"
hive_path: "/home/hadoop"
hive_config_path: "/home/hadoop/apache-hive-{{hive_version}}-bin/conf"
hive_tmp: "/home/hadoop/hive/tmp"
~~ snip
hive_warehouse: "/user/hive/warehouse"
hive_scratchdir: "/user/hive/tmp"
hive_querylog_location: "/user/hive/log"
~~ snip
# database
db_type: "postgres"
hive_connection_driver_name: "org.postgresql.Driver"
# hive_connection_host: "172.16.251.33"
hive_connection_host: "192.168.0.81"
hive_connection_port: "5432"
hive_connection_dbname: "bdrdemo"
hive_connection_user_name: "bdrsync"
hive_connection_password: "changeme"
```
### 5) The below query file is useful to remove all tables in hive database before running playboot.
```
vi drop_all_tables.sql
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
psql -h 192.168.0.81 -U bdrsync -d bdrdemo -p 5432 -f drop_all_tables.sql
```

## How to install and deploy hadoop cluster
```
make install
```

## How to undeply and uninstall hadoop cluster
```
make uninstall
```

## Planning
A few variables for yarn-resource-manager, etc in group_vars/all.yml need to modify to arrange at once.

## License
GNU General Public License v3.0

## References
* https://hadoop.apache.org/docs/r2.7.1/hadoop-project-dist/hadoop-hdfs/HDFSHighAvailabilityWithQJM.html
