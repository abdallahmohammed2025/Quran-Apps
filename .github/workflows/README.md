# GitHub Actions Workflows

This directory contains CI/CD workflows for the Quran + Azkar app.

## Workflows

### 1. CI (`ci.yml`)
Runs on every push and pull request:
- **Analyze**: Code analysis and formatting checks
- **Test**: Runs unit and integration tests
- **Build Web**: Builds web version
- **Build Android**: Builds Android APK and AAB (on push only)
- **Build iOS**: Builds iOS app (on main branch only)

### 2. Deploy Web (`deploy-web.yml`)
Deploys web version to hosting:
- **GitHub Pages**: Automatic deployment
- **Firebase Hosting**: If configured
- **Netlify**: If configured

Triggers:
- Push to `main` branch
- Version tags (v*)
- Manual dispatch

### 3. Release (`release.yml`)
Creates GitHub releases:
- Builds all platforms
- Creates release with artifacts
- Uploads APK and AAB

Triggers:
- Version tags (v*.*.*)
- Manual dispatch

### 4. Lint (`lint.yml`)
Code quality checks:
- Flutter analyze
- Format checking

### 5. CodeQL (`codeql.yml`)
Security analysis:
- Automated security scanning
- Runs on push, PR, and weekly schedule

### 6. Dependency Review (`dependency-review.yml`)
Reviews dependencies in PRs:
- Checks for security vulnerabilities
- Fails on moderate+ severity

## Setup

### Required Secrets

For **Firebase Hosting**:
- `FIREBASE_SERVICE_ACCOUNT`: Firebase service account JSON
- `FIREBASE_PROJECT_ID`: Firebase project ID
- `FIREBASE_HOSTING_TARGET`: (Optional) Hosting target

For **Netlify**:
- `NETLIFY_AUTH_TOKEN`: Netlify authentication token
- `NETLIFY_SITE_ID`: Netlify site ID

For **Custom Domain** (GitHub Pages):
- `CUSTOM_DOMAIN`: Your custom domain (optional)

### GitHub Pages Setup

1. Go to repository Settings → Pages
2. Set source to "GitHub Actions"
3. Workflow will automatically deploy on push to main

### Release Process

1. Update version in `pubspec.yaml`
2. Create a tag: `git tag v1.0.0`
3. Push tag: `git push origin v1.0.0`
4. Release workflow will create GitHub release

## Manual Triggers

You can manually trigger workflows:
1. Go to Actions tab
2. Select workflow
3. Click "Run workflow"

## Status Badges

Add to README.md:
```markdown
![CI](https://github.com/username/quran-azkar-app/workflows/CI/badge.svg)
![Deploy Web](https://github.com/username/quran-azkar-app/workflows/Deploy%20Web/badge.svg)
```

