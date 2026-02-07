# Congratulations!

You've successfully rescued a broken deployment using Kubernetes rollback features!

## What You Learned

- **Troubleshooting**: Diagnosed `ImagePullBackOff` errors using `kubectl describe`
- **Quick Rollback**: Used `kubectl rollout undo` to revert to the previous working version
- **Targeted Rollback**: Rolled back to a specific revision with `--to-revision`
- **Change Tracking**: Maintained audit trail with change-cause annotations
- **Revision History**: Navigated deployment revision history

## Key Concepts

### Deployment Revisions
Every time a Deployment's Pod template changes, Kubernetes creates a new revision. ReplicaSets from old revisions are kept (controlled by `revisionHistoryLimit`, default 10).

### ImagePullBackOff
Common causes:
- Image doesn't exist (wrong tag)
- Private registry without imagePullSecrets
- Network issues reaching registry
- Rate limiting from Docker Hub

### Rollback Strategy
When rolling back, Kubernetes:
1. Creates a new revision (rollback is just another update!)
2. Uses the pod template from the target revision
3. Performs a rolling update to the old version
4. The old ReplicaSet becomes active again

### Revision Numbers
- Revisions increment sequentially
- Rolling back creates a NEW revision with old template
- Original revision number is NOT reused
- Example: Rev 1 → 2 → 3 (break) → undo → 4 (same as 2)

## CKAD Exam Tips

1. **Quick Undo**: `kubectl rollout undo deployment/myapp` rolls back one revision

2. **Specific Revision**: `kubectl rollout undo deployment/myapp --to-revision=3` goes to exact revision

3. **Check History First**: Always run `kubectl rollout history` to see available revisions

4. **View Revision Details**: `kubectl rollout history deployment/myapp --revision=5` shows that revision's config

5. **Troubleshooting Flow**:
   ```bash
   kubectl get pods                    # See pod status
   kubectl describe pod <name>         # Get error details
   kubectl logs <name>                 # Check application logs (if pod started)
   kubectl rollout history deploy/app  # View history
   kubectl rollout undo deploy/app     # Fix it!
   ```

6. **Common Scenarios**:
   - Bad image tag: Rollback immediately
   - Configuration error: Rollback and fix YAML
   - Resource limits too low: May need to fix AND rollback
   - Database migration failed: Be careful! May need manual intervention

7. **Pause During Rollout**: If you catch a problem early:
   ```bash
   kubectl rollout pause deployment/myapp
   # Fix the issue
   kubectl rollout resume deployment/myapp
   ```

8. **RevisionHistoryLimit**: Control how many old ReplicaSets to keep:
   ```yaml
   spec:
     revisionHistoryLimit: 10  # default
   ```

## Pro Tips

- **Fast Detection**: Set up liveness/readiness probes to catch bad deployments quickly
- **Progressive Rollout**: Use small maxUnavailable to catch issues before all pods are affected
- **Change-Cause**: Always annotate with why you're making changes
- **Test First**: Deploy to dev/staging before production
- **Automated Rollback**: Some tools (Argo Rollouts, Flagger) can automatically rollback on metrics

## Next Steps

Learn advanced deployment patterns with Blue-Green and Canary deployments in the next scenarios!
