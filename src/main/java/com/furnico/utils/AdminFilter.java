package com.furnico.utils;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class AdminFilter implements Filter {

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("role") : null;

        if ("admin".equalsIgnoreCase(role)) {
            // Is admin — let through
            chain.doFilter(request, response);

        } else if (session == null || session.getAttribute("user") == null) {
            // Not logged in — send to login
            res.sendRedirect(req.getContextPath() + "/login");

        } else {
            // Logged in but not admin — show 403 error
            req.setAttribute("errorCode", 403);
            req.setAttribute("errorTitle", "Access Denied");
            req.setAttribute("errorMessage", "You do not have permission to access the admin panel.");
            res.setStatus(403);
            req.getRequestDispatcher("/WEB-INF/pages/views/error.jsp").forward(req, res);
        }
    }

    public void init(FilterConfig config) {}
    public void destroy() {}
}