import { util } from '@aws-appsync/utils';

/**
 * Sends a GET request to retrieve a user's inforrmation
 * @param {import('@aws-appsync/utils').Context} ctx the context
 * @returns the request
 */
export function request(ctx) {
    return fetch(`/api/forecast/city/${ctx.args.id}`, {
        headers: {
            'Content-Type': 'application/json',
		},
		query: {},
		body: JSON.stringify({})
    });
}

/**
 * Process the HTTP response
 * @param {import('@aws-appsync/utils').Context} ctx the context
 * @returns {*} the publish response
 */
export function response(ctx) {
    var { statusCode, body } = ctx.result;
    // if response is 200, return the response
	if (statusCode === 200) {
		body=JSON.parse(body)
		body.id = ctx.args.id
        return body;
    }
    // if response is not 200, append the response to error block.
    util.appendError(body, statusCode);
}

/**
 * Sends an HTTP request
 * @param {string} resourcePath path of the request
 * @param {Object} [options] values to publish
 * @param {'PUT' | 'POST' | 'GET' | 'DELETE' | 'PATCH'} [options.method] the request method
 * @param {Object.<string, string>} [options.headers] the request headers
 * @param {unknown} [options.body] the request body
 * @param {Object.<string, string>} [options.query] Key-value pairs that specify the query string
 * @returns {import('@aws-appsync/utils').HTTPRequest} the request
 */
function fetch(resourcePath, options) {
    const { method = 'GET', headers, body, query } = options;
    const params = { headers, query };
    if (method !== 'GET') {
        params.body = body;
    }
    return { resourcePath, method, params };
}