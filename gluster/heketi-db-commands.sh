# to get the heketi-cli secret key
oc describe pod <heketi pod>

# resync devices
oc rsh <heketi pod>
heketi-cli --secret <heketi pod secret> --user admin node list
heketi-cli --secret <heketi pod secret> --user admin node info <node id #1>
heketi-cli --secret <heketi pod secret> --user admin device resync <device id from node #1>
heketi-cli --secret <heketi pod secret> --user admin node info <node id #2>
heketi-cli --secret <heketi pod secret> --user admin device resync <device id from node #2>
heketi-cli --secret <heketi pod secret> --user admin node info <node id #3>
heketi-cli --secret <heketi pod secret> --user admin device resync <device id from node #3>

# recreate block device
heketi-cli --secret <heketi pod secret> --user admin volume create --size 300 --block
