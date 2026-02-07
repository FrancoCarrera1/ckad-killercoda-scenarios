#!/bin/bash
set -euo pipefail

# Check staging ConfigMap
if ! kubectl get configmap app-config -n staging &>/dev/null; then
  echo "❌ ConfigMap 'app-config' does not exist in namespace 'staging'"
  exit 1
fi

STAGING_DB=$(kubectl get configmap app-config -n staging -o jsonpath='{.data.DB_HOST}')
STAGING_LOG=$(kubectl get configmap app-config -n staging -o jsonpath='{.data.LOG_LEVEL}')
STAGING_FEATURE=$(kubectl get configmap app-config -n staging -o jsonpath='{.data.FEATURE_DARK_MODE}')

if [[ "$STAGING_DB" != "staging-db.internal" ]]; then
  echo "❌ Staging ConfigMap has incorrect DB_HOST (expected: staging-db.internal, found: $STAGING_DB)"
  exit 1
fi

if [[ "$STAGING_LOG" != "debug" ]]; then
  echo "❌ Staging ConfigMap has incorrect LOG_LEVEL (expected: debug, found: $STAGING_LOG)"
  exit 1
fi

if [[ "$STAGING_FEATURE" != "true" ]]; then
  echo "❌ Staging ConfigMap has incorrect FEATURE_DARK_MODE (expected: true, found: $STAGING_FEATURE)"
  exit 1
fi

# Check production ConfigMap
if ! kubectl get configmap app-config -n production &>/dev/null; then
  echo "❌ ConfigMap 'app-config' does not exist in namespace 'production'"
  exit 1
fi

PROD_DB=$(kubectl get configmap app-config -n production -o jsonpath='{.data.DB_HOST}')
PROD_LOG=$(kubectl get configmap app-config -n production -o jsonpath='{.data.LOG_LEVEL}')
PROD_FEATURE=$(kubectl get configmap app-config -n production -o jsonpath='{.data.FEATURE_DARK_MODE}')

if [[ "$PROD_DB" != "prod-db.internal" ]]; then
  echo "❌ Production ConfigMap has incorrect DB_HOST (expected: prod-db.internal, found: $PROD_DB)"
  exit 1
fi

if [[ "$PROD_LOG" != "warn" ]]; then
  echo "❌ Production ConfigMap has incorrect LOG_LEVEL (expected: warn, found: $PROD_LOG)"
  exit 1
fi

if [[ "$PROD_FEATURE" != "false" ]]; then
  echo "❌ Production ConfigMap has incorrect FEATURE_DARK_MODE (expected: false, found: $PROD_FEATURE)"
  exit 1
fi

echo "✅ Step 1 complete! Both ConfigMaps created with correct values."
exit 0
