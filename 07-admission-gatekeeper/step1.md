# Step 1: Identify Enabled Admission Controllers

Admission controllers are configured at the API server level. Let's examine which ones are enabled in your cluster.

## Your Task

1. **Find the kube-apiserver pod**:
   - The API server runs as a static pod in the `kube-system` namespace
   - It's typically named `kube-apiserver-<node-name>`

2. **Examine the admission plugins**:
   - Look at the pod's command-line arguments
   - Find the `--enable-admission-plugins` flag
   - Save the list of enabled plugins to `/root/admission-plugins.txt`

3. **Identify key admission controllers**:
   - Look for: `LimitRanger`, `ResourceQuota`, `PodSecurity`, `NodeRestriction`
   - These are the gatekeepers you'll work with

<details><summary>Hint</summary>

To find the API server pod:
```bash
kubectl get pods -n kube-system | grep apiserver
```

To see the full command and arguments:
```bash
kubectl get pod <apiserver-pod-name> -n kube-system -o yaml | grep -A 5 "enable-admission-plugins"
```

Or look at the static pod manifest:
```bash
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep enable-admission-plugins
```

To save to a file:
```bash
kubectl get pod <apiserver-pod-name> -n kube-system -o yaml | grep "enable-admission-plugins" > /root/admission-plugins.txt
```

</details>

<details><summary>Solution</summary>

```bash
# Find the API server pod
kubectl get pods -n kube-system | grep apiserver

# Get the pod name (it will be something like kube-apiserver-controlplane)
APISERVER_POD=$(kubectl get pods -n kube-system -o name | grep apiserver | head -1)

# View the admission plugins
kubectl get $APISERVER_POD -n kube-system -o yaml | grep "enable-admission-plugins"

# Save to file
kubectl get $APISERVER_POD -n kube-system -o yaml | grep "enable-admission-plugins" > /root/admission-plugins.txt

# Alternative: check the static pod manifest
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep enable-admission-plugins

# View the file
cat /root/admission-plugins.txt
```

Common admission controllers you'll see:
- **NodeRestriction**: Limits what kubelets can modify
- **LimitRanger**: Enforces LimitRange constraints
- **ResourceQuota**: Enforces ResourceQuota constraints
- **PodSecurity**: Enforces Pod Security Standards
- **ServiceAccount**: Automates ServiceAccount token mounting
- **DefaultStorageClass**: Sets default storage class
- **MutatingAdmissionWebhook**: Calls external webhooks that can modify requests
- **ValidatingAdmissionWebhook**: Calls external webhooks that validate requests

</details>

## Understanding Admission Controllers

### Built-in Controllers
- **Compiled into the API server**
- Enabled via `--enable-admission-plugins` flag
- Common ones: LimitRanger, ResourceQuota, PodSecurity, NodeRestriction

### Webhook Controllers
- **External services**
- Registered as MutatingWebhookConfiguration or ValidatingWebhookConfiguration
- Examples: OPA Gatekeeper, Istio sidecar injection

### Admission Controller Order
1. **Mutating** controllers run first (can modify requests)
2. **Validating** controllers run last (can only accept/reject)
3. If any controller rejects, the entire request fails
