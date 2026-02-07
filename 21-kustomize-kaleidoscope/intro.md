# The Kustomize Kaleidoscope

Welcome to the Kustomize Kaleidoscope! Kustomize is Kubernetes' native configuration management tool, built directly into `kubectl`.

## What You'll Learn

Kustomize allows you to customize Kubernetes manifests without templates or parameter substitution. In this scenario, you'll:

- **Create a base configuration**: Define common resources shared across environments
- **Build overlays**: Layer environment-specific customizations for dev and prod
- **Use patches**: Modify resources for different environments
- **Generate ConfigMaps and Secrets**: Create configuration with automatic hash suffixes
- **Deploy with kubectl**: Apply Kustomize configurations directly

## Why Kustomize Matters for CKAD

Kustomize is part of the CKAD curriculum and is built into `kubectl` (no separate installation needed). You'll need to:

- Understand the base/overlay pattern
- Create and modify `kustomization.yaml` files
- Use `kubectl kustomize` to preview changes
- Apply configurations with `kubectl apply -k`
- Work with generators for ConfigMaps and Secrets

The exam may ask you to customize existing manifests or create environment-specific configurations—Kustomize is the tool for the job.

## Directory Structure

You'll build this structure:
```
/root/kustomize-app/
├── base/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── kustomization.yaml
└── overlays/
    ├── dev/
    │   └── kustomization.yaml
    └── prod/
        ├── kustomization.yaml
        └── resource-limits-patch.yaml
```

Let's start building!
