package com.furnico.utils;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;

@WebFilter("/*")
public class LastVisitFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // optional
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletResponse res = (HttpServletResponse) response;

        String currentTime = LocalDateTime.now()
                .format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

        Cookie cookie = new Cookie("lastVisit",
                URLEncoder.encode(currentTime, StandardCharsets.UTF_8));

        cookie.setMaxAge(60 * 60 * 24 * 7); // 7 days
        res.addCookie(cookie);

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // optional
    }
}

