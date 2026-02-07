# Step 3: Use Token for In-Cluster API Access

Now let's put the token to use! You'll configure RBAC permissions for the `api-bot` ServiceAccount and use its token to access the Kubernetes API from within the pod.

## Your Task

### Part 1: Configure RBAC

1. **Create a Role** named `pod-reader` in `identity-lab`:
   - Allow `get` and `list` on `pods` resource
   - API group: `""` (core)

2. **Create a RoleBinding** named `api-bot-binding` in `identity-lab`:
   - Bind the `pod-reader` Role to the `api-bot` ServiceAccount

### Part 2: Test API Access

3. **Exec into `custom-token-pod`** and use curl to access the API:
   ```bash
   TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
   curl -sk https://kubernetes.default.svc/api/v1/namespaces/identity-lab/pods \
     -H "Authorization: Bearer $TOKEN"
   ```

4. **Verify the response**:
   - You should see a JSON response listing pods in `identity-lab` namespace
   - This proves the token works and RBAC is configured correctly

<details><summary>Hint</summary>

To create the Role:
```bash
kubectl create role pod-reader \
  --verb=get,list \
  --resource=pods \
  -n identity-lab
```

To create the RoleBinding:
```bash
kubectl create rolebinding api-bot-binding \
  --role=pod-reader \
  --serviceaccount=identity-lab:api-bot \
  -n identity-lab
```

To test with `kubectl auth can-i`:
```bash
kubectl auth can-i list pods \
  --as=system:serviceaccount:identity-lab:api-bot \
  -n identity-lab
```

</details>

<details><summary>Solution</summary>

```bash
# Part 1: Configure RBAC

# Create Role
kubectl create role pod-reader \
  --verb=get,list \
  --resource=pods \
  -n identity-lab

# Alternative: Create via YAML
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-reader
  namespace: identity-lab
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list"]
EOF

# Create RoleBinding
kubectl create rolebinding api-bot-binding \
  --role=pod-reader \
  --serviceaccount=identity-lab:api-bot \
  -n identity-lab

# Alternative: Create via YAML
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: api-bot-binding
  namespace: identity-lab
subjects:
- kind: ServiceAccount
  name: api-bot
  namespace: identity-lab
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
EOF

# Verify permissions
kubectl auth can-i list pods \
  --as=system:serviceaccount:identity-lab:api-bot \
  -n identity-lab
# Should return: yes

# Part 2: Test API Access

# Note: The custom-token-pod uses a custom audience (api.mycompany.io)
# which won't work with the Kubernetes API. We need to use a pod with
# the default token or auto-mount-pod for this test.

# Let's use auto-mount-pod (which has the standard Kubernetes token)
kubectl exec auto-mount-pod -n identity-lab -- sh -c '
  TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
  curl -sk https://kubernetes.default.svc/api/v1/namespaces/identity-lab/pods \
    -H "Authorization: Bearer $TOKEN"
'

# OR create a new pod with api-bot SA and default token
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: api-access-pod
  namespace: identity-lab
spec:
  serviceAccountName: api-bot
  containers:
  - name: curl
    image: curlimages/curl:8.1.0
    command: ["sleep", "3600"]
EOF

kubectl wait --for=condition=Ready pod/api-access-pod -n identity-lab --timeout=60s

# Test API access from api-access-pod
kubectl exec api-access-pod -n identity-lab -- sh -c '
  TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
  curl -sk https://kubernetes.default.svc/api/v1/namespaces/identity-lab/pods \
    -H "Authorization: Bearer $TOKEN"
'

# You should see JSON output with pod information
```

</details>

## Understanding In-Cluster API Access

### How Pods Access the API

1. **Service Discovery**:
   - DNS name: `kubernetes.default.svc` or `kubernetes.default.svc.cluster.local`
   - Environment variables: `KUBERNETES_SERVICE_HOST` and `KUBERNETES_SERVICE_PORT`

2. **Authentication**:
   - Bearer token from `/var/run/secrets/kubernetes.io/serviceaccount/token`
   - Header: `Authorization: Bearer <token>`

3. **TLS Verification**:
   - CA certificate: `/var/run/secrets/kubernetes.io/serviceaccount/ca.crt`
   - Use `-k` or `--insecure` to skip verification (not recommended in production)

### API Request Structure

```bash
curl -sk https://kubernetes.default.svc/api/v1/namespaces/<namespace>/<resource> \
  -H "Authorization: Bearer $TOKEN"
```

Examples:
- List pods: `/api/v1/namespaces/identity-lab/pods`
- Get specific pod: `/api/v1/namespaces/identity-lab/pods/my-pod`
- List deployments: `/apis/apps/v1/namespaces/identity-lab/deployments`

### Authentication vs Authorization

- **Authentication**: Token proves WHO you are (ServiceAccount)
- **Authorization**: RBAC determines WHAT you can do
- Both must succeed for the request to be allowed

## Common Use Cases

### Application Use Cases
- **Service discovery**: Query API for endpoints, services
- **Leader election**: Coordinate which pod is active
- **Dynamic configuration**: Read ConfigMaps/Secrets
- **Monitoring**: List pods, check health status
- **Operators**: Watch and reconcile resources

### Testing from Inside Pod

```bash
# Install curl if needed
kubectl exec <pod> -n <ns> -- apk add --no-cache curl

# Test basic connectivity
kubectl exec <pod> -n <ns> -- curl -k https://kubernetes.default.svc

# List pods with token
kubectl exec <pod> -n <ns> -- sh -c '
  TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
  curl -sk https://kubernetes.default.svc/api/v1/namespaces/<ns>/pods \
    -H "Authorization: Bearer $TOKEN"
'
```

### Using Client Libraries

Instead of raw curl, production applications use client libraries:
- **Go**: `client-go` (official)
- **Python**: `kubernetes-client`
- **Java**: `kubernetes-client-java`
- **JavaScript**: `@kubernetes/client-node`

These libraries handle authentication, TLS, and API versioning automatically.
