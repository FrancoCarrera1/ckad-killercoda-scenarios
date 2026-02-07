#!/bin/bash
set -euo pipefail

# Check if NetworkPolicy exists
if ! kubectl get networkpolicy default-deny-all -n lockdown &>/dev/null; then
  echo "NetworkPolicy 'default-deny-all' does not exist in namespace 'lockdown'"
  exit 1
fi

# Verify the policy has correct podSelector (should be empty to select all pods)
POD_SELECTOR=$(kubectl get networkpolicy default-deny-all -n lockdown -o jsonpath='{.spec.podSelector}')
if [ "$POD_SELECTOR" != "{}" ]; then
  echo "NetworkPolicy should have empty podSelector {} to select all pods"
  exit 1
fi

# Verify the policy has both Ingress and Egress types
POLICY_TYPES=$(kubectl get networkpolicy default-deny-all -n lockdown -o jsonpath='{.spec.policyTypes}')
if ! echo "$POLICY_TYPES" | grep -q "Ingress"; then
  echo "NetworkPolicy should have policyType 'Ingress'"
  exit 1
fi

if ! echo "$POLICY_TYPES" | grep -q "Egress"; then
  echo "NetworkPolicy should have policyType 'Egress'"
  exit 1
fi

# Verify there are no ingress rules (deny all ingress)
INGRESS_RULES=$(kubectl get networkpolicy default-deny-all -n lockdown -o jsonpath='{.spec.ingress}')
if [ ! -z "$INGRESS_RULES" ] && [ "$INGRESS_RULES" != "null" ]; then
  echo "NetworkPolicy should have no ingress rules (to deny all ingress)"
  exit 1
fi

# Verify there are no egress rules (deny all egress)
EGRESS_RULES=$(kubectl get networkpolicy default-deny-all -n lockdown -o jsonpath='{.spec.egress}')
if [ ! -z "$EGRESS_RULES" ] && [ "$EGRESS_RULES" != "null" ]; then
  echo "NetworkPolicy should have no egress rules (to deny all egress)"
  exit 1
fi

echo "Verification passed: Default deny-all NetworkPolicy exists"
exit 0
