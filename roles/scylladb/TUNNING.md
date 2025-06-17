# https://docs.datastax.com/en/cassandra-oss/3.x/cassandra/install/installRecommendSettings.html
# https://docs.datastax.com/en/dse/6.9/managing/configure/recommended-settings.html
# https://cassandra.apache.org/doc/latest/cassandra/getting-started/production.html


About Apache Cassandra

Understanding the architecture

Database internals

Planning a cluster deployment

Installing

Installing on Debian-based systems

Installing on RHEL-based systems

Installing from the binary tarball

Recommended settings

Installing the JDK and Python 2.7

Installing on cloud providers

Uninstalling Cassandra

Install locations

Configuration

Initializing a cluster

Operations

Cassandra tools

Troubleshooting
Release notes

Recommended production settings
The following sections provide recommendations for optimizing your Apache Cassandra™ installation on Linux:

Use the latest Java Virtual Machine
Use the latest 64-bit version of Oracle Java Platform, Standard Edition 8 (JDK) or OpenJDK 8.

Synchronize clocks
Synchronize the clocks on all nodes, using NTP (Network Time Protocol) or other methods.

This is required because Cassandra only overwrites a column if there is another version whose timestamp is more recent.

TCP settings
To handle thousands of concurrent connections used by Cassandra, DataStax recommends these settings to optimize the Linux network stack. Add these settings to /etc/sysctl.conf.


net.core.rmem_max = 16777216
        net.core.wmem_max = 16777216
        net.core.rmem_default = 16777216
        net.core.wmem_default = 16777216
        net.core.optmem_max = 40960
        net.ipv4.tcp_rmem = 4096 87380 16777216
        net.ipv4.tcp_wmem = 4096 65536 16777216
To set immediately (depending on your distribution):
sudo sysctl -p /etc/sysctl.conf
sudo sysctl -p /etc/sysctl.d/filename.conf
Make sure that new settings persist after reboot
CAUTION: Depending on your environment, some of the following settings may not be persisted after reboot. Check with your system administrator to ensure they are viable for your environment.
Optimize SSDs
The default SSD configurations on most Linux distributions are not optimal. Follow these steps to ensure the best settings for SSDs:

Ensure that the SysFS rotational flag is set to false (zero).
This overrides any detection by the operating system to ensure the drive is considered an SSD.

Apply the same rotational flag setting for any block devices created from SSD storage, such as mdarrays.
Set the IO scheduler to either deadline or noop:
The noop scheduler is the right choice when the target block device is an array of SSDs behind a high-end IO controller that performs IO optimization.
The deadline scheduler optimizes requests to minimize IO latency. If in doubt, use the deadline scheduler.
Set the readahead value for the block device to 8 KB.
This setting tells the operating system not to read extra bytes, which can increase IO time and pollute the cache with bytes that weren’t requested by the user.

For example, if the SSD is /dev/sda, in /etc/rc.local:

echo deadline > /sys/block/sda/queue/scheduler
              #OR...
              #echo noop > /sys/block/sda/queue/scheduler
              touch /var/lock/subsys/local
              echo 0 > /sys/class/block/sda/queue/rotational
              echo 8 > /sys/class/block/sda/queue/read_ahead_kb
Use the optimum --setra setting for RAID on SSD
The optimum readahead setting for RAID on SSDs (in Amazon EC2) is 8KB, the same as it is for non-RAID SSDs. For details, see Optimizing SSDs.

Disable zone_reclaim_mode on NUMA systems
The Linux kernel can be inconsistent in enabling/disabling zone_reclaim_mode. This can result in odd performance problems.
Random huge CPU spikes resulting in large increases in latency and throughput.
Programs hanging indefinitely apparently doing nothing.
Symptoms appearing and disappearing suddenly.
After a reboot, the symptoms generally do not show again for some time.
To ensure that zone_reclaim_mode is disabled:
echo 0 > /proc/sys/vm/zone_reclaim_mode
Set user resource limits
Use the ulimit -a command to view the current limits. Although limits can also be temporarily set using this command, DataStax recommends making the changes permanent:

Package installations: Ensure that the following settings are included in the /etc/security/limits.d/cassandra.conf file:
<cassandra_user> - memlock unlimited
          <cassandra_user> - nofile 100000
          <cassandra_user> - nproc 32768
          <cassandra_user> - as unlimited
Tarball installations: In RHEL version 6.x, ensure that the following settings are included in the /etc/security/limits.conf file:
<cassandra_user> - memlock unlimited
          <cassandra_user> - nofile 100000
          <cassandra_user> - nproc 32768
          <cassandra_user> - as unlimited
If you run Cassandra as root, some Linux distributions such as Ubuntu, require setting the limits for root explicitly instead of using cassandra_user:
root - memlock unlimited
          root - nofile 100000
          root - nproc 32768
          root - as unlimited

For RHEL 6.x-based systems, also set the nproc limits in /etc/security/limits.d/90-nproc.conf:
cassandra_user - nproc 32768
For all installations, add the following line to /etc/sysctl.conf:
vm.max_map_count = 1048575
For installations on Debian and Ubuntu operating systems, the pam_limits.so module is not enabled by default. Edit the /etc/pam.d/su file and uncomment this line:
session    required   pam_limits.so
This change to the PAM configuration file ensures that the system reads the files in the /etc/security/limits.d directory.
To make the changes take effect, reboot the server or run the following command:
sudo sysctl -p
To confirm the limits are applied to the Cassandra process, run the following command where pid is the process ID of the currently running Cassandra process:
cat /proc/pid/limits
Disable swap
Failure to disable swap entirely can severely lower performance. Because Cassandra has multiple replicas and transparent failover, it is preferable for a replica to be killed immediately when memory is low rather than go into swap. This allows traffic to be immediately redirected to a functioning replica instead of continuing to hit the replica that has high latency due to swapping. If your system has a lot of DRAM, swapping still lowers performance significantly because the OS swaps out executable code so that more DRAM is available for caching disks.

If you insist on using swap, you can set vm.swappiness=1. This allows the kernel swap out the absolute least used parts.

sudo swapoff --all
To make this change permanent, remove all swap file entries from /etc/fstab.

Check the Java Hugepages setting
Many modern Linux distributions ship with Transparent Hugepages enabled by default. When Linux uses Transparent Hugepages, the kernel tries to allocate memory in large chunks (usually 2MB), rather than 4K. This can improve performance by reducing the number of pages the CPU must track. However, some applications still allocate memory based on 4K pages. This can cause noticeable performance problems when Linux tries to defrag 2MB pages. For more information, see Cassandra Java Huge Pages and this RedHat bug report.

To solve this problem, disable defrag for hugepages. Enter:
echo never | sudo tee /sys/kernel/mm/transparent_hugepage/defrag
Set the heap size for optimal Java garbage collection in Cassandra
See Tuning Java resources.

Apply optimum blockdev --setra settings for RAID on spinning disks
Typically, a readahead of 128 is recommended.

Check to ensure setra is not set to 65536:

sudo blockdev --report /dev/spinning_disk
To set setra:

sudo blockdev --setra 128 /dev/spinning_disk
Note: The recommended setting for RAID on SSDs is the same as that for SSDs that are not being used in a RAID installation. For details, see Optimizing SSDs.
Install locations

