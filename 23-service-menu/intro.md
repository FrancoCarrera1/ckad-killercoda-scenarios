# The Service Menu

Welcome to the Service Menu scenario! Kubernetes offers several Service types, each designed for different use cases. Understanding when and how to use each type is crucial for the CKAD exam.

## Learning Objectives

In this scenario, you will:
- Create a **ClusterIP** service for internal cluster communication
- Deploy a **NodePort** service for external access on a specific port
- Configure an **ExternalName** service to alias external DNS names
- Set up a **Headless** service (ClusterIP: None) for direct pod DNS resolution

You'll verify each service type works correctly using curl and DNS lookups, gaining hands-on experience with Kubernetes networking fundamentals.

## Scenario Context

You're setting up a complete service architecture for a microservices application. The team needs different types of services:
- Internal services for pod-to-pod communication
- NodePort access for testing and debugging
- External API integration via ExternalName
- Direct pod access for stateful applications using headless services

Let's build the complete service menu!
