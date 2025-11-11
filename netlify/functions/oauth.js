const axios = require('axios');

// Configuration - OAuth endpoint is at root level
const OAUTH_BASE_URL = 'https://www.memverse.com';

exports.handler = async function(event, context) {
  // Handle CORS preflight OPTIONS request
  if (event.httpMethod === 'OPTIONS') {
    return {
      statusCode: 200,
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "Content-Type, Authorization, Accept",
        "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
        "Access-Control-Max-Age": "86400", // 24 hours
      },
      body: ''
    };
  }

  // Extract the path part after /oauth/ from the incoming request
  const oauthPath = event.path.replace(/^\/\.netlify\/functions\/oauth/, '').replace(/^\/oauth/, '');
  const queryString = new URLSearchParams(event.queryStringParameters || {}).toString();
  const queryPart = queryString ? `?${queryString}` : '';

  try {
    // Build the target URL - OAuth endpoints are at root level
    const targetUrl = `${OAUTH_BASE_URL}/oauth${oauthPath}${queryPart}`;
    console.log(`[${event.httpMethod}] Proxying OAuth request to: ${targetUrl}`);

    // Debug OAuth request details (without logging sensitive data)
    console.log('OAuth request detected');
    console.log('Headers:', JSON.stringify(event.headers));
    console.log('Content-Type:', event.headers['content-type']);
    console.log('Body present:', !!event.body);

    // Forward necessary headers
    const headersToForward = {};
    if (event.headers['authorization']) {
      headersToForward['Authorization'] = event.headers.authorization;
    }
    if (event.headers['content-type']) {
      headersToForward['Content-Type'] = event.headers['content-type'];
    }
    if (event.headers['accept']) {
      headersToForward['Accept'] = event.headers.accept;
    }

    // Handle request body - for OAuth, it's usually form-urlencoded
    let requestData = event.body;
    
    // If body is Base64 encoded, decode it first
    if (event.isBase64Encoded && event.body) {
      requestData = Buffer.from(event.body, 'base64').toString();
    }

    // Make the request to the OAuth endpoint
    const response = await axios({
      method: event.httpMethod,
      url: targetUrl,
      headers: headersToForward,
      data: requestData,
      validateStatus: () => true, // Don't throw on non-2xx
      responseType: 'arraybuffer'
    });

    console.log(`OAuth response status: ${response.status}`);
    
    // Log OAuth response (without sensitive token data)
    if (response.status !== 200) {
      const responseText = Buffer.from(response.data, 'binary').toString();
      console.log('OAuth error response:', responseText);
    } else {
      console.log('OAuth successful response (token not logged for security)');
    }

    // Convert ArrayBuffer to base64 string for Netlify Function response
    const responseBody = Buffer.from(response.data, 'binary').toString('base64');

    // Return the response with CORS headers
    return {
      statusCode: response.status,
      headers: {
        "Access-Control-Allow-Origin": "*", 
        "Access-Control-Allow-Headers": "Content-Type, Authorization, Accept",
        "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
        "Content-Type": response.headers['content-type'] || 'application/json',
      },
      body: responseBody,
      isBase64Encoded: true
    };
  } catch (error) {
    console.error('OAuth proxy error:', error.message);
    if (error.response) {
      console.error('OAuth error status:', error.response.status);
      console.error('OAuth error headers:', error.response.headers);
    }

    return {
      statusCode: error.response?.status || 500,
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "Content-Type, Authorization, Accept", 
        "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        error: 'OAuth proxy failed',
        details: error.message,
      })
    };
  }
};