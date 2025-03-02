### Configure Varialbes such as Download Location, Versions, Install/Config Path, Informations
$ vi group_vars/all.yml
```yaml
~~ snip
_spark:
  worker:
    core: 6
    memory: "6G"
    default_core: 4
  download: false
  firewall: false
  user: "{{ _hadoop.user }}"
  group: "{{ _hadoop.group }}"
  major_version: 3
  minor_version: 5
  patch_version: 4
  bin_type: tgz
  download_url: "https://archive.apache.org/dist/spark"
  base_path: "{{ _hadoop.base_path }}"
  master_work_port: 7077
  worker_work_port: 7078
  master_ui_port: 8080
  worker_ui_port: 8081
  net:
    type: "virtual"                # Or Physical
    gateway: "192.168.0.1"
    ipaddr0: "192.168.0.19"
    ipaddr1: "192.168.1.19"
    ipaddr2: "192.168.2.19"
~~ snip
```

### Install or Deploy Spark
```yaml
$ make spark r=setup   s=bin
$ make spark r=config  s=cluster
$ make spark r=start   s=cluster

or
$ make spark r=install s=all
```

### Uninstall or Destroy Spark
```yaml
$ make spark r=stop   s=cluster
$ make spark r=delete s=bin

or
$ make spark r=uninstall s=all
```


## References
https://sparkbyexamples.com/


