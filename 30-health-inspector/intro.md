# The Health Inspector

Health probes are your application's vital signs. Kubernetes uses startup probes to know when an app is initialized, readiness probes to know when it can receive traffic, and liveness probes to know when to restart it. You'll configure all three and observe what happens when they fail.

In this scenario, you will:
- Configure startup, liveness, and readiness probes
- Observe how probes interact during pod lifecycle
- Watch the automatic recovery cascade when probes fail

Let's begin monitoring your application's health!
