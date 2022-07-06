#!/bin/bash
emqx start
sed -i 's/node.name = emqx@127.0.0.1/node.name = emqx'$ID'@'$IPADDRESS'/g' /etc/emqx/emqx.conf
sed -i 's/cluster.discovery = manual/cluster.discovery = mcast\ncluster.mcast.addr = 239.192.0.1\ncluster.mcast.ports = 4369,4370\ncluster.mcast.iface = 0.0.0.0\ncluster.mcast.ttl = 255\ncluster.mcast.l>
sed -i 's/node.cookie = emqxsecretcookie/node.cookie = sztakicluster/g' /etc/emqx/emqx.conf
emqx restart
sleep infinity
