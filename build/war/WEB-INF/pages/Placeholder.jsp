<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="activePage" value="home" scope="request" />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - FurniCo</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/logo.png">
 
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,500;0,600;1,400;1,500&family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
 
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/placeholder.css">
</head>
<body>
 
<!-- HEADER -->
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
        <a href="${pageContext.request.contextPath}/wishlist" title="Wishlist"><i class="fa-regular fa-heart"></i></a>
        <a href="${pageContext.request.contextPath}/cart" title="Cart">
            <i class="fa-solid fa-bag-shopping"></i>
            <span class="cart-badge">0</span>
        </a>
        <jsp:include page="/WEB-INF/pages/accountMenu.jsp" />
    </div>
</header>
 
<!-- PLACEHOLDER -->
<section class="placeholder-wrap">
    <div class="placeholder-card">
        <div class="big-icon"><i class="fa-solid fa-${pageIcon}"></i></div>
        <h1>${pageTitle} - Coming Soon</h1>
        <p>The <strong>${pageTitle}</strong> module is being built by other teammates as part of the FurniCo group project. This placeholder page is here so the navigation links work end-to-end for Milestone 1.</p>
        <a href="${pageContext.request.contextPath}/products" class="btn-primary">Continue shopping</a>
    </div>
</section>
 
<!-- FOOTER -->
<jsp:include page="/WEB-INF/pages/footer.jsp" /> 
</body>
</html>