package com.furnico.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

import com.furnico.model.ProductModel;
import com.furnico.service.ProductService;


@WebServlet(asyncSupported = true, urlPatterns = { "/product" })
public class ProductDetailServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public ProductDetailServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub

		try {
			String idParam = request.getParameter("id");

			// If no id passed, send the user back to the products page
			if (idParam == null || idParam.isEmpty()) {
				response.sendRedirect(request.getContextPath() + "/products");
				return;
			}

			int id = Integer.parseInt(idParam);

			ProductService productService = new ProductService();
			ProductModel product = productService.fetchById(id);

			// If product not found, send back to the products page
			if (product == null) {
				response.sendRedirect(request.getContextPath() + "/products");
				return;
			}

			// Set in Request Scope for EL access
			request.setAttribute("product", product);

			// Forward to JSP
			request.getRequestDispatcher("/WEB-INF/pages/ProductDetail.jsp").forward(request, response);

		} catch (Exception e) {
			throw new ServletException("Database error", e);
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}