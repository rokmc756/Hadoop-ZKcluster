# Add the IP address, username and hostname of the target hosts here

USERNAME=jomoon
COMMON="yes"
ANSIBLE_HOST_PASS="changeme"
ANSIBLE_TARGET_PASS="changeme"
# include ./*.mk

HOSTS := $(shell grep -i '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' ./ansible-hosts | sed -e "s/ ansible_ssh_host=/,/g")

all:
	@echo ""
	@echo "[ Available targets ]"
	@echo ""
	@echo "init:            will install basic requirements (will ask several times for a password)"
	@echo "install:         will install the host with what is defined in install-host.yml"
	@echo "upgrade:         run Hadoop and Zookeeper updates"
	@echo "update:          run OS updates"
	@echo "ssh:             jump ssh to host"
	@echo "role-update:     update all downloades roles"
	@echo "available-roles: list known roles which can be downloaded"
	@echo "clean:           delete all temporary files"
	@echo ""
	@for HOST in ${HOSTS}; do \
		IP=$${HOST#*,}; \
	    	HOSTNAME=$${LINE%,*}; \
		echo "Current used hostname: $${HOSTNAME}"; \
		echo "Current used IP: $${IP}"; \
		echo "Current used user: ${USERNAME}"; \
		echo ""; \
	done

# https://ansible-tutorial.schoolofdevops.com/control_structures/

download: role-update download-hadoop.yml
	ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -u ${USERNAME} download-hadoop.yml --tags="download"

init: role-update init-hosts.yml
	ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -u ${USERNAME} init-hosts.yml --tags="init"

uninit: role-update init-hosts.yml
	ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -u ${USERNAME} init-hosts.yml --tags="uninit"

deploy: role-update install.yml
	ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -u ${USERNAME} install.yml --tags="install"

destroy: role-update uninstall.yml
	ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -u ${USERNAME} uninstall.yml --tags="uninstall"

upgrade: role-update upgrade.yml
	ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -u ${USERNAME} upgrade.yml --tags="upgrade"

update: role-update update.yml
	ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -i ${IP}, -u ${USERNAME} update.yml

boot: role-update control-vms.yml
	ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -u ${USERNAME} control-vms.yml --extra-vars "power_state=on power_title=Power-On"

shutdown: role-update control-vms.yml
	ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -u ${USERNAME} control-vms.yml --extra-vars "power_state=off power_title=Power-Off"

hadoop:
	@if [ "${r}" = "install" ]; then\
	  ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -u ${USERNAME} install-hadoop.yml --tags="install";\
	elif [ "${r}" = "uninstall" ]; then\
	  ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -u ${USERNAME} uninstall-hadoop.yml --tags="uninstall";\
	else\
	  echo "No Actions for Hadoop";\
	  exit;\
	fi

pgsql:
	@if [ "${r}" = "install" ]; then\
	  ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -u ${USERNAME} config-pgsql.yml --tags="install";\
	elif [ "${r}" = "uninstall" ]; then\
	  ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -u ${USERNAME} config-pgsql.yml --tags="uninstall";\
	else\
	  echo "No Actions for PostgreSQL";\
	  exit;\
	fi

hive:
	@if [ "${r}" = "install" ]; then\
	  ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -u ${USERNAME} config-hive.yml --tags="install";\
	elif [ "${r}" = "uninstall" ]; then\
	  ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -u ${USERNAME} config-hive.yml --tags="uninstall";\
	else\
	  echo "No Actions for Hive";\
	  exit;\
	fi

spark:
	@if [ "${r}" = "install" ]; then\
	  ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -u ${USERNAME} config-spark.yml --tags="install";\
	elif [ "${r}" = "uninstall" ]; then\
	  ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -u ${USERNAME} config-spark.yml --tags="uninstall";\
	else\
	  echo "No Actions for Spark";\
	  exit;\
	fi

hbase:
	@if [ "${r}" = "install" ]; then\
	  ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -u ${USERNAME} config-hbase.yml --tags="install";\
	elif [ "${r}" = "uninstall" ]; then\
	  ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -u ${USERNAME} config-hbase.yml --tags="uninstall";\
	else\
	  echo "No Actions for Hbase";\
	  exit;\
	fi

ganglia:
	@if [ "${r}" = "install" ]; then\
	  ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -u ${USERNAME} config-ganglia.yml --tags="install";\
	elif [ "${r}" = "uninstall" ]; then\
	  ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -u ${USERNAME} config-ganglia.yml --tags="uninstall";\
	else\
	  echo "No Actions for Ganglia";\
	  exit;\
	fi

#poweron: role-update poweron-vms.yml
#	ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -u ${USERNAME} poweron-vms.yml

# https://stackoverflow.com/questions/4219255/how-do-you-get-the-list-of-targets-in-a-makefile
no_targets__:
role-update:
	sh -c "$(MAKE) -p no_targets__ | awk -F':' '/^[a-zA-Z0-9][^\$$#\/\\t=]*:([^=]|$$)/ {split(\$$1,A,/ /);for(i in A)print A[i]}' | grep -v '__\$$' | grep '^ansible-update-*'" | xargs -n 1 make --no-print-directory
#        $(shell sed -i -e '2s/.*/ansible_become_pass: ${ANSIBLE_HOST_PASS}/g' ./group_vars/all.yml )

ssh:
	ssh -o UserKnownHostsFile=./known_hosts ${USERNAME}@${IP}

install.yml:
	cp -a install-hosts.template install.yml

update.yml:
	cp -a update-hosts.template update.yml

clean:
	rm -rf ./known_hosts install-hosts.yml update.yml

.PHONY:	all init install uninstall update ssh common clean no_targets__ role-update power

