package com.furnico.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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

        String sql = "SELECT r.*, p.product_name, p.image, p.price, "
                   + "CONCAT(u.first_name, ' ', u.last_name) AS customer_name, u.email AS customer_email "
                   + "FROM requests r "
                   + "JOIN product p ON r.product_id = p.product_id "
                   + "JOIN user u ON r.user_id = u.user_id "
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

        String sql = "SELECT r.*, p.product_name, p.image, p.price, "
                   + "CONCAT(u.first_name, ' ', u.last_name) AS customer_name, u.email AS customer_email "
                   + "FROM requests r "
                   + "JOIN product p ON r.product_id = p.product_id "
                   + "JOIN user u ON r.user_id = u.user_id "
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
     * Retrieves admin requests with optional search, status, and date filters.
     */
    public List<RequestModel> getFilteredRequests(String keyword, String status, String dateRange) throws Exception {
        List<RequestModel> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT r.*, p.product_name, p.image, p.price, ")
           .append("CONCAT(u.first_name, ' ', u.last_name) AS customer_name, u.email AS customer_email ")
           .append("FROM requests r ")
           .append("JOIN product p ON r.product_id = p.product_id ")
           .append("JOIN user u ON r.user_id = u.user_id ")
           .append("WHERE 1 = 1 ");

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (p.product_name LIKE ? OR u.first_name LIKE ? OR u.last_name LIKE ? OR u.email LIKE ?) ");
            String searchValue = "%" + keyword.trim() + "%";
            params.add(searchValue);
            params.add(searchValue);
            params.add(searchValue);
            params.add(searchValue);
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND r.status = ? ");
            params.add(status.trim());
        }

        if ("today".equals(dateRange)) {
            sql.append("AND DATE(r.requested_at) = CURRENT_DATE ");
        } else if ("week".equals(dateRange)) {
            sql.append("AND r.requested_at >= DATE_SUB(NOW(), INTERVAL 7 DAY) ");
        } else if ("month".equals(dateRange)) {
            sql.append("AND r.requested_at >= DATE_SUB(NOW(), INTERVAL 30 DAY) ");
        }

        sql.append("ORDER BY r.requested_at DESC");

        try (Connection con = DBconfig.getConnection();
             PreparedStatement pst = con.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                pst.setObject(i + 1, params.get(i));
            }

            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }

        return list;
    }

    public int countByStatus(String status) throws Exception {
        String sql = "SELECT COUNT(*) FROM requests WHERE status = ?";

        try (Connection con = DBconfig.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {

            pst.setString(1, status);
            ResultSet rs = pst.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public int countApprovedToday() throws Exception {
        String sql = "SELECT COUNT(*) FROM requests WHERE status = 'approved' AND DATE(requested_at) = CURRENT_DATE";

        try (Connection con = DBconfig.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {

            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public int countLowStockProducts() throws Exception {
        String sql = "SELECT COUNT(*) FROM product WHERE stock <= 3";

        try (Connection con = DBconfig.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {

            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public String getMostRequestedCategory() throws Exception {
        String sql = "SELECT c.category_name, COUNT(*) AS total_requests "
                   + "FROM requests r "
                   + "JOIN product p ON r.product_id = p.product_id "
                   + "JOIN category c ON p.category_id = c.category_id "
                   + "GROUP BY c.category_id, c.category_name "
                   + "ORDER BY total_requests DESC, c.category_name ASC "
                   + "LIMIT 1";

        try (Connection con = DBconfig.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {

            return rs.next() ? rs.getString("category_name") : "N/A";
        }
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
        req.setCustomerName(readOptionalString(rs, "customer_name"));
        req.setCustomerEmail(readOptionalString(rs, "customer_email"));
        req.setProductName(rs.getString("product_name"));
        req.setProductImage(rs.getString("image"));
        req.setProductPrice(rs.getDouble("price"));
        req.setQuantity(rs.getInt("quantity"));
        req.setStatus(rs.getString("status"));
        req.setNote(rs.getString("note"));
        req.setRequestedAt(rs.getTimestamp("requested_at"));
        return req;
    }

    private String readOptionalString(ResultSet rs, String columnName) throws SQLException {
        try {
            return rs.getString(columnName);
        } catch (SQLException e) {
            return "";
        }
    }
}
