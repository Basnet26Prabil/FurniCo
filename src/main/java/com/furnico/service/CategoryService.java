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

    public List<CategoryModel> filter(String keyword) throws Exception {
        CategoryDAO dao = new CategoryDAO();
        return dao.filterCategories(keyword);
    }

    public void add(CategoryModel category) throws Exception {
        CategoryDAO dao = new CategoryDAO();
        dao.addCategory(category);
    }

    public void update(CategoryModel category) throws Exception {
        CategoryDAO dao = new CategoryDAO();
        dao.updateCategory(category);
    }

    public void delete(int categoryId) throws Exception {
        CategoryDAO dao = new CategoryDAO();
        dao.deleteCategory(categoryId);
    }
}
