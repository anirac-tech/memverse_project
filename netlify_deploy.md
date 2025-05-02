# Netlify CORS Proxy Deployment Guide

This document explains the Netlify CORS proxy setup implemented in this project, why it's necessary,
and how it works.

## What Was Done

To enable the Flutter web application to make requests to external APIs without running into browser
security restrictions (CORS), we set up a proxy using Netlify Functions. This involved:

1. **Creating `netlify.toml`**: A configuration file in the project root that tells Netlify how to
   build and deploy the site, including where to find serverless functions and how to handle
   redirects.
2. **Creating `netlify/functions/api.js`**: A serverless Node.js function that acts as a proxy. It
   receives requests from the frontend, forwards them to the target API, and returns the response
   back to the frontend with appropriate CORS headers added.
3. **Creating `netlify/functions/package.json`**: Defines the Node.js dependencies needed by the
   `api.js` function (specifically `axios` for making HTTP requests).
4. **Updating `.gitignore`**: Added `netlify/functions/node_modules/` and `.netlify/` to prevent
   committing build artifacts and dependencies.
5. **Updating Dart Code**: Modified the Flutter code where API calls are made to use the proxy URL (
   `/api/...`) when running on the web (`kIsWeb`) and the direct API URL otherwise.

## How the Proxy Works

1. **Frontend Request**: The Flutter web app makes an HTTP request to a relative path starting with
   `/api/` (e.g., `/api/users/1`).
2. **Netlify Redirect**: Netlify detects this request path. Based on the `[[redirects]]` rule in
   `netlify.toml`, it internally rewrites the request URL to `/.netlify/functions/api/users/1` and
   invokes the `api` function. The `:splat` in the `to` rule captures the part of the URL after
   `/api/`.
3. **Netlify Function Execution**: The `netlify/functions/api.js` function executes.
    * It reconstructs the original intended target API URL (e.g.,
      `https://your-actual-api.com/users/1`) using the path information passed from the redirect and
      the `API_BASE_URL` constant defined within the function. **Remember to set this constant
      correctly!**
    * It uses `axios` to make the actual request to the target API.
    * It receives the response from the target API.
4. **Response Modification**: Before sending the response back to the browser, the function modifies
   the response headers:
    * It adds `Access-Control-Allow-Origin: *`. This tells the browser that content from *any*
      origin is allowed to access the response. For tighter security, you could replace `*` with
      your specific Netlify site URL.
    * It may add other `Access-Control-Allow-*` headers if needed (like `Allow-Headers` or
      `Allow-Methods`).
    * It forwards the original `Content-Type` and other relevant headers from the target API's
      response.
5. **Frontend Receives Response**: The browser receives the response from the Netlify function.
   Because the necessary CORS headers are present, the browser allows the Flutter web app to access
   the response data.

## What is CORS?

CORS stands for **Cross-Origin Resource Sharing**. It's a security mechanism implemented by web
browsers to prevent web pages from making requests to a different domain (origin) than the one that
served the web page.

An "origin" is defined by the combination of protocol (e.g., `https`), domain (e.g.,
`your-site.netlify.app`), and port (e.g., `443`).

**Why does it exist?** Imagine you're logged into your online bank at `mybank.com`. If you then
visit a malicious website (`evil.com`) in another tab, without CORS, scripts running on `evil.com`
could potentially make requests to `mybank.com` using *your* logged-in credentials, accessing your
sensitive data.

CORS prevents this by default. When a script on `your-site.netlify.app` tries to fetch data from
`api.some-other-domain.com`, the browser first sends a "preflight" request (an `OPTIONS` request) to
`api.some-other-domain.com`. The server at `api.some-other-domain.com` must respond with specific
CORS headers (like `Access-Control-Allow-Origin`) that explicitly grant permission for
`your-site.netlify.app` to make the actual request (e.g., a `GET` or `POST`).

If the server *doesn't* respond with the correct CORS headers, the browser blocks the request, and
you see a CORS error in the console.

**How the Proxy Solves This:** The browser makes a request to `/api/...`, which is on the *same
origin* (`your-site.netlify.app`). Netlify handles this request internally and invokes the function.
The function then makes a *server-side* request to the *different* origin (
`api.some-other-domain.com`). Server-to-server requests are not subject to browser CORS
restrictions. The function gets the response and sends it back to the browser *from the original
origin* (`your-site.netlify.app`), adding the necessary CORS headers (
`Access-Control-Allow-Origin: *`) so the browser allows the frontend code to read it.

## What is TOML?

