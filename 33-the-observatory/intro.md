# The Observatory

Welcome to the Observatory! As a Kubernetes administrator and developer, you need comprehensive observability skills to monitor, debug, and maintain your cluster effectively.

## Scenario

You're managing a Kubernetes cluster running various workloads. Your mission is to:
- Monitor resource consumption across nodes and pods
- Analyze logs from single and multi-container pods
- Debug mysterious pod crashes and failures
- Assess overall cluster health and identify issues

These are essential CKAD skills you'll use daily in production environments.

## What You'll Learn

- **Resource Monitoring**: Using `kubectl top` to track CPU and memory usage
- **Log Analysis**: Extracting logs with filters (`-c`, `--previous`, `--since`, `-l`)
- **Crash Debugging**: Understanding OOMKilled errors and resource limits
- **Health Checks**: Examining node conditions, events, and system pod status
- **Troubleshooting Workflows**: Systematic approaches to identifying and resolving issues

## The Environment

We've deployed several workloads in the `observatory` namespace:
- A multi-container pod for log analysis practice
- A CPU-intensive workload
- A pod that crashes due to memory issues
- Multiple application pods with different labels

Your task is to observe, analyze, and fix issues across this diverse landscape.

Let's start monitoring!
