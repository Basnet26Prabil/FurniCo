package com.furnico.controller;

import jakarta.servlet.ServletException;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.furnico.model.CategoryModel;
import com.furnico.model.ProductModel;
import com.furnico.service.CategoryService;
import com.furnico.service.ProductService;
import com.furnico.utils.FurnicoException;

/**
 * Servlet implementation class SearchServlet
 */
@WebServlet(asyncSupported = true, urlPatterns = { "/search" })
public class SearchServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public SearchServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub

		try {
			String keyword = request.getParameter("keyword");
			if (keyword == null) {
				keyword = "";
			}

			CategoryService categoryService = new CategoryService();
			ProductService productService = new ProductService();

			// Get all categories for the sidebar
			List<CategoryModel> categories = categoryService.fetchAll();

			// Count products per category (for sidebar display)
			Map<Integer, Integer> categoryCounts = new HashMap<>();
			for (CategoryModel cat : categories) {
				categoryCounts.put(cat.getCategoryId(), categoryService.countProducts(cat.getCategoryId()));
			}

			// Run the search if keyword is not empty
			List<ProductModel> products;
			if (!keyword.trim().isEmpty()) {
				products = productService.search(keyword.trim());
			} else {
				products = new ArrayList<>();
			}

			// Set in Request Scope for EL access
			request.setAttribute("categories", categories);
			request.setAttribute("categoryCounts", categoryCounts);
			request.setAttribute("products", products);
			request.setAttribute("keyword", keyword);

			// Forward to JSP (reuse the products listing page)
			request.getRequestDispatcher("/WEB-INF/pages/Products.jsp").forward(request, response);

		} catch (FurnicoException e) {
			request.setAttribute("errorMessage", e.getMessage());
			request.setAttribute("statusCode", e.getStatusCode());
			request.getRequestDispatcher("/WEB-INF/pages/views/error.jsp").forward(request, response);
			return;
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}