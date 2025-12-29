# CI/CD Pipeline Setup Guide

## Overview

This project includes comprehensive GitHub Actions workflows for:
- ✅ Continuous Integration (CI)
- ✅ Automated Testing
- ✅ Code Quality Checks
- ✅ Automated Builds
- ✅ Automated Deployment
- ✅ Release Management

## Workflows

### 1. CI Pipeline (`ci.yml`)

**Triggers:**
- Push to `main` or `develop`
- Pull requests to `main` or `develop`

**Jobs:**
- **Analyze**: Code analysis and formatting
- **Test**: Run all tests with coverage
- **Build Web**: Build web version
- **Build Android**: Build APK and AAB (on push)
- **Build iOS**: Build iOS app (on main branch)

### 2. Deploy Web (`deploy-web.yml`)

**Triggers:**
- Push to `main` branch
- Version tags (v*)
- Manual dispatch

**Deployment Options:**
- GitHub Pages (automatic)
- Firebase Hosting (if configured)
- Netlify (if configured)

### 3. Release (`release.yml`)

**Triggers:**
- Version tags (v*.*.*)
- Manual dispatch

**Actions:**
- Builds all platforms
- Creates GitHub release
- Uploads artifacts (APK, AAB)

### 4. Code Quality

- **Lint**: Code quality checks
- **CodeQL**: Security analysis
- **Dependency Review**: Security scanning

## Quick Start

### 1. Enable GitHub Actions

Workflows are automatically enabled when you push to GitHub.

### 2. Set Up Secrets (Optional)

For Firebase Hosting:
```
Settings → Secrets → New repository secret
- FIREBASE_SERVICE_ACCOUNT
- FIREBASE_PROJECT_ID
```

For Netlify:
```
Settings → Secrets → New repository secret
- NETLIFY_AUTH_TOKEN
- NETLIFY_SITE_ID
```

### 3. Enable GitHub Pages

1. Go to **Settings → Pages**
2. Source: **GitHub Actions**
3. Save

The web app will deploy automatically on push to `main`.

## Release Process

### Create a Release

**Option 1: Using Tags**
```bash
# Update version in pubspec.yaml
# Then create and push tag
git tag v1.0.0
git push origin v1.0.0
```

**Option 2: Manual Dispatch**
1. Go to Actions → Release
2. Click "Run workflow"
3. Enter version number
4. Run

### Version Format

Follow semantic versioning:
- `v1.0.0` - Major release
- `v1.0.1` - Patch release
- `v1.1.0` - Minor release

## Deployment Targets

### GitHub Pages

**Automatic**: Deploys on push to `main`

**URL**: `https://[username].github.io/[repo-name]/`

### Firebase Hosting

1. Install Firebase CLI: `npm install -g firebase-tools`
2. Login: `firebase login`
3. Initialize: `firebase init hosting`
4. Add secrets to GitHub
5. Deploy automatically on push

### Netlify

1. Create Netlify site
2. Get auth token and site ID
3. Add secrets to GitHub
4. Deploy automatically on push

## Workflow Status

Check workflow status:
- Go to **Actions** tab
- View workflow runs
- See build logs and artifacts

## Artifacts

Build artifacts are available:
- **Web**: Download from workflow run
- **Android APK**: Download from workflow run
- **Android AAB**: Download from workflow run
- **iOS**: Download from workflow run (if built)

## Troubleshooting

### Build Failures

1. Check workflow logs
2. Verify Flutter version compatibility
3. Check dependency issues
4. Review error messages

### Deployment Failures

1. Verify secrets are set correctly
2. Check permissions
3. Review deployment logs
4. Verify hosting configuration

### Test Failures

1. Run tests locally: `flutter test`
2. Check test coverage
3. Review failing tests
4. Fix issues before pushing

## Customization

### Modify Workflows

Edit files in `.github/workflows/`:
- Adjust Flutter version
- Change build configurations
- Add deployment targets
- Modify triggers

### Add New Jobs

Example:
```yaml
new-job:
  name: New Job
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v4
    # Add your steps
```

## Best Practices

1. **Always test locally** before pushing
2. **Review PRs** before merging
3. **Use semantic versioning** for releases
4. **Keep secrets secure** (never commit)
5. **Monitor workflow runs** regularly

## Status Badges

Add to README.md:
```markdown
![CI](https://github.com/[username]/[repo]/workflows/CI/badge.svg)
![Deploy](https://github.com/[username]/[repo]/workflows/Deploy%20Web/badge.svg)
```

## Support

For issues with workflows:
1. Check workflow logs
2. Review GitHub Actions documentation
3. Check Flutter version compatibility
4. Verify all secrets are set

---

**Your CI/CD pipeline is ready!** 🚀

Push to GitHub and watch the workflows run automatically!

