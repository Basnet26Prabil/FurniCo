package com.furnico.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.furnico.model.ProductModel;
import com.furnico.utils.DBconfig;

public class ProductDAO {

    public List<ProductModel> getAllProducts() throws Exception {
        List<ProductModel> products = new ArrayList<>();
        Connection con = DBconfig.getConnection();

        String sql = "SELECT p.*, c.category_name FROM product p "
                   + "JOIN category c ON p.category_id = c.category_id "
                   + "ORDER BY p.product_id";

        PreparedStatement pst = con.prepareStatement(sql);
        ResultSet rs = pst.executeQuery();

        while (rs.next()) {
            ProductModel p = new ProductModel();
            p.setProductId(rs.getInt("product_id"));
            p.setProductName(rs.getString("product_name"));
            p.setCategoryId(rs.getInt("category_id"));
            p.setCategoryName(rs.getString("category_name"));
            p.setPrice(rs.getDouble("price"));
            p.setDescription(rs.getString("description"));
            p.setImage(rs.getString("image"));
            p.setStock(rs.getInt("stock"));
            p.setRating(rs.getDouble("rating"));
            p.setRatingCount(rs.getInt("rating_count"));
            p.setBestSeller(rs.getInt("is_best_seller") == 1);
            products.add(p);
        }

        rs.close();
        pst.close();
        con.close();
        return products;
    }

    public List<ProductModel> getProductsByCategory(int categoryId) throws Exception {
        List<ProductModel> products = new ArrayList<>();
        Connection con = DBconfig.getConnection();

        String sql = "SELECT p.*, c.category_name FROM product p "
                   + "JOIN category c ON p.category_id = c.category_id "
                   + "WHERE p.category_id = ? "
                   + "ORDER BY p.product_id";

        PreparedStatement pst = con.prepareStatement(sql);
        pst.setInt(1, categoryId);
        ResultSet rs = pst.executeQuery();

        while (rs.next()) {
            ProductModel p = new ProductModel();
            p.setProductId(rs.getInt("product_id"));
            p.setProductName(rs.getString("product_name"));
            p.setCategoryId(rs.getInt("category_id"));
            p.setCategoryName(rs.getString("category_name"));
            p.setPrice(rs.getDouble("price"));
            p.setDescription(rs.getString("description"));
            p.setImage(rs.getString("image"));
            p.setStock(rs.getInt("stock"));
            p.setRating(rs.getDouble("rating"));
            p.setRatingCount(rs.getInt("rating_count"));
            p.setBestSeller(rs.getInt("is_best_seller") == 1);
            products.add(p);
        }

        rs.close();
        pst.close();
        con.close();
        return products;
    }

    public ProductModel getProductById(int productId) throws Exception {
        ProductModel p = null;
        Connection con = DBconfig.getConnection();

        String sql = "SELECT p.*, c.category_name FROM product p "
                   + "JOIN category c ON p.category_id = c.category_id "
                   + "WHERE p.product_id = ?";

        PreparedStatement pst = con.prepareStatement(sql);
        pst.setInt(1, productId);
        ResultSet rs = pst.executeQuery();

        if (rs.next()) {
            p = new ProductModel();
            p.setProductId(rs.getInt("product_id"));
            p.setProductName(rs.getString("product_name"));
            p.setCategoryId(rs.getInt("category_id"));
            p.setCategoryName(rs.getString("category_name"));
            p.setPrice(rs.getDouble("price"));
            p.setDescription(rs.getString("description"));
            p.setImage(rs.getString("image"));
            p.setStock(rs.getInt("stock"));
            p.setRating(rs.getDouble("rating"));
            p.setRatingCount(rs.getInt("rating_count"));
            p.setBestSeller(rs.getInt("is_best_seller") == 1);
        }

        rs.close();
        pst.close();
        con.close();
        return p;
    }

