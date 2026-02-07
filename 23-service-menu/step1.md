# Step 1: Create ClusterIP Service

ClusterIP is the default service type in Kubernetes. It exposes the service on an internal IP within the cluster, making it accessible only from within the cluster.

## Task

Create a ClusterIP service named `web-clusterip` in the `service-menu` namespace that:
- Selects pods with label `app=web`
- Exposes port 80
- Uses the default ClusterIP type

After creating the service, verify it works by running a curl command from a temporary test pod:

```bash
kubectl run test-curl --image=curlimages/curl -n service-menu --rm -it --restart=Never -- curl -s web-clusterip
```

You should see the nginx welcome page HTML output.

<details><summary>Hint</summary>

Use `kubectl expose` to create a service from the existing deployment, or create a service manifest with:
- `spec.type: ClusterIP` (or omit it, as ClusterIP is the default)
- `spec.selector.app: web`
- `spec.ports` with port 80

The deployment automatically created pods with the label `app=web`.

</details>

<details><summary>Solution</summary>

```bash
# Method 1: Using kubectl expose
kubectl expose deployment web --name=web-clusterip --port=80 -n service-menu

# Method 2: Using kubectl create service
kubectl create service clusterip web-clusterip --tcp=80:80 -n service-menu
# Then add the selector
kubectl set selector service/web-clusterip app=web -n service-menu

# Verify the service
kubectl get svc web-clusterip -n service-menu

# Test with curl
kubectl run test-curl --image=curlimages/curl -n service-menu --rm -it --restart=Never -- curl -s web-clusterip
```

</details>
