## Step 2: Verify Init Container

Verify that the init container completed successfully before the main containers started.

### Requirements

1. Check that the pod shows `2/2 Ready` (init containers don't count in the ready count)
2. Verify the init container status shows it completed successfully
3. Check the init container logs to see it successfully resolved the database service

### Key Concepts

- **Init Container Lifecycle**: Init containers run to completion in order, each must succeed before the next starts
- **Pod Status**: The `READY` count only shows main containers (e.g., `2/2`), init containers are separate
- **Container States**: Init containers will show status `Completed` after successful execution

<details><summary>Hint</summary>

Use these commands to inspect the pod:

```bash
# Check pod status
kubectl get pod webapp -n microservices

# Describe pod to see init container status
kubectl describe pod webapp -n microservices

# View init container logs
kubectl logs webapp -n microservices -c wait-for-db
```

Look for:
- Ready status: `2/2`
- Init container state: Terminated with Reason: Completed
- Init container logs showing successful DNS resolution

</details>

<details><summary>Solution</summary>

```bash
# Check pod is running with 2/2 containers ready
kubectl get pod webapp -n microservices

# View detailed pod status
kubectl describe pod webapp -n microservices

# Check init container logs (should show successful DNS lookup)
kubectl logs webapp -n microservices -c wait-for-db

# Verify init container completed successfully
kubectl get pod webapp -n microservices -o jsonpath='{.status.initContainerStatuses[0].state.terminated.reason}'
```

Expected output:
- Pod status: `2/2 Running`
- Init container terminated reason: `Completed`
- Init container logs show successful nslookup of database-service

</details>

### Understanding Init Containers

Init containers are powerful for:
- **Waiting for dependencies**: Like we did with the database service
- **Cloning repositories**: Fetching code before the app starts
- **Setting permissions**: Configuring volumes before the app uses them
- **Registration**: Registering the pod with an external service

They always run to completion before any main container starts!

### Verification

The pod should show 2/2 Ready and the init container should have completed successfully.
