package com.furnico.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

import com.furnico.service.RegisterService;
import com.furnico.utils.CryptoUtil;
import com.furnico.utils.ValidationUtil;

@WebServlet(asyncSupported = true, urlPatterns = { "/register" })
public class RegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public RegisterServlet() {
        super();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.getRequestDispatcher("/WEB-INF/pages/Register.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			// Get form fields
			String firstName = request.getParameter("firstName");
			String lastName = request.getParameter("lastName");
			String phone = request.getParameter("phone");
			String dob = request.getParameter("dob");
			String email;
			String password;
			String confirmPassword;

			try {
				email = CryptoUtil.decryptFormValue(request.getParameter("email"));
				password = CryptoUtil.decryptFormValue(request.getParameter("password"));
				confirmPassword = CryptoUtil.decryptFormValue(request.getParameter("confirmPassword"));
			} catch (Exception e) {
				request.setAttribute("firstName", firstName);
				request.setAttribute("lastName", lastName);
				request.setAttribute("phone", phone);
				request.setAttribute("dob", dob);
				request.setAttribute("error", "Unable to read encrypted registration details. Please try again.");
				request.getRequestDispatcher("/WEB-INF/pages/Register.jsp").forward(request, response);
				return;
			}

			request.setAttribute("firstName", firstName);
			request.setAttribute("lastName", lastName);
			request.setAttribute("email", email);
			request.setAttribute("phone", phone);
			request.setAttribute("dob", dob);

			List<String> errors = ValidationUtil.validateRegistration(firstName, lastName, email, phone, dob, password, confirmPassword);

			RegisterService service = new RegisterService();
			if (errors.isEmpty() && service.emailExists(email.trim())) {
				errors.add("An account with this email address already exists.");
			}
			if (errors.isEmpty() && service.phoneExists(phone.trim())) {
				errors.add("An account with this phone number already exists.");
			}

			if (!errors.isEmpty()) {
				request.setAttribute("errors", errors);
				request.getRequestDispatcher("/WEB-INF/pages/Register.jsp").forward(request, response);
				return;
			}

			// Save the user only after all validation checks pass.
			service.addUser(firstName.trim(), lastName.trim(), email.trim(), phone.trim(), dob, password);

			// Redirect to login page on success
			response.sendRedirect(request.getContextPath() + "/login?success=registered");

		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("error", "Registration failed. The email may already be in use.");
			request.getRequestDispatcher("/WEB-INF/pages/Register.jsp").forward(request, response);
		}
	}

}
