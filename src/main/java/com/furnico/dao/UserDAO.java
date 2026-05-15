package com.furnico.dao;

import java.sql.Connection;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.furnico.model.UserModel;
import com.furnico.utils.DBconfig;
import com.furnico.utils.FurnicoException;


public class UserDAO {

    public void insertUser(String firstName, String lastName, String email, String phone,
                           String dob, String hashedPassword) throws FurnicoException {
    	try {
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
    }  catch (SQLException e) {                                             // ADD
        throw new FurnicoException("Failed to register user", e);         // ADD
    } 
   }

    public UserModel findByEmail(String email) throws FurnicoException {
        UserModel user = null;
        try {
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
       } catch (SQLException e) {                                             // ADD
            throw new FurnicoException("Failed to find user by email", e);    // ADD
        }   
        return user;
    }
}