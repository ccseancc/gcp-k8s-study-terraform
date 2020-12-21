master="control0"

### Bootstrap Control Plane
gcloud compute scp bootstrap-node.sh $master:/tmp/
gcloud compute ssh $master --command "sudo sh -x /tmp/bootstrap-node.sh"

### configure k8s for GCP
gcloud compute scp configure_k8s_master.sh $master:/tmp/
gcloud compute ssh $master --command "sudo sh -x /tmp/configure_k8s_master.sh"

