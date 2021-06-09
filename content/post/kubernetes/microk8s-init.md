+++
author = "Michele Sciabarrà"
title = "Deploy MicroK8s  with cloud-init"
date = "2021-06-09"
description = "A simple cloud-init script to build automatically Kubernetes based on MicroK8s, and test it with multipass."
tags = [ "Kubernetes" ]
+++

If you need to run Kubernetes, today very frequently you just pick one managed in some cloud provider. However this option is frequently expensive. A cheaper option is to get a bunch of virtual machines and install Kubernetes in it.

Creating a Kubernetes cluster actually today is pretty simple, using tools like [MicroK8s](https://microk8s.io/) but there are still some manual actions to take.

To make cluster building even simpler, you can use for example [cloud-init](https://cloudinit.readthedocs.io/en/latest/), the standard for cloud image initialization. So I decided to write a cloud-init that can automatically build a cluster for you.

The result is [here](https://bit.ly/microk8s-init), you can download it with this command:

```
curl -sL bit.ly/microk8s-init >microk8s-init.yaml
```

To entirely automate the cluster generation I had to use a couple of tricks.

First I assigned statically an IP address to virtual machines. I assign ips to virtual machines using a number that is expected to be included in the hostname. Second I generate "programmatically" a token to join the cluster.

There are hence a couple of parameters you may need to customize before using it. You may need to change the `NET` parameter.  All the virtual machines will get an IP in that network according to the host name. For example, the virtual machine  `kube1` will get the address `10.0.0.1`.  Also note that the `1` virtual machine is always the one used to join the cluster

Also for security you may want to change the `PASS` parameter that is the  password used to generate the unique token for joining the cluster.

The script can be used in many different environments. The low hanging fruit  to use it is wth [`multipass`](https://multipass.run/), another handy tool from Ubuntu to launch virtual machines in multiple environments.

Microk8s requires at least 2gb of memory to run and 2 vcpu. You can hence test the script with the following commands to create the first node of a local cluster:

```
multipass launch -nkube1 -m3g -c2 --cloud-init microk8s-init.yaml
```

Sometimes it will time out during the initialization so you may need to wait for it to complete with

```
multipass exec kube1 -- sudo cloud-init status --wait
```

You can then launch more instances and wait for them:

```
multipass launch -nkube2 -m2g -c2 --cloud-init microk8s-init.yaml
multipass exec kube2 -- sudo cloud-init status --wait
multipass launch -nkube3 -m2g -c2 --cloud-init microk8s-init.yaml
multipass exec kube3 -- sudo cloud-init status --wait
```

You can finally extract the configuration file and check for the cluster status with:

```
multipass transfer kube1:/etc/kubeconfig ~/.kube/config
kubectl get nodes
```
