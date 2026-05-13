package com.furnico.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;

import com.furnico.model.CategoryModel;
import com.furnico.model.ProductModel;
import com.furnico.service.CategoryService;
import com.furnico.service.ProductService;
import com.furnico.utils.ValidationUtil;

@WebServlet(asyncSupported = true, urlPatterns = { "/admin", "/admin/products" })
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 5,
        maxRequestSize = 1024 * 1024 * 8
)
public class AdminProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final CategoryService categoryService = new CategoryService();
    private final ProductService productService = new ProductService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String editId = request.getParameter("editId");
            if (!ValidationUtil.isBlank(editId)) {
                ProductModel product = productService.fetchById(Integer.parseInt(editId));
                request.setAttribute("formProduct", product);
            }

            loadAdminPage(request);
            request.getRequestDispatcher("/WEB-INF/pages/AdminProducts.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Unable to load admin products", e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("delete".equals(action)) {
                int productId = Integer.parseInt(request.getParameter("productId"));
                productService.delete(productId);
                response.sendRedirect(request.getContextPath() + "/admin/products?success=deleted");
                return;
            }

            ProductModel product = buildProductFromRequest(request);
            List<String> errors = ValidationUtil.validateProduct(product);

            if (!errors.isEmpty()) {
                request.setAttribute("errors", errors);
                request.setAttribute("formProduct", product);
                loadAdminPage(request);
                request.getRequestDispatcher("/WEB-INF/pages/AdminProducts.jsp").forward(request, response);
                return;
            }

            if (product.getProductId() > 0) {
                productService.update(product);
                response.sendRedirect(request.getContextPath() + "/admin/products?success=updated");
            } else {
                productService.add(product);
                response.sendRedirect(request.getContextPath() + "/admin/products?success=created");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errors", List.of("Please enter valid numeric values for product details."));
            request.setAttribute("formProduct", buildProductWithSafeValues(request));
            try {
                loadAdminPage(request);
            } catch (Exception loadError) {
                throw new ServletException("Unable to reload admin products", loadError);
            }
            request.getRequestDispatcher("/WEB-INF/pages/AdminProducts.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Unable to save product", e);
        }
    }

    private void loadAdminPage(HttpServletRequest request) throws Exception {
        List<CategoryModel> categories = categoryService.fetchAll();

        String keyword = request.getParameter("keyword");
        String categoryParam = request.getParameter("categoryId");
        String stockStatus = request.getParameter("stockStatus");
        Integer categoryId = null;

        if (!ValidationUtil.isBlank(categoryParam)) {
            categoryId = Integer.parseInt(categoryParam);
        }

        List<ProductModel> products = productService.filter(keyword, categoryId, stockStatus);

        request.setAttribute("categories", categories);
        request.setAttribute("products", products);
        request.setAttribute("keyword", keyword);
        request.setAttribute("selectedCategoryId", categoryId);
        request.setAttribute("stockStatus", stockStatus);

        String success = request.getParameter("success");
        if ("created".equals(success)) {
            request.setAttribute("success", "Product added successfully.");
        } else if ("updated".equals(success)) {
            request.setAttribute("success", "Product updated successfully.");
        } else if ("deleted".equals(success)) {
            request.setAttribute("success", "Product deleted successfully.");
        }
    }

    private ProductModel buildProductFromRequest(HttpServletRequest request) throws IOException, ServletException {
        ProductModel product = new ProductModel();

        String productId = request.getParameter("productId");
        if (!ValidationUtil.isBlank(productId)) {
            product.setProductId(Integer.parseInt(productId));
        }

        product.setProductName(request.getParameter("productName").trim());
        product.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
        product.setPrice(Double.parseDouble(request.getParameter("price")));
        product.setDescription(request.getParameter("description").trim());
        product.setImage(resolveProductImage(request));
        product.setStock(Integer.parseInt(request.getParameter("stock")));

        return product;
    }

    private ProductModel buildProductWithSafeValues(HttpServletRequest request) {
        ProductModel product = new ProductModel();

        product.setProductName(valueOrEmpty(request.getParameter("productName")));
        product.setDescription(valueOrEmpty(request.getParameter("description")));
        product.setImage(valueOrEmpty(request.getParameter("currentImage")));

        trySetInt(request.getParameter("productId"), product::setProductId);
        trySetInt(request.getParameter("categoryId"), product::setCategoryId);
        trySetInt(request.getParameter("stock"), product::setStock);
        trySetDouble(request.getParameter("price"), product::setPrice);

        return product;
    }

    private String resolveProductImage(HttpServletRequest request) throws IOException, ServletException {
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

    private String valueOrEmpty(String value) {
        return value == null ? "" : value.trim();
    }

    private void trySetInt(String value, IntSetter setter) {
        try {
            if (!ValidationUtil.isBlank(value)) {
                setter.set(Integer.parseInt(value));
            }
        } catch (NumberFormatException e) {
            setter.set(0);
        }
    }

    private void trySetDouble(String value, DoubleSetter setter) {
        try {
            if (!ValidationUtil.isBlank(value)) {
                setter.set(Double.parseDouble(value));
            }
        } catch (NumberFormatException e) {
            setter.set(0);
        }
    }

    private interface IntSetter {
        void set(int value);
    }

    private interface DoubleSetter {
        void set(double value);
    }
}
