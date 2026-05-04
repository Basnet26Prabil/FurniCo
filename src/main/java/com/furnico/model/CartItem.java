package com.furnico.model;

/**
 * CartItem represents a single product entry in the user's shopping cart.
 * The cart itself is stored in the HTTP session as a Map<Integer, CartItem>.
 */
public class CartItem {

    private ProductModel product;
    private int quantity;

    public CartItem() {}

    public CartItem(ProductModel product, int quantity) {
        this.product = product;
        this.quantity = quantity;
    }

    // ── Getters & Setters ──────────────────────────────────────────────────

    public ProductModel getProduct() {
        return product;
    }

    public void setProduct(ProductModel product) {
        this.product = product;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    /** Convenience helper used in JSP via EL: ${item.subtotal} */
    public double getSubtotal() {
        return product.getPrice() * quantity;
    }
}
