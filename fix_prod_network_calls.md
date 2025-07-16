# Fixing Production Network Calls (Sign-In, Sign-Up, Get Verses)

---

## LLM Prompt (for refactoring or debugging):

> I need to reliably implement and debug API calls for sign-in, sign-up, and get-verses endpoints in
> a Flutter app that uses Dio and/or http. Please ensure:
> 1. Requests are correctly constructed for both web and mobile (content types, form vs. JSON
     payload).
> 2. Tokens/client API key/clientSecret are attached *exactly* as backend expects.
> 3. All error states (400/401/500/timeout/bad content) are caught and shown in the UI, not just
     logs.
> 4. Responses are parsed safely: null-check, type-check, AuthToken models.
> 5. Test/dev mode can fake/mimic prod network calls, so PRs can be CI/QA verified.
> 6. App must work with Dart/Flutter null safety and be robust to backend changes.
> 7. Provide log/trace outputs that can be shared with backend for debugging real API contract
     mismatches.
     > Show production-safe working code for sign-in (password grant), sign-up, and fetch verses.

---

## General Strategy for Fixing/Fully Implementing Prod Auth and Verses API

1. **API Contract Review**
    - Get the latest API docs/spec from backend for each endpoint (sign-in, sign-up, get-verses).
    - Confirm: method (POST/GET), URL, required fields (headers, query, body params, content-type),
      authentication method (OAuth2, Bearer, etc).
    - Double check mobile vs. web differences (some require json, some form data).

2. **Request Construction**
    - Construct POST/GET using Dio or http as dictated by backend (FormData for native, JSON for web
      if needed).
    - Always log full request for debugging (except passwords).
    - Attach client ID, secrets, and tokens per contract.

3. **Response Handling**
    - Parse response using fromJson/factory, handle missing/optional fields.
    - Null-safe parsing for all properties (especially for new/changed backend contracts).
    - Map backend error content to friendly, clear UI error messages.

4. **Error Handling**
    - Always catch failures: connectivity, HTTP status, timeouts, JSON parsing.
    - Report status codes and error payloads in debug logs and optionally to BetterFeedback.
    - Show user-visible error for every authentication/network failure.
    - Provide fallback data in case backend changes contract and something becomes non-nullable.

5. **Local/Dev/CI Testing**
    - Ensure all test/dev/CI flows *mock* these endpoints using the current mock/fake provider
      pattern.
    - Production API calls are only used if CLIENT_ID is real (not debug/empty).

6. **Trace and Logging**
    - Use AppLogger (or similar) to emit request/response/error for every API round trip.
    - If backend fails, always include full response body in a debug log.
    - Include helpful trace on logs for backend team: endpoint, full URL, status code, truncated
      payload.

7. **Functional/Golden Tests**
    - Write widget/integration tests for sign-in and get-verses flows, covering errors and success.
    - Confirm UX gracefully handles ALL error types (auth error, server down, slow network, wrong
      password).

8. **Client ID & Contract Troubleshooting with curl**
    - **1. Always check that `client_id` (and, if present, `client_secret`) are included in the
      request per backend spec:**
        - For OAuth/password grant, `client_id` is often required in both form data and as a URL
          param. Check Swagger doc/Live API doc for what is specified and required.

    - **2. To debug, issue the *actual* POST/GET using curl:**

```sh
curl -X POST \
  'https://api.memverse.com/oauth/token' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -d 'grant_type=password&username=test%40email.com&password=testpw&client_id=xxxx&client_secret=yyyy'
```

    - Change field names as needed (sometimes `api_key` is expected by backend, sometimes `client_secret`).
    - Always verify the actual live API contract via Swagger and confirm which field names are required.

    - **3. Compare your curl (or Postman) response to the Swagger example:**
      - Confirm the expected HTTP status code (200 for success, 400/401 for bad credentials, etc).
      - Compare keys/values: Is the backend response structure as documented?
      - Copy the network body into your test to validate parsing and error handling.

    - **4. In Your Client:**
      - Log the *exact* outgoing request (minus passwords!) and received response.
      - Catch and expose all backend errors in logs/UI for easier debugging with backend team.
      - If API contract changes, update your AuthToken/model and call site accordingly.

---
**Special Note:**

- Focus on making sign-in and get-verses bulletproof first, since they block almost all user
  interaction.
- If issues persist, use curl or Postman to validate backend endpoint outside app, then match
  headers/formats exactly in client.
- Always diff backend response, documentation, and your live error logs with every network API
  change.

