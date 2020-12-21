if [[ $# -eq 0 ]]; then
  echo "usage: $0 <worker hostname>"
  exit 0
fi

master="control0"
worker="$1"

### Join worker to control panel
gcloud compute ssh $master --command "kubeadm token create --print-join-command" > joink8s.sh
gcloud compute scp joink8s.sh $worker:/tmp/
gcloud compute ssh $worker --command "sudo kubeadm reset -f"
gcloud compute ssh $worker --command "sudo sh -x /tmp/joink8s.sh"
