# perform a series of Java thread dumps on a particular pod
POD=<pod name>; PID=$(oc exec $POD ps aux | grep java | awk '{print $2}'); oc exec $POD -- bash -c "for x in {1..6}; do jstack -l $PID >> /tmp/pod-name.out; sleep 20; done"; oc rsync $POD:/tmp/pod-name.out . 

# adhoc command
oc exec <pod-name> -c <service> -- jcmd 1 <file>
