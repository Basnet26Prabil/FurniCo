package com.furnico.controller;

import jakarta.servlet.ServletException;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

import com.furnico.model.RequestModel;
import com.furnico.model.UserModel;
import com.furnico.service.RequestService;
import com.furnico.utils.SessionUtil;
import com.furnico.utils.FurnicoException; 

/**
 * RequestServlet handles product Apply / Request functionality.
 *
 * URL mappings:
 *   GET  /requests               → user views their requests
 *   POST /requests?action=submit → user submits a new request
 *   POST /requests?action=cancel → user cancels a pending request
 */
@WebServlet(asyncSupported = true, urlPatterns = { "/requests" })
public class RequestServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final RequestService requestService = new RequestService();

    // ── GET: Display user's requests ──────────────────────────────────────

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserModel user = (UserModel) SessionUtil.getAttribute(request, "user");

        // Must be logged in
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            List<RequestModel> requests = requestService.getUserRequests(user.getUserId());
            request.setAttribute("requests", requests);
            request.getRequestDispatcher("/WEB-INF/pages/MyRequests.jsp")
                   .forward(request, response);
        } catch (FurnicoException e) {   // CHANGED
            request.setAttribute("errorMessage", e.getMessage());
            request.setAttribute("statusCode", e.getStatusCode());
            request.getRequestDispatcher("/WEB-INF/pages/views/erro.jsp").forward(request, response);   // CHANGED
        }
    }

    // ── POST: Submit or Cancel request ────────────────────────────────────

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserModel user = (UserModel) SessionUtil.getAttribute(request, "user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        try {
            if ("submit".equals(action)) {
                handleSubmit(request, response, user);
            } else if ("cancel".equals(action)) {
                handleCancel(request, response, user);
            } else {
                response.sendRedirect(request.getContextPath() + "/requests");
            }
        } catch (FurnicoException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.setAttribute("statusCode", e.getStatusCode());
            request.getRequestDispatcher("/WEB-INF/pages/views/error.jsp").forward(request, response);
        }
    }

    // ── Private action handlers ───────────────────────────────────────────

    private void handleSubmit(HttpServletRequest request, HttpServletResponse response,
            UserModel user) throws FurnicoException, ServletException, IOException {   // CHANGED

        String productIdParam = request.getParameter("productId");
        String qtyParam       = request.getParameter("quantity");
        String note           = request.getParameter("note");

        // Validation
        if (productIdParam == null || productIdParam.trim().isEmpty()) {
            request.setAttribute("requestError", "Invalid product.");
            doGet(request, response);
            return;
        }

        int productId;
        int quantity;
        try {
            productId = Integer.parseInt(productIdParam.trim());
            quantity  = Integer.parseInt(qtyParam.trim());
            if (quantity < 1) throw new NumberFormatException("qty < 1");
        } catch (NumberFormatException e) {
            request.setAttribute("requestError", "Please enter a valid quantity (minimum 1).");
            doGet(request, response);
            return;
        }

        boolean success = requestService.submitRequest(user.getUserId(), productId, quantity, note);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/requests?success=submitted");
        } else {
            request.setAttribute("requestError", "Failed to submit request. Please try again.");
            doGet(request, response);
        }
    }

    private void handleCancel(HttpServletRequest request, HttpServletResponse response,
                               UserModel user) throws FurnicoException, IOException {

        String requestIdParam = request.getParameter("requestId");
        if (requestIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/requests");
            return;
        }

        try {
            int requestId = Integer.parseInt(requestIdParam.trim());
            requestService.cancelRequest(requestId, user.getUserId());
        } catch (NumberFormatException e) {
            // ignore bad param
        }

        response.sendRedirect(request.getContextPath() + "/requests?success=cancelled");
    }
}