const axios = require('axios');

// Configuration - Set to your actual API base URL
const API_BASE_URL = 'https://www.memverse.com/api/v1';

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

  // Extract the path part after /api/ from the incoming request
  const apiPath = event.path.replace(/^\/\.netlify\/functions\/api/, '').replace(/^\/api/, '');
  const queryString = new URLSearchParams(event.queryStringParameters || {}).toString();
  const queryPart = queryString ? `?${queryString}` : '';

  try {
    // Build the target URL
    const targetUrl = `${API_BASE_URL}${apiPath}${queryPart}`;
    console.log(`[${event.httpMethod}] Proxying request to: ${targetUrl}`);

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

    // Handle request body based on content type
    let requestData = event.body;
    
    // Parse body if it's JSON and we're sending as JSON 
    if (event.headers['content-type'] && 
        event.headers['content-type'].includes('application/json') && 
        event.body) {
      try {
        // If body is Base64 encoded, decode it first
        const bodyText = event.isBase64Encoded 
          ? Buffer.from(event.body, 'base64').toString() 
          : event.body;
          
        requestData = JSON.parse(bodyText);
        console.log('Parsed JSON body successfully');
      } catch (err) {
        console.log('Failed to parse JSON body:', err.message);
        // Continue with the original body if parsing fails
      }
    }

    // Make the request to the external API
    const response = await axios({
      method: event.httpMethod,
      url: targetUrl,
      headers: headersToForward,
      data: requestData,
      validateStatus: () => true, // Don't throw on non-2xx
      responseType: 'arraybuffer'
    });

    console.log(`Response status: ${response.status}`);

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
    console.error('Proxy error:', error.message);
    if (error.response) {
      console.error('Error status:', error.response.status);
      console.error('Error headers:', error.response.headers);
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
        error: 'Proxy failed',
        details: error.message,
      })
    };
  }
};
