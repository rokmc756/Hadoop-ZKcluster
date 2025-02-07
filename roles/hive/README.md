### Configure Varialbes such as Download Location, Versions, Install/Config Path, Informations of Postgresql Databbase for Hive in role/hive/var/main.yml
```yaml
$ vi group_vars/all.yml
~~ snip
_hive:
  user: "{{ _hadoop.user }}"
  group: "{{ _hadoop.group }}"
  download: false
  firewall: false
  major_version: 4
  minor_version: 0
  patch_version: 1
  bin_type: tar.gz
  download_url: "https://dlcdn.apache.org/hive"
  base_path: "{{ _hadoop.base_path }}"
  default_path: "/user/hive"
  tmp_path: "{{ _hadoop.base_path }}/hive/tmp"
  server_port: 10000
  hwi_port: 9999
  metastore_port: 9083
  net:
    type: "virtual"                # Or Physical
    gateway: "192.168.0.1"
    ipaddr0: "192.168.0.19"
    ipaddr1: "192.168.1.19"
    ipaddr2: "192.168.2.19"
~~ snip

_postgres:
  firewall: false
  net:
    type: "virtual"                # Or Physical
    gateway: "192.168.0.1"
    ipaddr0: "192.168.0.19"
    ipaddr1: "192.168.1.19"
    ipaddr2: "192.168.2.19"
~~ snip
```


### How to Install or Deploy Postgres Database
```yaml
$ make postgres r=disable s=firewall
$ make postgres r=setup s=pkgs
$ make postgres r=init s=postgres
$ make postgres r=enable s=ssl
$ make postgres r=add s=user

or
$ make postgres r=install s=all
```

### How to Install or Deploy Hive
```yaml
$ make hive r=disable s=firewall
$ make hive r=setup s=hive
$ make hive r=config s=hive
$ make hive r=init s=hive

or
$ make hive r=install s=all
```

### The Below Query File is Useful to Remove All Tables in Hive Database before Running Playbook
```yaml
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

## Run to Remove Tables In a Specific Database
```yaml
$ psql -h 192.168.2.196 -U hive_user -d hive_testdb -p 5432 -f drop_all_tables.sql
```


## How to Uninstall or Destroy Hive
```yaml
$ make postgres r=recreate s=hivedb
$ make hive r=delete s=hive
$ make hive r=enable s=firewall

or
$ make hive r=uninstall s=all
```

## How to Uninstall Postgres Database
```yaml
$ make postgres r=delete s=pkgs
$ make postgres r=enable s=firewall

or
$ make postgres r=uninstall s=all
```

