# The Permission Maze

Welcome to the Permission Maze! The dev team is unable to deploy their application. They have a ServiceAccount called `deploy-bot`, but something is wrong with the RBAC configuration.

There are **THREE bugs** hiding in the Role, RoleBinding, and ServiceAccount setup. Your mission is to find and fix them all.

## Scenario Setup

- **Namespace**: `rbac-lab`
- **ServiceAccount**: `deploy-bot`
- **Role**: `deployer-role`
- **RoleBinding**: `deployer-binding`

## Learning Objectives

By the end of this scenario, you will be able to:

- Use `kubectl auth can-i` to debug RBAC permissions
- Troubleshoot Role and RoleBinding configurations
- Understand API groups for different resources
- Fix broken RBAC chains

## Challenge Level

**Medium** - This is a troubleshooting scenario requiring careful investigation and systematic debugging.

Let's begin the hunt for those bugs!
