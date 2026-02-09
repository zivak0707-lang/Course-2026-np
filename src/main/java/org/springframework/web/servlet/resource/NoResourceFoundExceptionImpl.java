package org.springframework.web.servlet.resource;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;

public class NoResourceFoundExceptionImpl extends NoResourceFoundException {
    /**
     * Create an instance.
     *
     * @param httpMethod
     * @param requestUri
     * @param resourcePath
     */
    public NoResourceFoundExceptionImpl(HttpMethod httpMethod, String requestUri, String resourcePath) {
        super(httpMethod, requestUri, resourcePath);
    }

    @Override
    public HttpHeaders getHeaders() {
        return super.getHeaders();
    }
}
