# The Identity Crisis

Welcome to The Identity Crisis! ServiceAccount tokens are the identity cards of your pods. They allow pods to authenticate to the Kubernetes API server and perform authorized actions.

## The Challenge

In this scenario, you'll master ServiceAccount token mechanics:

- **Auto-mounting**: How tokens are automatically injected into pods
- **Disabling auto-mount**: When and why to turn it off
- **Projected volumes**: Creating custom tokens with specific audiences and expirations
- **In-cluster API access**: Using tokens to communicate with the API server from within a pod

## ServiceAccount Token Basics

### Default Behavior
- Every pod is assigned a ServiceAccount (default: `default`)
- The ServiceAccount's token is automatically mounted at `/var/run/secrets/kubernetes.io/serviceaccount/`
- The token allows the pod to authenticate as that ServiceAccount

### Token Contents
- `token`: The actual JWT bearer token
- `ca.crt`: The cluster CA certificate (to verify the API server)
- `namespace`: The pod's namespace

### Security Considerations
- Not all pods need API access
- Auto-mounting tokens increases attack surface
- Use `automountServiceAccountToken: false` when API access isn't needed
- Use projected volumes for custom token configurations

## Learning Objectives

By the end of this scenario, you will be able to:

- Understand how ServiceAccount tokens are auto-mounted
- Disable auto-mounting when appropriate
- Create projected volume tokens with custom audiences and expiration
- Use tokens to access the Kubernetes API from within a pod
- Configure RBAC to grant API permissions to ServiceAccounts

## Challenge Level

**Hard** - This scenario requires understanding authentication, authorization, and in-pod API access.

Let's solve The Identity Crisis!
