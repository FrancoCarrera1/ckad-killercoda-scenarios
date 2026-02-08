# The New Hire's Sandbox

Welcome to your first day as a Kubernetes cluster administrator!

## Scenario

Angelica just joined the frontend team at your company. Your job as cluster admin is to create her isolated development environment with proper resource controls so she can't accidentally consume all cluster resources.

This is a common real-world task that ensures:

- Developers have isolated workspaces (namespaces)
- They can't monopolize cluster resources (ResourceQuotas)
- Their pods get sensible defaults (LimitRanges)
- They have proper identity in the cluster (ServiceAccounts)

## Learning Objectives

By the end of this scenario, you will be able to:

- Create namespaces with labels for organization
- Create ServiceAccounts for pod identity
- Configure ResourceQuotas to limit namespace resource consumption
- Set up LimitRanges to provide default resource requests/limits
- Verify that resource defaults are automatically injected into pods

## CKAD Exam Relevance

This scenario covers **Core Concepts** and **Application Environment, Configuration and Security** domains, which together make up about 35% of the CKAD exam. Resource management questions are common!

Let's get started!
