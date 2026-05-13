package com.furnico.service;

import com.furnico.dao.UserDAO;
import com.furnico.utils.PasswordUtil;

public class RegisterService {

    public void addUser(String firstName, String lastName, String email, String phone,
                        String dob, String password) throws Exception {

        // Hash the password before storing
        password = PasswordUtil.getHashPassword(password);

        UserDAO dao = new UserDAO();
        dao.insertUser(firstName, lastName, email, phone, dob, password);
    }

    public boolean emailExists(String email) throws Exception {
        UserDAO dao = new UserDAO();
        return dao.emailExists(email);
    }

    public boolean phoneExists(String phone) throws Exception {
        UserDAO dao = new UserDAO();
        return dao.phoneExists(phone);
    }
}
