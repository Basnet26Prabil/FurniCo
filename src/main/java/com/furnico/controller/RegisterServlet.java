package com.furnico.controller;

import jakarta.servlet.ServletException;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.furnico.utils.FurnicoException;

import java.io.IOException;

import com.furnico.service.RegisterService;

@WebServlet(asyncSupported = true, urlPatterns = { "/register" })
public class RegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public RegisterServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		request.getRequestDispatcher("/WEB-INF/pages/Register.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub

		try {
			// Get form fields
			String firstName = request.getParameter("firstName");
			String lastName = request.getParameter("lastName");
			String email = request.getParameter("email");
			String phone = request.getParameter("phone");
			String dob = request.getParameter("dob");
			String password = request.getParameter("password");
			String confirmPassword = request.getParameter("confirmPassword");

			// Check that the two password fields match
			if (!password.equals(confirmPassword)) {
				request.setAttribute("error", "Passwords do not match");
				request.getRequestDispatcher("/WEB-INF/pages/Register.jsp").forward(request, response);
				return;
			}

			// Save the user
			RegisterService service = new RegisterService();
			service.addUser(firstName, lastName, email, phone, dob, password);

			// Redirect to login page on success
			response.sendRedirect(request.getContextPath() + "/login?success=registered");

		} catch (FurnicoException e) {   // CHANGED
		    request.setAttribute("errorMessage", e.getMessage());
		    request.setAttribute("statusCode", e.getStatusCode());
		    request.getRequestDispatcher("/WEB-INF/pages/views/error.jsp").forward(request, response);   // CHANGED
		}
	}

}