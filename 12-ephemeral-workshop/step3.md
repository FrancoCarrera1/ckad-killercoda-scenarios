# Step 3: Template Renderer

In this final step, you'll combine ConfigMaps with emptyDir volumes and init containers to create a template rendering pattern. This is commonly used for generating configuration files with environment-specific values.

## Task Description

Create the following resources in the `workshop` namespace:

**1. ConfigMap `template-config`**:
- Key: `index.html.tmpl`
- Value: `<html><body>Hello {{NAME}}</body></html>`

**2. Pod `template-renderer`**:

**Init Container `renderer`**:
- Image: `busybox:1.36`
- Reads the ConfigMap template from `/templates`
- Uses `sed` to replace `{{NAME}}` with `"Kubernetes"`
- Writes the rendered output to `/rendered/index.html`
- Command: `["sh", "-c", "sed 's/{{NAME}}/Kubernetes/g' /templates/index.html.tmpl > /rendered/index.html"]`

**Main Container `web`**:
- Image: `nginx:1.24`
- Serves content from `/usr/share/nginx/html`

**Volumes**:
- ConfigMap volume `templates` mounted at `/templates` (init container only)
- emptyDir volume `rendered` mounted at `/rendered` (init container) and `/usr/share/nginx/html` (main container)

This pattern separates configuration (ConfigMap) from runtime rendering (init container) and serving (main container).

<details><summary>Hint</summary>

The key is having the init container write to the emptyDir, which the main container then reads:

```yaml
initContainers:
- name: renderer
  volumeMounts:
  - name: templates
    mountPath: /templates
  - name: rendered
    mountPath: /rendered
containers:
- name: web
  volumeMounts:
  - name: rendered
    mountPath: /usr/share/nginx/html
volumes:
- name: templates
  configMap:
    name: template-config
- name: rendered
  emptyDir: {}
```

</details>

<details><summary>Solution</summary>

```bash
# Create the ConfigMap with the template
kubectl create configmap template-config -n workshop \
  --from-literal='index.html.tmpl=<html><body>Hello {{NAME}}</body></html>'

# Create the pod with init container and main container
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: template-renderer
  namespace: workshop
spec:
  initContainers:
  - name: renderer
    image: busybox:1.36
    command: ["sh", "-c", "sed 's/{{NAME}}/Kubernetes/g' /templates/index.html.tmpl > /rendered/index.html"]
    volumeMounts:
    - name: templates
      mountPath: /templates
    - name: rendered
      mountPath: /rendered
  containers:
  - name: web
    image: nginx:1.24
    volumeMounts:
    - name: rendered
      mountPath: /usr/share/nginx/html
  volumes:
  - name: templates
    configMap:
      name: template-config
  - name: rendered
    emptyDir: {}
EOF

# Wait for the pod to be ready
kubectl wait --for=condition=Ready pod/template-renderer -n workshop --timeout=60s

# Verify the rendered content
kubectl exec template-renderer -n workshop -- cat /usr/share/nginx/html/index.html
```

</details>
