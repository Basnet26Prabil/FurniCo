package com.furnico.controller;

import jakarta.servlet.ServletException;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import com.furnico.model.CategoryModel;
import com.furnico.model.ProductModel;
import com.furnico.service.CategoryService;
import com.furnico.service.ProductService;
import com.furnico.utils.FurnicoException;

/**
 * Servlet implementation class HomeServlet
 */
@WebServlet(asyncSupported = true, urlPatterns = { "/home" })
public class HomeServlet extends SearchServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public HomeServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		// response.getWriter().append("Served at: ").append(request.getContextPath());

		try {
			CategoryService categoryService = new CategoryService();
			ProductService productService = new ProductService();

			// Get data from service
			List<CategoryModel> categories = categoryService.fetchAll();
			List<ProductModel> products = productService.fetchAll();

			// Set in Request Scope for EL access
			request.setAttribute("categories", categories);
			request.setAttribute("products", products);
			
			// Forward to JSP
			request.getRequestDispatcher("/WEB-INF/pages/Home.jsp").forward(request, response);
		 } catch (FurnicoException e) {                                      // CHANGE
	            request.setAttribute("errorMessage", e.getMessage());           // ADD
	            request.setAttribute("statusCode", e.getStatusCode());          // ADD
	            request.getRequestDispatcher("/WEB-INF/pages/views/error.jsp")        // ADD
	                   .forward(request, response);                             // ADD
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