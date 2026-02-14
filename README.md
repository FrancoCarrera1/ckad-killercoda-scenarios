# CKAD Killercoda Scenarios

33 hands-on interactive scenarios for **Certified Kubernetes Application Developer (CKAD)** exam preparation, built for [Killercoda](https://killercoda.com/).


## Scenarios

### Domain 1: Application Environment, Configuration & Security (25%)

| # | Scenario | Difficulty | Skills |
|---|----------|------------|--------|
| 01 | [The New Hire's Sandbox](01-new-hires-sandbox) | Easy | Namespace, ServiceAccount, ResourceQuota, LimitRange |
| 02 | [The Config Switchboard](02-config-switchboard) | Easy | ConfigMap envFrom vs volumeMount patterns |
| 03 | [The Vault Heist](03-vault-heist) | Medium | Secret types, SecurityContext, imagePullSecrets |
| 04 | [The Cluster Census](04-cluster-census) | Easy | Listing, filtering, jsonpath, custom-columns |
| 05 | [The Permission Maze](05-permission-maze) | Medium | RBAC troubleshooting (Role, RoleBinding, ServiceAccount) |
| 06 | [The Fortress](06-the-fortress) | Hard | Pod Security Standards (restricted, baseline) |
| 07 | [The Admission Gatekeeper](07-admission-gatekeeper) | Hard | Admission controllers, LimitRange/quota arithmetic |
| 08 | [The Identity Crisis](08-identity-crisis) | Hard | ServiceAccount token mechanics, projected volumes |

### Domain 2: Application Design & Build (20%)

| # | Scenario | Difficulty | Skills |
|---|----------|------------|--------|
| 09 | [The Data Pipeline](09-data-pipeline) | Easy | Job parallelism, CronJob, manual trigger |
| 10 | [The Microservices Quartet](10-microservices-quartet) | Easy | Init containers, sidecars, shared volumes |
| 11 | [The Persistent Bookshelf](11-persistent-bookshelf) | Medium | StorageClass, PV, PVC, data persistence |
| 12 | [The Ephemeral Workshop](12-ephemeral-workshop) | Medium | emptyDir variations (memory-backed, shared, hybrid) |
| 13 | [The Container Factory](13-container-factory) | Medium | Multi-stage Dockerfile, docker save/load |
| 14 | [The Resilient Worker](14-resilient-worker) | Hard | Indexed Jobs, ttlSecondsAfterFinished, backoffLimit |
| 15 | [The Sidecar Surgery](15-sidecar-surgery) | Hard | Retrofit sidecar + probes to existing Deployment |

### Domain 3: Application Deployment (20%)

| # | Scenario | Difficulty | Skills |
|---|----------|------------|--------|
| 16 | [The Smooth Operator](16-smooth-operator) | Easy | Rolling update (maxUnavailable, maxSurge) |
| 17 | [The Time Machine](17-time-machine) | Easy | Rollback (undo, --to-revision, change-cause) |
| 18 | [The Blue-Green Bridge](18-blue-green-bridge) | Medium | Blue-green deployment with Service selector swap |
| 19 | [The Canary Cage](19-canary-cage) | Medium | Canary deployment with traffic splitting |
| 20 | [The Helm Expedition](20-helm-expedition) | Medium | Helm install, upgrade, rollback, uninstall |
| 21 | [The Kustomize Kaleidoscope](21-kustomize-kaleidoscope) | Hard | Kustomize base, overlays, generators |
| 22 | [The Release Train](22-release-train) | Hard | Helm + Kustomize combined workflow |

### Domain 4: Services & Networking (20%)

| # | Scenario | Difficulty | Skills |
|---|----------|------------|--------|
| 23 | [The Service Menu](23-service-menu) | Easy | ClusterIP, NodePort, ExternalName, Headless |
| 24 | [The Traffic Director](24-traffic-director) | Easy | Ingress with multi-path rules + default backend |
| 25 | [The Network Lockdown](25-network-lockdown) | Medium | NetworkPolicy progressive zero-trust hardening |
| 26 | [The Cross-Namespace Corridor](26-cross-namespace-corridor) | Medium | Cross-namespace NetworkPolicy |
| 27 | [The Broken Bridge](27-broken-bridge) | Medium | Networking troubleshooting (selectors, ports) |
| 28 | [The TLS Fortress](28-tls-fortress) | Hard | TLS Ingress with self-signed certs |
| 29 | [The DNS Detective](29-dns-detective) | Hard | Kubernetes DNS (FQDN, headless, StatefulSet records) |

### Domain 5: Application Observability & Maintenance (15%)

| # | Scenario | Difficulty | Skills |
|---|----------|------------|--------|
| 30 | [The Health Inspector](30-health-inspector) | Easy | startupProbe, livenessProbe, readinessProbe |
| 31 | [The Application Autopsy](31-application-autopsy) | Medium | Cascading multi-tier debugging |
| 32 | [The API Archaeologist](32-api-archaeologist) | Medium | Deprecated API manifest conversion |
| 33 | [The Observatory](33-the-observatory) | Hard | kubectl top, logs, events, OOMKilled debugging |

## Difficulty Distribution

| Level | Count |
|-------|-------|
| Easy | 10 |
| Medium | 13 |
| Hard | 10 |

## Scenario Structure

Each scenario follows the same file layout:

```
scenario-name/
  index.json           # Title, description, backend config, step definitions
  intro.md             # Narrative context and learning objectives
  setup.sh             # Pre-creates namespaces, broken resources, etc.
  step1.md             # Task instructions (includes hints + solutions)
  step1-verify.sh      # Automated validation (exit 0 = pass, exit 1 = fail)
  step2.md / step2-verify.sh
  step3.md / step3-verify.sh
  finish.md            # Summary and exam tips
```

- **intro.md** sets the scene with a real-world narrative
- **stepN.md** files contain the task, hints in collapsible `<details>` blocks, and a full solution
- **stepN-verify.sh** scripts automatically check your work (pass/fail)
- **finish.md** recaps what you learned and gives CKAD exam tips

## How to Use

### On Killercoda

1. Push this repo to GitHub
2. Link the repo to your [Killercoda Creator](https://killercoda.com/creator) account
3. Scenarios will appear automatically based on `structure.json`

### Suggested Study Path

1. **Start with Easy scenarios** to build confidence with core primitives
2. **Progress to Medium** for multi-resource and troubleshooting tasks
3. **Finish with Hard** for exam-realistic, multi-step challenges
4. **Revisit troubleshooting scenarios** (05, 15, 17, 27, 31, 32) under time pressure

### Exam Tips

- Practice with `kubectl explain <resource>` instead of reaching for docs
- Use `kubectl run --dry-run=client -o yaml` to generate manifests quickly
- Get comfortable with `kubectl get -o jsonpath='{...}'` for extracting specific fields
- Know your short names: `po`, `svc`, `deploy`, `ns`, `cm`, `sa`, `pv`, `pvc`, `ing`, `netpol`
