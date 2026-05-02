package com.furnico.service;

import java.util.List;

import com.furnico.dao.CategoryDAO;
import com.furnico.model.CategoryModel;

public class CategoryService {

    public List<CategoryModel> fetchAll() throws Exception {
        CategoryDAO dao = new CategoryDAO();
        return dao.getAllCategories();
    }

    public CategoryModel fetchById(int categoryId) throws Exception {
        CategoryDAO dao = new CategoryDAO();
        return dao.getCategoryById(categoryId);
    }

    public int countProducts(int categoryId) throws Exception {
        CategoryDAO dao = new CategoryDAO();
        return dao.countByCategory(categoryId);
    }
}