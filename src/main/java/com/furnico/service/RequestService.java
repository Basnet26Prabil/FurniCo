package com.furnico.service;

import java.util.List;

import com.furnico.dao.RequestDAO;
import com.furnico.model.RequestModel;

/**
 * RequestService encapsulates business logic for the Apply / Request feature.
 * The Controller delegates to this class; this class delegates to RequestDAO.
 */
public class RequestService {

    private final RequestDAO requestDAO = new RequestDAO();

    /**
     * Submits a new product request after validating quantity.
     *
     * @param userId    the logged-in user's ID
     * @param productId the product being requested
     * @param quantity  number of units requested (must be >= 1)
     * @param note      optional message from the user
     * @return true if saved successfully
     * @throws IllegalArgumentException for invalid input
     */
    public boolean submitRequest(int userId, int productId, int quantity, String note) throws Exception {
        if (quantity < 1) {
            throw new IllegalArgumentException("Quantity must be at least 1.");
        }

        RequestModel req = new RequestModel();
        req.setUserId(userId);
        req.setProductId(productId);
        req.setQuantity(quantity);
        req.setNote(note != null ? note.trim() : "");

        return requestDAO.insertRequest(req);
    }

    /**
     * Retrieves all requests for a given user (for My Requests portal page).
     */
    public List<RequestModel> getUserRequests(int userId) throws Exception {
        return requestDAO.getRequestsByUser(userId);
    }

    /**
     * Retrieves all requests — for the admin dashboard.
     */
    public List<RequestModel> getAllRequests() throws Exception {
        return requestDAO.getAllRequests();
    }

    /**
     * Admin approves a request.
     */
    public boolean approveRequest(int requestId) throws Exception {
        return requestDAO.updateStatus(requestId, "approved");
    }

    /**
     * Admin rejects a request.
     */
    public boolean rejectRequest(int requestId) throws Exception {
        return requestDAO.updateStatus(requestId, "rejected");
    }

    /**
     * User cancels their own pending request.
     */
    public boolean cancelRequest(int requestId, int userId) throws Exception {
        return requestDAO.deleteRequest(requestId, userId);
    }
}
