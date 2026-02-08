# Congratulations!

You've successfully created a production-ready development sandbox for Angelica with all the necessary resource controls.

## What You Learned

In this scenario, you mastered:

1. **Namespace Management**
   - Creating namespaces with meaningful labels
   - Using labels for organization and filtering

2. **ServiceAccounts**
   - Creating ServiceAccounts for pod identity
   - Assigning ServiceAccounts to pods

3. **ResourceQuotas**
   - Limiting total resource consumption at the namespace level
   - Preventing resource starvation across teams

4. **LimitRanges**
   - Automatically injecting default resource requests/limits
   - Ensuring pods always have resource boundaries

5. **Resource Control Interaction**
   - How LimitRange and ResourceQuota work together
   - Testing and verifying resource policies

## CKAD Exam Tips

### Time-Saving Techniques

1. **Use imperative commands when possible**

   ```bash
   kubectl create namespace <name>
   kubectl create quota <name> --hard=<limits>
   kubectl create serviceaccount <name>
   ```

2. **Keep YAML templates handy for LimitRange** (can't be created imperatively)
   - Practice typing it quickly or use kubectl dry-run to generate starting templates

3. **Verify with describe commands**
   ```bash
   kubectl describe namespace <name>
   kubectl describe quota <name> -n <namespace>
   kubectl describe limitrange <name> -n <namespace>
   ```

### Common Pitfalls

- Forgetting to specify the namespace with `-n` flag
- Confusing `requests` vs `limits` in ResourceQuota
- Not understanding that LimitRange applies to **new** pods (won't affect existing ones)
- Incorrect units: use `m` for millicores (e.g., 250m) and `Mi`/`Gi` for memory

### Exam Relevance

This scenario covers concepts that appear in:

- **Application Environment, Configuration and Security (25%)**: Resource limits, quotas, ServiceAccounts
- **Core Concepts (13%)**: Namespaces, labels

## Next Steps

Now that you understand resource controls, you're ready to tackle:

- ConfigMaps and Secrets for application configuration
- SecurityContext for pod-level security
- Network Policies for traffic control

Great job! You're one step closer to CKAD certification!
