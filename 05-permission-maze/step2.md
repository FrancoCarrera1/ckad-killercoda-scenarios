# Step 2: Fix the RoleBinding Subject

You've fixed the Role's API group, but the ServiceAccount still can't perform its authorized actions. There's another bug lurking in the RoleBinding!

## Your Task

1. **Test permissions again**:
   - Even with the fixed Role, check if `deploy-bot` can list deployments
   - It should still fail!

2. **Examine the RoleBinding**:
   - Look at the RoleBinding's subjects section
   - Compare the ServiceAccount name in the RoleBinding with the actual ServiceAccount

3. **Find Bug #2**:
   - The RoleBinding references the wrong ServiceAccount name
   - It should bind to `deploy-bot`, not `deployment-bot`

4. **Fix the RoleBinding**:
   - Edit the RoleBinding and correct the subject name

5. **Verify the fix**:
   - Test that `deploy-bot` can now create and list deployments

<details><summary>Hint</summary>

Check what ServiceAccounts exist:
```bash
kubectl get serviceaccounts -n rbac-lab
```

Then compare with the RoleBinding:
```bash
kubectl get rolebinding deployer-binding -n rbac-lab -o yaml
```

Look at the `subjects` section - does the name match?

</details>

<details><summary>Solution</summary>

```bash
# Test permissions (should still fail)
kubectl auth can-i create deployments --as=system:serviceaccount:rbac-lab:deploy-bot -n rbac-lab
# Returns: no

# Check existing ServiceAccounts
kubectl get serviceaccounts -n rbac-lab
# Shows: deploy-bot exists

# Examine the RoleBinding
kubectl get rolebinding deployer-binding -n rbac-lab -o yaml
# Notice: subjects[0].name is "deployment-bot" (wrong!)

# Fix Bug #2: Edit the RoleBinding
kubectl edit rolebinding deployer-binding -n rbac-lab
# Change subjects[0].name from "deployment-bot" to "deploy-bot"

# Alternative: use kubectl patch
kubectl patch rolebinding deployer-binding -n rbac-lab --type='json' \
  -p='[{"op": "replace", "path": "/subjects/0/name", "value": "deploy-bot"}]'

# Verify the fix
kubectl auth can-i create deployments --as=system:serviceaccount:rbac-lab:deploy-bot -n rbac-lab
# Should return: yes

kubectl auth can-i list deployments --as=system:serviceaccount:rbac-lab:deploy-bot -n rbac-lab
# Should return: yes

kubectl auth can-i list pods --as=system:serviceaccount:rbac-lab:deploy-bot -n rbac-lab
# Should return: yes
```

</details>
