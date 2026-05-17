<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Categories - FurniCo</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/logo.png">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@500;600;700&family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css?v=7">
</head>
<body>

<header class="header">
    <a href="${pageContext.request.contextPath}/home" class="logo">
        <span class="logo-icon"><img src="${pageContext.request.contextPath}/images/logo.png" alt="FurniCo"></span>
        <span class="logo-text">Furni Co</span>
    </a>

    <nav class="main-nav">
        <a href="${pageContext.request.contextPath}/admin">Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/products">Products</a>
        <a href="${pageContext.request.contextPath}/admin/categories" class="active">Categories</a>
        <a href="${pageContext.request.contextPath}/admin/orders">Orders</a>
        <a href="${pageContext.request.contextPath}/admin/users">Users</a>
        <jsp:include page="/WEB-INF/pages/accountMenu.jsp" />
    </nav>
</header>

<main class="admin-wrap">
    <section class="page-head">
        <div>
            <span class="eyebrow">Admin Dashboard</span>
            <h1>Category Management</h1>
        </div>
        <a class="btn-outline" href="${pageContext.request.contextPath}/admin/products">
            <i class="fa-solid fa-boxes-stacked"></i> Products
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
                    <c:when test="${formCategory.categoryId gt 0}">Update Category</c:when>
                    <c:otherwise>Add Category</c:otherwise>
                </c:choose>
            </h2>
            <c:if test="${formCategory.categoryId gt 0}">
                <a href="${pageContext.request.contextPath}/admin/categories" class="small-link">Cancel edit</a>
            </c:if>
        </div>

        <form action="${pageContext.request.contextPath}/admin/categories" method="post" class="product-form category-form" enctype="multipart/form-data">
            <input type="hidden" name="action" value="save">
            <input type="hidden" name="categoryId" value="${formCategory.categoryId}">
            <input type="hidden" name="currentImage" value="${formCategory.image}">

            <div class="field">
                <label>Category Name</label>
                <input type="text" name="categoryName" value="${formCategory.categoryName}" maxlength="50" required>
            </div>

            <div class="field">
                <label>Category Image</label>
                <input type="file" name="imageFile" accept="image/*" ${empty formCategory.image ? 'required' : ''}>
            </div>

            <div class="field full">
                <label>Description</label>
                <textarea name="description" rows="4" maxlength="255" required>${formCategory.description}</textarea>
            </div>

            <button class="btn-primary" type="submit">
                <c:choose>
                    <c:when test="${formCategory.categoryId gt 0}">Update Category</c:when>
                    <c:otherwise>Add Category</c:otherwise>
                </c:choose>
            </button>
        </form>
    </section>

    <section class="panel">
        <div class="panel-head">
            <h2>All Categories</h2>
            <span class="record-count">${fn:length(categories)} records</span>
        </div>

        <form class="filter-form category-filter-form" action="${pageContext.request.contextPath}/admin/categories" method="get">
            <div class="field">
                <label>Search</label>
                <div class="filter-input">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <input type="text" name="keyword" placeholder="Search by category name or description" value="${keyword}">
                </div>
            </div>
            <div class="filter-actions">
                <button class="btn-filter" type="submit">
                    <i class="fa-solid fa-filter"></i> Apply
                </button>
                <a class="btn-clear" href="${pageContext.request.contextPath}/admin/categories">
                    <i class="fa-solid fa-rotate-left"></i> Reset
                </a>
            </div>
        </form>

        <div class="table-wrap">
            <table class="category-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Category</th>
                        <th>Description</th>
                        <th>Products</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="category" items="${categories}">
                        <tr>
                            <td>#${category.categoryId}</td>
                            <td>
                                <div class="product-cell">
                                    <img src="${pageContext.request.contextPath}/images/${category.image}" alt="${category.categoryName}"
                                         onerror="this.src='${pageContext.request.contextPath}/images/placeholder.jpg';">
                                    <span>${category.categoryName}</span>
                                </div>
                            </td>
                            <td>${category.description}</td>
                            <td>
                                <span class="pill ${category.productCount == 0 ? 'muted' : ''}">
                                    ${category.productCount} products
                                </span>
                            </td>
                            <td>
                                <div class="action-row">
                                    <a class="icon-btn" href="${pageContext.request.contextPath}/admin/categories?editId=${category.categoryId}" title="Edit">
                                        <i class="fa-regular fa-pen-to-square"></i>
                                    </a>
                                    <form action="${pageContext.request.contextPath}/admin/categories" method="post" onsubmit="return confirm('Delete this category? Categories with products cannot be deleted.');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="categoryId" value="${category.categoryId}">
                                        <button class="icon-btn danger" type="submit" title="Delete" ${category.productCount gt 0 ? 'disabled' : ''}>
                                            <i class="fa-regular fa-trash-can"></i>
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty categories}">
                        <tr>
                            <td colspan="5" class="empty-row">No categories matched the selected search.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </section>
</main>

</body>
</html>
