# Step 1: Identify RBAC Bugs with auth can-i

The dev team reports that the `deploy-bot` ServiceAccount should be able to manage deployments and view pods, but something isn't working.

## Your Task

Use `kubectl auth can-i` to check what the `deploy-bot` ServiceAccount can actually do:

1. **Test pod listing**:
   - Can `deploy-bot` list pods in the `rbac-lab` namespace?

2. **Test deployment listing**:
   - Can `deploy-bot` list deployments?

3. **Test deployment creation**:
   - Can `deploy-bot` create deployments?

4. **Identify the bugs**:
   - Examine the Role with `kubectl get role deployer-role -n rbac-lab -o yaml`
   - Check the RoleBinding with `kubectl get rolebinding deployer-binding -n rbac-lab -o yaml`
   - Look for what's wrong

5. **Fix Bug #1 (API Group)**:
   - The Role uses the wrong API group for deployments
   - Deployments are in the `apps` API group, not `extensions`
   - Edit the Role and fix the apiGroup

<details><summary>Hint</summary>

To test ServiceAccount permissions, use:
```bash
kubectl auth can-i <verb> <resource> --as=system:serviceaccount:<namespace>:<serviceaccount-name> -n <namespace>
```

For example:
```bash
kubectl auth can-i list pods --as=system:serviceaccount:rbac-lab:deploy-bot -n rbac-lab
```

To check API groups for resources:
```bash
kubectl api-resources | grep deployments
```

</details>

<details><summary>Solution</summary>

```bash
# Test current permissions
kubectl auth can-i list pods --as=system:serviceaccount:rbac-lab:deploy-bot -n rbac-lab
# Should return: yes

kubectl auth can-i list deployments --as=system:serviceaccount:rbac-lab:deploy-bot -n rbac-lab
# Should return: no (due to wrong apiGroup)

kubectl auth can-i create deployments --as=system:serviceaccount:rbac-lab:deploy-bot -n rbac-lab
# Should return: no (due to wrong apiGroup)

# Examine the Role
kubectl get role deployer-role -n rbac-lab -o yaml
# Notice: apiGroups: ["extensions"] is wrong for deployments

# Verify the correct API group
kubectl api-resources | grep deployments
# Shows: deployments are in the "apps" API group

# Fix Bug #1: Edit the Role
kubectl edit role deployer-role -n rbac-lab
# Change apiGroups: ["extensions"] to apiGroups: ["apps"] for the deployments rule

# Verify the fix
kubectl auth can-i list deployments --as=system:serviceaccount:rbac-lab:deploy-bot -n rbac-lab
# Should still return: no (there's another bug!)
```

</details>
