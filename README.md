# kube-utils

A set of handy Zsh-based command-line utilities to simplify and speed up working with Kubernetes clusters.

## 🚀 Features

- ✅ List services with namespace, cluster-local URL, and exposed ports (`kservices`)
- ✅ View pods in wide format (IP, Node, Status) (`kpods`)
- ✅ Tail logs of the latest pod matching a name (`kf`)
- ✅ Open a shell inside a pod (`ksh`)
- ✅ List ingress domains and paths (`kingress`)
- ✅ Detect crash or image pull errors in pods (`kcrash`)
- ✅ Search within ConfigMaps and Secrets (`kfind`)
- ✅ List top pods by CPU usage (`ktop`)
- ✅ Show the most recently created pod (`knewest`)
- ✅ Switch between Kubernetes contexts (`kctx`)
- ✅ Change namespace in current context (`kns`)
- ✅ List all deployments across namespaces (`kdeploys`)
- ✅ Monitor rollout status of a deployment (`krollout`)
- ✅ Port-forward pod to localhost (`kportfwd`)
- ✅ List all container images used in deployments (`kimg`)
- ✅ Launch a temporary BusyBox pod for debugging (`kdebug`)
- ✅ Clean up completed or evicted pods (`kclean`)
- ✅ Execute a command inside a pod (`kexec`)
- ✅ View Kubernetes node info and resource capacity (`knodes`)
- ✅ Annotate a resource (`kannotate`)
- ✅ Compare live deployment YAML with a local manifest (`kdiff`)
- ✅ Backup full cluster resources and Helm releases (`kbackup`)
- ✅ Restore from cluster resource and Helm manifest backups (`krestore`)

## 📦 Installation

You can add this utility set to your machine with a simple `curl` command:

```bash
curl -o ~/.kube-utils.zsh https://raw.githubusercontent.com/isimtekin/kube-utils/main/.kube-utils.zsh
echo 'source ~/.kube-utils.zsh' >> ~/.zshrc
echo 'alias kube-utils-update="curl -fsSL https://raw.githubusercontent.com/isimtekin/kube-utils/main/.kube-utils.zsh -o ~/.kube-utils.zsh && source ~/.kube-utils.zsh"'  >> ~/.zshrc
source ~/.zshrc
```

> ⚠️ You need to have `kubectl` and `column` installed. Most systems already have `column`. Optionally, you can install `jq` for extended features.

## 🧪 Usage

```bash
kservices [namespace]             # List services with their URLs and ports
kpods [namespace]                 # Show pods with wide output
kf <namespace> <name-pattern>     # Tail logs of latest pod matching pattern
ksh <namespace> <pod-name>        # Start shell inside a pod
kingress                          # Show ingress domain and path mappings
kcrash                            # List pods in error or crash loop
kfind <configmap|secret> <kw>    # Search inside ConfigMaps or Secrets
ktop                              # Show top 10 pods by CPU
knewest [namespace]               # Most recently created pod
kctx                              # Show current context and list all
kns <namespace>                   # Change the active namespace
kdeploys                          # List all deployments across namespaces
krollout <deployment> [ns]        # Watch rollout status of a deployment
kportfwd <ns> <name> <lport> <rport> # Port forward a pod to localhost
kimg                              # List all images used in deployments
kdebug                            # Launch temporary BusyBox pod for debugging
kclean                            # Clean up completed and evicted pods
kexec <ns> <pod> <cmd>            # Execute command in a pod
knodes                            # Show node info and resource capacity
kannotate <res> <name> <k> <v>    # Add or update annotation on a resource
kdiff <ns> <deployment>           # Diff live deployment with local manifest
kbackup                            # Backup all namespaces, resources, and Helm manifests
krestore <path>                    # Restore Kubernetes resources and Helm manifests from backup
```

All commands are namespace-aware and safe to run.

## 👤 Author

[Ersin Isimtekin](https://github.com/isimtekin)

## 🪪 License

MIT
