# The following commands are for a migration from firewalld to iptables.

# We need to first clear the /etc/sysconfig/iptables definitions file first before firewalld can load properly
> /etc/sysconfig/iptables
systemctl daemon-reload
systemctl restart firewalld.service
systemctl enable firewalld.service
systemctl status firewalld.service

# Stop and disable iptables
systemctl stop iptables.service
systemctl mask iptables.service
systemctl status iptables.service

# Remove link from iptables to docker, so that iptables does not start on docker startup
# https://fralef.me/docker-and-iptables.html
mv /etc/systemd/system/docker.service.d/ /tmp/
systemctl daemon-reload
systemctl stop iptables.service
