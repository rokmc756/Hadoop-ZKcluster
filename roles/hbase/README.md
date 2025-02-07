### Configure Varialbes such as Download Location, Versions, Install/Config Path, Informations
```yaml
$ vi group_vars/all.yml
~~ snip
_hbase:
  user: "{{ _hadoop.user }}"
  group: "{{ _hadoop.group }}"
  base_path: "{{ _hadoop.base_path }}"
  download: false
  firewall: false
  major_version: 2
  minor_version: 6
  patch_version: 1
  bin_type: tar.gz
  download_url: "https://archive.apache.org/dist/hbase"
  net:
    type: "virtual"                # Or Physical
    gateway: "192.168.0.1"
    ipaddr0: "192.168.0.19"
    ipaddr1: "192.168.1.19"
    ipaddr2: "192.168.2.19"
~~ snip
```

### How to Install or Deploy HBase
```yaml
$ make hbase r=disable s=firewall
$ make hbase r=setup s=hbase
$ make hbase r=config s=hbase

or
$ make hbase r=uninstall s=all
```

### How to Uninstall or Destroy Hbase
```yaml
$ make hbase r=remove s=hbase
$ make hbase r=enable s=firewall

or
$ make hbase r=uninstall s=all
```

