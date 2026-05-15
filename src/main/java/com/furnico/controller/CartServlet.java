package com.furnico.controller;

import jakarta.servlet.ServletException;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

import com.furnico.model.CartItem;
import com.furnico.model.ProductModel;
import com.furnico.service.ProductService;
import com.furnico.utils.FurnicoException; 

/**
 * CartServlet manages the session-based shopping cart.
 *
 * URL mappings:
 *   GET  /cart                   → view cart page
 *   POST /cart?action=add        → add / increment item (requires productId, qty)
 *   POST /cart?action=remove     → remove a single item (requires productId)
 *   POST /cart?action=update     → update quantity (requires productId, qty)
 *   POST /cart?action=clear      → empty the cart
 *
 * The cart is stored in session as Map<Integer, CartItem> under key "cart".
 */
@WebServlet(asyncSupported = true, urlPatterns = { "/cart" })
public class CartServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String SESSION_KEY = "cart";

    private final ProductService productService = new ProductService();

    // ── GET: Display cart ─────────────────────────────────────────────────

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Map<Integer, CartItem> cart = getCart(request);

        double grandTotal = 0;
        for (CartItem item : cart.values()) {
            grandTotal += item.getSubtotal();
        }

        request.setAttribute("cart", cart);
        request.setAttribute("cartTotal", grandTotal);
        request.setAttribute("cartCount", cart.size());

        request.getRequestDispatcher("/WEB-INF/pages/Cart.jsp")
               .forward(request, response);
    }

    // ── POST: Mutate cart ─────────────────────────────────────────────────

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action    = request.getParameter("action");
        String idParam   = request.getParameter("productId");
        String qtyParam  = request.getParameter("qty");
        String redirectTo = request.getParameter("redirectTo");

        Map<Integer, CartItem> cart = getCart(request);

        try {
            if ("add".equals(action) && idParam != null) {
                int productId = Integer.parseInt(idParam.trim());
                int qty = parseQty(qtyParam, 1);

                if (cart.containsKey(productId)) {
                    // Increment existing quantity
                    CartItem existing = cart.get(productId);
                    existing.setQuantity(existing.getQuantity() + qty);
                } else {
                    // Fetch product from DB and create new CartItem
                    ProductModel product = productService.fetchById(productId);
                    if (product != null && product.getStock() > 0) {
                        cart.put(productId, new CartItem(product, qty));
                    }
                }

            } else if ("remove".equals(action) && idParam != null) {
                int productId = Integer.parseInt(idParam.trim());
                cart.remove(productId);

            } else if ("update".equals(action) && idParam != null && qtyParam != null) {
                int productId = Integer.parseInt(idParam.trim());
                int qty = parseQty(qtyParam, 1);
                if (cart.containsKey(productId)) {
                    if (qty <= 0) {
                        cart.remove(productId);
                    } else {
                        cart.get(productId).setQuantity(qty);
                    }
                }

            } else if ("clear".equals(action)) {
                cart.clear();
            }
        }catch (NumberFormatException e) {
                // Invalid number parameter — do nothing, redirect back
            } catch (IllegalArgumentException e) {
                // Invalid argument — do nothing, redirect back
            } catch (FurnicoException e) {                                   // ← CHANGED THIS LINE
                request.setAttribute("errorMessage", e.getMessage());
                request.setAttribute("statusCode", e.getStatusCode());
                request.getRequestDispatcher("/WEB-INF/pages/error.jsp")
                       .forward(request, response);
                return;
            }

            saveCart(request, cart);

            if (redirectTo != null && !redirectTo.isEmpty()) {
                response.sendRedirect(request.getContextPath() + redirectTo);
            } else {
                response.sendRedirect(request.getContextPath() + "/cart");
            }
        }

    // ── Helpers ───────────────────────────────────────────────────────────

    @SuppressWarnings("unchecked")
    private Map<Integer, CartItem> getCart(HttpServletRequest request) {
        HttpSession session = request.getSession(true);
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute(SESSION_KEY);
        if (cart == null) {
            cart = new LinkedHashMap<>();
            session.setAttribute(SESSION_KEY, cart);
        }
        return cart;
    }

    private void saveCart(HttpServletRequest request, Map<Integer, CartItem> cart) {
        request.getSession(true).setAttribute(SESSION_KEY, cart);
    }

    private int parseQty(String qtyParam, int defaultVal) {
        if (qtyParam == null || qtyParam.trim().isEmpty()) return defaultVal;
        try {
            int qty = Integer.parseInt(qtyParam.trim());
            return qty < 1 ? 1 : qty;
        } catch (NumberFormatException e) {
            return defaultVal;
        }
    }
}