    public List<ProductModel> searchProducts(String keyword) throws Exception {
        List<ProductModel> products = new ArrayList<>();
        Connection con = DBconfig.getConnection();

        String sql = "SELECT p.*, c.category_name FROM product p "
                   + "JOIN category c ON p.category_id = c.category_id "
                   + "WHERE p.product_name LIKE ? "
                   + "ORDER BY p.product_id";

        PreparedStatement pst = con.prepareStatement(sql);
        pst.setString(1, "%" + keyword + "%");
        ResultSet rs = pst.executeQuery();

        while (rs.next()) {
            ProductModel p = new ProductModel();
            p.setProductId(rs.getInt("product_id"));
            p.setProductName(rs.getString("product_name"));
            p.setCategoryId(rs.getInt("category_id"));
            p.setCategoryName(rs.getString("category_name"));
            p.setPrice(rs.getDouble("price"));
            p.setDescription(rs.getString("description"));
            p.setImage(rs.getString("image"));
            p.setStock(rs.getInt("stock"));
            p.setRating(rs.getDouble("rating"));
            p.setRatingCount(rs.getInt("rating_count"));
            p.setBestSeller(rs.getInt("is_best_seller") == 1);
            products.add(p);
        }

        rs.close();
        pst.close();
        con.close();
        return products;
    }

    public List<ProductModel> filterProducts(String keyword, Integer categoryId, String stockStatus) throws Exception {
        List<ProductModel> products = new ArrayList<>();
        Connection con = DBconfig.getConnection();

        String sql = "SELECT p.*, c.category_name FROM product p "
                   + "JOIN category c ON p.category_id = c.category_id "
                   + "WHERE (? IS NULL OR p.product_name LIKE ?) "
                   + "AND (? IS NULL OR p.category_id = ?) "
                   + "AND (? IS NULL OR (? = 'in_stock' AND p.stock > 0) OR (? = 'out_of_stock' AND p.stock = 0)) "
                   + "ORDER BY p.product_id";

        PreparedStatement pst = con.prepareStatement(sql);

        String searchValue = keyword == null || keyword.trim().isEmpty() ? null : "%" + keyword.trim() + "%";
        pst.setString(1, searchValue);
        pst.setString(2, searchValue);

        if (categoryId == null || categoryId <= 0) {
            pst.setObject(3, null);
            pst.setObject(4, null);
        } else {
            pst.setInt(3, categoryId);
            pst.setInt(4, categoryId);
        }

        String stockValue = stockStatus == null || stockStatus.trim().isEmpty() ? null : stockStatus.trim();
        pst.setString(5, stockValue);
        pst.setString(6, stockValue);
        pst.setString(7, stockValue);

        ResultSet rs = pst.executeQuery();

        while (rs.next()) {
            ProductModel p = new ProductModel();
            p.setProductId(rs.getInt("product_id"));
            p.setProductName(rs.getString("product_name"));
            p.setCategoryId(rs.getInt("category_id"));
            p.setCategoryName(rs.getString("category_name"));
            p.setPrice(rs.getDouble("price"));
            p.setDescription(rs.getString("description"));
            p.setImage(rs.getString("image"));
            p.setStock(rs.getInt("stock"));
            p.setRating(rs.getDouble("rating"));
            p.setRatingCount(rs.getInt("rating_count"));
            p.setBestSeller(rs.getInt("is_best_seller") == 1);
            products.add(p);
        }

        rs.close();
        pst.close();
        con.close();
        return products;
    }

    public void addProduct(ProductModel product) throws Exception {
        Connection con = DBconfig.getConnection();

        String sql = "INSERT INTO product (product_name, category_id, price, description, image, stock) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";

        PreparedStatement pst = con.prepareStatement(sql);
        pst.setString(1, product.getProductName());
        pst.setInt(2, product.getCategoryId());
        pst.setDouble(3, product.getPrice());
        pst.setString(4, product.getDescription());
        pst.setString(5, product.getImage());
        pst.setInt(6, product.getStock());

        pst.executeUpdate();

        pst.close();
        con.close();
    }

    public void updateProduct(ProductModel product) throws Exception {
        Connection con = DBconfig.getConnection();

        String sql = "UPDATE product SET product_name = ?, category_id = ?, price = ?, description = ?, "
                   + "image = ?, stock = ? "
                   + "WHERE product_id = ?";

        PreparedStatement pst = con.prepareStatement(sql);
        pst.setString(1, product.getProductName());
        pst.setInt(2, product.getCategoryId());
        pst.setDouble(3, product.getPrice());
        pst.setString(4, product.getDescription());
        pst.setString(5, product.getImage());
        pst.setInt(6, product.getStock());
        pst.setInt(7, product.getProductId());

        pst.executeUpdate();

        pst.close();
        con.close();
    }

    public void deleteProduct(int productId) throws Exception {
        Connection con = DBconfig.getConnection();

        String sql = "DELETE FROM product WHERE product_id = ?";
        PreparedStatement pst = con.prepareStatement(sql);
        pst.setInt(1, productId);
        pst.executeUpdate();

        pst.close();
        con.close();
    }
}
