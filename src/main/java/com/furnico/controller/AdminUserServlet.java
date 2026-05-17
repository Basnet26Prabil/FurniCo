package com.furnico.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

import com.furnico.model.UserModel;
import com.furnico.service.UserService;

@WebServlet(asyncSupported = true, urlPatterns = { "/admin/users" })
public class AdminUserServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String keyword = trimToEmpty(request.getParameter("keyword"));
            String role = trimToEmpty(request.getParameter("role"));
            String sortBy = trimToEmpty(request.getParameter("sortBy"));

            List<UserModel> users = userService.getFilteredUsers(keyword, role, sortBy);

            request.setAttribute("users", users);
            request.setAttribute("keyword", keyword);
            request.setAttribute("role", role);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("totalUsers", userService.getTotalUsers());
            request.setAttribute("customerCount", userService.getCustomerCount());
            request.setAttribute("adminCount", userService.getAdminCount());
            request.setAttribute("newUsersThisWeek", userService.getNewUsersThisWeek());

            request.getRequestDispatcher("/WEB-INF/pages/AdminUsers.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("Unable to load users", e);
        }
    }

    private String trimToEmpty(String value) {
        return value == null ? "" : value.trim();
    }
}
