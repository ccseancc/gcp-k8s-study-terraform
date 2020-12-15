master="control0"

gcloud compute scp configure_k8s.sh $master:/tmp/
gcloud compute ssh $master --command "sh -x /tmp/configure_k8s.sh"
