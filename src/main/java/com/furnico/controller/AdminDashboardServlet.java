package com.furnico.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

import com.furnico.model.ProductModel;
import com.furnico.model.RequestModel;
import com.furnico.model.UserModel;
import com.furnico.service.ProductService;
import com.furnico.service.RequestService;
import com.furnico.service.UserService;

@WebServlet(asyncSupported = true, urlPatterns = { "/admin" })
public class AdminDashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final ProductService productService = new ProductService();
    private final RequestService requestService = new RequestService();
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<ProductModel> products = productService.fetchAll();
            List<RequestModel> latestRequests = requestService.getFilteredRequests("", "", "");
            List<UserModel> latestUsers = userService.getFilteredUsers("", "", "latest");

            request.setAttribute("productCount", products.size());
            request.setAttribute("pendingCount", requestService.getPendingCount());
            request.setAttribute("lowStockCount", requestService.getLowStockProductCount());
            request.setAttribute("totalUsers", userService.getTotalUsers());
            request.setAttribute("customerCount", userService.getCustomerCount());
            request.setAttribute("adminCount", userService.getAdminCount());
            request.setAttribute("latestRequests", latestRequests);
            request.setAttribute("latestUsers", latestUsers);

            request.getRequestDispatcher("/WEB-INF/pages/AdminDashboard.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("Unable to load admin dashboard", e);
        }
    }
}
