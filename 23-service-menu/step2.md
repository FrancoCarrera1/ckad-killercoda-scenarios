# Step 2: Create NodePort Service

NodePort services expose your application on a static port on each node's IP. This allows external traffic to access your service using `<NodeIP>:<NodePort>`.

## Task

Create a NodePort service named `web-nodeport` in the `service-menu` namespace that:
- Selects pods with label `app=web`
- Exposes port 80
- Uses NodePort 30080
- Type is NodePort

After creating the service, verify it works by curling the node IP on port 30080:

```bash
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
curl http://$NODE_IP:30080
```

<details><summary>Hint</summary>

You can create a NodePort service using a YAML manifest with:
- `spec.type: NodePort`
- `spec.ports[0].nodePort: 30080`
- `spec.ports[0].port: 80`
- `spec.selector.app: web`

Or use `kubectl create service nodeport` and then edit to set the specific nodePort.

</details>

<details><summary>Solution</summary>

```bash
# Method 1: Using YAML
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: web-nodeport
  namespace: service-menu
spec:
  type: NodePort
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30080
EOF

# Method 2: Using kubectl and patch
kubectl create service nodeport web-nodeport --tcp=80:80 --node-port=30080 -n service-menu --dry-run=client -o yaml | kubectl apply -f -
kubectl patch service web-nodeport -n service-menu -p '{"spec":{"selector":{"app":"web"}}}'

# Verify the service
kubectl get svc web-nodeport -n service-menu

# Test with curl
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
curl http://$NODE_IP:30080
```

</details>
