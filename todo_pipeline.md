# Pipeline Setup TODOs

This document outlines the steps required to fully enable the CI/CD pipeline defined in
`.github/workflows/flutter.yml`.

## 1. Codecov Setup

The pipeline uploads unit/widget and integration test coverage reports to Codecov.io.

* **Secret:** `CODECOV_TOKEN`
    * **Purpose:** Authenticates uploads to Codecov, especially required for private repositories.
    * **How to get:**
        1. Go to your repository settings on Codecov.io.
        2. Find the "Upload Token".
        3. Copy the token.
    * **How to add:**
        1. In your GitHub repository, go to `Settings` > `Secrets and variables` > `Actions`.
        2. Click `New repository secret`.
        3. Name the secret `CODECOV_TOKEN`.
        4. Paste the copied token into the `Value` field.
        5. Click `Add secret`.

## 2. Firebase Test Lab Setup

The pipeline includes a job (`firebase_test_lab`) to run integration tests on Firebase Test Lab (
FTL).

* **Secret:** `GCP_SA_KEY`
    * **Purpose:** Authenticates GitHub Actions with Google Cloud Platform (GCP) to allow running
      tests on FTL and accessing results.
    * **How to get:**
        1. Go to the Google Cloud
           Console: [https://console.cloud.google.com/](https://console.cloud.google.com/)
        2. Select your GCP project.
        3. Navigate to `IAM & Admin` > `Service Accounts`.
        4. Click `+ CREATE SERVICE ACCOUNT`.
        5. Give it a name (e.g., `github-actions-ftl`).
        6. Grant necessary roles:
            * `Firebase Test Lab Admin` (to run tests)
            * `Cloud Storage Object Admin` (to write results to GCS bucket)
            * Optionally `Firebase Quality Admin` for broader access.
        7. Click `Done`.
        8. Find the newly created service account in the list.
        9. Click on the service account email.
        10. Go to the `KEYS` tab.
        11. Click `ADD KEY` > `Create new key`.
        12. Choose `JSON` as the key type and click `CREATE`.
        13. A JSON key file will be downloaded. **Keep this file secure!**
    * **How to add:**
        1. In your GitHub repository, go to `Settings` > `Secrets and variables` > `Actions`.
        2. Click `New repository secret`.
        3. Name the secret `GCP_SA_KEY`.
        4. Open the downloaded JSON key file and copy its entire content.
        5. Paste the JSON content into the `Value` field.
        6. Click `Add secret`.

* **Placeholder:** `YOUR_RESULTS_BUCKET_NAME`
    * **Purpose:** Specifies the Google Cloud Storage (GCS) bucket where FTL will store test
      results (logs, videos, etc.).
    * **How to setup:**
        1. Go to the Google Cloud Console > `Cloud Storage` > `Buckets`.
        2. Click `+ CREATE`.
        3. Choose a unique bucket name (e.g., `yourproject-ftl-results`).
        4. Configure location, storage class, access control as needed (defaults are often fine).
        5. Click `CREATE`.
        6. In `.github/workflows/flutter.yml`, find the `firebase_test_lab` job.
        7. Replace `gs://YOUR_RESULTS_BUCKET_NAME` with `gs://your-chosen-bucket-name`.

* **Placeholder:** `YOUR_GCP_PROJECT_ID`
    * **Purpose:** Specifies the GCP project ID where FTL tests should run.
    * **How to setup:**
        1. Find your GCP Project ID in the Google Cloud Console dashboard.
        2. In `.github/workflows/flutter.yml`, find the `firebase_test_lab` job.
        3. Replace `YOUR_GCP_PROJECT_ID` with your actual GCP Project ID.

**Note:** Running tests on Firebase Test Lab incurs costs on your GCP account.
