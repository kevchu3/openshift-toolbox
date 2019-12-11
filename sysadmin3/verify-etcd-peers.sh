#!/bin/bash

# Output of logs in etcd-member
sudo crictl logs <etcd-member-pod-id>

# Create an interactive shell in etcd-member pod
sudo crictl ps | grep etcd-member
sudo crictl exec -it <etcd-member-pod-id> /bin/sh

# Check health of etcd cluster
# Note: use the peer certificates instead of server certificates in client context
export ETCDCTL_API=3 ETCDCTL_CACERT=/etc/ssl/etcd/ca.crt ETCDCTL_CERT=$(find /etc/ssl/ -name *peer*crt) ETCDCTL_KEY=$(find /etc/ssl/ -name *peer*key)
etcdctl endpoint health --cluster
