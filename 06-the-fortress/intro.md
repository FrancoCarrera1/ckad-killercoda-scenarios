# The Fortress

Welcome to The Fortress! Your cluster runs both modern security-compliant applications and legacy workloads. You need to enforce Pod Security Standards (PSS) at the namespace level to ensure proper security posture.

## The Challenge

You'll enforce different security levels:
- **Restricted** for secure, modern applications
- **Baseline** for legacy workloads

You'll also learn how to create compliant pod specifications and understand what happens when non-compliant pods are rejected.

## Pod Security Standards (PSS) Overview

Kubernetes provides three predefined Pod Security Standards:

1. **Privileged**: Unrestricted (default)
2. **Baseline**: Minimally restrictive, prevents known privilege escalations
3. **Restricted**: Heavily restricted, follows current pod hardening best practices

## Learning Objectives

By the end of this scenario, you will be able to:

- Apply Pod Security Standards at the namespace level using labels
- Create pods that comply with the `restricted` standard
- Understand the differences between `baseline` and `restricted` policies
- Debug PSS violations using namespace events

## Challenge Level

**Hard** - This scenario requires understanding security contexts, compliance requirements, and pod specifications.

Let's build The Fortress!
