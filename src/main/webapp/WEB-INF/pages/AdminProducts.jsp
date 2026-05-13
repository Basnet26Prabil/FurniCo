<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Products - FurniCo</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/logo.png">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@500;600;700&family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css?v=5">
</head>
<body>

<header class="header">
    <a href="${pageContext.request.contextPath}/home" class="logo">
        <span class="logo-icon"><img src="${pageContext.request.contextPath}/images/logo.png" alt="FurniCo"></span>
        <span class="logo-text">Furni Co</span>
    </a>

    <nav class="main-nav">
        <a href="${pageContext.request.contextPath}/home">Storefront</a>
        <a href="${pageContext.request.contextPath}/admin/products" class="active">Products</a>
        <a href="${pageContext.request.contextPath}/admin/orders">Orders</a>
        <jsp:include page="/WEB-INF/pages/accountMenu.jsp" />
    </nav>
</header>

<main class="admin-wrap">
    <section class="page-head">
        <div>
            <span class="eyebrow">Admin Dashboard</span>
            <h1>Product Management</h1>
        </div>
        <a class="btn-outline" href="${pageContext.request.contextPath}/products">
            <i class="fa-solid fa-store"></i> View shop
        </a>
    </section>

    <c:if test="${not empty success}">
        <div class="success">${success}</div>
    </c:if>

    <c:if test="${not empty errors}">
        <div class="error">
            <c:forEach var="message" items="${errors}">
                <div>${message}</div>
            </c:forEach>
        </div>
    </c:if>

    <section class="panel">
        <div class="panel-head">
            <h2>
                <c:choose>
                    <c:when test="${formProduct.productId gt 0}">Update Product</c:when>
                    <c:otherwise>Add Product</c:otherwise>
                </c:choose>
            </h2>
            <c:if test="${formProduct.productId gt 0}">
                <a href="${pageContext.request.contextPath}/admin/products" class="small-link">Cancel edit</a>
            </c:if>
        </div>

        <form action="${pageContext.request.contextPath}/admin/products" method="post" class="product-form" enctype="multipart/form-data">
            <input type="hidden" name="action" value="save">
            <input type="hidden" name="productId" value="${formProduct.productId}">
            <input type="hidden" name="currentImage" value="${formProduct.image}">

            <div class="field">
                <label>Product Name</label>
                <input type="text" name="productName" value="${formProduct.productName}" required>
            </div>

            <div class="field">
                <label>Category</label>
                <select name="categoryId" required>
                    <option value="">Select category</option>
                    <c:forEach var="c" items="${categories}">
                        <option value="${c.categoryId}" ${formProduct.categoryId == c.categoryId ? 'selected' : ''}>
                            ${c.categoryName}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="field">
                <label>Price</label>
                <input type="number" name="price" min="1" step="0.01" value="${formProduct.price}" required>
            </div>

            <div class="field">
                <label>Stock</label>
                <input type="number" name="stock" min="0" value="${formProduct.stock}" required>
            </div>

            <div class="field">
                <label>Product Image</label>
                <input type="file" name="imageFile" accept="image/*" ${empty formProduct.image ? 'required' : ''}>
            </div>

            <div class="field full">
                <label>Description</label>
                <textarea name="description" rows="4" required>${formProduct.description}</textarea>
            </div>

            <div class="field full computed-note">
                Rating, review count, and best-seller status are calculated by the system and are not edited from this form.
            </div>

            <button class="btn-primary" type="submit">
                <c:choose>
                    <c:when test="${formProduct.productId gt 0}">Update Product</c:when>
                    <c:otherwise>Add Product</c:otherwise>
                </c:choose>
            </button>
        </form>
    </section>

    <section class="panel">
        <div class="panel-head">
            <h2>All Products</h2>
            <span class="record-count">${fn:length(products)} records</span>
        </div>

        <form class="filter-form" action="${pageContext.request.contextPath}/admin/products" method="get">
            <div class="field">
                <label>Search</label>
                <div class="filter-input">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <input type="text" name="keyword" placeholder="Search by product name" value="${keyword}">
                </div>
            </div>
            <div class="field">
                <label>Category</label>
                <select name="categoryId">
                    <option value="">All categories</option>
                    <c:forEach var="c" items="${categories}">
                        <option value="${c.categoryId}" ${selectedCategoryId == c.categoryId ? 'selected' : ''}>
                            ${c.categoryName}
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div class="field">
                <label>Stock</label>
                <select name="stockStatus">
                    <option value="">All stock</option>
                    <option value="in_stock" ${stockStatus == 'in_stock' ? 'selected' : ''}>In stock</option>
                    <option value="out_of_stock" ${stockStatus == 'out_of_stock' ? 'selected' : ''}>Out of stock</option>
                </select>
            </div>
            <div class="filter-actions">
                <button class="btn-filter" type="submit">
                    <i class="fa-solid fa-filter"></i> Apply
                </button>
                <a class="btn-clear" href="${pageContext.request.contextPath}/admin/products">
                    <i class="fa-solid fa-rotate-left"></i> Reset
                </a>
            </div>
        </form>

        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Product</th>
                        <th>Category</th>
                        <th>Price</th>
                        <th>Stock</th>
                        <th>Rating</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="p" items="${products}">
                        <tr>
                            <td>#${p.productId}</td>
                            <td>
                                <div class="product-cell">
                                    <img src="${pageContext.request.contextPath}/images/${p.image}" alt="${p.productName}"
                                         onerror="this.src='${pageContext.request.contextPath}/images/placeholder.jpg';">
                                    <span>${p.productName}</span>
                                </div>
                            </td>
                            <td>${p.categoryName}</td>
                            <td>Rs. <fmt:formatNumber value="${p.price}" type="number" maxFractionDigits="0"/></td>
                            <td>${p.stock}</td>
                            <td>${p.rating} (${p.ratingCount})</td>
                            <td>
                                <c:choose>
                                    <c:when test="${p.bestSeller}">
                                        <span class="pill">Best Seller</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="pill muted">Regular</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="action-row">
                                    <a class="icon-btn" href="${pageContext.request.contextPath}/admin/products?editId=${p.productId}" title="Edit">
                                        <i class="fa-regular fa-pen-to-square"></i>
                                    </a>
                                    <form action="${pageContext.request.contextPath}/admin/products" method="post" onsubmit="return confirm('Delete this product?');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="productId" value="${p.productId}">
                                        <button class="icon-btn danger" type="submit" title="Delete">
                                            <i class="fa-regular fa-trash-can"></i>
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </section>
</main>

</body>
</html>
