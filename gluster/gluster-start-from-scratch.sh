# 1. delete the gluster infra project
oc project storage-infra
oc delete namespace storage-infra

# 2. from each of the gluster nodes
lvmdiskscan | grep /dev/sdb2

[root@master ~]# vgs
  /run/lvm/lvmetad.socket: connect failed: Connection refused
  WARNING: Failed to connect to lvmetad. Falling back to device scanning.
  VG                                  #PV #LV #SN Attr   VSize    VFree
  infravg                               1   9   0 wz--n-  <44.00g <8.50g
  rootvg                                2   3   0 wz--n-  195.19g 69.19g
  vg_cd0d683afaeb7ee911cb22d17d863224   1   2   0 wz--n-   <1.76t <1.76t
  vgdocker                              1   1   0 wz--n- <100.00g  5.00g
[root@master ~]# vgremove -y vg_cd0d683afaeb7ee911cb22d17d863224
  /run/lvm/lvmetad.socket: connect failed: Connection refused
  WARNING: Failed to connect to lvmetad. Falling back to device scanning.
  Logical volume "brick_d25e884a3daf5c565f5b439078b24a26" successfully removed
  Logical volume "tp_d25e884a3daf5c565f5b439078b24a26" successfully removed
  Volume group "vg_cd0d683afaeb7ee911cb22d17d863224" successfully removed
[root@master ~]# wipefs -a /dev/sdb2
/dev/sdb2: 8 bytes were erased at offset 0x00000218 (LVM2_member): 4c 56 4d 32 20 30 30 31
[root@master ~]# pvcreate /dev/sdb2
  /run/lvm/lvmetad.socket: connect failed: Connection refused
  WARNING: Failed to connect to lvmetad. Falling back to device scanning.
  Physical volume "/dev/sdb2" successfully created.

# 3. update these files temporarily

vi group_vars/OSEv3/glusterfs_registry.yml
# set file storage for glusterfs
## StorageClasses ##
# Automatically create a StorageClass for Registry_GlusterFS
openshift_storage_glusterfs_registry_storageclass: true

# also set this, temporary
# Automatically create a StorageClass for Registry_GlusterFS_Block
openshift_storage_glusterfs_registry_block_storageclass: true

vi group_vars/OSEv3/registry.yml
# uncomment these two

# GlusterFS
# Specify that we want to use GlusterFS storage for a hosted registry
openshift_hosted_registry_storage_kind: glusterfs
# Volume Size when using GlusterFS as storage
openshift_hosted_registry_storage_volume_size: 1Gi

# 4. temporarily comment these registry references out of the hosts inventory file:
# Registry NFS
#openshift_hosted_registry_storage_host=
#openshift_hosted_registry_storage_nfs_directory=/
#openshift_hosted_registry_storage_volume_name=
#openshift_hosted_registry_hostname=
#openshift_hosted_registry_console_hostname=

# 5. Run the gluster playbook
- import_playbook: /usr/share/ansible/openshift-ansible/playbooks/openshift-glusterfs/config.yml

