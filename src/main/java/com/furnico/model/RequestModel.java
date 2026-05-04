package com.furnico.model;

import java.sql.Timestamp;

/**
 * RequestModel represents a product request/order placed by a logged-in user.
 * Stored in the `requests` database table.
 */
public class RequestModel {

    private int requestId;
    private int userId;
    private int productId;
    private String productName;   // joined from product table (read-only)
    private String productImage;  // joined from product table (read-only)
    private double productPrice;  // joined from product table (read-only)
    private int quantity;
    private String status;        // 'pending' | 'approved' | 'rejected'
    private String note;
    private Timestamp requestedAt;

    // ── Getters & Setters ──────────────────────────────────────────────────

    public int getRequestId() { return requestId; }
    public void setRequestId(int requestId) { this.requestId = requestId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getProductImage() { return productImage; }
    public void setProductImage(String productImage) { this.productImage = productImage; }

    public double getProductPrice() { return productPrice; }
    public void setProductPrice(double productPrice) { this.productPrice = productPrice; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public Timestamp getRequestedAt() { return requestedAt; }
    public void setRequestedAt(Timestamp requestedAt) { this.requestedAt = requestedAt; }
}
