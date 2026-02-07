# Step 3: Grant Pod Log Access

Great work fixing the first two bugs! Now the dev team has a new requirement: the `deploy-bot` ServiceAccount needs to view pod logs for debugging purposes.

## Your Task

1. **Test current log access**:
   - Check if `deploy-bot` can get pod logs using `kubectl auth can-i`
   - The subresource for logs is `pods/log`

2. **Extend the Role**:
   - Add a new rule to the `deployer-role` that allows `get` on the `pods/log` subresource
   - Remember: subresources use the format `resource/subresource`

3. **Verify the fix**:
   - Confirm that `deploy-bot` can now access pod logs

<details><summary>Hint</summary>

Subresources in Kubernetes use a slash notation. For pod logs, the resource is `pods/log`.

To test subresource access:
```bash
kubectl auth can-i get pods/log --as=system:serviceaccount:rbac-lab:deploy-bot -n rbac-lab
```

When adding a rule for subresources, you can either:
- Add a new rule specifically for the subresource
- Or add the subresource to an existing rule with the same apiGroup

</details>

<details><summary>Solution</summary>

```bash
# Test current log access
kubectl auth can-i get pods/log --as=system:serviceaccount:rbac-lab:deploy-bot -n rbac-lab
# Should return: no

# Edit the Role to add pods/log access
kubectl edit role deployer-role -n rbac-lab

# Add this rule (or modify the existing pods rule):
# - apiGroups: [""]
#   resources: ["pods/log"]
#   verbs: ["get"]

# Alternative: use kubectl patch to add the rule
kubectl patch role deployer-role -n rbac-lab --type='json' -p='[
  {
    "op": "add",
    "path": "/rules/-",
    "value": {
      "apiGroups": [""],
      "resources": ["pods/log"],
      "verbs": ["get"]
    }
  }
]'

# Verify the fix
kubectl auth can-i get pods/log --as=system:serviceaccount:rbac-lab:deploy-bot -n rbac-lab
# Should return: yes

# View the final Role configuration
kubectl get role deployer-role -n rbac-lab -o yaml
```

</details>

## Congratulations!

You've successfully debugged and fixed all three RBAC bugs:
1. ✅ Fixed the API group for deployments (extensions → apps)
2. ✅ Fixed the RoleBinding subject name (deployment-bot → deploy-bot)
3. ✅ Added pod log access for debugging

The `deploy-bot` ServiceAccount is now fully functional!
