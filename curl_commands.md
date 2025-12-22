# Memverse API Test Commands

This file contains curl commands for testing the Memverse API endpoints. Replace `YOUR_CLIENT_ID`
and `YOUR_CLIENT_SECRET` with your actual credentials.

## Environment Setup

First, set your credentials as environment variables:

```bash
export MEMVERSE_CLIENT_ID="your_client_id_here"
export MEMVERSE_CLIENT_SECRET="your_client_secret_here"
export MEMVERSE_USERNAME="your_username_here"
export MEMVERSE_PASSWORD="your_password_here"
export MEMVERSE_CLIENT_API_KEY="your_client_api_key_here"
```

## 1. Login/OAuth Token Command

Test the OAuth token endpoint to get an access token:

```bash
curl -X POST 'https://www.memverse.com/oauth/token' \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    --data-urlencode 'grant_type=password' \
    --data-urlencode "username=$MEMVERSE_USERNAME" \
    --data-urlencode "password=$MEMVERSE_PASSWORD" \
    --data-urlencode "client_id=$MEMVERSE_CLIENT_ID" \
    --data-urlencode "client_secret=$MEMVERSE_CLIENT_API_KEY"
```

**Expected Response:**
```json
{
  "access_token": "your_access_token_here",
  "token_type": "Bearer",
  "scope": "public",
  "created_at": 1762834255
}
```

## 2. Get Verses/Memverses Command

Test the memverses endpoint to fetch user's memory verses (requires authentication):

```bash
# First get your access token from the login command above, then use it here:
export ACCESS_TOKEN="your_access_token_from_login"

curl -X GET "https://www.memverse.com/api/v1/memverses?sort=2" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -v
```

**Expected Response:**
```json
{
  "response": [
    {
      "id": 123,
      "verse_id": 456,
      "user_id": 789,
      "status": "Learning",
      "ref": "John 3:16",
      "verse": {
        "id": 456,
        "text": "For God so loved the world...",
        "translation": "ESV",
        "book": "John",
        "chapter": 3,
        "versenum": 16
      }
    }
  ],
  "count": 1,
  "page": 1,
  "per_page": 25
}
```

## 3. Get User Info Command

Test the user info endpoint:

```bash
curl -X GET "https://www.memverse.com/api/v1/me" \
    -H "Authorization: Bearer $ACCESS_TOKEN" \
    -H 'Content-Type: application/json' \
    -H 'Accept: application/json'
```

## Alternative Commands (for testing different scenarios)

### User Creation (Signup) Command

```bash
curl -X POST "https://www.memverse.com/api/v1/users" \
  -H "Content-Type: application/json" \
  -H "Authorization: Basic $(echo -n "$MEMVERSE_CLIENT_ID:$MEMVERSE_CLIENT_API_KEY" | base64)" \
  -d '{
    "name": "Test User",
    "email": "test+$(date +%s)@example.com",
    "password": "TestPassword123"
  }' \
  -v
```

### Test API Connectivity (Simple GET)

```bash
curl -X GET "https://www.memverse.com/api/v1/memverses" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -I
```

## Troubleshooting

### 301 Redirect Issues

If you see 301 redirects, it usually means:

1. **HTTP vs HTTPS**: Make sure you're using `https://` not `http://`
2. **WWW vs Non-WWW**: Use `https://www.memverse.com` not `https://memverse.com` (server redirects
   to www)
3. **Trailing Slash**: Some APIs are sensitive to trailing slashes

### Common Error Responses

- **401 Unauthorized**: Check your credentials and base64 encoding
- **404 Not Found**: Verify the endpoint URL and API version
- **422 Unprocessable Entity**: Check request body format and required fields
- **500 Internal Server Error**: Server-side issue, check API status

### Debug Commands

Add `-v` for verbose output to see full request/response headers:

```bash
curl -X GET "https://www.memverse.com/api/v1/memverses" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -v
```

Add `-I` for headers-only response:

```bash
curl -X GET "https://www.memverse.com/api/v1/memverses" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -I
```