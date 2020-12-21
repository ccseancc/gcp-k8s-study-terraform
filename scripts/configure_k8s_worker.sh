projectid=`gcloud config get-value project`

## configure kubernetes for GCE
cat << EOF | sudo tee /etc/kubernetes/cloud-config
[Global]
project-id = "$projectid"
EOF

cat << EOF | sudo tee /etc/default/kubelet
KUBELET_EXTRA_ARGS="--cloud-provider=gce"
EOF

sudo systemctl restart kubelet
