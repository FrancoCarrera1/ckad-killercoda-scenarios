# The Canary Cage

Canary deployments are a risk-mitigation strategy that allows you to test a new version of your application with a small percentage of real production traffic before fully rolling it out. The name comes from the "canary in a coal mine" concept - if the canary (new version) has issues, you can quickly roll back before affecting all users.

In Kubernetes, you can implement canary deployments without a service mesh by using multiple Deployments with a shared Service selector. By controlling the replica counts, you can achieve approximate traffic splitting based on the ratio of pods.

## The Strategy

1. Deploy your **stable version** with N replicas
2. Deploy a **canary version** with M replicas (where M << N)
3. Both deployments share a common label that the Service selects
4. Traffic is distributed roughly in the ratio N:M
5. Monitor the canary for errors
6. If successful, scale up the canary and scale down the stable version
7. If issues arise, quickly scale the canary to 0

## Learning Objectives

- Implement canary deployment patterns in Kubernetes
- Use shared Service selectors to split traffic between deployments
- Control traffic distribution through replica counts
- Perform progressive rollouts
- Understand the relationship between pods and Service endpoints

## Prerequisites

- Understanding of Deployments and Services
- Knowledge of labels and selectors
- Basic familiarity with load balancing concepts

Let's begin implementing a safe, progressive rollout strategy!
