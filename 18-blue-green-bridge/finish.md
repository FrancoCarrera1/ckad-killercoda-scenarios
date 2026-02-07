# Congratulations!

You've successfully implemented a blue-green deployment pattern in Kubernetes!

## What You Learned

- **Blue-Green Pattern**: Deployed two identical environments side-by-side
- **Service Routing**: Used Service label selectors to control traffic routing
- **Atomic Cutover**: Switched traffic instantly with zero downtime
- **ConfigMap Mounting**: Mounted ConfigMaps as volumes to serve content
- **Rollback Readiness**: Kept blue scaled to 0 for quick rollback capability

## Key Concepts

### Blue-Green vs Rolling Update

**Blue-Green**:
- ✅ Instant cutover (change Service selector)
- ✅ Instant rollback (change selector back)
- ✅ Easy to test green before cutover
- ❌ Requires 2x resources during deployment
- ❌ Database migrations can be tricky
- Best for: Major releases, high-risk changes

**Rolling Update**:
- ✅ Resource efficient (controlled pod replacement)
- ✅ Gradual rollout can catch issues early
- ❌ Slower cutover
- ❌ Rollback requires new rollout
- Best for: Regular updates, minor changes

### Service Selector Switching

The magic of blue-green in Kubernetes:
```bash
# Before: selector: {app: webapp, version: blue}
# After:  selector: {app: webapp, version: green}
```

Kubernetes immediately updates the Service's endpoints to point to pods with the new label. This happens in milliseconds.

### Resource Requirements

Blue-green temporarily doubles resource usage:
- 3 blue pods + 3 green pods = 6 total
- After cutover, scale blue to 0
- Keep blue deployment for quick rollback
- Delete blue when confident in green

## CKAD Exam Tips

1. **Quick Selector Patch**:
   ```bash
   kubectl patch svc myapp -p '{"spec":{"selector":{"version":"green"}}}'
   ```

2. **Multiple Selectors**: Services can have multiple label selectors - ALL must match:
   ```yaml
   selector:
     app: webapp      # AND
     version: green   # must both match
   ```

3. **Check Endpoints**: Verify traffic routing with:
   ```bash
   kubectl get endpoints myapp
   ```
   Shows which pod IPs the Service is routing to.

4. **Scale to Zero**: Keep deployments at 0 replicas for quick rollback:
   ```bash
   kubectl scale deployment old-version --replicas=0
   ```

5. **Testing Before Cutover**: Access green directly before switching:
   ```bash
   # Create temporary service for testing
   kubectl expose deployment webapp-green --name=webapp-test --port=80
   # Test it
   # Delete when done
   kubectl delete service webapp-test
   ```

6. **Common Exam Pattern**:
   - Deploy new version with different label (version=v2)
   - Test it
   - Switch Service selector to new label
   - Verify traffic switched

7. **ConfigMap as Volume**:
   ```yaml
   volumes:
   - name: config
     configMap:
       name: my-config
   volumeMounts:
   - name: config
     mountPath: /etc/config
   ```

## Advanced Patterns

### Blue-Green with Ingress

For external traffic, use Ingress annotations:
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: webapp
spec:
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: webapp-svc  # Switch Service, or change Ingress backend
            port:
              number: 80
```

### Database Considerations

Blue-green with databases requires:
- Backward-compatible migrations (blue and green share DB during transition)
- Or separate databases (more complex)
- Or read-only blue after cutover

### Smoke Testing

Before full cutover:
```bash
# Create test service for green
kubectl expose deployment webapp-green --name=green-test --port=80
# Run smoke tests against green-test
# If tests pass, switch main service
kubectl patch svc webapp-svc -p '{"spec":{"selector":{"version":"green"}}}'
```

## When to Use Blue-Green

**Good for**:
- Major version upgrades
- High-risk deployments
- Compliance requirements (instant rollback)
- A/B testing infrastructure
- Scheduled maintenance windows

**Not ideal for**:
- Resource-constrained clusters
- Frequent small updates (use rolling instead)
- Stateful applications with complex data migrations
- When you need gradual traffic shifting (use canary)

## Next Steps

Learn canary deployments for progressive rollout with weighted traffic splitting!
