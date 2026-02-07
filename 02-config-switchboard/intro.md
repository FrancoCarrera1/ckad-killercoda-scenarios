# The Config Switchboard

Welcome to configuration management in Kubernetes!

## Scenario

Your company runs the same web application in both staging and production environments, but each needs different configurations (database hosts, log levels, feature flags). You need to master both ConfigMap injection patterns: environment variables and volume mounts.

This is a fundamental skill for:
- Separating configuration from code (12-factor app principle)
- Managing multi-environment deployments
- Avoiding hardcoded values in container images

## Learning Objectives

By the end of this scenario, you will be able to:
- Create ConfigMaps with multiple key-value pairs
- Inject entire ConfigMaps as environment variables using `envFrom`
- Mount ConfigMaps as files using volumes
- Verify configuration is correctly loaded in running containers
- Understand when to use env vars vs volume mounts

## CKAD Exam Relevance

This scenario covers the **Application Environment, Configuration and Security** domain (25% of the exam). ConfigMap questions are extremely common in the CKAD exam, and you must be fast at creating and injecting them!

## The Two Injection Patterns

1. **Environment Variables** (`envFrom`): Best for simple key-value configs
2. **Volume Mounts**: Best for config files, allows hot-reload without pod restart

Let's master both!
