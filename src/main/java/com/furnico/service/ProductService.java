package com.furnico.service;

import java.util.List;

import com.furnico.dao.ProductDAO;
import com.furnico.model.ProductModel;
import com.furnico.utils.FurnicoException; 

public class ProductService {

    public List<ProductModel> fetchAll() throws FurnicoException {
        ProductDAO dao = new ProductDAO();
        return dao.getAllProducts();
    }

    public List<ProductModel> fetchByCategory(int categoryId) throws FurnicoException {
        ProductDAO dao = new ProductDAO();
        return dao.getProductsByCategory(categoryId);
    }

    public ProductModel fetchById(int productId) throws FurnicoException {
        ProductDAO dao = new ProductDAO();
        return dao.getProductById(productId);
    }

    public List<ProductModel> search(String keyword) throws FurnicoException {
        ProductDAO dao = new ProductDAO();
        return dao.searchProducts(keyword);
    }
}