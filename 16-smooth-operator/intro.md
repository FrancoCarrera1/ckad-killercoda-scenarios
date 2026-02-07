# The Smooth Operator

Deployments are the workhorses of Kubernetes, and rolling updates let you ship new versions without downtime. You'll fine-tune `maxUnavailable` and `maxSurge` to control exactly how fast your rollout proceeds, then learn to inspect rollout history.

## Learning Objectives

- Configure Deployment rolling update strategy
- Understand `maxUnavailable` and `maxSurge` parameters
- Use `kubectl rollout status` to monitor deployments
- Track and view rollout history
- Add change-cause annotations for audit trails

## Scenario

Your payment service needs frequent updates for security patches and feature releases. You'll configure the deployment's rolling update strategy to ensure smooth transitions with controlled pod replacement rates.
