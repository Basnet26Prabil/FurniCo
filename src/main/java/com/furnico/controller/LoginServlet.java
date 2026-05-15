package com.furnico.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import com.furnico.model.UserModel;
import com.furnico.service.LoginService;
import com.furnico.utils.FurnicoException;

@WebServlet(asyncSupported = true, urlPatterns = { "/login" })
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public LoginServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/pages/Login.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            LoginService loginService = new LoginService();
            UserModel user = loginService.loginUser(email, password);

            if (user == null) {
                // Wrong email or password — stay on login page
                request.setAttribute("error", "Invalid email or password.");
                request.getRequestDispatcher("/WEB-INF/pages/Login.jsp").forward(request, response);
                return;
            } else {
                // Success — save user in session and go home
                HttpSession session = request.getSession();
                session.setAttribute("loggedUser", user);
                response.sendRedirect(request.getContextPath() + "/home");
            }

        } catch (FurnicoException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.setAttribute("statusCode", e.getStatusCode());
            request.getRequestDispatcher("/WEB-INF/pages/views/error.jsp").forward(request, response);
        }
    }
}