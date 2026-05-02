package com.furnico.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.furnico.model.CategoryModel;
import com.furnico.model.ProductModel;
import com.furnico.service.CategoryService;
import com.furnico.service.ProductService;

/**
 * Servlet implementation class ProductListServlet
 */
@WebServlet(asyncSupported = true, urlPatterns = { "/products" })
public class ProductListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public ProductListServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub

		try {
			CategoryService categoryService = new CategoryService();
			ProductService productService = new ProductService();

			// Get all categories for the sidebar
			List<CategoryModel> categories = categoryService.fetchAll();

			// Count products per category (for sidebar display)
			Map<Integer, Integer> categoryCounts = new HashMap<>();
			for (CategoryModel cat : categories) {
				categoryCounts.put(cat.getCategoryId(), categoryService.countProducts(cat.getCategoryId()));
			}

			// Check if a category filter is selected
			String categoryIdParam = request.getParameter("categoryId");
			List<ProductModel> products;
			Integer selectedCategoryId = null;
			String selectedCategoryName = null;

			if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
				int categoryId = Integer.parseInt(categoryIdParam);
				products = productService.fetchByCategory(categoryId);
				selectedCategoryId = categoryId;

				CategoryModel cat = categoryService.fetchById(categoryId);
				if (cat != null) {
					selectedCategoryName = cat.getCategoryName();
				}
			} else {
				products = productService.fetchAll();
			}

			// Set in Request Scope for EL access
			request.setAttribute("categories", categories);
			request.setAttribute("categoryCounts", categoryCounts);
			request.setAttribute("products", products);
			request.setAttribute("selectedCategoryId", selectedCategoryId);
			request.setAttribute("selectedCategoryName", selectedCategoryName);

			// Forward to JSP
			request.getRequestDispatcher("/WEB-INF/pages/Products.jsp").forward(request, response);

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