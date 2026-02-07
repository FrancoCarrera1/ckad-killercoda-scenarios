# Step 3: Test Traffic Split

Now you'll verify that traffic is being split between the stable and canary versions according to the pod ratio.

## Task Description

Test the traffic distribution by making multiple requests to the Service. With 4 stable pods and 1 canary pod, you should see approximately 80% "Stable v1" responses and 20% "Canary v2" responses.

You can test this by:
1. Creating a temporary test pod
2. Running a curl loop to make multiple requests
3. Observing the distribution of responses

This step helps you understand how Kubernetes Services distribute traffic across pods and how replica counts affect traffic splitting in canary deployments.

<details><summary>Hint</summary>

You can create a temporary pod and use curl in a loop:

```bash
kubectl run test-client --rm -i --tty --image=curlimages/curl -n canary-test -- sh
```

Then inside the pod:
```bash
for i in $(seq 1 10); do curl -s http://frontend-svc; echo ""; done
```

</details>

<details><summary>Solution</summary>

```bash
# Create a test pod to make requests
kubectl run test-client --image=curlimages/curl -n canary-test --rm -i --tty -- sh -c '
for i in $(seq 1 20); do
  curl -s http://frontend-svc
  echo ""
done | sort | uniq -c
'

# Expected output (approximately):
# 16 Stable v1
#  4 Canary v2

# Alternative: Run multiple curl requests and count
kubectl run test-client --image=curlimages/curl -n canary-test --rm -i --tty -- sh -c '
STABLE=0
CANARY=0
for i in $(seq 1 20); do
  RESPONSE=$(curl -s http://frontend-svc)
  if echo "$RESPONSE" | grep -q "Stable"; then
    STABLE=$((STABLE + 1))
  elif echo "$RESPONSE" | grep -q "Canary"; then
    CANARY=$((CANARY + 1))
  fi
done
echo "Stable: $STABLE, Canary: $CANARY"
'

# You can also check the endpoints to see the IP distribution
kubectl get endpoints frontend-svc -n canary-test -o yaml

# View the pods and their IPs
kubectl get pods -n canary-test -l app=frontend -o wide
```

</details>

## Understanding Traffic Distribution

The traffic split is **probabilistic**, not deterministic. Kubernetes Services use iptables or IPVS for load balancing, which distributes connections across endpoints. With 5 total pods (4 stable, 1 canary):

- Each request has a 1/5 chance of hitting any specific pod
- Over many requests, approximately 80% will hit stable pods and 20% will hit the canary pod
- Individual test runs may vary, but the ratio should average out over 20+ requests

This is "good enough" for canary testing without requiring a service mesh like Istio or Linkerd, which provide more precise traffic splitting.
