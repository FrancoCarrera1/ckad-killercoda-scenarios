# The Network Lockdown

By default, Kubernetes allows all pods to communicate freely with each other. This "open" networking model is convenient for development but dangerous for production. In a zero-trust security model, you deny all traffic by default and explicitly allow only what's necessary.

NetworkPolicies let you implement firewall rules at the pod level. Think of them as security groups or iptables rules for your Kubernetes workloads. They control which pods can communicate with each other and what external endpoints they can reach.

In this scenario, you'll progressively lock down a three-tier application:
1. **Deny everything** - Start with a blank slate
2. **Allow frontend → backend** - Enable the first tier communication
3. **Allow backend → database** - Enable the second tier communication
4. **Allow DNS** - Enable essential cluster services

## The Application Architecture

```
┌──────────┐       ┌──────────┐       ┌──────────┐
│ frontend │──────▶│ backend  │──────▶│ database │
│ (nginx)  │       │ (nginx)  │       │ (nginx)  │
└──────────┘       └──────────┘       └──────────┘
tier=frontend      tier=backend       tier=database
port 80            port 8080          port 5432
```

## Learning Objectives

- Create default deny NetworkPolicies for ingress and egress
- Implement tier-based access controls
- Use label selectors for pod and namespace targeting
- Configure port-based traffic rules
- Enable DNS resolution for cluster services

## Prerequisites

- Understanding of Kubernetes networking basics
- Familiarity with labels and selectors
- Basic knowledge of network security concepts

## Important Notes

- NetworkPolicies require a CNI plugin that supports them (Calico, Cilium, etc.)
- The kubeadm environment has Calico pre-installed
- NetworkPolicies are additive - multiple policies can select the same pod
- If no NetworkPolicy selects a pod, all traffic is allowed

Let's lock down the network and implement defense in depth!
