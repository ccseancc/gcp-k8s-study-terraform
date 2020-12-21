externalIP=`gcloud compute addresses list |grep k8s-ip |awk '{print $2}'`
control_endpoint="$externalIP:6443"
pod_network_cidr="10.200.0.0/16"
projectid=`gcloud config get-value project`

## init the cluster
sudo kubeadm init --control-plane-endpoint $control_endpoint --upload-certs --pod-network-cidr=$pod_network_cidr

## add remote control to user
mkdir -p $HOME/.kube
rm -rf $HOME/.kube/*
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
user=`basename $HOME`
sudo chown $user:$user $HOME/.kube/config

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
