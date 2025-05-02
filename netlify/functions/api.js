const axios = require('axios');

// Configuration - Set to your actual API base URL
const API_BASE_URL = 'https://www.memverse.com';

exports.handler = async function(event, context) {
  // Extract the path part after /api/ from the incoming request
  // Example: /api/users/1 -> /users/1
  const apiPath = event.path.replace(/^\/\.netlify\/functions\/api/, '').replace(/^\/api/, '');
  const queryString = new URLSearchParams(event.queryStringParameters || {}).toString();
  const queryPart = queryString ? `?${queryString}` : '';

  try {
    // Build the target URL
    const targetUrl = `${API_BASE_URL}${apiPath}${queryPart}`;
    console.log(`Proxying request to: ${targetUrl}`);

    // Forward necessary headers. Add others if needed (e.g., Authorization).
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


    // Make the request to the external API using the original method and body
    const response = await axios({
        method: event.httpMethod,
        url: targetUrl,
        headers: headersToForward,
        data: event.body,
        // Prevent axios from throwing on non-2xx status codes, so we can forward the original status
        validateStatus: () => true,
         // Forward response as buffer to handle different content types (JSON, images, etc.)
        responseType: 'arraybuffer'
      });

    // Convert ArrayBuffer to base64 string for Netlify Function response
    const responseBody = Buffer.from(response.data, 'binary').toString('base64');

    // Return the response with CORS headers and original status/content-type
    return {
      statusCode: response.status,
      headers: {
        "Access-Control-Allow-Origin": "*", // Or restrict to your Netlify URL in production
        "Access-Control-Allow-Headers": "Content-Type, Authorization, Accept", // Match forwarded/expected headers
        "Content-Type": response.headers['content-type'] || 'application/json', // Forward original content type
         // Forward other relevant headers from the target response if needed
         ...response.headers // Forward all headers from target (optional, review for security)
      },
       body: responseBody,
      isBase64Encoded: true // Indicate the body is base64 encoded
    };
  } catch (error) {
    console.error('Proxy error:', error.message);

    // Return error with CORS headers
    return {
      statusCode: error.response?.status || 500,
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "Content-Type, Authorization, Accept",
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        error: 'Proxy failed',
        details: error.message,
      })
    };
  }
};
