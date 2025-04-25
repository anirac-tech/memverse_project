# TODO: Integrate Feedback with Jira

This document outlines the steps needed to integrate the in-app feedback mechanism (using the
`feedback` package) with Jira to automatically create issues.

## Steps:

1. **Set up Jira API Access:**
    * Create a dedicated Jira API token with permissions to create issues in the desired
      project. [Jira API Tokens Documentation](https://support.atlassian.com/atlassian-account/docs/manage-api-tokens-for-your-atlassian-account/)
    * Securely store the API token, Jira instance URL, and project key (e.g., using
      `flutter_secure_storage` or environment variables via `--dart-define`). **Do not commit
      credentials directly into the codebase.**

2. **Implement Feedback Upload Logic:**
    * Modify the `onFeedback` callback provided to `BetterFeedback.of(context).show()`.
    * Inside the callback, instead of using `share_plus`, make an HTTP POST request to the Jira REST
      API's "create issue" endpoint (`/rest/api/2/issue` or
      `/rest/api/3/issue`). [Jira Cloud REST API - Create Issue](https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issues/#api-rest-api-3-issue-post)
    * **Authentication:** Use Basic Auth with the email address associated with the API token and
      the API token itself. Construct the `Authorization` header:
      `Basic base64Encode(your-email:your-api-token)`.
    * **Request Body:** Construct a JSON payload for the new issue. Include:
        * `fields`:
            * `project`: `{ "key": "YOUR_PROJECT_KEY" }`
            * `summary`: A concise summary, possibly including the start of the user's text
              feedback.
            * `description`: The full user feedback text (`feedback.text`). Consider appending
              device info (using `device_info_plus`) and app info (using `package_info_plus`) here
              for more context.
            * `issuetype`: `{ "name": "Bug" }` (or "Task", "Improvement", etc., as appropriate).
            * Optionally add labels, components, custom fields, etc.
    * Use an HTTP client package like `dio` or `http` for the request.

3. **Handle Screenshot Attachment:**
    * After successfully creating the issue (check the response status code), use the Jira REST
      API's "add attachment" endpoint (`/rest/api/2/issue/{issueIdOrKey}/attachments` or
      `/rest/api/3/issue/{issueIdOrKey}/attachments`). [Jira Cloud REST API - Add Attachment](https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-attachments/#api-rest-api-3-issue-issueidorkey-attachments-post)
    * This requires a `multipart/form-data` request.
    * Include the `feedback.screenshot` (which is a `Uint8List`) as the file part of the request.
    * Set the `X-Atlassian-Token: no-check` header for this request.
    * Use the `issueId` or `issueKey` returned from the successful issue creation request.

4. **Error Handling:**
    * Implement robust error handling for network issues, API errors (invalid credentials,
      non-existent project, etc.), and file saving/upload errors.
    * Provide user feedback if the submission fails (e.g., a `SnackBar`). Consider logging errors.

5. **User Interface:**
    * Update the UI to indicate that the feedback is being submitted (e.g., show a loading
      indicator).
    * Show a success message (e.g., `SnackBar`) upon successful submission.

6. **Testing:**
    * Write integration tests (or unit tests with mocked HTTP clients) to verify the Jira submission
      logic. Be careful not to create actual Jira issues during automated testing; use mock servers
      or a dedicated test project if necessary.

## Packages potentially needed:

* `http` or `dio` (already included)
* `flutter_secure_storage` (already included)
* `device_info_plus`
* `package_info_plus`
* `mime` (to determine mime type for attachment if needed, usually `image/png`)
