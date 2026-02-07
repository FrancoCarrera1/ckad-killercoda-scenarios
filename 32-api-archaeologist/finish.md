# Congratulations, API Archaeologist!

You've successfully excavated and modernized ancient Kubernetes manifests! This is a crucial real-world skill as Kubernetes continues to evolve and deprecate old API versions.

## What You Accomplished

1. **Identified Deprecated APIs**: Discovered which API versions are no longer supported
2. **Converted Deployment**: Migrated from `extensions/v1beta1` to `apps/v1` with required selector
3. **Updated Ingress**: Converted from `networking.k8s.io/v1beta1` to `v1` with new backend structure
4. **Modernized CronJob**: Upgraded from `batch/v1beta1` to `batch/v1`
5. **Deployed Successfully**: Applied all modernized manifests to a running cluster

## Key Takeaways

### Deployment (apps/v1)
- **Must have**: `spec.selector.matchLabels` that matches pod labels
- This is the most common migration issue

### Ingress (networking.k8s.io/v1)
- **Backend structure changed**:
  - Old: `serviceName` and `servicePort`
  - New: `service.name` and `service.port.number`
- **pathType is required**: Usually `Prefix` or `Exact`

### CronJob (batch/v1)
- The structure remained the same, only the API version changed
- This is now the stable API version

## CKAD Exam Tips

- Always check the API version first when debugging manifest issues
- Know the required fields for `apps/v1` Deployments (especially `selector`)
- Remember that `networking.k8s.io/v1` Ingress requires `pathType`
- Use `kubectl api-resources` to see current API versions
- Use `kubectl explain <resource>` to check field requirements

## Additional Practice

Try these commands to explore API versions:
```bash
# List all API resources and their versions
kubectl api-resources

# Get detailed field documentation
kubectl explain deployment.spec
kubectl explain ingress.spec.rules.http.paths

# Check API version deprecations
kubectl api-versions
```

Great work! You're now ready to handle API version migrations in any Kubernetes cluster.
