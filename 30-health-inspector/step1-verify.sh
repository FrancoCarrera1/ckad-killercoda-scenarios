#!/bin/bash
set -euo pipefail

# Check if pod exists and is Running
if ! kubectl get pod healthy-app -n health-lab &>/dev/null; then
  echo "Pod healthy-app does not exist in health-lab namespace"
  exit 1
fi

POD_STATUS=$(kubectl get pod healthy-app -n health-lab -o jsonpath='{.status.phase}')
if [ "$POD_STATUS" != "Running" ]; then
  echo "Pod healthy-app is not Running (current status: $POD_STATUS)"
  exit 1
fi

# Check if pod is Ready
POD_READY=$(kubectl get pod healthy-app -n health-lab -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}')
if [ "$POD_READY" != "True" ]; then
  echo "Pod healthy-app is not Ready"
  exit 1
fi

# Verify all three probes are configured
STARTUP_PROBE=$(kubectl get pod healthy-app -n health-lab -o jsonpath='{.spec.containers[0].startupProbe}')
LIVENESS_PROBE=$(kubectl get pod healthy-app -n health-lab -o jsonpath='{.spec.containers[0].livenessProbe}')
READINESS_PROBE=$(kubectl get pod healthy-app -n health-lab -o jsonpath='{.spec.containers[0].readinessProbe}')

if [ -z "$STARTUP_PROBE" ]; then
  echo "startupProbe is not configured"
  exit 1
fi

if [ -z "$LIVENESS_PROBE" ]; then
  echo "livenessProbe is not configured"
  exit 1
fi

if [ -z "$READINESS_PROBE" ]; then
  echo "readinessProbe is not configured"
  exit 1
fi

# Check if Service exists
if ! kubectl get service healthy-svc -n health-lab &>/dev/null; then
  echo "Service healthy-svc does not exist in health-lab namespace"
  exit 1
fi

echo "Pod is Running and Ready with all three probes configured!"
