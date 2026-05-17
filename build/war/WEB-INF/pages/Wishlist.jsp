<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<c:set var="activePage" value="wishlist" scope="request" />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Wishlist - FurniCo</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/logo.png">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,500;0,600;0,700;1,400;1,500&family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/wishlist.css">
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
        <a href="${pageContext.request.contextPath}/products">Shop</a>
        <a href="${pageContext.request.contextPath}/about">About</a>
        <a href="${pageContext.request.contextPath}/contact">Contact</a>
    </nav>

    <div class="header-icons">
        <a href="${pageContext.request.contextPath}/wishlist" title="Wishlist" class="active-icon">
            <i class="fa-solid fa-heart"></i>
            <c:if test="${wishlistCount > 0}">
                <span class="cart-badge">${wishlistCount}</span>
            </c:if>
        </a>
        <a href="${pageContext.request.contextPath}/cart" title="Cart">
            <i class="fa-solid fa-bag-shopping"></i>
        </a>
        <jsp:include page="/WEB-INF/pages/accountMenu.jsp" />
    </div>
</header>

<!-- ===================== PAGE HERO ===================== -->
<section class="page-hero">
    <div class="page-hero-text">
        <span class="eyebrow">Your Saved Items</span>
        <h1>My <em>Wishlist</em></h1>
        <p>Items you love, saved for later. Move them to your cart when you're ready.</p>
    </div>
</section>

<!-- ===================== MAIN CONTENT ===================== -->
<main class="wishlist-main">

    <c:choose>
        <%-- ── EMPTY STATE ── --%>
        <c:when test="${empty wishlistProducts}">
            <div class="empty-state">
                <div class="empty-icon"><i class="fa-regular fa-heart"></i></div>
                <h2>Your wishlist is empty</h2>
                <p>Browse our collection and save the pieces you love.</p>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">
                    Explore Products
                </a>
            </div>
        </c:when>

        <%-- ── WISHLIST GRID ── --%>
        <c:otherwise>
            <div class="wishlist-header-row">
                <p class="wishlist-count">${wishlistCount} item<c:if test="${wishlistCount != 1}">s</c:if> saved</p>

                <%-- Clear all button --%>
                <form method="post" action="${pageContext.request.contextPath}/wishlist"
                      onsubmit="return confirm('Remove all items from your wishlist?')">
                    <input type="hidden" name="action" value="clear">
                    <button type="submit" class="btn-text-danger">
                        <i class="fa-regular fa-trash-can"></i> Clear all
                    </button>
                </form>
            </div>

            <div class="wishlist-grid">
                <c:forEach var="p" items="${wishlistProducts}">
                    <div class="wishlist-card">
                        <%-- Remove from wishlist --%>
                        <form method="post" action="${pageContext.request.contextPath}/wishlist"
                              class="remove-form">
                            <input type="hidden" name="action"    value="remove">
                            <input type="hidden" name="productId" value="${p.productId}">
                            <button type="submit" class="remove-btn" title="Remove from wishlist">
                                <i class="fa-solid fa-xmark"></i>
                            </button>
                        </form>

                        <a href="${pageContext.request.contextPath}/product?id=${p.productId}" class="card-image-link">
                            <div class="card-image">
                                <c:if test="${p.bestSeller}">
                                    <span class="best-seller-pill">Best Seller</span>
                                </c:if>
                                <img src="${pageContext.request.contextPath}/images/${p.image}"
                                     alt="${p.productName}"
                                     onerror="this.src='${pageContext.request.contextPath}/images/placeholder.jpg';">
                            </div>
                        </a>

                        <div class="card-body">
                            <div class="product-cat">${fn:toUpperCase(p.categoryName)}</div>
                            <a href="${pageContext.request.contextPath}/product?id=${p.productId}">
                                <h3 class="product-name">${p.productName}</h3>
                            </a>

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
                                <span class="rating-count">(${p.ratingCount})</span>
                            </div>

                            <div class="card-footer">
                                <span class="product-price">
                                    Rs. <fmt:formatNumber value="${p.price}" type="number" maxFractionDigits="0"/>
                                </span>

                                <c:choose>
                                    <c:when test="${p.stock > 0}">
                                        <%-- Add to Cart --%>
                                        <form method="post" action="${pageContext.request.contextPath}/cart">
                                            <input type="hidden" name="action"    value="add">
                                            <input type="hidden" name="productId" value="${p.productId}">
                                            <input type="hidden" name="qty"       value="1">
                                            <input type="hidden" name="redirectTo" value="/cart">
                                            <button type="submit" class="cart-btn" title="Add to Cart">
                                                <i class="fa-solid fa-bag-shopping"></i>
                                            </button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="out-of-stock-badge">Out of stock</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <%-- Apply / Request button --%>
                            <c:if test="${p.stock <= 0 || p.stock < 5}">
                                <a href="${pageContext.request.contextPath}/product?id=${p.productId}#apply"
                                   class="apply-link">
                                    <i class="fa-regular fa-paper-plane"></i> Request this item
                                </a>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <%-- Continue shopping --%>
            <div class="continue-row">
                <a href="${pageContext.request.contextPath}/products" class="btn btn-outline">
                    <i class="fa-solid fa-arrow-left"></i> Continue Shopping
                </a>
                <a href="${pageContext.request.contextPath}/cart" class="btn btn-primary">
                    View Cart <i class="fa-solid fa-arrow-right"></i>
                </a>
            </div>
        </c:otherwise>
    </c:choose>

</main>

<!-- ===================== FOOTER ===================== -->
<jsp:include page="/WEB-INF/pages/footer.jsp" />

</body>
</html>
