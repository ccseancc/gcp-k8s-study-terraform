control_endpoint="34.92.70.21:6443"
pod_network_cidr="10.200.0.0/16"
projectid=k8sstudy1120

## init the cluster
sudo kubeadm init --control-plane-endpoint $control_endpoint --upload-certs --pod-network-cidr=$pod_network_cidr

## add remote control to user
mkdir -p $HOME/.kube
rm -rf $HOME/.kube/*
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

## configure kubernetes for GCE
cat << EOF | sudo tee /etc/kubernetes/cloud-config
[Global]
project-id = "$projectid"
EOF

cat << EOF | sudo tee /etc/default/kubelet
KUBELET_EXTRA_ARGS="--cloud-provider=gce"
EOF

sudo systemctl restart kubelet
sudo sed -i '/use-service-account-credential/ a \   \ - --cloud-provider=gce' /etc/kubernetes/manifests/kube-controller-manager.yaml

## Add CNI :
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
