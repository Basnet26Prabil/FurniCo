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
import com.furnico.utils.FurnicoException;

/**
 * Servlet implementation class ProductListServlet
 */
@WebServlet(asyncSupported = true, urlPatterns = { "/products" })
public class ProductListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public ProductListServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		try {
			CategoryService categoryService = new CategoryService();
			ProductService productService = new ProductService();

			// Get all categories for the sidebar
			List<CategoryModel> categories = categoryService.fetchAll();

			// Count products per category (for sidebar display)
			Map<Integer, Integer> categoryCounts = new HashMap<>();

			for (CategoryModel cat : categories) {
				try {
					int count = categoryService.countProducts(cat.getCategoryId());
					categoryCounts.put(cat.getCategoryId(), count);
				} catch (Exception e) {
					categoryCounts.put(cat.getCategoryId(), 0);
				}
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

		} catch (FurnicoException e) {
			request.setAttribute("errorMessage", e.getMessage());
			request.setAttribute("statusCode", e.getStatusCode());
			request.getRequestDispatcher("/WEB-INF/pages/views/error.jsp").forward(request, response);
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}
}