## Task description

Create an Ingress resource named `secure-ingress` in the `tls-lab` namespace with TLS configuration.

Requirements:
- Name: `secure-ingress`
- Namespace: `tls-lab`
- Hostname: `secure.example.com`
- TLS secret: `secure-tls`
- Backend service: `secure-app-svc` on port 80
- IngressClassName: `nginx`
- Add annotation to force SSL redirect: `nginx.ingress.kubernetes.io/ssl-redirect: "true"`

<details><summary>Hint</summary>
The Ingress should have both a `tls` section (with hosts and secretName) and a `rules` section (with host and http paths).
</details>

<details><summary>Solution</summary>
```bash
kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: secure-ingress
  namespace: tls-lab
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - secure.example.com
    secretName: secure-tls
  rules:
  - host: secure.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: secure-app-svc
            port:
              number: 80
EOF
```
</details>
