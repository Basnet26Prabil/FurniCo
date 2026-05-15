package com.furnico.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.LinkedHashSet;
import java.util.Set;
import java.util.List;
import java.util.ArrayList;

import com.furnico.model.ProductModel;
import com.furnico.service.ProductService;
import com.furnico.utils.FurnicoException;

@WebServlet(asyncSupported = true, urlPatterns = { "/wishlist" })
public class WishlistServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String SESSION_KEY = "wishlistIds";

    private final ProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Set<Integer> ids = getWishlistIds(request);

        List<ProductModel> wishlistProducts = new ArrayList<>();

        try {
            for (int id : ids) {
                ProductModel p = productService.fetchById(id);
                if (p != null) {
                    wishlistProducts.add(p);
                }
            }

        } catch (FurnicoException e) {

            request.setAttribute("errorMessage", e.getMessage());
            request.setAttribute("statusCode", e.getStatusCode());

            request.getRequestDispatcher("/WEB-INF/pages/views/error.jsp")
                    .forward(request, response);
            return; // FIXED: stop further execution
        }

        request.setAttribute("wishlistProducts", wishlistProducts);
        request.setAttribute("wishlistCount", ids.size());

        request.getRequestDispatcher("/WEB-INF/pages/Wishlist.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String idParam = request.getParameter("productId");
        String redirectTo = request.getParameter("redirectTo");

        Set<Integer> ids = getWishlistIds(request);

        if ("add".equals(action) && idParam != null) {
            try {
                int productId = Integer.parseInt(idParam.trim());
                ids.add(productId);
                saveWishlistIds(request, ids);

            } catch (NumberFormatException ignored) {
                // invalid id ignored safely
            }

        } else if ("remove".equals(action) && idParam != null) {
            try {
                int productId = Integer.parseInt(idParam.trim());
                ids.remove(productId);
                saveWishlistIds(request, ids);

            } catch (NumberFormatException ignored) {
                // invalid id ignored safely
            }

        } else if ("clear".equals(action)) {
            ids.clear();
            saveWishlistIds(request, ids);
        }

        if (redirectTo != null && !redirectTo.isEmpty()) {
            response.sendRedirect(request.getContextPath() + redirectTo);
        } else {
            response.sendRedirect(request.getContextPath() + "/wishlist");
        }
    }

    @SuppressWarnings("unchecked")
    private Set<Integer> getWishlistIds(HttpServletRequest request) {
        HttpSession session = request.getSession(true);

        Set<Integer> ids = (Set<Integer>) session.getAttribute(SESSION_KEY);

        if (ids == null) {
            ids = new LinkedHashSet<>();
            session.setAttribute(SESSION_KEY, ids);
        }

        return ids;
    }

    private void saveWishlistIds(HttpServletRequest request, Set<Integer> ids) {
        request.getSession(true).setAttribute(SESSION_KEY, ids);
    }
}