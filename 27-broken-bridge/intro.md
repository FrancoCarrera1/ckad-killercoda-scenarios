# The Broken Bridge

Welcome to the Broken Bridge challenge! The web team's application is completely unreachable through the Ingress. Traffic isn't making it from the Ingress controller all the way to the pods.

## The Problem

There are **THREE** networking bugs hiding in the chain:
1. A Service selector mismatch
2. A wrong port configuration
3. A wrong targetPort configuration

Your mission is to trace the full networking path from Ingress → Service → Pods and fix all three bugs.

## What You'll Learn

- End-to-end networking debugging in Kubernetes
- Service selector matching
- Understanding port vs targetPort
- Ingress backend configuration
- Using `kubectl describe` and endpoint inspection
- Systematic troubleshooting methodology

## The Setup

You'll find the following resources in the `broken-bridge` namespace:
- Deployment `webapp` running nginx pods
- Service `webapp-svc` (broken!)
- Ingress `webapp-ingress` (broken!)

Let's start debugging!
