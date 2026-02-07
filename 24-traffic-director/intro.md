# The Traffic Director

Welcome to the Traffic Director scenario! Ingress resources are Kubernetes' way of managing external HTTP/HTTPS access to services. They provide powerful routing capabilities based on hostnames and URL paths.

## Learning Objectives

In this scenario, you will:
- Deploy multiple backend services with custom HTML pages
- Create an Ingress resource with path-based routing rules
- Configure a default backend for unmatched requests
- Test routing using curl with custom Host headers
- Understand the `pathType` field and rewrite rules

## Scenario Context

Your company is building a unified web platform that needs to route traffic to different microservices based on URL paths:
- `/shop` should route to the storefront service
- `/api` should route to the API server
- `/docs` should route to the documentation site
- All other paths should default to the storefront

You'll set up an Ingress controller and configure intelligent traffic routing to make this architecture work.

Let's direct some traffic!
