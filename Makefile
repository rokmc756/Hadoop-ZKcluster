# add the IP address, username and hostname of the target hosts here

USERNAME=jomoon
COMMON="yes"
ANSIBLE_HOST_PASS="rmsidwoalfh"
ANSIBLE_TARGET_PASS="changeme"
# include ./*.mk

GPHOSTS := $(shell grep -i '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' ./ansible-hosts | sed -e "s/ ansible_ssh_host=/,/g")

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
	@for GPHOST in ${GPHOSTS}; do \
		IP=$${GPHOST#*,}; \
	    	HOSTNAME=$${LINE%,*}; \
		echo "Current used hostname: $${HOSTNAME}"; \
		echo "Current used IP: $${IP}"; \
		echo "Current used user: ${USERNAME}"; \
		echo ""; \
	done

# - https://ansible-tutorial.schoolofdevops.com/control_structures/
install: role-update install-hosts.yml
	ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -u ${USERNAME} install-hosts.yml --tags="install"

uninstall: role-update uninstall-hosts.yml
	ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -u ${USERNAME} uninstall-hosts.yml --tags="uninstall"

upgrade: role-update upgrade-hosts.yml
	ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -u ${USERNAME} upgrade-hosts.yml --tags="upgrade"

update: role-update update-hosts.yml
	ansible-playbook --ssh-common-args='-o UserKnownHostsFile=./known_hosts' -i ${IP}, -u ${USERNAME} update-hosts.yml

# https://stackoverflow.com/questions/4219255/how-do-you-get-the-list-of-targets-in-a-makefile
no_targets__:
role-update:
	sh -c "$(MAKE) -p no_targets__ | awk -F':' '/^[a-zA-Z0-9][^\$$#\/\\t=]*:([^=]|$$)/ {split(\$$1,A,/ /);for(i in A)print A[i]}' | grep -v '__\$$' | grep '^ansible-update-*'" | xargs -n 1 make --no-print-directory
#        $(shell sed -i -e '2s/.*/ansible_become_pass: ${ANSIBLE_HOST_PASS}/g' ./group_vars/all.yml )

ssh:
	ssh -o UserKnownHostsFile=./known_hosts ${USERNAME}@${IP}

install-hosts.yml:
	cp -a install-hosts.template install-hosts.yml

update-hosts.yml:
	cp -a update-hosts.template update-hosts.yml

clean:
	rm -rf ./known_hosts install-hosts.yml update-hosts.yml

.PHONY:	all init install update ssh common clean no_targets__ role-update
