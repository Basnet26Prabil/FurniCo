package com.furnico.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.SQLIntegrityConstraintViolationException;
import java.util.List;

import com.furnico.model.CategoryModel;
import com.furnico.service.CategoryService;
import com.furnico.utils.ValidationUtil;

@WebServlet(asyncSupported = true, urlPatterns = { "/admin/categories" })
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 5,
        maxRequestSize = 1024 * 1024 * 8
)
public class AdminCategoryServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final CategoryService categoryService = new CategoryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String editId = request.getParameter("editId");
            if (!ValidationUtil.isBlank(editId)) {
                CategoryModel category = categoryService.fetchById(Integer.parseInt(editId));
                request.setAttribute("formCategory", category);
            }

            loadAdminPage(request);
            request.getRequestDispatcher("/WEB-INF/pages/AdminCategories.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("Unable to load admin categories", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("delete".equals(action)) {
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));

                if (categoryService.countProducts(categoryId) > 0) {
                    response.sendRedirect(request.getContextPath() + "/admin/categories?error=in_use");
                    return;
                }

                categoryService.delete(categoryId);
                response.sendRedirect(request.getContextPath() + "/admin/categories?success=deleted");
                return;
            }

            CategoryModel category = buildCategoryFromRequest(request);
            List<String> errors = ValidationUtil.validateCategory(category);

            if (!errors.isEmpty()) {
                request.setAttribute("errors", errors);
                request.setAttribute("formCategory", category);
                loadAdminPage(request);
                request.getRequestDispatcher("/WEB-INF/pages/AdminCategories.jsp").forward(request, response);
                return;
            }

            if (category.getCategoryId() > 0) {
                categoryService.update(category);
                response.sendRedirect(request.getContextPath() + "/admin/categories?success=updated");
            } else {
                categoryService.add(category);
                response.sendRedirect(request.getContextPath() + "/admin/categories?success=created");
            }
        } catch (SQLIntegrityConstraintViolationException e) {
            request.setAttribute("errors", List.of("Category name already exists or the category is being used by products."));
            request.setAttribute("formCategory", buildCategoryWithSafeValues(request));
            reloadForm(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("errors", List.of("Please enter valid category details."));
            request.setAttribute("formCategory", buildCategoryWithSafeValues(request));
            reloadForm(request, response);
        } catch (Exception e) {
            throw new ServletException("Unable to save category", e);
        }
    }

    private void loadAdminPage(HttpServletRequest request) throws Exception {
        String keyword = request.getParameter("keyword");
        List<CategoryModel> categories = categoryService.filter(keyword);

        request.setAttribute("categories", categories);
        request.setAttribute("keyword", keyword);

        String success = request.getParameter("success");
        String error = request.getParameter("error");

        if ("created".equals(success)) {
            request.setAttribute("success", "Category added successfully.");
        } else if ("updated".equals(success)) {
            request.setAttribute("success", "Category updated successfully.");
        } else if ("deleted".equals(success)) {
            request.setAttribute("success", "Category deleted successfully.");
        }

        if ("in_use".equals(error)) {
            request.setAttribute("errors", List.of("This category cannot be deleted because products are assigned to it."));
        }
    }

    private CategoryModel buildCategoryFromRequest(HttpServletRequest request) throws IOException, ServletException {
        CategoryModel category = new CategoryModel();

        String categoryId = request.getParameter("categoryId");
        if (!ValidationUtil.isBlank(categoryId)) {
            category.setCategoryId(Integer.parseInt(categoryId));
        }

        category.setCategoryName(valueOrEmpty(request.getParameter("categoryName")));
        category.setDescription(valueOrEmpty(request.getParameter("description")));
        category.setImage(resolveCategoryImage(request));
        return category;
    }

    private CategoryModel buildCategoryWithSafeValues(HttpServletRequest request) {
        CategoryModel category = new CategoryModel();

        category.setCategoryName(valueOrEmpty(request.getParameter("categoryName")));
        category.setDescription(valueOrEmpty(request.getParameter("description")));
        category.setImage(valueOrEmpty(request.getParameter("currentImage")));

        try {
            String categoryId = request.getParameter("categoryId");
            if (!ValidationUtil.isBlank(categoryId)) {
                category.setCategoryId(Integer.parseInt(categoryId));
            }
        } catch (NumberFormatException e) {
            category.setCategoryId(0);
        }

        return category;
    }

    private String resolveCategoryImage(HttpServletRequest request) throws IOException, ServletException {
        Part imagePart = request.getPart("imageFile");
        String currentImage = request.getParameter("currentImage");

        if (imagePart == null || imagePart.getSize() == 0) {
            return valueOrEmpty(currentImage);
        }

        String submittedName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
        String safeName = System.currentTimeMillis() + "-" + submittedName.replaceAll("[^A-Za-z0-9._-]", "_");

        String uploadPath = getServletContext().getRealPath("/images");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        imagePart.write(new File(uploadDir, safeName).getAbsolutePath());
        return safeName;
    }

    private void reloadForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            loadAdminPage(request);
        } catch (Exception e) {
            throw new ServletException("Unable to reload admin categories", e);
        }
        request.getRequestDispatcher("/WEB-INF/pages/AdminCategories.jsp").forward(request, response);
    }

    private String valueOrEmpty(String value) {
        return value == null ? "" : value.trim();
    }
}
