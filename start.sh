#!/bin/bash
emqx start
echo "Cluster name setup"
sleep 45
sed -i 's/node.name = emqx@127.0.0.1/node.name = emqx@'$IPADDRESS'/g' /etc/emqx/emqx.conf
#sed -i 's/cluster.discovery = manual/cluster.discovery = mcast\ncluster.mcast.addr = 239.192.0.1\ncluster.mcast.ports = 4369,4370\ncluster.mcast.iface = 0.0.0.0\ncluster.mcast.ttl = 255\ncluster.mcast.l>
echo "Cluster cookie setup"
sed -i 's/node.cookie = emqxsecretcookie/node.cookie = sztakicluster/g' /etc/emqx/emqx.conf
echo "EMQX restart"
emqx stop
sleep 20
emqx start
sleep 30
if [ "$WORKER" = true ]
then
  emqx_ctl cluster join emqx@'$masterIP'
fi
echo "Sleep infinity"
sleep infinity
