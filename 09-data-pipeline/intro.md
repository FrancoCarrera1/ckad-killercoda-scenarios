# The Data Pipeline

Welcome to the data processing lab! Your data engineering team needs to implement batch processing workflows in Kubernetes. You'll be creating parallel Jobs for one-time batch processing and CronJobs for scheduled recurring tasks.

## Learning Objectives

By completing this scenario, you will master:

- **Job Configuration**: Understanding completions, parallelism, backoffLimit, and activeDeadlineSeconds
- **CronJob Scheduling**: Using cron syntax and managing concurrency policies
- **Job History Management**: Controlling successful and failed job history limits
- **Manual Job Creation**: Triggering jobs manually from CronJob templates

## CKAD Exam Relevance

Jobs and CronJobs are essential for the CKAD exam:
- **Application Deployment** (25%): Understanding different workload types
- **Application Observability and Maintenance** (15%): Monitoring job completion and failures
- Jobs often appear in exam scenarios requiring batch processing or one-time tasks

## Your Mission

Your data platform needs two components:
1. A parallel Job to process a backlog of data batches
2. A scheduled CronJob to archive records every 15 minutes

Let's build a production-ready data pipeline!
