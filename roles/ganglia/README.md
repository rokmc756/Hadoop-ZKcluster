### Configure Hostname / IP Addresses and Username to Run in ansible-hosts
```yaml
$ vi ansible-hosts-rk9-ganglia
[all:vars]
ssh_key_filename="id_rsa"
remote_machine_username="jomoon"
remote_machine_password="changeme"


[master]
rk9-node01 ansible_ssh_host=192.168.2.191 zk_id=1


[standby]
rk9-node02 ansible_ssh_host=192.168.2.192 zk_id=2


[database]
rk9-node06 ansible_ssh_host=192.168.2.196 zk_id=6
```

### Configure Varialbes Such as Download Location, Versions, Install/Config Path, Informations
```yaml
~~ snip
_ganglia:
  user: "ganglia"
  group: "ganglia"
  base_path: "/var/www"
  firewall: false
  web:
    user: "admin"
    password: "changeme"
    major_version: 3
    minor_version: 7
    patch_version: 2
    bin_type: tar.gz
    download: false
    firewall: false
  net:
    type: "virtual"                # Or Physical
    gateway: "192.168.0.1"
    ipaddr0: "192.168.0.19"
    ipaddr1: "192.168.1.19"
    ipaddr2: "192.168.2.19"
  cluster_name: "hadoop-jack-kr"
  site_name: "ganglia-jack-kr"
  mtu: 9216 # IPv4 maximum transmission unit, 9216 is the maximum for Intel/Cisco hardware
  upgrade_kernel: no

  # To enable Postfix SMTP through Mandrill (@mandrillapp), set the following variables:
  # notify_email: notifications@example.com
  # postfix_domain: example.com
  # mandrill_username: your_username
  # mandrill_api_key: your_api_key
  # Upgrade kernel to 3.13, much improved epoll performance
~~ snip
```

### Install and Deploy Ganglia
```yaml
$ make ganglia r=disable s=firewall
$ make ganglia r=setup s=pkgs
$ make ganglia r=setup s=gmond
$ make ganglia r=setup s=gmetad
$ make ganglia r=setup s=web
$ make ganglia r=config s=metrics

or
$ make ganglia r=install s=all
```

### Uninstall Ganglia
```yaml
$ make ganglia r=remove s=web
$ make ganglia r=remove s=gmetad
$ make ganglia r=remove s=gmond
$ make ganglia r=remove s=metrics
$ make ganglia r=remove s=pkgs
$ make ganglia r=enable s=firewall
$ make ganglia r=disable s=selinux

or
$ make ganglia r=uninstall s=all
```
