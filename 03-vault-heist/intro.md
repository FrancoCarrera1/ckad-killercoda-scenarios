# The Vault Heist

Welcome to the world of Kubernetes secret management and security!

## Scenario

The security team needs you to demonstrate mastery of all Secret types. You'll create secrets for different purposes (credentials, TLS certificates, container registry access) and use them in pods through different injection methods.

This scenario simulates real-world requirements for:
- Managing sensitive data (passwords, API keys, certificates)
- Securing container registry access for private images
- Understanding when to use volume mounts vs environment variables

## Learning Objectives

By the end of this scenario, you will be able to:
- Create generic secrets from literal values
- Create TLS secrets from certificate files
- Create docker-registry secrets for private registries
- Mount secrets as volumes
- Inject secrets as environment variables
- Use imagePullSecrets for private registries

## CKAD Exam Relevance

This scenario covers the **Application Environment, Configuration and Security** domain (25% of the exam). Secret management and SecurityContext are high-frequency topics!

## The Three Secret Types

1. **Opaque** (generic): Generic key-value secrets
2. **kubernetes.io/tls**: TLS certificate and key pairs
3. **kubernetes.io/dockerconfigjson**: Container registry credentials

Let's master them all!
