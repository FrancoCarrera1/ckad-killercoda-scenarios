# The Persistent Bookshelf

Welcome to the world of persistent storage in Kubernetes! Unlike emptyDir volumes that disappear when a pod is deleted, PersistentVolumes provide storage that survives pod restarts, rescheduling, and even deletions.

## Learning Objectives

By completing this scenario, you will master:

- **StorageClass**: Defining storage tiers and binding policies
- **PersistentVolume (PV)**: Creating the actual storage resource
- **PersistentVolumeClaim (PVC)**: Requesting storage for your application
- **Volume Binding**: Understanding WaitForFirstConsumer mode
- **Data Persistence**: Proving data survives pod deletion

## CKAD Exam Relevance

Persistent storage is critical for the CKAD exam:
- **Application Environment, Configuration and Security** (25%): ConfigMaps, Secrets, and volumes
- **Application Deployment** (25%): Deploying stateful applications
- **Services & Networking** (20%): StatefulSets often use persistent storage

Storage questions appear in almost every CKAD exam!

## Your Mission

You're building a bookshelf application that needs persistent storage for its book collection. You'll create the complete storage chain:

1. **StorageClass**: Define how storage should be provisioned
2. **PersistentVolume**: Create the actual storage resource
3. **PersistentVolumeClaim**: Request storage for your app
4. **Deployment**: Use the storage in a running application
5. **Verification**: Prove data persists across pod deletions

Let's build a persistent bookshelf that never loses your books!
