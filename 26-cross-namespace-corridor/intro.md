# The Cross-Namespace Corridor

In a multi-team cluster, you need to control traffic between namespaces. The API gateway team should reach backend services, but not vice versa. The monitoring team needs access to everything. You'll build these asymmetric policies.

## Scenario

You have three namespaces:
- `api-gateway` - Contains the API gateway that needs to reach backend services
- `backend` - Contains backend services that should only accept traffic from the gateway
- `monitoring` - Contains monitoring tools that need access to all services

Your task is to implement NetworkPolicies that enforce these access rules while maintaining security through default-deny policies.

Click **Start** to begin!
