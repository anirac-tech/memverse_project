# Security Guidelines for Memverse Project

## 🔐 CRITICAL: Password and Credentials Management

### Environment Variables for Testing

This project uses specific environment variables that contain **REAL, VALID credentials** for testing purposes. **NEVER** commit the actual values of these variables - only commit references to them.

#### Valid Password Variable

- **Variable Name**: `MEMVERSE_CORRECT_PASSWORD_DO_NOT_COMMIT`
- **Usage**: Contains a valid password for authentication testing
- **⚠️ WARNING**: This is a REAL password - NEVER commit its value!

### How to Use Credentials Safely

#### ✅ CORRECT - Use Environment Variable Reference

```dart
// In tests - this is SAFE to commit
await tester.enterText(
  passwordField,
  const String.fromEnvironment(
    'MEMVERSE_CORRECT_PASSWORD_DO_NOT_COMMIT',
    defaultValue: 'dummysigninuser@dummy.com',
  ),
);
```

```yaml
# In Maestro tests - this is SAFE to commit
env:
  PASSWORD: ${MEMVERSE_CORRECT_PASSWORD_DO_NOT_COMMIT}

- inputText: ${PASSWORD}
```

#### ❌ WRONG - Hardcoded Password Value

```dart
// NEVER DO THIS - DO NOT COMMIT PASSWORD VALUES
await tester.enterText(passwordField, 'ActualPasswordValue123!');
```

```yaml
# NEVER DO THIS - DO NOT COMMIT PASSWORD VALUES  
- inputText: "ActualPasswordValue123!"
```

### Pre-Commit Checklist

Before committing ANY code, verify:

- [ ] No hardcoded passwords, API keys, or tokens in the code
- [ ] All sensitive values use `String.fromEnvironment()` or `${ENV_VAR}` syntax
- [ ] Search codebase for patterns: `password=`, `pwd:`, `pass:`, `token=`, `key=`
- [ ] Review `.gitignore` to ensure credential files are excluded
- [ ] Integration tests use `MEMVERSE_CORRECT_PASSWORD_DO_NOT_COMMIT` reference only

### Setting Up Environment Variables

#### For Local Development

Add to your `~/.zshrc` or `~/.bashrc`:

```bash
export MEMVERSE_USERNAME="your-username"
export MEMVERSE_CORRECT_PASSWORD_DO_NOT_COMMIT="your-password"
export MEMVERSE_CLIENT_ID="your-client-id"
export POSTHOG_MEMVERSE_API_KEY="your-api-key"
```

#### For CI/CD

Set these as **secret** environment variables in your CI/CD platform:
- GitHub Actions: Repository Settings → Secrets
- GitLab CI: Settings → CI/CD → Variables
- CircleCI: Project Settings → Environment Variables

### What to Do If You Accidentally Commit Credentials

1. **Immediately** rotate/change the compromised credentials
2. Remove the credentials from git history using `git filter-branch` or BFG Repo-Cleaner
3. Force push the cleaned history (coordinate with team first!)
4. Update all systems using the old credentials

### Additional Resources

- `.gitignore` - Lists patterns for files that should never be committed
- `firebender.json` - Contains security rules enforced by Firebender AI
- `integration_test/incorrect_password_test.dart` - Example of secure credential usage

## 🛡️ Security Best Practices

1. **Principle of Least Privilege**: Only use credentials with minimum required permissions
2. **Credential Rotation**: Regularly rotate passwords and API keys
3. **Separate Environments**: Use different credentials for dev, staging, and production
4. **Audit Regularly**: Review code and commits for accidental credential exposure
5. **Use Secret Management**: Consider tools like HashiCorp Vault, AWS Secrets Manager, or similar

---

**Remember**: It's easier to prevent credential leaks than to fix them after the fact. When in doubt, use an environment variable!
