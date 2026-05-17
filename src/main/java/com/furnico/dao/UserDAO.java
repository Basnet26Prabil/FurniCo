package com.furnico.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.furnico.model.UserModel;
import com.furnico.utils.DBconfig;

public class UserDAO {

    public void insertUser(String firstName, String lastName, String email, String phone,
                           String dob, String hashedPassword) throws Exception {

        Connection con = DBconfig.getConnection();

        String sql = "INSERT INTO user (first_name, last_name, email, phone, dob, password) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";

        PreparedStatement pst = con.prepareStatement(sql);
        pst.setString(1, firstName);
        pst.setString(2, lastName);
        pst.setString(3, email);
        pst.setString(4, phone);
        pst.setString(5, dob);
        pst.setString(6, hashedPassword);

        pst.executeUpdate();

        pst.close();
        con.close();
    }

    public UserModel findByEmail(String email) throws Exception {
        UserModel user = null;
        Connection con = DBconfig.getConnection();

        String sql = "SELECT * FROM user WHERE email = ?";
        PreparedStatement pst = con.prepareStatement(sql);
        pst.setString(1, email);
        ResultSet rs = pst.executeQuery();

        if (rs.next()) {
            user = new UserModel();
            user.setUserId(rs.getInt("user_id"));
            user.setFirstName(rs.getString("first_name"));
            user.setLastName(rs.getString("last_name"));
            user.setEmail(rs.getString("email"));
            user.setPhone(rs.getString("phone"));
            user.setDob(rs.getDate("dob"));
            user.setPassword(rs.getString("password"));
            user.setRole(rs.getString("role"));
            user.setCreatedAt(rs.getTimestamp("created_at"));
        }

        rs.close();
        pst.close();
        con.close();
        return user;
    }

    public boolean emailExists(String email) throws Exception {
        boolean exists = false;
        Connection con = DBconfig.getConnection();

        String sql = "SELECT user_id FROM user WHERE email = ?";
        PreparedStatement pst = con.prepareStatement(sql);
        pst.setString(1, email);
        ResultSet rs = pst.executeQuery();

        exists = rs.next();

        rs.close();
        pst.close();
        con.close();
        return exists;
    }

    public boolean phoneExists(String phone) throws Exception {
        boolean exists = false;
        Connection con = DBconfig.getConnection();

        String sql = "SELECT user_id FROM user WHERE phone = ?";
        PreparedStatement pst = con.prepareStatement(sql);
        pst.setString(1, phone);
        ResultSet rs = pst.executeQuery();

        exists = rs.next();

        rs.close();
        pst.close();
        con.close();
        return exists;
    }

    public List<UserModel> getFilteredUsers(String keyword, String role, String sortBy) throws Exception {
        List<UserModel> users = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT * FROM user WHERE 1 = 1 ");

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (first_name LIKE ? OR last_name LIKE ? OR email LIKE ? OR phone LIKE ?) ");
            String searchValue = "%" + keyword.trim() + "%";
            params.add(searchValue);
            params.add(searchValue);
            params.add(searchValue);
            params.add(searchValue);
        }

        if (role != null && !role.trim().isEmpty()) {
            sql.append("AND role = ? ");
            params.add(role.trim());
        }

        sql.append(resolveUserSort(sortBy));

        try (Connection con = DBconfig.getConnection();
             PreparedStatement pst = con.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                pst.setObject(i + 1, params.get(i));
            }

            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                users.add(mapUser(rs));
            }
        }

        return users;
    }

    public int countUsers() throws Exception {
        return countByCondition("SELECT COUNT(*) FROM user");
    }

    public int countUsersByRole(String role) throws Exception {
        String sql = "SELECT COUNT(*) FROM user WHERE role = ?";

        try (Connection con = DBconfig.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {

            pst.setString(1, role);
            ResultSet rs = pst.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public int countNewUsersThisWeek() throws Exception {
        return countByCondition("SELECT COUNT(*) FROM user WHERE created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)");
    }

    private int countByCondition(String sql) throws Exception {
        try (Connection con = DBconfig.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {

            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    private String resolveUserSort(String sortBy) {
        if ("name_asc".equals(sortBy)) {
            return "ORDER BY first_name ASC, last_name ASC";
        }
        if ("name_desc".equals(sortBy)) {
            return "ORDER BY first_name DESC, last_name DESC";
        }
        if ("email_asc".equals(sortBy)) {
            return "ORDER BY email ASC";
        }
        if ("role".equals(sortBy)) {
            return "ORDER BY role ASC, first_name ASC";
        }
        return "ORDER BY created_at DESC";
    }

    private UserModel mapUser(ResultSet rs) throws Exception {
        UserModel user = new UserModel();
        user.setUserId(rs.getInt("user_id"));
        user.setFirstName(rs.getString("first_name"));
        user.setLastName(rs.getString("last_name"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setDob(rs.getDate("dob"));
        user.setPassword(rs.getString("password"));
        user.setRole(rs.getString("role"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        return user;
    }
}
