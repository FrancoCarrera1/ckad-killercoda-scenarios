# The Time Machine

Someone deployed a bad image and the payment service is down! Pods are stuck in `ImagePullBackOff`. You need to quickly diagnose the problem and roll back to a working version. Time is money — every second counts.

## Learning Objectives

- Diagnose `ImagePullBackOff` errors
- Use `kubectl rollout undo` to roll back deployments
- Roll back to specific revisions
- Track changes with change-cause annotations
- Understand deployment revision history

## Scenario

The payment service was working fine on nginx 1.24, then updated to 1.25 successfully. But someone just deployed nginx 1.99 (which doesn't exist!), and now all pods are failing. You need to quickly restore service.

**Current State**: The deployment has broken pods due to a non-existent image.
