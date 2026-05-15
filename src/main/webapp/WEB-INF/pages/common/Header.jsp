<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
Cookie[] cookies = request.getCookies();
String lastVisit = null;

if (cookies != null) {
    for (Cookie c : cookies) {
        if ("lastVisit".equals(c.getName())) {
            lastVisit = java.net.URLDecoder.decode(c.getValue(), "UTF-8");
        }
    }
}
%>

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

<!-- COOKIE MESSAGE BAR -->
<div id="cookieMessage"
     style="background:#F8F5F2; padding:8px 15px; font-size:14px; border-bottom:1px solid #E5DFD8;">

    <% if (lastVisit != null) { %>
        👋 Welcome back! Last visit: <b><%= lastVisit %></b>
    <% } else { %>
        👋 Welcome to FurniCo!
    <% } %>

</div>

<!-- 2.5 SECOND FADE OUT SCRIPT -->
<script>
    setTimeout(function () {
        var msg = document.getElementById("cookieMessage");

        if (msg) {
            msg.style.transition = "opacity 0.8s ease";
            msg.style.opacity = "0";

            setTimeout(function () {
                msg.style.display = "none";
            }, 800);
        }
    }, 1000); // 1 seconds
</script>