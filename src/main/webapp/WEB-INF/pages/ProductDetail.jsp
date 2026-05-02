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
    <title>${product.productName} - FurniCo</title>
 
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,500;0,600;0,700;1,400;1,500&family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
 
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/productdetail.css">
</head>
<body>
 
<!-- ===================== HEADER ===================== -->
<header class="header">
    <a href="${pageContext.request.contextPath}/home" class="logo">
        <span class="logo-icon"><i class="fa-solid fa-couch"></i></span>
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
 
<!-- ===================== BREADCRUMB ===================== -->
<nav class="breadcrumb">
    <a href="${pageContext.request.contextPath}/home">Home</a>
    <span class="sep">&#8250;</span>
    <a href="${pageContext.request.contextPath}/products?categoryId=${product.categoryId}">${product.categoryName}</a>
    <span class="sep">&#8250;</span>
    <span class="current">${product.productName}</span>
</nav>
 
<!-- ===================== DETAIL ===================== -->
<div class="detail-wrap">
 
    <div class="detail-image">
        <c:if test="${product.bestSeller}">
            <span class="best-seller-pill">Best Seller</span>
        </c:if>
        <img src="${pageContext.request.contextPath}/images/${product.image}" alt="${product.productName}"
             onerror="this.src='${pageContext.request.contextPath}/images/placeholder.jpg';">
    </div>
 
    <div class="detail-info">
        <div class="product-cat">${fn:toUpperCase(product.categoryName)}</div>
 
        <h1>${product.productName}</h1>
 
        <div class="detail-rating">
            <span class="stars">
                <c:forEach begin="1" end="5" var="i">
                    <c:choose>
                        <c:when test="${i le product.rating}"><i class="fa-solid fa-star"></i></c:when>
                        <c:when test="${i - 0.5 le product.rating}"><i class="fa-solid fa-star-half-stroke"></i></c:when>
                        <c:otherwise><i class="fa-regular fa-star"></i></c:otherwise>
                    </c:choose>
                </c:forEach>
            </span>
            <span>${product.rating} (${product.ratingCount} reviews)</span>
        </div>
 
        <div class="detail-price">
            Rs. <fmt:formatNumber value="${product.price}" type="number" maxFractionDigits="0"/>
        </div>
 
        <p class="detail-desc">${product.description}</p>
 
        <c:choose>
            <c:when test="${product.stock gt 0}">
                <div class="stock-line">
                    <i class="fa-solid fa-check"></i>
                    In stock - ${product.stock} available
                </div>
            </c:when>
            <c:otherwise>
                <div class="stock-line out">
                    <i class="fa-solid fa-xmark"></i>
                    Out of stock
                </div>
            </c:otherwise>
        </c:choose>
 
        <div class="actions">
            <a href="${pageContext.request.contextPath}/cart?id=${product.productId}" class="btn btn-primary">
                <i class="fa-solid fa-bag-shopping"></i> Add to Cart
            </a>
            <a href="${pageContext.request.contextPath}/wishlist?id=${product.productId}" class="btn btn-outline">
                <i class="fa-regular fa-heart"></i> Wishlist
            </a>
        </div>
 
        <div class="meta">
            <div class="meta-row"><strong>Category:</strong> ${product.categoryName}</div>
            <div class="meta-row"><strong>Product ID:</strong> #${product.productId}</div>
            <div class="meta-row"><strong>Delivery:</strong> Within Kathmandu Valley in 3-5 days</div>
        </div>
    </div>
</div>
 
<!-- ===================== FOOTER ===================== -->
<jsp:include page="/WEB-INF/pages/footer.jsp" />
 
</body>
</html>