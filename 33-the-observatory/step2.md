## Task description

Master log analysis techniques using the `multi-logger` pod, which has two containers. Practice various log filtering and extraction methods.

Tasks:
1. View logs from the `app` container only
2. View logs from the `sidecar` container only
3. View logs from all containers in the pod
4. View logs from the last 5 minutes using `--since=5m`
5. View logs from all pods with label `app=logger`
6. Save the logs from the `app` container to `/root/app-logs.txt`

<details><summary>Hint</summary>

Key flags for `kubectl logs`:
- `-c <container>`: Specify container in multi-container pod
- `--all-containers`: Get logs from all containers
- `--since=<duration>`: Only show logs from last N time (e.g., 5m, 1h)
- `-l <label>`: Select pods by label
- `--previous`: Get logs from previous (crashed) container

Basic syntax:
```bash
kubectl logs <pod-name> -c <container-name> -n <namespace>
```

</details>

<details><summary>Solution</summary>

```bash
# View logs from the app container
kubectl logs multi-logger -c app -n observatory

# View logs from the sidecar container
kubectl logs multi-logger -c sidecar -n observatory

# View logs from all containers in the pod
kubectl logs multi-logger --all-containers -n observatory

# View logs from the last 5 minutes
kubectl logs multi-logger -c app -n observatory --since=5m

# View logs from all pods with label app=logger
kubectl logs -l app=logger -n observatory

# View logs and show which container each line is from
kubectl logs multi-logger --all-containers --prefix -n observatory

# Save app container logs to file
kubectl logs multi-logger -c app -n observatory > /root/app-logs.txt

# Verify the saved logs
cat /root/app-logs.txt
```

You should see:
- `[APP]` messages from the app container
- `[SIDECAR]` messages from the sidecar container
- Both when using `--all-containers`

</details>
