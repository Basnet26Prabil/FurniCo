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

/**
 * WishlistServlet manages the session-based wishlist for the user portal.
 *
 * URL mappings:
 *   GET  /wishlist              → view wishlist page
 *   POST /wishlist?action=add   → add a product to wishlist
 *   POST /wishlist?action=remove → remove a product from wishlist
 *   POST /wishlist?action=clear  → clear entire wishlist
 *
 * The wishlist is stored in the session as a Set<Integer> of product IDs
 * under the key "wishlistIds". Full ProductModel objects are fetched from DB
 * only when rendering the page.
 */
@WebServlet(asyncSupported = true, urlPatterns = { "/wishlist" })
public class WishlistServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String SESSION_KEY = "wishlistIds";

    private final ProductService productService = new ProductService();

    // ── GET: Display wishlist ─────────────────────────────────────────────

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
        } catch (Exception e) {
            throw new ServletException("Error loading wishlist products", e);
        }

        request.setAttribute("wishlistProducts", wishlistProducts);
        request.setAttribute("wishlistCount", ids.size());

        request.getRequestDispatcher("/WEB-INF/pages/Wishlist.jsp")
               .forward(request, response);
    }

    // ── POST: Mutate wishlist ─────────────────────────────────────────────

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action    = request.getParameter("action");
        String idParam   = request.getParameter("productId");
        String redirectTo = request.getParameter("redirectTo"); // optional back-URL

        Set<Integer> ids = getWishlistIds(request);

        if ("add".equals(action) && idParam != null) {
            try {
                int productId = Integer.parseInt(idParam.trim());
                ids.add(productId);
                saveWishlistIds(request, ids);
            } catch (NumberFormatException ignored) {
                // bad param — ignore silently
            }

        } else if ("remove".equals(action) && idParam != null) {
            try {
                int productId = Integer.parseInt(idParam.trim());
                ids.remove(productId);
                saveWishlistIds(request, ids);
            } catch (NumberFormatException ignored) {}

        } else if ("clear".equals(action)) {
            ids.clear();
            saveWishlistIds(request, ids);
        }

        // Redirect back — either to the referring page or to wishlist page
        if (redirectTo != null && !redirectTo.isEmpty()) {
            response.sendRedirect(request.getContextPath() + redirectTo);
        } else {
            response.sendRedirect(request.getContextPath() + "/wishlist");
        }
    }

    // ── Helpers ───────────────────────────────────────────────────────────

    /**
     * Returns the existing wishlist ID set from the session,
     * or creates and stores a new empty set if none exists.
     */
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