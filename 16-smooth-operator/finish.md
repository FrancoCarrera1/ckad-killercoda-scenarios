# Congratulations!

You've mastered rolling update configuration for Kubernetes Deployments!

## What You Learned

- **Rolling Update Strategy**: Configured `maxUnavailable` and `maxSurge` to control deployment update speed
- **Update Monitoring**: Used `kubectl rollout status` to watch deployment progress
- **Change Tracking**: Annotated deployments with `kubernetes.io/change-cause` for audit trails
- **History Management**: Viewed and compared rollout revisions

## Key Concepts

### maxUnavailable
Specifies the maximum number of pods that can be unavailable during the update. Can be an absolute number or percentage.
- `maxUnavailable: 1` means at least (replicas - 1) pods are always available
- Smaller values = slower rollout, higher availability during update

### maxSurge
Specifies the maximum number of extra pods that can be created above the desired replica count. Can be an absolute number or percentage.
- `maxSurge: 1` means at most (replicas + 1) pods during update
- Larger values = faster rollout, more resource usage

### Trade-offs
- **Fast rollout**: High maxSurge, high maxUnavailable (more disruption, faster)
- **Safe rollout**: Low maxSurge, low maxUnavailable (slower, more stable)
- **Default**: maxSurge=25%, maxUnavailable=25%

## CKAD Exam Tips

1. **Quick Strategy Updates**: Know how to use `kubectl patch` to modify strategy without editing YAML
   ```bash
   kubectl patch deployment myapp -p '{"spec":{"strategy":{"rollingUpdate":{"maxSurge":2,"maxUnavailable":0}}}}'
   ```

2. **Zero Downtime**: For zero downtime, set `maxUnavailable: 0` and `maxSurge: 1+`

3. **Resource Constraints**: If resources are tight, use `maxSurge: 0` to prevent extra pods

4. **Change-Cause**: Remember the annotation: `kubernetes.io/change-cause` (useful for tracking)

5. **Rollout Commands**:
   - `kubectl rollout status` - watch rollout progress
   - `kubectl rollout history` - view revision history
   - `kubectl rollout pause` - pause a rollout
   - `kubectl rollout resume` - resume a paused rollout
   - `kubectl rollout undo` - rollback (covered in next scenario!)

6. **Common Patterns**:
   - High availability services: `maxUnavailable: 0, maxSurge: 1`
   - Fast rollout: `maxUnavailable: 50%, maxSurge: 50%`
   - Resource constrained: `maxSurge: 0, maxUnavailable: 1`

## Next Steps

Practice the Time Machine scenario to learn rollback techniques when deployments go wrong!
