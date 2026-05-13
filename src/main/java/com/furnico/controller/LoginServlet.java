package com.furnico.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Cookie;

import java.io.IOException;
import java.util.List;

import com.furnico.model.UserModel;
import com.furnico.service.LoginService;
import com.furnico.utils.CryptoUtil;
import com.furnico.utils.SessionUtil;
import com.furnico.utils.ValidationUtil;

@WebServlet(asyncSupported = true, urlPatterns = { "/login" })
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public LoginServlet() {
        super();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Object role = SessionUtil.getAttribute(request, "userRole");
		if (role != null) {
			if ("admin".equalsIgnoreCase(role.toString())) {
				response.sendRedirect(request.getContextPath() + "/admin/products");
			} else {
				response.sendRedirect(request.getContextPath() + "/home");
			}
			return;
		}

		if ("registered".equals(request.getParameter("success"))) {
			request.setAttribute("success", "Registration completed. Please sign in.");
		} else if ("logout".equals(request.getParameter("success"))) {
			request.setAttribute("success", "You have been logged out successfully.");
		}
		request.getRequestDispatcher("/WEB-INF/pages/Login.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String email;
		String password;
		String remember = request.getParameter("remember");

		try {
			email = CryptoUtil.decryptFormValue(request.getParameter("email"));
			password = CryptoUtil.decryptFormValue(request.getParameter("password"));
		} catch (Exception e) {
			request.setAttribute("error", "Unable to read encrypted login details. Please try again.");
			request.getRequestDispatcher("/WEB-INF/pages/Login.jsp").forward(request, response);
			return;
		}

		request.setAttribute("email", email);

		List<String> errors = ValidationUtil.validateLogin(email, password);
		if (!errors.isEmpty()) {
			request.setAttribute("errors", errors);
			request.getRequestDispatcher("/WEB-INF/pages/Login.jsp").forward(request, response);
			return;
		}

		try {
			LoginService service = new LoginService();
			UserModel user = service.loginUser(email.trim(), password);

			if (user == null) {
				request.setAttribute("error", "Invalid email or password.");
				request.getRequestDispatcher("/WEB-INF/pages/Login.jsp").forward(request, response);
				return;
			}

			// Store details needed by the application in the session.
			SessionUtil.setAttribute(request, "user", user);
			SessionUtil.setAttribute(request, "userId", user.getUserId());
			SessionUtil.setAttribute(request, "userEmail", user.getEmail());
			SessionUtil.setAttribute(request, "userName", user.getFirstName() + " " + user.getLastName());
			SessionUtil.setAttribute(request, "userRole", user.getRole());

			Cookie emailCookie = new Cookie("rememberedEmail", user.getEmail());
			emailCookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
			if ("on".equals(remember)) {
				emailCookie.setMaxAge(60 * 60 * 24 * 7);
			} else {
				emailCookie.setMaxAge(0);
			}
			response.addCookie(emailCookie);

			if ("admin".equalsIgnoreCase(user.getRole())) {
				response.sendRedirect(request.getContextPath() + "/admin/products");
			} else {
				response.sendRedirect(request.getContextPath() + "/home");
			}

		} catch (Exception e) {
			throw new ServletException("Login failed", e);
		}
	}

}
