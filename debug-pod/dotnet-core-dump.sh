# Collecting core dumps at .NET level
oc rsh <pod name>

scl enable rh-dotnet21 '/opt/rh/rh-dotnet21/root/usr/lib64/dotnet/shared/Microsoft.NETCore.App/2.1.2/createdump -f /tmp/coredump2.%d 1'
Writing minidump with heap to file /tmp/coredump2.1
Written 2397376512 bytes (585297 pages) to core file

sh-4.2$ cat /sys/fs/cgroup/memory/memory.usage_in_bytes


sh-4.2$ cat /sys/fs/cgroup/memory/memory.limit_in_bytes


sh-4.2$ cat /sys/fs/cgroup/memory/memory.stat
