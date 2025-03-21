# List Kubernetes services with their namespace, cluster-local URL, and exposed ports
kservices() {
  local ns_arg=$1

  if [[ -n "$ns_arg" ]]; then
    svc_data=$(kubectl get svc -n "$ns_arg" --no-headers -o custom-columns="NAME:.metadata.name,NAMESPACE:.metadata.namespace,PORTS:.spec.ports[*].port")
  else
    svc_data=$(kubectl get svc --all-namespaces --no-headers -o custom-columns="NAME:.metadata.name,NAMESPACE:.metadata.namespace,PORTS:.spec.ports[*].port")
  fi

  {
    echo "SERVICE_NAME NAMESPACE CLUSTER_URL PORTS"
    echo "$svc_data" | while read -r name namespace ports; do
      url="http://$name.$namespace.svc.cluster.local"
      echo "$name $namespace $url $ports"
    done
  } | column -t -s ' '
}

# List pods with detailed information, including their node and IP
kpods() {
  local ns=${1:-"--all-namespaces"}
  kubectl get pods -o wide -n $ns | column -t
}

# Tail logs of the most recently created pod matching a name pattern
kf() {
  local ns=${1:-default}
  local name=$2
  if [[ -z "$name" ]]; then
    echo "Usage: kf <namespace> <deployment/pod-name>"
    return 1
  fi
  pod=$(kubectl get pods -n $ns --sort-by=.metadata.creationTimestamp | grep "$name" | tail -1 | awk '{print $1}')
  echo "Tailing logs for pod: $pod"
  kubectl logs -f "$pod" -n "$ns"
}

# Open a shell inside the given pod
ksh() {
  local ns=${1:-default}
  local pod=$2
  if [[ -z "$pod" ]]; then
    echo "Usage: ksh <namespace> <pod-name>"
    return 1
  fi
  kubectl exec -it "$pod" -n "$ns" -- /bin/bash || kubectl exec -it "$pod" -n "$ns" -- /bin/sh
}

# List ingress rules with host and path information
kingress() {
  kubectl get ingress --all-namespaces -o custom-columns="NAMESPACE:.metadata.namespace,NAME:.metadata.name,HOSTS:.spec.rules[*].host,PATHS:.spec.rules[*].http.paths[*].path" | column -t
}

# Find pods with crash or image pull errors
kcrash() {
  kubectl get pods --all-namespaces | grep -E 'CrashLoopBackOff|Error|ImagePullBackOff'
}

# Search inside ConfigMaps or Secrets for a keyword
kfind() {
  local type=$1
  local keyword=$2
  if [[ "$type" != "configmap" && "$type" != "secret" ]]; then
    echo "Usage: kfind <configmap|secret> <keyword>"
    return 1
  fi
  kubectl get $type --all-namespaces -o yaml | grep -i "$keyword" -B 2 -A 2
}

# Show top 10 pods by CPU usage
ktop() {
  kubectl top pod --all-namespaces | sort -k3 -h -r | head -n 10
}

# Show the most recently created pod in a namespace
knewest() {
  local ns=${1:-default}
  kubectl get pods -n "$ns" --sort-by=.metadata.creationTimestamp | tail -n 1
}

# Switch between Kubernetes contexts
kctx() {
  echo "Available contexts:"
  kubectl config get-contexts
  echo "Current context: $(kubectl config current-context)"
}

# Change current namespace in the current context
kns() {
  kubectl config set-context --current --namespace="$1"
}

# List all deployments in all namespaces
kdeploys() {
  kubectl get deployments --all-namespaces | column -t
}

# Show rollout status for a deployment
krollout() {
  kubectl rollout status deployment/$1 -n ${2:-default}
}

# Port forward a pod by name pattern
kportfwd() {
  local ns=${1:-default}
  local name=$2
  local local_port=$3
  local remote_port=$4

  pod=$(kubectl get pods -n "$ns" -o name | grep "$name" | head -n 1)
  kubectl port-forward -n "$ns" "$pod" "$local_port:$remote_port"
}

# List all container images used in deployments
kimg() {
  kubectl get deployments --all-namespaces -o jsonpath="{range .items[*]}{.metadata.namespace}{'\t'}{.metadata.name}{'\t'}{range .spec.template.spec.containers[*]}{.image}{'\n'}{end}{end}" | column -t
}

# Start a temporary BusyBox pod for debugging
kdebug() {
  kubectl run -i --tty debug --image=busybox --restart=Never -- sh
}

# Clean up completed and evicted pods
kclean() {
  kubectl get pods --all-namespaces --field-selector=status.phase==Succeeded -o name | xargs kubectl delete
  kubectl get pods --all-namespaces --field-selector=status.phase==Failed -o name | grep Evicted | xargs kubectl delete
}

# Execute a command inside a pod
kexec() {
  local ns=$1
  local pod=$2
  local cmd=$3
  kubectl exec -n "$ns" "$pod" -- $cmd
}

# Show node info and their resource capacity
knodes() {
  kubectl get nodes -o wide
  echo ""
  kubectl describe nodes | grep -E 'Name:|cpu|memory'
}

# Annotate a Kubernetes resource
kannotate() {
  resource=$1
  name=$2
  key=$3
  value=$4
  kubectl annotate "$resource" "$name" "$key"="$value" --overwrite
}

# Compare current deployment YAML with a local manifest
kdiff() {
  local ns=$1
  local deploy=$2
  kubectl get deployment "$deploy" -n "$ns" -o yaml > live.yaml
  echo "Paste your manifest to: manifest.yaml and run:"
  echo "diff -u manifest.yaml live.yaml"
}