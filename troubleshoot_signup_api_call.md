# Troubleshooting Signup API Call - 404 Error Investigation

## Overview

We're getting a 404 error when trying to signup users. This document provides steps to debug and fix
the API call.

## Current Implementation Analysis

### Expected API Structure (Based on Swagger)

- **Endpoint**: `POST /api/1/users`
- **Authentication**: Bearer token (Basic Auth with base64 encoded `client_id:client_secret`)
- **Content-Type**: `application/json` (likely)
- **Body Structure**:
  ```json
  {
    "user": {
      "name": "Test User",
      "email": "test@example.com", 
      "password": "password"
    }
  }
  ```

### Current Flutter Implementation Issues

1. **Wrong Content-Type**: Using `application/x-www-form-urlencoded` instead of `application/json`
2. **Wrong Endpoint**: May be incorrect API version or path
3. **Authentication**: Bearer token format may be incorrect

## Debugging Steps

### Step 1: Test with cURL Commands

#### Basic Signup Test (JSON format)

```bash
curl -X POST "https://www.memverse.com/api/1/users" \
  -H "Content-Type: application/json" \
  -H "Authorization: Basic $(echo -n 'CLIENT_ID:CLIENT_SECRET' | base64)" \
  -d '{
    "user": {
      "name": "Test User",
      "email": "test@example.com",
      "password": "Test1234"
    }
  }' \
  -v
```

#### Alternative Format Test (Form Data)

```bash
curl -X POST "https://www.memverse.com/api/1/users" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "Authorization: Basic $(echo -n 'CLIENT_ID:CLIENT_SECRET' | base64)" \
  -d 'user[name]=Test User&user[email]=test@example.com&user[password]=Test1234' \
  -v
```

#### Test Different Endpoints

```bash
# Try without version number
curl -X POST "https://www.memverse.com/api/users" \
  -H "Content-Type: application/json" \
  -H "Authorization: Basic $(echo -n 'CLIENT_ID:CLIENT_SECRET' | base64)" \
  -d '{"user":{"name":"Test","email":"test@example.com","password":"Test1234"}}' \
  -v

# Try with different auth format
curl -X POST "https://www.memverse.com/api/1/users" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $(echo -n 'CLIENT_ID:CLIENT_SECRET' | base64)" \
  -d '{"user":{"name":"Test","email":"test@example.com","password":"Test1234"}}' \
  -v
```

### Step 2: Add Dio Interceptor for Debugging

Add this to your Flutter app for detailed request/response logging:

```dart
// Add to lib/src/common/interceptors/curl_logging_interceptor.dart
import 'package:dio/dio.dart';

class CurlLoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _printCurlCommand(options);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('✅ RESPONSE: ${response.statusCode}');
    print('📝 Response Headers: ${response.headers}');
    print('📦 Response Body: ${response.data}');
    super.onResponse(response, handler);
  }

  @override  
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('❌ ERROR: ${err.message}');
    print('🔍 Request URL: ${err.requestOptions.uri}');
    print('📝 Request Headers: ${err.requestOptions.headers}');
    print('📦 Request Data: ${err.requestOptions.data}');
    if (err.response != null) {
      print('📥 Error Response: ${err.response?.data}');
      print('🔢 Status Code: ${err.response?.statusCode}');
    }
    super.onError(err, handler);
  }

  void _printCurlCommand(RequestOptions options) {
    final uri = options.uri;
    var curl = 'curl -X ${options.method.toUpperCase()} "$uri"';
    
    // Add headers
    options.headers.forEach((key, value) {
      curl += ' \\\n  -H "$key: $value"';
    });
    
    // Add data if present
    if (options.data != null) {
      if (options.data is String) {
        curl += ' \\\n  -d \'${options.data}\'';
      } else {
        curl += ' \\\n  -d \'${options.data.toString()}\'';
      }
    }
    
    curl += ' \\\n  -v';
    
    print('🚀 cURL Command:');
    print(curl);
    print('---');
  }
}
```

### Step 3: Update ApiUserRepository with Debugging

```dart
// Add the interceptor to your ApiUserRepository
void _configureDio() {
  // Generate bearer token credentials like the Kotlin/Java code
  final credentials = _generateEncodedBearerTokenCredentials();
  final basicAuth = 'Basic $credentials';
  
  // Add curl logging interceptor
  _dio.interceptors.add(CurlLoggingInterceptor());
  
  _dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Authorization'] = basicAuth;
        options.headers['Content-Type'] = 'application/json'; // Changed from form-urlencoded
        options.headers['Accept'] = 'application/json';
        handler.next(options);
      },
    ),
  );
}
```

### Step 4: Compare with Chrome DevTools

1. **Open Chrome DevTools** (F12)
2. **Go to Network tab**
3. **Visit**: https://www.memverse.com/api/index.html#!/user/createUser
4. **Try the "Try it out" feature** if available
5. **Right-click on the network request** → Copy → Copy as cURL
6. **Compare the generated cURL** with our Flutter implementation

### Step 5: Test Different API Patterns

Based on common Rails API patterns, try these variations:

#### Rails Standard Pattern

```bash
curl -X POST "https://www.memverse.com/api/v1/users" \
  -H "Content-Type: application/json" \
  -H "Authorization: Basic $(echo -n 'CLIENT_ID:CLIENT_SECRET' | base64)" \
  -d '{"user":{"name":"Test","email":"test@example.com","password":"Test1234","password_confirmation":"Test1234"}}' \
  -v
```

#### Without API Prefix

```bash
curl -X POST "https://www.memverse.com/users" \
  -H "Content-Type: application/json" \
  -H "Authorization: Basic $(echo -n 'CLIENT_ID:CLIENT_SECRET' | base64)" \
  -d '{"user":{"name":"Test","email":"test@example.com","password":"Test1234"}}' \
  -v
```

## Common Issues & Solutions

### Issue 1: 404 Not Found

**Possible Causes:**

- Wrong endpoint URL
- Missing API version
- Incorrect HTTP method

**Solutions:**

- Try different endpoint variations above
- Check if API requires different path structure
- Verify HTTP method is POST

### Issue 2: 401 Unauthorized

**Possible Causes:**

- Incorrect authentication format
- Wrong client credentials
- Missing authentication header

**Solutions:**

- Verify base64 encoding of credentials
- Try "Bearer" instead of "Basic" auth
- Check client ID and secret values

### Issue 3: 422 Unprocessable Entity

**Possible Causes:**

- Wrong request body format
- Missing required fields
- Validation errors

**Solutions:**

- Add password_confirmation field
- Check required vs optional fields
- Verify field names match API expectations

## Expected Fixes

Based on typical Rails API patterns, we likely need to:

1. **Change Content-Type** to `application/json`
2. **Fix endpoint URL** (try `/api/v1/users` instead of `/api/1/users`)
3. **Add password_confirmation** field
4. **Verify authentication** format (Basic vs Bearer)

## Testing Commands

Replace `YOUR_CLIENT_ID` and `YOUR_CLIENT_SECRET` with actual values:

```bash
# Test command with your actual credentials
curl -X POST "https://www.memverse.com/api/v1/users" \
  -H "Content-Type: application/json" \
  -H "Authorization: Basic $(echo -n 'YOUR_CLIENT_ID:YOUR_CLIENT_SECRET' | base64)" \
  -d '{
    "user": {
      "name": "Test User",
      "email": "test+$(date +%s)@example.com",
      "password": "Test1234",
      "password_confirmation": "Test1234"
    }
  }' \
  -v
```

Once you find a working cURL command, we can update the Flutter implementation to match.