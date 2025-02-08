### Architecture
- https://www.scylladb.com/glossary/apache-cassandra-architecture/
- https://cassandra.apache.org/_/cassandra-basics.html
- https://www.yugabyte.com/blog/apache-cassandra-architecture-how-it-works-lightweight-transactions/
- https://cassandra.link/post/cassandra-architecture-tutorial-or-simplilearn
- https://medium.com/@brunocrt/the-distributed-architecture-behind-cassandra-database-fba8b5cc4785
- https://www.learnovita.com/cassandra-architecture-tutorial



### Configure Varialbes such as Download Location, Versions, Install/Config Path, Informations
```yaml
$ vi group_vars/all.yml
~~ snip
_cassandra:
  cluster_name: "Jack Cassandra"
  user: "cassandra"
  group: "cassandra"
  password: "changeme"
  users:
    - { name: "jomoon", password: "changeme", su: "true", login: "true" }
    - { name: "romoon", password: "changeme", su: "false", login: "false" }
    - { name: "komoon", password: "changeme", su: "true", login: "false" }
    - { name: "somoon", password: "changeme", su: "false", login: "true" }
  user_home: "/home/cassandra"
  base_path: "/usr/local"
  major_version: 4
  minor_version: 1
  patch_version: 8
  bin_type: tar.gz
  force_clean: false
  download: false
  firewall: false
  download_url: "https://archive.apache.org/dist/cassandra"
  download_path: /tmp
  dir:
    base: /csdr_data
    commit: /csdr_data/cassandra/commitlog
    data: /csdr_data/cassandra/data
    logs: /csdr_data/cassandra/logs
  net:
    type: "virtual"                # Or Physical
    gateway: "192.168.0.1"
    ipaddr0: "192.168.0.19"
    ipaddr1: "192.168.1.19"
    ipaddr2: "192.168.2.19"
~~ snip
```
### How to Install/Deploy Cassandra
```yaml
$ make cassandra r=add s=sysuser
$ make cassandra r=setup s=bin
$ make cassandra r=create s=dir
$ make cassandra r=setup s=config
$ make cassandra r=start s=service
$ make cassandra r=copy s=examples
$ make cassandra r=change s=passwd
$ make cassandra r=add s=users
$ make cassandra r=disable s=admin

or
$ make cassandra r=install s=all
```

### How to Uninstall/Destroy Cassandra
```yaml
$ make cassandra r=delete s=users
$ make cassandra r=stop s=service
$ make cassandra r=delete s=config
$ make cassandra r=remove s=sysuser

or
$ make cassandra r=uninstall s=all
```

## Planning
- [] Configure and Enable/Disable SSL

