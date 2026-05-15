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

        String sql = "SELECT * FROM category ORDER BY category_id";
        PreparedStatement pst = con.prepareStatement(sql);
        ResultSet rs = pst.executeQuery();

        while (rs.next()) {
            CategoryModel c = new CategoryModel();
            c.setCategoryId(rs.getInt("category_id"));
            c.setCategoryName(rs.getString("category_name"));
            c.setDescription(rs.getString("description"));
            c.setImage(rs.getString("image"));
            categories.add(c);
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
            c = new CategoryModel();
            c.setCategoryId(rs.getInt("category_id"));
            c.setCategoryName(rs.getString("category_name"));
            c.setDescription(rs.getString("description"));
            c.setImage(rs.getString("image"));
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
}