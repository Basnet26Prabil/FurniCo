package com.furnico.model;

public class ProductModel {

    private int productId;
    private String productName;
    private int categoryId;
    private String categoryName;
    private double price;
    private String description;
    private String image;
    private int stock;
    private double rating;
    private int ratingCount;
    private boolean bestSeller;

    public int getProductId() {
        return productId;
    }
    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }
    public void setProductName(String productName) {
        this.productName = productName;
    }

    public int getCategoryId() {
        return categoryId;
    }
    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }
    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public double getPrice() {
        return price;
    }
    public void setPrice(double price) {
        this.price = price;
    }

    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }

    public String getImage() {
        return image;
    }
    public void setImage(String image) {
        this.image = image;
    }

    public int getStock() {
        return stock;
    }
    public void setStock(int stock) {
        this.stock = stock;
    }

    public double getRating() {
        return rating;
    }
    public void setRating(double rating) {
        this.rating = rating;
    }

    public int getRatingCount() {
        return ratingCount;
    }
    public void setRatingCount(int ratingCount) {
        this.ratingCount = ratingCount;
    }

    public boolean isBestSeller() {
        return bestSeller;
    }
    public void setBestSeller(boolean bestSeller) {
        this.bestSeller = bestSeller;
    }
}