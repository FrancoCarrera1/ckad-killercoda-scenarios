# The Sidecar Surgery

Welcome to the Sidecar Surgery! You've inherited a legacy application that was deployed without proper logging or health checks. Your mission: upgrade it to production standards without disrupting service.

## Scenario Overview

In this scenario, you'll perform "surgery" on a running deployment:
- **Add a log-collector sidecar** to centralize logging
- **Configure shared volumes** for inter-container communication
- **Add health probes** for reliability and zero-downtime deployments
- **Perform rolling updates** safely

## Why This Matters

Legacy applications often lack:
- **Centralized logging**: Logs trapped inside containers
- **Health checks**: No way for Kubernetes to detect failures
- **Observability**: Difficult to debug production issues
- **Graceful deployments**: No readiness checks lead to downtime

Retrofitting these features is a common real-world task that requires careful planning and execution.

## Real-World Context

The "legacy-app" team deployed their nginx application months ago. It works, but:
- **No logging infrastructure**: Logs are only accessible via `kubectl logs`
- **No health probes**: Kubernetes can't detect if the app is healthy
- **No readiness checks**: Traffic sent before app is ready
- **No monitoring**: Can't track request patterns

You need to add these features without causing downtime or data loss.

## Learning Objectives

By the end of this scenario, you will:
- Add sidecar containers to existing deployments
- Configure shared `emptyDir` volumes for inter-container communication
- Implement liveness and readiness probes
- Understand rolling update mechanics
- Debug multi-container Pods
- Safely modify production deployments

Let's perform some surgical precision on this legacy app!
