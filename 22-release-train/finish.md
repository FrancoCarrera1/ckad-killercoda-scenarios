# Congratulations!

You've completed the Release Train and orchestrated a full-stack deployment pipeline!

## What You Learned

- **Multi-tool Orchestration**: Combined Helm and Kustomize in a single deployment
- **Service Dependencies**: Configured webapp to connect to Redis infrastructure
- **Rolling Updates**: Performed zero-downtime updates with Kubernetes
- **Failure Recovery**: Simulated failures and executed rollbacks
- **Environment Variables**: Used env vars for service discovery
- **Real-World Patterns**: Applied production deployment practices

## CKAD Exam Tips

### 1. Tool Selection
- **Helm**: Pre-packaged applications (databases, monitoring, ingress controllers)
- **Kustomize**: Custom applications, environment-specific configs
- **Raw YAML**: Simple, one-off resources

### 2. Rolling Updates
```bash
# Trigger update
kubectl set image deployment/webapp nginx=nginx:1.26 -n fullstack

# Watch progress
kubectl rollout status deployment/webapp -n fullstack

# Pause if issues arise
kubectl rollout pause deployment/webapp -n fullstack

# Resume
kubectl rollout resume deployment/webapp -n fullstack
```

### 3. Rollback Commands
```bash
# Undo to previous revision
kubectl rollout undo deployment/webapp -n fullstack

# Undo to specific revision
kubectl rollout undo deployment/webapp --to-revision=2 -n fullstack

# View history
kubectl rollout history deployment/webapp -n fullstack

# View specific revision details
kubectl rollout history deployment/webapp --revision=3 -n fullstack
```

### 4. Service Discovery
In Kubernetes, services are accessible via DNS:
- Same namespace: `service-name`
- Different namespace: `service-name.namespace.svc.cluster.local`
- Full FQDN: `service-name.namespace.svc.cluster.local`

### 5. Environment Variables
```yaml
env:
  - name: REDIS_HOST
    value: my-redis-master.fullstack.svc.cluster.local
  - name: DB_PASSWORD
    valueFrom:
      secretKeyRef:
        name: db-secret
        key: password
```

### 6. Quick Verification
```bash
# Check deployment status
kubectl get deployment -n fullstack

# Check pod health
kubectl get pods -n fullstack

# Check events for errors
kubectl get events -n fullstack --sort-by='.lastTimestamp'

# Exec into pod for testing
kubectl exec -it <pod-name> -n fullstack -- sh
```

## Production Best Practices

1. **Always test updates in dev/staging first**
2. **Use health checks** (readiness/liveness probes)
3. **Set resource limits** to prevent resource exhaustion
4. **Monitor rollout progress** before marking deployment complete
5. **Keep rollout history** for easy rollbacks
6. **Use version tags**, not `latest`, for reproducibility

## Common Pitfalls

- **Forgetting `-n namespace`**: Always specify the namespace
- **Not waiting for rollout**: Verify with `kubectl rollout status`
- **Breaking changes without rollback plan**: Always know how to undo
- **Missing dependencies**: Ensure backing services are ready first
- **Image pull errors**: Verify image names and registry access

## Time-Saving Exam Aliases

```bash
alias k='kubectl'
alias h='helm'
alias kgp='kubectl get pods'
alias kgd='kubectl get deployments'
alias kdp='kubectl describe pod'
alias kl='kubectl logs'
alias ke='kubectl exec -it'
```

Keep practicing these workflows—combining tools, managing dependencies, and handling failures are essential CKAD skills that you'll use every day in production Kubernetes!
