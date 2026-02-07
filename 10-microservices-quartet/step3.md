## Step 3: Test Shared Volume

Verify that the main container and sidecar can share data through the emptyDir volume.

### Requirements

1. Write a test log entry to the shared volume from the `app` container
2. Verify the `log-streamer` sidecar can read the same file

### Task

Execute this command to write to the shared volume:

```bash
kubectl exec webapp -n microservices -c app -- sh -c "echo 'test-log-entry' >> /var/log/app/access.log"
```

Then verify the sidecar can see it:

```bash
kubectl exec webapp -n microservices -c log-streamer -- cat /var/log/app/access.log
```

### Key Concepts

- **emptyDir Volume**: Created when the pod is assigned to a node, initially empty
- **Shared Storage**: All containers in the pod can mount the same emptyDir volume
- **Pod Lifecycle**: The volume exists as long as the pod exists, data is lost when pod is deleted
- **Container Isolation**: Even though containers share the volume, they still have separate filesystems otherwise

<details><summary>Hint</summary>

To exec into a specific container in a multi-container pod, use the `-c` flag:

```bash
kubectl exec <pod-name> -n <namespace> -c <container-name> -- <command>
```

Write to the file from the `app` container, then read from the `log-streamer` container.

</details>

<details><summary>Solution</summary>

```bash
# Write test data from the app container
kubectl exec webapp -n microservices -c app -- sh -c "echo 'test-log-entry' >> /var/log/app/access.log"

# Read from the log-streamer sidecar
kubectl exec webapp -n microservices -c log-streamer -- cat /var/log/app/access.log

# You should see the test-log-entry in the output

# Also check the sidecar logs (it's tailing the file)
kubectl logs webapp -n microservices -c log-streamer

# Create more log entries and watch the sidecar stream them
kubectl exec webapp -n microservices -c app -- sh -c "for i in 1 2 3; do echo 'Log entry \$i' >> /var/log/app/access.log; sleep 1; done"
kubectl logs webapp -n microservices -c log-streamer --tail=5
```

This demonstrates the sidecar pattern: the log-streamer is continuously monitoring logs created by the main application.

</details>

### Common Sidecar Use Cases

Sidecars are used for:
- **Log collection**: Like our log-streamer (Fluentd, Filebeat)
- **Metrics collection**: Prometheus exporters
- **Service mesh proxies**: Envoy, Linkerd
- **Secret management**: Vault agent injector
- **Configuration sync**: Keeping config files updated

### Verification

The shared volume should work correctly, with both containers able to access the same file.
