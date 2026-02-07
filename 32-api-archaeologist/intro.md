# The API Archaeologist

Welcome, API Archaeologist! You've just inherited a collection of ancient Kubernetes manifests from a project that hasn't been updated in years. These manifests use deprecated API versions that modern Kubernetes clusters refuse to accept.

## Scenario

Your task is to excavate these old manifests, understand why they're broken, and convert them to current API versions. This is a common real-world challenge when maintaining legacy infrastructure and a critical skill for the CKAD exam.

## What You'll Learn

- Identifying deprecated API versions
- Understanding API version migration paths
- Converting `extensions/v1beta1` Deployments to `apps/v1`
- Updating `networking.k8s.io/v1beta1` Ingress to `networking.k8s.io/v1`
- Migrating `batch/v1beta1` CronJob to `batch/v1`
- Key structural changes required for each API version

## The Challenge

Three ancient manifests await you in `/root/old-manifests/`:
- A Deployment using the long-deprecated `extensions/v1beta1` API
- An Ingress using the old `networking.k8s.io/v1beta1` API
- A CronJob using `batch/v1beta1`

None of these will apply on a modern cluster. Your mission: make them work.

Let's begin the excavation!
