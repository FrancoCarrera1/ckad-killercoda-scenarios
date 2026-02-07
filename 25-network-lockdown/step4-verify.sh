#!/bin/bash
set -euo pipefail

# Check if NetworkPolicy exists
if ! kubectl get networkpolicy allow-dns -n lockdown &>/dev/null; then
  echo "NetworkPolicy 'allow-dns' does not exist in namespace 'lockdown'"
  exit 1
fi

# Verify the policy selects all pods (empty selector)
POD_SELECTOR=$(kubectl get networkpolicy allow-dns -n lockdown -o jsonpath='{.spec.podSelector}')
if [ "$POD_SELECTOR" != "{}" ]; then
  echo "NetworkPolicy should have empty podSelector {} to select all pods"
  exit 1
fi

# Verify the policy has Egress type
POLICY_TYPES=$(kubectl get networkpolicy allow-dns -n lockdown -o jsonpath='{.spec.policyTypes}')
if ! echo "$POLICY_TYPES" | grep -q "Egress"; then
  echo "NetworkPolicy should have policyType 'Egress'"
  exit 1
fi

# Verify the egress rule targets kube-system namespace
NAMESPACE_SELECTOR=$(kubectl get networkpolicy allow-dns -n lockdown -o jsonpath='{.spec.egress[0].to[0].namespaceSelector.matchLabels}')
if ! echo "$NAMESPACE_SELECTOR" | jq -e '.["kubernetes.io/metadata.name"] == "kube-system"' &>/dev/null; then
  echo "NetworkPolicy should target kube-system namespace with label 'kubernetes.io/metadata.name: kube-system'"
  exit 1
fi

# Verify port 53 is allowed for both TCP and UDP
PORTS=$(kubectl get networkpolicy allow-dns -n lockdown -o jsonpath='{.spec.egress[0].ports}')

# Check for TCP port 53
if ! echo "$PORTS" | jq -e 'any(.protocol == "TCP" and .port == 53)' &>/dev/null; then
  echo "NetworkPolicy should allow TCP port 53 for DNS"
  exit 1
fi

# Check for UDP port 53
if ! echo "$PORTS" | jq -e 'any(.protocol == "UDP" and .port == 53)' &>/dev/null; then
  echo "NetworkPolicy should allow UDP port 53 for DNS"
  exit 1
fi

# Verify we have exactly 2 port rules (TCP and UDP)
PORT_COUNT=$(echo "$PORTS" | jq 'length')
if [ "$PORT_COUNT" != "2" ]; then
  echo "NetworkPolicy should have exactly 2 port rules (TCP and UDP on port 53, found: $PORT_COUNT)"
  exit 1
fi

echo "Verification passed: NetworkPolicy allows DNS egress to kube-system on port 53 (TCP and UDP)"
exit 0
