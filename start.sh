#!/bin/bash
emqx start
echo "Cluster name setup"
sleep 45
sed -i 's/node.name = emqx@127.0.0.1/node.name = emqx@'$IPADDRESS'/g' /etc/emqx/emqx.conf
sed -i 's/dashboard.default_user.login = admin/dashboard.default_user.login = '$USERNAME'/g' /etc/emqx/plugins/emqx_dashboard.conf
sed -i 's/dashboard.default_user.password = public/dashboard.default_user.pawssword = '$PASSWORD'/g' /etc/emqx/plugins/emqx_dashboard.conf
echo "Cluster cookie setup"
sed -i 's/node.cookie = emqxsecretcookie/node.cookie = sztakicluster/g' /etc/emqx/emqx.conf
echo "EMQX restart"
emqx stop
sleep 20
emqx start
sleep 30
if [ "$WORKER" = true ]
then
  emqx_ctl cluster join emqx@"$masterIP"
fi
echo "Sleep infinity"
sleep infinity
