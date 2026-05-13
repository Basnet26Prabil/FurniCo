package com.furnico.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

import com.furnico.model.RequestModel;
import com.furnico.service.RequestService;

@WebServlet(asyncSupported = true, urlPatterns = { "/admin/orders" })
public class AdminRequestServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final RequestService requestService = new RequestService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            loadPageData(request);
            request.getRequestDispatcher("/WEB-INF/pages/AdminRequests.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("Unable to load customer requests", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        int requestId = parseInt(request.getParameter("requestId"));

        try {
            if (requestId > 0 && "approve".equals(action)) {
                requestService.approveRequest(requestId);
                response.sendRedirect(request.getContextPath() + "/admin/orders?success=approved&selectedId=" + requestId);
                return;
            }

            if (requestId > 0 && "reject".equals(action)) {
                requestService.rejectRequest(requestId);
                response.sendRedirect(request.getContextPath() + "/admin/orders?success=rejected&selectedId=" + requestId);
                return;
            }

            response.sendRedirect(request.getContextPath() + "/admin/orders");
        } catch (Exception e) {
            throw new ServletException("Unable to update request status", e);
        }
    }

    private void loadPageData(HttpServletRequest request) throws Exception {
        String keyword = trimToEmpty(request.getParameter("keyword"));
        String status = trimToEmpty(request.getParameter("status"));
        String dateRange = trimToEmpty(request.getParameter("dateRange"));
        int selectedId = parseInt(request.getParameter("selectedId"));

        List<RequestModel> requests = requestService.getFilteredRequests(keyword, status, dateRange);
        RequestModel selectedRequest = findSelectedRequest(requests, selectedId);

        request.setAttribute("requests", requests);
        request.setAttribute("selectedRequest", selectedRequest);
        request.setAttribute("keyword", keyword);
        request.setAttribute("status", status);
        request.setAttribute("dateRange", dateRange);
        request.setAttribute("pendingCount", requestService.getPendingCount());
        request.setAttribute("approvedTodayCount", requestService.getApprovedTodayCount());
        request.setAttribute("lowStockCount", requestService.getLowStockProductCount());
        request.setAttribute("mostRequestedCategory", requestService.getMostRequestedCategory());
    }

    private RequestModel findSelectedRequest(List<RequestModel> requests, int selectedId) {
        if (requests == null || requests.isEmpty()) {
            return null;
        }

        if (selectedId > 0) {
            for (RequestModel item : requests) {
                if (item.getRequestId() == selectedId) {
                    return item;
                }
            }
        }

        return requests.get(0);
    }

    private int parseInt(String value) {
        try {
            return value == null ? 0 : Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private String trimToEmpty(String value) {
        return value == null ? "" : value.trim();
    }
}
