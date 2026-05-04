package com.furnico.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.furnico.model.RequestModel;
import com.furnico.utils.DBconfig;

/**
 * RequestDAO handles all database operations for the `requests` table.
 */
public class RequestDAO {

    /**
     * Inserts a new product request into the database.
     *
     * @param req the RequestModel to persist
     * @return true if the insert succeeded, false otherwise
     */
    public boolean insertRequest(RequestModel req) throws Exception {
        String sql = "INSERT INTO requests (user_id, product_id, quantity, note, status) "
                   + "VALUES (?, ?, ?, ?, 'pending')";

        try (Connection con = DBconfig.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {

            pst.setInt(1, req.getUserId());
            pst.setInt(2, req.getProductId());
            pst.setInt(3, req.getQuantity());
            pst.setString(4, req.getNote());

            return pst.executeUpdate() > 0;
        }
    }

    /**
     * Retrieves all requests placed by a specific user, with product details joined in.
     *
     * @param userId the ID of the logged-in user
     * @return list of RequestModel objects ordered newest first
     */
    public List<RequestModel> getRequestsByUser(int userId) throws Exception {
        List<RequestModel> list = new ArrayList<>();

        String sql = "SELECT r.*, p.product_name, p.image, p.price "
                   + "FROM requests r "
                   + "JOIN product p ON r.product_id = p.product_id "
                   + "WHERE r.user_id = ? "
                   + "ORDER BY r.requested_at DESC";

        try (Connection con = DBconfig.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {

            pst.setInt(1, userId);
            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                RequestModel req = mapRow(rs);
                list.add(req);
            }
        }

        return list;
    }

    /**
     * Retrieves all requests — used by admin dashboard.
     *
     * @return list of all RequestModel objects ordered newest first
     */
    public List<RequestModel> getAllRequests() throws Exception {
        List<RequestModel> list = new ArrayList<>();

        String sql = "SELECT r.*, p.product_name, p.image, p.price "
                   + "FROM requests r "
                   + "JOIN product p ON r.product_id = p.product_id "
                   + "ORDER BY r.requested_at DESC";

        try (Connection con = DBconfig.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {

            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }

        return list;
    }

    /**
     * Updates the status of a request (admin action: approve / reject).
     *
     * @param requestId the ID of the request
     * @param status    'approved' or 'rejected'
     * @return true on success
     */
    public boolean updateStatus(int requestId, String status) throws Exception {
        String sql = "UPDATE requests SET status = ? WHERE request_id = ?";

        try (Connection con = DBconfig.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {

            pst.setString(1, status);
            pst.setInt(2, requestId);
            return pst.executeUpdate() > 0;
        }
    }

    /**
     * Deletes a pending request — allows user to cancel before admin acts on it.
     *
     * @param requestId the ID of the request
     * @param userId    the owner's ID (safety check — only owner can delete)
     * @return true on success
     */
    public boolean deleteRequest(int requestId, int userId) throws Exception {
        String sql = "DELETE FROM requests WHERE request_id = ? AND user_id = ? AND status = 'pending'";

        try (Connection con = DBconfig.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {

            pst.setInt(1, requestId);
            pst.setInt(2, userId);
            return pst.executeUpdate() > 0;
        }
    }

    // ── Private helpers ───────────────────────────────────────────────────

    private RequestModel mapRow(ResultSet rs) throws Exception {
        RequestModel req = new RequestModel();
        req.setRequestId(rs.getInt("request_id"));
        req.setUserId(rs.getInt("user_id"));
        req.setProductId(rs.getInt("product_id"));
        req.setProductName(rs.getString("product_name"));
        req.setProductImage(rs.getString("image"));
        req.setProductPrice(rs.getDouble("price"));
        req.setQuantity(rs.getInt("quantity"));
        req.setStatus(rs.getString("status"));
        req.setNote(rs.getString("note"));
        req.setRequestedAt(rs.getTimestamp("requested_at"));
        return req;
    }
}
