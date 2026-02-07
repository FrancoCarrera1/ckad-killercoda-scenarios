# The Admission Gatekeeper

Welcome to The Admission Gatekeeper! In this scenario, you'll learn how to use **LimitRange** and **ResourceQuota** to control resource usage in your Kubernetes cluster.

## The Situation

Your cluster has two namespaces, each running application pods with **no resource requests or limits** configured. This is a problem — without resource constraints, a single pod could consume all available node resources and starve other workloads.

Your job is to lock things down:

- **`limitrange-lab`**: Configure per-container resource defaults and boundaries using a LimitRange
- **`quota-lab`**: Configure namespace-level resource caps using a ResourceQuota

## What Are LimitRange and ResourceQuota?

### LimitRange
A **LimitRange** sets resource constraints at the **individual container/pod level**:
- **Default requests/limits**: Automatically injected into containers that don't specify their own
- **Min/Max boundaries**: Reject pods whose requests fall outside the allowed range
- Enforced by the **LimitRanger** admission controller at pod creation time

### ResourceQuota
A **ResourceQuota** sets resource constraints at the **namespace level**:
- **Aggregate caps**: Total CPU, memory, and pod count across all pods in the namespace
- **Enforcement**: New pods that would push usage over the quota are rejected
- When a CPU/memory quota exists, **every new pod must specify resource requests/limits** or it will be rejected with a 403 error

### Key Behavior
- LimitRange defaults are only applied when a pod is **created** — they are **not** retroactively applied to already-running pods
- Existing pods continue running even after a ResourceQuota is added, but new pods must comply

## Learning Objectives

By the end of this scenario, you will be able to:

- Create a LimitRange with default requests, limits, and min/max boundaries
- Create a ResourceQuota with CPU, memory, and pod count limits
- Understand that LimitRange defaults only apply at pod admission time
- Update existing pods to comply with new resource policies
- Test and observe rejection behavior for both LimitRange and ResourceQuota

Let's get started!
