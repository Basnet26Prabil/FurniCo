package com.furnico.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.furnico.model.CategoryModel;
import com.furnico.utils.DBconfig;

public class CategoryDAO {

    public List<CategoryModel> getAllCategories() throws Exception {
        List<CategoryModel> categories = new ArrayList<>();
        Connection con = DBconfig.getConnection();

        String sql = "SELECT c.*, COUNT(p.product_id) AS product_count "
                   + "FROM category c "
                   + "LEFT JOIN product p ON c.category_id = p.category_id "
                   + "GROUP BY c.category_id, c.category_name, c.description, c.image "
                   + "ORDER BY c.category_id";
        PreparedStatement pst = con.prepareStatement(sql);
        ResultSet rs = pst.executeQuery();

        while (rs.next()) {
            categories.add(mapCategory(rs));
        }

        rs.close();
        pst.close();
        con.close();
        return categories;
    }

    public CategoryModel getCategoryById(int categoryId) throws Exception {
        CategoryModel c = null;
        Connection con = DBconfig.getConnection();

        String sql = "SELECT * FROM category WHERE category_id = ?";
        PreparedStatement pst = con.prepareStatement(sql);
        pst.setInt(1, categoryId);
        ResultSet rs = pst.executeQuery();

        if (rs.next()) {
            c = mapCategory(rs);
        }

        rs.close();
        pst.close();
        con.close();
        return c;
    }

    public int countByCategory(int categoryId) throws Exception {
        int count = 0;
        Connection con = DBconfig.getConnection();

        String sql = "SELECT COUNT(*) FROM product WHERE category_id = ?";
        PreparedStatement pst = con.prepareStatement(sql);
        pst.setInt(1, categoryId);
        ResultSet rs = pst.executeQuery();

        if (rs.next()) {
            count = rs.getInt(1);
        }

        rs.close();
        pst.close();
        con.close();
        return count;
    }

    public List<CategoryModel> filterCategories(String keyword) throws Exception {
        List<CategoryModel> categories = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT c.*, COUNT(p.product_id) AS product_count ")
           .append("FROM category c ")
           .append("LEFT JOIN product p ON c.category_id = p.category_id ")
           .append("WHERE 1 = 1 ");

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (c.category_name LIKE ? OR c.description LIKE ?) ");
            String searchValue = "%" + keyword.trim() + "%";
            params.add(searchValue);
            params.add(searchValue);
        }

        sql.append("GROUP BY c.category_id, c.category_name, c.description, c.image ")
           .append("ORDER BY c.category_id");

        try (Connection con = DBconfig.getConnection();
             PreparedStatement pst = con.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                pst.setObject(i + 1, params.get(i));
            }

            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                categories.add(mapCategory(rs));
            }
        }

        return categories;
    }

    public void addCategory(CategoryModel category) throws Exception {
        String sql = "INSERT INTO category (category_name, description, image) VALUES (?, ?, ?)";

        try (Connection con = DBconfig.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {

            pst.setString(1, category.getCategoryName());
            pst.setString(2, category.getDescription());
            pst.setString(3, category.getImage());
            pst.executeUpdate();
        }
    }

    public void updateCategory(CategoryModel category) throws Exception {
        String sql = "UPDATE category SET category_name = ?, description = ?, image = ? WHERE category_id = ?";

        try (Connection con = DBconfig.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {

            pst.setString(1, category.getCategoryName());
            pst.setString(2, category.getDescription());
            pst.setString(3, category.getImage());
            pst.setInt(4, category.getCategoryId());
            pst.executeUpdate();
        }
    }

    public void deleteCategory(int categoryId) throws Exception {
        String sql = "DELETE FROM category WHERE category_id = ?";

        try (Connection con = DBconfig.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {

            pst.setInt(1, categoryId);
            pst.executeUpdate();
        }
    }

    private CategoryModel mapCategory(ResultSet rs) throws Exception {
        CategoryModel c = new CategoryModel();
        c.setCategoryId(rs.getInt("category_id"));
        c.setCategoryName(rs.getString("category_name"));
        c.setDescription(rs.getString("description"));
        c.setImage(rs.getString("image"));

        try {
            c.setProductCount(rs.getInt("product_count"));
        } catch (Exception e) {
            c.setProductCount(0);
        }

        return c;
    }
}
