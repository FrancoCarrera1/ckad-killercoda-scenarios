# Congratulations, Observatory Master!

You've completed a comprehensive tour of Kubernetes observability and debugging! These are essential skills for any Kubernetes administrator or developer, and critical for the CKAD exam.

## What You Accomplished

1. **Resource Monitoring**: Used `kubectl top` to monitor CPU and memory usage across nodes and pods
2. **Log Analysis**: Mastered log extraction with container-specific, time-based, and label-based filters
3. **Crash Debugging**: Identified and fixed an OOMKilled pod by adjusting resource limits
4. **Health Assessment**: Evaluated cluster health through node conditions, system pods, and events

## Key Commands Mastered

### Resource Monitoring
```bash
kubectl top nodes
kubectl top pods -n <namespace>
kubectl top pods --sort-by=cpu
kubectl top pods --sort-by=memory
```

### Log Analysis
```bash
kubectl logs <pod> -c <container>        # Specific container
kubectl logs <pod> --all-containers      # All containers
kubectl logs <pod> --previous            # Previous container instance
kubectl logs <pod> --since=5m            # Last 5 minutes
kubectl logs -l app=myapp                # By label selector
kubectl logs <pod> --prefix              # Show container name prefix
```

### Debugging
```bash
kubectl get pod <pod> -o yaml            # Full pod spec
kubectl describe pod <pod>               # Detailed info + events
kubectl get events --sort-by='.lastTimestamp'
kubectl get events --field-selector type=Warning
```

### Health Checks
```bash
kubectl get nodes -o wide
kubectl describe nodes
kubectl get pods -n kube-system
kubectl get componentstatuses  # (deprecated but still useful)
```

## Common Issues and Solutions

### OOMKilled Pods
- **Symptom**: Pod status shows OOMKilled or CrashLoopBackOff
- **Cause**: Container used more memory than its limit
- **Solution**: Increase `resources.limits.memory` or optimize the application

### High CPU Usage
- **Symptom**: Pod consuming excessive CPU in `kubectl top`
- **Investigate**: Check container processes, review application code
- **Solution**: Set CPU limits, optimize code, or scale horizontally

### Missing Logs
- **Symptom**: `kubectl logs` returns empty or old logs
- **Solution**: Use `--previous` flag for crashed containers, check container name with `-c`

### Metrics Unavailable
- **Symptom**: `kubectl top` returns "metrics not available"
- **Solution**: Ensure metrics-server is deployed and running in kube-system namespace

## CKAD Exam Tips

1. **kubectl top requires metrics-server**: Know that it won't work without it
2. **Multi-container pods**: Always specify `-c <container>` for logs and exec
3. **Resource units**: Memory uses Mi/Gi, CPU uses millicores (m) or cores
4. **Events are time-limited**: Events expire, so check them quickly when debugging
5. **--previous flag**: Essential for debugging crashed containers
6. **Label selectors**: Use `-l` to filter pods for logs and other operations

## Real-World Applications

These skills are used daily to:
- Monitor application performance and resource usage
- Debug production issues quickly
- Identify resource bottlenecks before they cause outages
- Audit cluster health and capacity
- Troubleshoot deployment problems
- Investigate security incidents through log analysis

## Next Steps

Practice these workflows:
1. Set up alerts for high resource usage
2. Create dashboards with metrics-server data
3. Integrate with logging platforms (ELK, Loki, etc.)
4. Automate health checks with scripts
5. Practice debugging under time pressure (like in the CKAD exam!)

Excellent work! You now have the observability skills needed to maintain healthy Kubernetes clusters and ace the CKAD exam.
