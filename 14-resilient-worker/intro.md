# The Resilient Worker

Welcome to the Resilient Worker scenario! Production batch processing systems must handle failures gracefully and process work efficiently at scale.

## Scenario Overview

In this scenario, you'll build a fault-tolerant batch processing pipeline using:
- **Indexed Jobs** for parallel processing with unique work identifiers
- **Backoff limits** for automatic retry with exponential backoff
- **TTL cleanup** for automatic resource management
- **CronJobs** for scheduled pipeline execution

## Why This Matters

Real-world batch systems face constant challenges:
- **Transient failures**: Network glitches, temporary resource unavailability
- **Partial failures**: Some work items succeed, others fail
- **Resource management**: Cleaning up completed jobs automatically
- **Parallel processing**: Distributing work across multiple workers

Kubernetes Jobs provide built-in resilience patterns that make production batch processing reliable and manageable.

## Real-World Context

You're building a data processing pipeline that needs to:
1. Process multiple data partitions in parallel (Indexed Jobs)
2. Retry failed tasks automatically (backoffLimit)
3. Clean up completed jobs after 2 minutes (TTL)
4. Run on a schedule and read configuration dynamically (CronJob + ConfigMap)

## Learning Objectives

By the end of this scenario, you will:
- Create Indexed Jobs with `JOB_COMPLETION_INDEX` for parallel processing
- Configure `backoffLimit` for automatic retry behavior
- Use `ttlSecondsAfterFinished` for automatic cleanup
- Build CronJobs that read configuration from ConfigMaps
- Understand job failure modes and recovery strategies

Let's build resilient batch systems!
