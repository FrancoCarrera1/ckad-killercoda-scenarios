# The Blue-Green Bridge

Blue-green deployments maintain two identical environments — only one serves live traffic at a time. By switching the Service selector, you achieve instant, zero-downtime cutover. If anything goes wrong, switching back is just as fast.

## Learning Objectives

- Implement the blue-green deployment pattern
- Use Service label selectors for traffic routing
- Perform instant traffic cutover with zero downtime
- Maintain rollback capability
- Understand the trade-offs of blue-green vs rolling updates

## Scenario

Your web application needs a major update. Instead of a gradual rolling update, you want instant cutover with the ability to instantly roll back if needed. You'll deploy the new version alongside the old one, then switch traffic atomically.

## Blue-Green Pattern

```
Before:                 After:
┌──────────┐           ┌──────────┐
│ Service  │           │ Service  │
│ (blue)   │           │ (green)  │
└────┬─────┘           └────┬─────┘
     │                      │
┌────▼─────┐           ┌────▼─────┐
│  Blue    │           │  Green   │
│ v1.24    │           │  v1.25   │
└──────────┘           └──────────┘
```
