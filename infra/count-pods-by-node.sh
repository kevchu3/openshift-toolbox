# Count running pods
oc get pods -o wide --all-namespaces | grep Running | awk '{print $8}' | sort | uniq -c

# Count all pods by node
oc get pods -o wide --all-namespaces | awk '{print $4, $8}' | sort | uniq -c
