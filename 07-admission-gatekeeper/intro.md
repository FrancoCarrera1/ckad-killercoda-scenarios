# The Admission Gatekeeper

Welcome to The Admission Gatekeeper! Admission controllers are the bouncers of your Kubernetes cluster. They intercept requests to the API server and can validate, mutate, or reject them before objects are persisted.

## The Challenge

In this scenario, you'll explore how admission controllers work together to enforce resource policies and prevent runaway workloads. You'll work with:

- **Admission Controllers**: The built-in gatekeepers
- **LimitRange**: Sets limits on resource requests per pod/container
- **ResourceQuota**: Sets aggregate limits on resources in a namespace

## Admission Controller Flow

When you create a pod, the request flows through multiple admission controllers:

1. **MutatingAdmissionWebhook**: Can modify the request
2. **LimitRanger**: Applies default limits and validates against LimitRange
3. **ResourceQuota**: Validates against namespace quotas
4. **PodSecurity**: Validates against Pod Security Standards
5. **ValidatingAdmissionWebhook**: Final validation (can't modify)

If any admission controller rejects the request, the object is not created.

## Learning Objectives

By the end of this scenario, you will be able to:

- Identify which admission controllers are enabled in your cluster
- Understand how LimitRange enforces per-pod constraints
- Understand how ResourceQuota enforces namespace-level constraints
- Calculate remaining quota headroom
- Create deployments that fit within available resources

## Challenge Level

**Hard** - This scenario requires understanding resource management, quotas, and how to work within constraints.

Let's meet the gatekeepers!
