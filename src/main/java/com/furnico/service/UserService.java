package com.furnico.service;

import java.util.List;

import com.furnico.dao.UserDAO;
import com.furnico.model.UserModel;

public class UserService {

    private final UserDAO userDAO = new UserDAO();

    public List<UserModel> getFilteredUsers(String keyword, String role, String sortBy) throws Exception {
        return userDAO.getFilteredUsers(keyword, role, sortBy);
    }

    public int getTotalUsers() throws Exception {
        return userDAO.countUsers();
    }

    public int getCustomerCount() throws Exception {
        return userDAO.countUsersByRole("customer");
    }

    public int getAdminCount() throws Exception {
        return userDAO.countUsersByRole("admin");
    }

    public int getNewUsersThisWeek() throws Exception {
        return userDAO.countNewUsersThisWeek();
    }
}
