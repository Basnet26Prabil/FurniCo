package com.furnico.service;

import java.util.List;

import com.furnico.dao.ProductDAO;
import com.furnico.model.ProductModel;

public class ProductService {

    public List<ProductModel> fetchAll() throws Exception {
        ProductDAO dao = new ProductDAO();
        return dao.getAllProducts();
    }

    public List<ProductModel> fetchByCategory(int categoryId) throws Exception {
        ProductDAO dao = new ProductDAO();
        return dao.getProductsByCategory(categoryId);
    }

    public ProductModel fetchById(int productId) throws Exception {
        ProductDAO dao = new ProductDAO();
        return dao.getProductById(productId);
    }

    public List<ProductModel> search(String keyword) throws Exception {
        ProductDAO dao = new ProductDAO();
        return dao.searchProducts(keyword);
    }
}