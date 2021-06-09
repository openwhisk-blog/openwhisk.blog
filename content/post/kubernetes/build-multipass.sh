multipass launch -nkube1 -m2g -c2 --cloud-init microk8s-init.yaml
multipass exec kube1 -- sudo cloud-init status --wait
multipass launch -nkube2 -m2g -c2 --cloud-init microk8s-init.yaml
multipass exec kube2 -- sudo cloud-init status --wait
multipass launch -nkube3 -m2g -c2 --cloud-init microk8s-init.yaml
multipass exec kube3 -- sudo cloud-init status --wait
multipass transfer kube1:/etc/kubeconfig ~/.kube/config
