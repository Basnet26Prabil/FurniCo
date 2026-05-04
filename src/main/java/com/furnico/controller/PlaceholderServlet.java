package com.furnico.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Servlet implementation class PlaceholderServlet
 *
 * Handles the URLs of modules still being built by other teammates
 * (About, Contact) and shows a friendly "Coming soon" page instead of a 404.
 *
 * NOTE: /cart and /wishlist have been removed from here — they are now
 * handled by CartServlet and WishlistServlet (Member 4).
 */
@WebServlet(asyncSupported = true,
            urlPatterns = { "/about", "/contact" })
public class PlaceholderServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public PlaceholderServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub

		String path = request.getServletPath(); // e.g. "/about"

		String pageTitle = "Coming Soon";
		String pageIcon = "circle-question";

		if (path.equals("/about")) {
			pageTitle = "About Us";
			pageIcon = "circle-info";
		} else if (path.equals("/contact")) {
			pageTitle = "Contact";
			pageIcon = "envelope";
		}

		request.setAttribute("pageTitle", pageTitle);
		request.setAttribute("pageIcon", pageIcon);

		request.getRequestDispatcher("/WEB-INF/pages/Placeholder.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}