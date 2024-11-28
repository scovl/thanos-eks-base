#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh '${cluster_name}' \
  --kubelet-extra-args '--node-labels=node.kubernetes.io/lifecycle=spot' \
  --apiserver-endpoint '${cluster_endpoint}' \
  --b64-cluster-ca '${cluster_ca_certificate}'

