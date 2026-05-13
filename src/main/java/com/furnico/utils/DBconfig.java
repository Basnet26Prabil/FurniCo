package com.furnico.utils;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBconfig {
	
	private static final String URL = "jdbc:mysql://localhost:3306/furnico";
    private static final String USER = "root";
    private static final String PASSWORD = "affinity";

    public static Connection getConnection() {

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println(" Connected to DB");
            return conn;

        } catch (Exception e) {
            System.out.println("DB Connection Failed");
            throw new RuntimeException("Unable to connect to FurniCo database", e);
        }
    }
}
