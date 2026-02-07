# Congratulations!

You've successfully mastered ServiceAccount token mechanics and solved The Identity Crisis!

## What You Learned

### ServiceAccount Tokens
- **Auto-mounting**: Default behavior mounts token at `/var/run/secrets/kubernetes.io/serviceaccount/`
- **Disabling auto-mount**: Use `automountServiceAccountToken: false` for pods that don't need API access
- **Token contents**: `token` (JWT), `ca.crt` (cluster CA), `namespace` (pod namespace)

### Projected Volumes
- **Custom tokens**: Define audience, expiration, and path
- **Automatic rotation**: Kubelet refreshes tokens before expiration
- **Multiple sources**: Combine ServiceAccountToken with ConfigMaps, Secrets, downwardAPI
- **Use cases**: Service mesh, external auth, short-lived tokens

### In-Cluster API Access
- **Discovery**: `kubernetes.default.svc` or environment variables
- **Authentication**: Bearer token in `Authorization` header
- **Authorization**: RBAC controls what the ServiceAccount can do
- **TLS**: CA cert at `/var/run/secrets/kubernetes.io/serviceaccount/ca.crt`

## CKAD Exam Tips

### Quick ServiceAccount Commands

```bash
# Create ServiceAccount
kubectl create serviceaccount <name> -n <namespace>

# Create pod with specific ServiceAccount
kubectl run <pod> --image=<image> --serviceaccount=<sa-name> -n <ns>

# Disable auto-mount (in YAML)
spec:
  automountServiceAccountToken: false
```

### RBAC for ServiceAccounts

```bash
# Create Role
kubectl create role <role-name> \
  --verb=get,list \
  --resource=pods \
  -n <namespace>

# Bind Role to ServiceAccount
kubectl create rolebinding <binding-name> \
  --role=<role-name> \
  --serviceaccount=<namespace>:<sa-name> \
  -n <namespace>

# Test permissions
kubectl auth can-i <verb> <resource> \
  --as=system:serviceaccount:<namespace>:<sa-name> \
  -n <namespace>
```

### Projected Volume Template

```yaml
volumes:
- name: custom-token
  projected:
    sources:
    - serviceAccountToken:
        audience: <audience>
        expirationSeconds: <seconds>
        path: token
```

### In-Cluster API Access Pattern

```bash
# From within a pod:
TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
NAMESPACE=$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace)

curl -sk https://kubernetes.default.svc/api/v1/namespaces/$NAMESPACE/pods \
  -H "Authorization: Bearer $TOKEN"
```

## Common Exam Scenarios

### Scenario 1: Create Pod with Custom ServiceAccount
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  serviceAccountName: my-service-account
  containers:
  - name: app
    image: myapp:latest
```

### Scenario 2: Disable Token Auto-Mount
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: no-token-pod
spec:
  automountServiceAccountToken: false
  containers:
  - name: app
    image: myapp:latest
```

### Scenario 3: Projected Volume Token
```yaml
volumes:
- name: token-vol
  projected:
    sources:
    - serviceAccountToken:
        audience: api.example.com
        expirationSeconds: 3600
        path: token
volumeMounts:
- name: token-vol
  mountPath: /var/run/secrets/tokens
```

### Scenario 4: Grant API Access
```bash
# 1. Create ServiceAccount
kubectl create sa api-bot -n my-namespace

# 2. Create Role
kubectl create role pod-lister \
  --verb=get,list \
  --resource=pods \
  -n my-namespace

# 3. Create RoleBinding
kubectl create rolebinding api-bot-binding \
  --role=pod-lister \
  --serviceaccount=my-namespace:api-bot \
  -n my-namespace

# 4. Use SA in pod
kubectl run my-pod --image=nginx --serviceaccount=api-bot -n my-namespace
```

## Best Practices

### Security
- **Least Privilege**: Only grant necessary permissions
- **Disable Auto-Mount**: For pods that don't need API access
- **Short-Lived Tokens**: Use projected volumes with short expiration
- **Audit**: Monitor ServiceAccount usage and permissions

### Token Management
- **Default SA**: Don't use for production workloads
- **Dedicated SAs**: One per application or workload type
- **Rotation**: Projected volumes rotate automatically
- **Audience**: Use custom audiences for non-Kubernetes systems

### RBAC
- **Namespace-scoped**: Use Role/RoleBinding when possible
- **Cluster-scoped**: Use ClusterRole/ClusterRoleBinding only when needed
- **Granular**: Grant specific verbs and resources, not wildcards
- **Test**: Use `kubectl auth can-i` to verify permissions

## Troubleshooting

### Token Not Found
```bash
# Check if auto-mount is disabled
kubectl get pod <pod> -o jsonpath='{.spec.automountServiceAccountToken}'

# Check ServiceAccount exists
kubectl get sa <sa-name> -n <namespace>
```

### Permission Denied
```bash
# Check RBAC bindings
kubectl get rolebinding -n <namespace>

# Test permissions
kubectl auth can-i <verb> <resource> \
  --as=system:serviceaccount:<namespace>:<sa-name> \
  -n <namespace>

# Check Role/ClusterRole
kubectl describe role <role-name> -n <namespace>
```

### API Connection Failed
```bash
# Verify API server service
kubectl get svc kubernetes

# Check DNS resolution from pod
kubectl exec <pod> -- nslookup kubernetes.default.svc

# Test basic connectivity
kubectl exec <pod> -- curl -k https://kubernetes.default.svc
```

## API Resource Paths

### Core API (v1)
- Pods: `/api/v1/namespaces/<ns>/pods`
- Services: `/api/v1/namespaces/<ns>/services`
- ConfigMaps: `/api/v1/namespaces/<ns>/configmaps`
- Secrets: `/api/v1/namespaces/<ns>/secrets`

### Apps API (apps/v1)
- Deployments: `/apis/apps/v1/namespaces/<ns>/deployments`
- StatefulSets: `/apis/apps/v1/namespaces/<ns>/statefulsets`
- DaemonSets: `/apis/apps/v1/namespaces/<ns>/daemonsets`

### Batch API (batch/v1)
- Jobs: `/apis/batch/v1/namespaces/<ns>/jobs`
- CronJobs: `/apis/batch/v1/namespaces/<ns>/cronjobs`

## Token Anatomy (JWT)

A ServiceAccount token is a JSON Web Token (JWT) with three parts:
1. **Header**: Algorithm and type
2. **Payload**: Claims (sub, iss, aud, exp, iat, kubernetes.io/serviceaccount/*)
3. **Signature**: Signed by cluster's private key

Example payload:
```json
{
  "iss": "kubernetes/serviceaccount",
  "sub": "system:serviceaccount:identity-lab:api-bot",
  "aud": ["kubernetes.default.svc"],
  "exp": 1735000000,
  "iat": 1734996400,
  "kubernetes.io/serviceaccount/namespace": "identity-lab",
  "kubernetes.io/serviceaccount/service-account.name": "api-bot"
}
```

## Next Steps

- Explore client-go library for programmatic API access
- Learn about TokenRequest API for short-lived tokens
- Study service mesh token exchange (e.g., Istio SDS)
- Practice writing operators that use ServiceAccount tokens
- Investigate Pod Identity (Azure, AWS, GCP) for cloud integration

Excellent work! ServiceAccount tokens and RBAC are fundamental to Kubernetes security and a critical topic for the CKAD exam. You now understand how pods authenticate and authorize API access!
