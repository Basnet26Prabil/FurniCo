<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<header class="header">
    <a href="${pageContext.request.contextPath}/home" class="logo">
        <span class="logo-icon">
            <img src="${pageContext.request.contextPath}/images/logo.png" alt="FurniCo">
        </span>
        <!-- FIX: Removed stray underscores -->
        <span class="logo-text">Furni Co</span>
    </a>

    <nav class="main-nav">
        <a href="${pageContext.request.contextPath}/home"
           class="${activePage == 'home' ? 'active' : ''}">Home</a>
        <a href="${pageContext.request.contextPath}/products"
           class="${activePage == 'products' ? 'active' : ''}">Shop</a>
        <a href="${pageContext.request.contextPath}/about"
           class="${activePage == 'about' ? 'active' : ''}">About</a>
        <a href="${pageContext.request.contextPath}/contact"
           class="${activePage == 'contact' ? 'active' : ''}">Contact</a>
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