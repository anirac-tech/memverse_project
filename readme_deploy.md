# Memverse Deployment Instructions

This document outlines how to deploy the Memverse app to GitHub Pages and alternative platforms.

## GitHub Pages Deployment

This project is configured for free deployment to GitHub Pages through a GitHub Actions workflow.

### Setup Instructions

1. **Add API Token**: Add your MEMVERSE_API_TOKEN to GitHub repository secrets
    - Go to your GitHub repository
    - Navigate to Settings → Secrets and variables → Actions
    - Click "New repository secret"
    - Name: `MEMVERSE_API_TOKEN`
    - Value: Your API token from memverse.com

2. **Deploy**:
    - Push code to the `main` branch
    - OR manually trigger the GitHub Pages workflow from the Actions tab

3. **Access**:
    - Your app will be available at `https://[username].github.io/[repo-name]/`
    - First deployment may take a few minutes to become available

## Running Locally with Chrome

For local development, the simplest approach is to use a browser extension to handle CORS issues:

1. Install the **CORS Unblock** browser extension for Chrome:
   -
   Chrome: https://chrome.google.com/webstore/detail/cors-unblock/lfhmikememgdcahcdlaciloancbhjino

2. Enable the extension and run your Flutter app: