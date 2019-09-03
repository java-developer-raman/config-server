package com.sharma.config.server.filter;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.annotation.Order;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Component;
import org.springframework.vault.authentication.SessionManager;
import org.springframework.vault.core.VaultOperations;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

@Component
@Order(2)
public class AppendVaultXConfigHeaderFilter implements Filter {

    @Autowired
    private SessionManager sessionManager;

    @Autowired
    private VaultOperations vaultOperations;

    @Autowired
    private Environment environment;

    @Override
    public void init(FilterConfig filterConfig) {

    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        MutableHttpServletRequest mutableRequest = new MutableHttpServletRequest(httpRequest);
        mutableRequest.addHeader("X-Config-Token", sessionManager.getSessionToken().getToken());
        chain.doFilter(mutableRequest, response);
    }

    @Override
    public void destroy() {

    }
}
