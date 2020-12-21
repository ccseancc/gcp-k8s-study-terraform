if [[ $# -eq 0 ]]; then
  echo "usage: $0 <worker hostname>"
  exit 0
fi

master="control0"
worker="$1"

### Bootstrap worker
gcloud compute scp bootstrap-node.sh $worker:/tmp/
gcloud compute ssh $worker --command "sudo sh -x /tmp/bootstrap-node.sh"

### configure k8s for GCP
gcloud compute scp configure_k8s_worker.sh $worker:/tmp/
gcloud compute ssh $worker --command "sudo sh -x /tmp/configure_k8s_worker.sh"

### join worker to control plane
sh -x k8s_worker-join.sh $worker