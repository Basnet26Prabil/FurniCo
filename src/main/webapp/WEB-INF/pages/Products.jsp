<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<c:set var="activePage" value="home" scope="request" />
 
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Our Collection - FurniCo</title>
 
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,500;0,600;0,700;1,400;1,500&family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
 
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/products.css">
</head>
<body>
 
<!-- ===================== HEADER ===================== -->
<header class="header">
    <a href="${pageContext.request.contextPath}/home" class="logo">
        <span class="logo-icon"><img src="${pageContext.request.contextPath}/images/logo.png" alt="FurniCo"></span>
        <span class="logo-text">Furni Co</span>
    </a>
 
    <nav class="main-nav">
        <a href="${pageContext.request.contextPath}/home">Home</a>
        <a href="${pageContext.request.contextPath}/products" class="active">Shop</a>
        <a href="${pageContext.request.contextPath}/about">About</a>
        <a href="${pageContext.request.contextPath}/contact">Contact</a>
    </nav>
 
    <div class="header-icons">
        <a href="${pageContext.request.contextPath}/wishlist" title="Wishlist">
            <i class="fa-regular fa-heart"></i>
        </a>
        <a href="${pageContext.request.contextPath}/cart" title="Cart">
            <i class="fa-solid fa-bag-shopping"></i>
            <span class="cart-badge">0</span>
        </a>
        <a href="${pageContext.request.contextPath}/login" title="Account" class="profile-icon">
            <i class="fa-regular fa-user"></i>
        </a>
    </div>
</header>
 
<!-- ===================== PAGE TITLE ===================== -->
<div class="page-head">
    <c:choose>
        <c:when test="${not empty keyword}">
            <h1 class="page-title">Search: "${keyword}"</h1>
        </c:when>
        <c:when test="${not empty selectedCategoryName}">
            <h1 class="page-title">${selectedCategoryName}</h1>
        </c:when>
        <c:otherwise>
            <h1 class="page-title">Our Collection</h1>
        </c:otherwise>
    </c:choose>
</div>
 
<!-- ===================== SEARCH + SORT ===================== -->
<form class="search-row" action="${pageContext.request.contextPath}/search" method="get">
    <div class="search-box">
        <i class="fa-solid fa-magnifying-glass"></i>
        <input type="text" name="keyword" placeholder="Search products..." value="${keyword}">
    </div>
    <div class="sort-box">
        <select aria-label="Sort">
            <option>Featured</option>
            <option>Price: Low to High</option>
            <option>Price: High to Low</option>
            <option>Rating</option>
        </select>
    </div>
</form>
 
