#!/bin/bash
set -e

SERVER_IP="192.168.56.110"

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server \
  --node-ip=${SERVER_IP} \
  --bind-address=${SERVER_IP} \
  --tls-san=${SERVER_IP} \
  --write-kubeconfig-mode=644" sh -

until [ -f /var/lib/rancher/k3s/server/node-token ]; do
  sleep 1
done

cp /var/lib/rancher/k3s/server/node-token /vagrant/node-token