TOML stands for **Tom's Obvious, Minimal Language**. It's a configuration file format designed to be
easy to read due to straightforward semantics.

**Why is it called TOML?** It was created by Tom Preston-Werner, a co-founder of GitHub. He named it
after himself, aiming for a format that felt obvious and minimal compared to alternatives like YAML
or JSON for configuration purposes.

**Key Features:**

* **Easy to Read:** Syntax is simple and resembles INI files.
* **Semantic:** Designed specifically for configuration.
* **Data Types:** Supports strings, integers, floats, booleans, dates, arrays, and tables (key-value
  maps).
* **Structure:** Uses `[section]` headers for tables and `[[array_of_tables]]` for arrays of
  tables (like our `[[redirects]]` rule).

In our case, `netlify.toml` uses TOML syntax to define build settings, function locations, and
redirect rules for the Netlify platform.

## Netlify Basics for Newcomers

* **What is Netlify?** Netlify is a platform for building, deploying, and managing modern web
  projects (websites and web apps). It excels at hosting static sites (like the output of
  `flutter build web`) but also supports serverless functions, form handling, authentication, and
  more.
* **Key Concepts:**
    * **Site:** A project deployed on Netlify.
    * **Build:** The process of converting your source code into static files that can be served (
      e.g., running `flutter build web`). Netlify runs this build process based on the `command` in
      `netlify.toml`.
    * **Deploy:** Uploading the built files (from the `publish` directory specified in
      `netlify.toml`) to Netlify's global CDN.
    * **Serverless Functions:** Small pieces of backend code (like our `api.js` proxy) that run on
      demand without managing servers. Netlify handles scaling automatically.
    * **Redirects & Rewrites:** Rules (defined in `netlify.toml` or a `_redirects` file) to manage
      how incoming URLs are handled, crucial for SPAs (Single Page Applications) and proxies.
    * **CDN (Content Delivery Network):** Netlify deploys your static assets to servers worldwide,
      so users load the site from a server geographically close to them, improving speed.
* **Workflow:**
    1. Connect your Git repository (GitHub, GitLab, Bitbucket) to Netlify.
    2. Configure build settings (often auto-detected or via `netlify.toml`).
    3. Push code to your repository.
    4. Netlify automatically detects the push, runs the build command, and deploys the result.
* **Benefits:** Continuous deployment, HTTPS by default, global CDN, serverless functions, generous
  free tier.

## Next Steps & Considerations

* **Set `API_BASE_URL`:** Ensure the `API_BASE_URL` constant in `netlify/functions/api.js` is
  correctly set to the base URL of the API you are proxying (should be `https://www.memverse.com`).
* **Dependencies:** Netlify automatically runs `npm install` in the `netlify/functions` directory
  during deployment based on `package.json`. Manual local installation is only needed for local
  testing.
* **Environment Variables:** For sensitive information like API keys needed by the proxy function or
  your app:
    * The current setup requires a `MEMVERSE_CLIENT_ID` environment variable to be set in Netlify (
      Site settings > Build & deploy > Environment).
    * This variable is passed to the Flutter app via the
      `--dart-define=CLIENT_ID=$MEMVERSE_CLIENT_ID` flag during build.
    * You can add additional environment variables as needed following the same pattern.
* **Entry Point:** The build is currently configured to use `lib/main_development.dart` as the entry
  point instead of the default `lib/main.dart`.
    * This is specified via the `--target lib/main_development.dart` flag in the build command.
    * If you need to change the entry point (e.g., to use a production configuration), update this
      flag in `netlify.toml`.
* **Error Handling:** Review the error handling in `api.js` to ensure it meets your needs.
* **Security:** For production, consider changing `Access-Control-Allow-Origin: *` in `api.js` to
  your specific Netlify domain (`Access-Control-Allow-Origin: https://your-site-name.netlify.app`)
  for better security.

## Deployment Notes

To summarize key aspects of the current deployment setup:

1. **Flutter Installation:** Flutter version 3.29.3 is downloaded and installed during the build
   process directly from Google's servers using `curl` and `tar`.
2. **Web Build:** The app is built for web with `flutter build web --release` along with appropriate
   `--dart-define` parameters.
3. **Environment Variables:**
    - `MEMVERSE_CLIENT_ID`: Used for authentication with the Memverse API, passed to the app via
      `--dart-define=CLIENT_ID`.
4. **Entry Point:** Using `lib/main_development.dart` instead of default `lib/main.dart`.
5. **CORS Proxy:** A serverless function (`netlify/functions/api.js`) handles the CORS proxying,
   making external API calls possible from the web app.

---