<!-- ===================== MAIN LAYOUT ===================== -->
<div class="layout">
 
    <!-- ============ SIDEBAR ============ -->
    <aside class="sidebar">
 
        <div class="sidebar-block">
            <div class="sidebar-head">
                <h3>Filters</h3>
                <a href="${pageContext.request.contextPath}/products" class="clear-all">Clear All</a>
            </div>
 
            <div class="sidebar-label">Categories</div>
            <ul class="cat-list">
                <li>
                    <a href="${pageContext.request.contextPath}/products"
                       class="cat-row ${empty selectedCategoryId and empty keyword ? 'active' : ''}">
                        <span class="left">
                            <input type="checkbox" ${empty selectedCategoryId and empty keyword ? 'checked' : ''}>
                            All
                        </span>
                        <span class="count">${fn:length(products)}</span>
                    </a>
                </li>
                <c:forEach var="c" items="${categories}">
                    <li>
                        <a href="${pageContext.request.contextPath}/products?categoryId=${c.categoryId}"
                           class="cat-row ${selectedCategoryId == c.categoryId ? 'active' : ''}">
                            <span class="left">
                                <input type="checkbox" ${selectedCategoryId == c.categoryId ? 'checked' : ''}>
                                ${c.categoryName}
                            </span>
                            <span class="count">${categoryCounts[c.categoryId]}</span>
                        </a>
                    </li>
                </c:forEach>
            </ul>
        </div>
 
        <div class="sidebar-block">
            <div class="sidebar-label">Price Range</div>
            <div class="price-range">
                <input type="range" min="0" max="100000" value="100000">
                <div class="limits">
                    <span>Rs. 0</span>
                    <span>Rs. 100,000</span>
                </div>
            </div>
        </div>
 
        <div class="sidebar-block">
            <div class="sidebar-label">Minimum Rating</div>
 
            <label class="rating-row">
                <input type="checkbox">
                <span class="stars">
                    <i class="fa-solid fa-star"></i>
                    <i class="fa-solid fa-star"></i>
                    <i class="fa-solid fa-star"></i>
                    <i class="fa-solid fa-star"></i>
                    <i class="fa-regular fa-star dim"></i>
                </span>
                <span class="up-text">&amp; Up</span>
            </label>
 
            <label class="rating-row">
                <input type="checkbox">
                <span class="stars">
                    <i class="fa-solid fa-star"></i>
                    <i class="fa-solid fa-star"></i>
                    <i class="fa-solid fa-star"></i>
                    <i class="fa-regular fa-star dim"></i>
                    <i class="fa-regular fa-star dim"></i>
                </span>
                <span class="up-text">&amp; Up</span>
            </label>
 
            <label class="rating-row">
                <input type="checkbox">
                <span class="stars">
                    <i class="fa-solid fa-star"></i>
                    <i class="fa-solid fa-star"></i>
                    <i class="fa-regular fa-star dim"></i>
                    <i class="fa-regular fa-star dim"></i>
                    <i class="fa-regular fa-star dim"></i>
                </span>
                <span class="up-text">&amp; Up</span>
            </label>
 
            <label class="rating-row">
                <input type="checkbox">
                <span class="stars">
                    <i class="fa-solid fa-star"></i>
                    <i class="fa-regular fa-star dim"></i>
                    <i class="fa-regular fa-star dim"></i>
                    <i class="fa-regular fa-star dim"></i>
                    <i class="fa-regular fa-star dim"></i>
                </span>
                <span class="up-text">&amp; Up</span>
            </label>
        </div>
    </aside>
 
    <!-- ============ MAIN AREA ============ -->
    <section class="main-area">
 
        <div class="result-count">
            Showing ${fn:length(products)} product<c:if test="${fn:length(products) != 1}">s</c:if>
            <c:if test="${not empty keyword}">
                for "${keyword}"
            </c:if>
        </div>
 
        <c:choose>
            <c:when test="${empty products}">
                <div class="empty-state">
                    <h4>No products found</h4>
                    <c:if test="${not empty keyword}">
                        <p>We couldn't find anything matching "${keyword}".</p>
                    </c:if>
                    <c:if test="${empty keyword}">
                        <p>No products in this category yet.</p>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/products" class="btn">View all products</a>
                </div>
            </c:when>
 
            <c:otherwise>
                <div class="product-grid">
                    <c:forEach var="p" items="${products}">
                        <article class="product-card">
                            <div class="product-image">
                                <c:if test="${p.bestSeller}">
                                    <span class="best-seller-pill">Best Seller</span>
                                </c:if>
                                <a href="${pageContext.request.contextPath}/product?id=${p.productId}">
                                    <img src="${pageContext.request.contextPath}/images/${p.image}" alt="${p.productName}"
                                         onerror="this.src='${pageContext.request.contextPath}/images/placeholder.jpg';">
                                </a>
                            </div>
                            <div class="product-body">
                                <div class="product-cat">${fn:toUpperCase(p.categoryName)}</div>
                                <h3 class="product-name">
                                    <a href="${pageContext.request.contextPath}/product?id=${p.productId}">${p.productName}</a>
                                </h3>
                                <div class="product-rating">
                                    <span class="stars">
                                        <c:forEach begin="1" end="5" var="i">
                                            <c:choose>
                                                <c:when test="${i le p.rating}"><i class="fa-solid fa-star"></i></c:when>
                                                <c:when test="${i - 0.5 le p.rating}"><i class="fa-solid fa-star-half-stroke"></i></c:when>
                                                <c:otherwise><i class="fa-regular fa-star"></i></c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                    </span>
                                    <span>(${p.ratingCount})</span>
                                </div>
                                <div class="product-footer">
                                    <div class="product-price">Rs. <fmt:formatNumber value="${p.price}" type="number" maxFractionDigits="0"/></div>
                                    <form method="post" action="${pageContext.request.contextPath}/cart" style="display:inline;">
                                        <input type="hidden" name="action"    value="add">
                                        <input type="hidden" name="productId" value="${p.productId}">
                                        <input type="hidden" name="qty"       value="1">
                                        <input type="hidden" name="redirectTo" value="/cart">
                                        <button type="submit" class="cart-btn" title="Add to cart">
                                            <i class="fa-solid fa-bag-shopping"></i>
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </article>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </section>
</div>
 
<!-- ===================== FOOTER ===================== -->
<jsp:include page="/WEB-INF/pages/footer.jsp" /> 
 
</body>
</html>    