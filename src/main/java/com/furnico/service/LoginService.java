package com.furnico.service;

import com.furnico.dao.UserDAO;

import com.furnico.model.UserModel;
import com.furnico.utils.PasswordUtil;
import com.furnico.utils.FurnicoException;

public class LoginService {

    public UserModel loginUser(String email, String password) throws FurnicoException {

        UserDAO dao = new UserDAO();
        UserModel user = dao.findByEmail(email);

        // No account with that email
        if (user == null) {
            return null;
        }

        // Compare the typed password against the stored hash
        boolean match = PasswordUtil.checkPassword(password, user.getPassword());

        if (match) {
            return user;  // login successful
        } else {
            return null;  // wrong password
        }
    }
}