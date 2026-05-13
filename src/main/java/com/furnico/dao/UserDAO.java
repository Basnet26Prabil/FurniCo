package com.furnico.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

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
}
