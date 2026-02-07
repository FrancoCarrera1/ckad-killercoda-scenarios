# Congratulations!

You've successfully implemented a canary deployment strategy in Kubernetes and performed a progressive rollout!

## What You Learned

### 1. Canary Deployment Pattern
- Deployed multiple versions of an application simultaneously
- Used replica counts to control traffic distribution
- Implemented progressive rollout with minimal risk

### 2. Service Selector Strategy
- Created a Service that selects across multiple deployments
- Used shared labels (`app=frontend`) for traffic routing
- Maintained separate tracking labels (`track=stable/canary`) for management

### 3. Traffic Splitting
- Achieved approximate traffic splitting through replica ratios
- Understood that Kubernetes load balancing is probabilistic
- Tested traffic distribution through multiple requests

### 4. Promotion and Rollback
- Scaled deployments to change traffic distribution
- Promoted canary to production by scaling replicas
- Understood how to quickly rollback if issues arise

## Key Takeaways

- **Label strategy**: Use common labels for Service selection, specific labels for deployment management
- **Traffic ratio**: Traffic split ≈ pods_canary / (pods_stable + pods_canary)
- **Gradual rollout**: Start with small canary (1-2 pods), gradually increase if successful
- **Quick rollback**: Scale canary to 0 to immediately stop serving traffic
- **Cost-effective**: No service mesh required for basic canary deployments

## CKAD Exam Tips

1. **Service selectors**: Remember that Services can select pods from multiple Deployments if they share labels

2. **Quick scaling**:
   ```bash
   kubectl scale deployment <name> --replicas=<count>
   ```

3. **Label management**: Use specific labels for management (track, version) but generic labels for Service selection (app, tier)

4. **Verification commands**:
   ```bash
   # Check endpoints
   kubectl get endpoints <svc-name>

   # Check pod distribution
   kubectl get pods -l app=<name> --show-labels

   # Quick deployment status
   kubectl get deploy
   ```

5. **ConfigMap mounting**: Remember that ConfigMaps can be mounted as volumes to serve different content per deployment

6. **Testing traffic**: In the exam, you might need to verify traffic distribution:
   ```bash
   kubectl run test --image=curlimages/curl --rm -i -- curl http://service
   ```

## Canary Deployment Ratios

Common canary deployment progressions:

- **10%**: 1 canary pod, 9 stable pods
- **20%**: 1 canary pod, 4 stable pods (what we did)
- **25%**: 1 canary pod, 3 stable pods
- **50%**: Equal number of canary and stable pods
- **100%**: All canary pods, 0 stable pods (full promotion)

## Real-World Enhancements

In production, you would typically:

1. **Automated Analysis**: Use tools like Flagger or Argo Rollouts for automated canary analysis
2. **Metrics-Based Decisions**: Monitor error rates, latency, and business metrics
3. **Progressive Automation**: Automatically promote or rollback based on metrics
4. **Service Mesh**: Use Istio/Linkerd for precise traffic splitting (e.g., exactly 5%)
5. **Multiple Stages**: Test canary with internal users first, then gradually expose to external traffic

## Architecture Pattern

```
                   Service (app=frontend)
                           |
                           v
         +----------------------------------+
         |                                  |
         v                                  v
  Deployment: stable              Deployment: canary
  (app=frontend,track=stable)     (app=frontend,track=canary)
  replicas: 0 → 4 → 0              replicas: 1 → 5
  nginx:1.24                       nginx:1.25
```

Great work! You've mastered the canary deployment pattern and can now safely roll out new versions with confidence.
