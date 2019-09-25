#!/bin/bash

# Create an interactive shell in a pod on a node using crictl
sudo crictl ps | grep <my-pod>
sudo crictl exec -it <my-pod-id> /bin/sh
