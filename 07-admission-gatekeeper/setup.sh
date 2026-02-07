#!/bin/bash
set -euo pipefail

# Create namespaces
kubectl create namespace limitrange-lab
kubectl create namespace quota-lab

# Create pods in limitrange-lab with NO resource requests/limits
for i in 1 2 3; do
  kubectl run app-$i --image=nginx:1.24 -n limitrange-lab
done

# Create pods in quota-lab with NO resource requests/limits
for i in 1 2 3; do
  kubectl run app-$i --image=nginx:1.24 -n quota-lab
done

# Wait for all pods to be running
kubectl wait --for=condition=Ready pods --all -n limitrange-lab --timeout=120s
kubectl wait --for=condition=Ready pods --all -n quota-lab --timeout=120s

echo "Setup complete!"
echo "- limitrange-lab: 3 pods running (no resource requests/limits)"
echo "- quota-lab: 3 pods running (no resource requests/limits)"
