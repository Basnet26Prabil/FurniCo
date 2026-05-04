<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="activePage" value="cart" scope="request" />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cart - FurniCo</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,500;0,600;0,700;1,400;1,500&family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/cart.css">
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
        <a href="${pageContext.request.contextPath}/wishlist" title="Wishlist">
            <i class="fa-regular fa-heart"></i>
        </a>
        <a href="${pageContext.request.contextPath}/cart" title="Cart" class="active-icon">
            <i class="fa-solid fa-bag-shopping"></i>
            <c:if test="${cartCount > 0}">
                <span class="cart-badge">${cartCount}</span>
            </c:if>
        </a>
        <a href="${pageContext.request.contextPath}/login" title="Account" class="profile-icon">
            <i class="fa-regular fa-user"></i>
        </a>
    </div>
</header>

<!-- ===================== PAGE HERO ===================== -->
<section class="page-hero">
    <div class="page-hero-text">
        <span class="eyebrow">Your Selection</span>
        <h1>Shopping <em>Cart</em></h1>
        <p>Review your items, adjust quantities, and proceed to request.</p>
    </div>
</section>

<!-- ===================== MAIN ===================== -->
<main class="cart-main">

    <c:choose>

        <%-- ── EMPTY CART ── --%>
        <c:when test="${empty cart}">
            <div class="empty-state">
                <div class="empty-icon"><i class="fa-solid fa-bag-shopping"></i></div>
                <h2>Your cart is empty</h2>
                <p>Looks like you haven't added anything yet. Start exploring!</p>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">
                    Browse Products
                </a>
            </div>
        </c:when>

        <%-- ── CART WITH ITEMS ── --%>
        <c:otherwise>
            <div class="cart-layout">

                <%-- ── LEFT: Items table ── --%>
                <div class="cart-items">

                    <div class="cart-items-header">
                        <h2>Cart Items <span class="items-count">(${cartCount})</span></h2>
                        <form method="post" action="${pageContext.request.contextPath}/cart"
                              onsubmit="return confirm('Clear your entire cart?')">
                            <input type="hidden" name="action" value="clear">
                            <button type="submit" class="btn-text-danger">
                                <i class="fa-regular fa-trash-can"></i> Clear cart
                            </button>
                        </form>
                    </div>

                    <c:forEach var="entry" items="${cart}">
                        <c:set var="item" value="${entry.value}" />
                        <c:set var="p"    value="${item.product}" />

                        <div class="cart-row">
                            <a href="${pageContext.request.contextPath}/product?id=${p.productId}"
                               class="cart-img-link">
                                <img src="${pageContext.request.contextPath}/images/${p.image}"
                                     alt="${p.productName}"
                                     onerror="this.src='${pageContext.request.contextPath}/images/placeholder.jpg';">
                            </a>

                            <div class="cart-row-info">
                                <div class="cart-row-cat">${p.categoryName}</div>
                                <a href="${pageContext.request.contextPath}/product?id=${p.productId}">
                                    <h3>${p.productName}</h3>
                                </a>
                                <div class="cart-row-unit-price">
                                    Rs. <fmt:formatNumber value="${p.price}" type="number" maxFractionDigits="0"/> each
                                </div>
                            </div>

                            <%-- Quantity control --%>
                            <div class="cart-qty-wrap">
                                <form method="post" action="${pageContext.request.contextPath}/cart"
                                      class="qty-form">
                                    <input type="hidden" name="action"    value="update">
                                    <input type="hidden" name="productId" value="${p.productId}">

                                    <button type="submit" name="qty" value="${item.quantity - 1}"
                                            class="qty-btn"
                                            <c:if test="${item.quantity <= 1}">disabled</c:if>>
                                        <i class="fa-solid fa-minus"></i>
                                    </button>

                                    <span class="qty-display">${item.quantity}</span>

                                    <button type="submit" name="qty" value="${item.quantity + 1}"
                                            class="qty-btn">
                                        <i class="fa-solid fa-plus"></i>
                                    </button>
                                </form>
                            </div>

                            <%-- Subtotal --%>
                            <div class="cart-row-subtotal">
                                Rs. <fmt:formatNumber value="${item.subtotal}" type="number" maxFractionDigits="0"/>
                            </div>

                            <%-- Remove --%>
                            <form method="post" action="${pageContext.request.contextPath}/cart">
                                <input type="hidden" name="action"    value="remove">
                                <input type="hidden" name="productId" value="${p.productId}">
                                <button type="submit" class="remove-btn" title="Remove item">
                                    <i class="fa-solid fa-xmark"></i>
                                </button>
                            </form>
                        </div>
                    </c:forEach>
                </div>

                <%-- ── RIGHT: Order Summary ── --%>
                <aside class="cart-summary">
                    <h2>Order Summary</h2>

                    <div class="summary-row">
                        <span>Subtotal (${cartCount} item<c:if test="${cartCount != 1}">s</c:if>)</span>
                        <span>Rs. <fmt:formatNumber value="${cartTotal}" type="number" maxFractionDigits="0"/></span>
                    </div>
                    <div class="summary-row">
                        <span>Delivery</span>
                        <span class="free-tag">Free</span>
                    </div>
                    <div class="summary-divider"></div>
                    <div class="summary-row summary-total">
                        <span>Total</span>
                        <span>Rs. <fmt:formatNumber value="${cartTotal}" type="number" maxFractionDigits="0"/></span>
                    </div>

                    <%-- Place a request for all items --%>
                    <a href="${pageContext.request.contextPath}/requests" class="btn btn-primary btn-block">
                        <i class="fa-regular fa-paper-plane"></i> Place Request
                    </a>

                    <a href="${pageContext.request.contextPath}/products" class="btn btn-outline btn-block">
                        Continue Shopping
                    </a>

                    <div class="trust-badges">
                        <div class="trust-item"><i class="fa-solid fa-shield-halved"></i> Secure &amp; Private</div>
                        <div class="trust-item"><i class="fa-solid fa-truck"></i> Free Delivery in KTM</div>
                        <div class="trust-item"><i class="fa-solid fa-rotate-left"></i> Easy Returns</div>
                    </div>
                </aside>

            </div>
        </c:otherwise>
    </c:choose>

</main>

<!-- ===================== FOOTER ===================== -->
<jsp:include page="/WEB-INF/pages/footer.jsp" />

</body>
</html>
