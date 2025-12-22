# Memverse API Endpoints Documentation

This document explains the structure and usage of Memverse API endpoints.

## ⚠️ Critical: Endpoint Structure

The Memverse API has an unusual structure where different types of endpoints use different base
URLs:

### OAuth Endpoints (Root Level)

```
https://www.memverse.com/oauth/token
```

- Used for authentication and token management
- **Does NOT use `/api/v1/` prefix**
- Requires `application/x-www-form-urlencoded` content type
- Must include both `client_id` and `client_secret` in form data

### Regular API Endpoints (Versioned)

```
https://www.memverse.com/api/v1/*
```

- Used for all other operations (users, verses, etc.)
- **Uses `/api/v1/` prefix**
- Typically uses `application/json` content type
- Requires `Bearer` token authorization

## Authentication Flow

### 1. Get OAuth Token

**Endpoint:** `POST https://www.memverse.com/oauth/token`

**Headers:**

```
Content-Type: application/x-www-form-urlencoded
```

**Body (form data):**

```
grant_type=password
username=user@example.com
password=userpassword
client_id=your_client_id
client_secret=your_client_secret
```

**Response:**

```json
{
  "access_token": "your_access_token_here",
  "token_type": "Bearer",
  "scope": "public",
  "created_at": 1762834255
}
```

### 2. Use Token for API Calls

**Headers:**

```
Authorization: Bearer your_access_token_here
Content-Type: application/json
Accept: application/json
```

## Common API Endpoints

### Get User Info

```
GET https://www.memverse.com/api/v1/me
```

### Get User's Memory Verses

```
GET https://www.memverse.com/api/v1/memverses?sort=2
```

### Create New User

```
POST https://www.memverse.com/api/v1/users
```

## Implementation Notes

### Flutter/Dart Implementation

```dart
// OAuth API - uses root base URL
final oauthApi = AuthApi(dio, baseUrl: 'https://www.memverse.com');

// Regular API - uses versioned base URL  
final regularApi = ApiClient(dio, baseUrl: 'https://www.memverse.com/api/v1');
```

### Common Pitfalls

1. **Wrong OAuth URL**: Don't use `/api/v1/oauth/token` - it will return 500 error
2. **Missing client_secret**: OAuth requires both client_id AND client_secret
3. **Wrong Content-Type**: OAuth requires form-urlencoded, not JSON
4. **WWW prefix**: Always use `www.memverse.com`, not `memverse.com` (server redirects)

### Error Responses

- **500 Internal Server Error**: Usually means wrong OAuth endpoint URL
- **401 Unauthorized**: Invalid credentials or missing/expired token
- **404 Not Found**: Wrong API version or endpoint path
- **422 Unprocessable Entity**: Invalid request format or missing fields

## Environment Variables

For security, never hardcode credentials. Use environment variables:

```bash
export MEMVERSE_CLIENT_ID="your_client_id"
export MEMVERSE_CLIENT_API_KEY="your_client_secret"  
export MEMVERSE_USERNAME="your_username"
export MEMVERSE_PASSWORD="your_password"
```

## Testing

Use the provided `curl_commands.md` file for testing API endpoints manually.

For automated testing, see `test/oauth_debug_test.dart` for an example of how to test authentication
flow.