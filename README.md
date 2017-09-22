# zabbix_template_disk.presence
This is zabbix template for monitoring HDD &amp; SSD presence in system

Works only on Debian 8, Debian 9, CentOS7

This template needs "bc", "megacli", "smartmontools"

1. Zabbix Template Disk Presence.xml --- template for zabbix server
2. userparameter.disk.presence.conf --- keys for template
3. z.disk.presence.sh --- script, which make 2 files. One for discovery disks. Second for automatic disk search and take items. Without RAID or with Megaraid (LSI).

visudo zabbix ALL=NOPASSWD: /etc/zabbix/bin/z.disk.presence.sh
