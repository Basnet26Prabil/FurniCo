<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
 <c:set var="activePage" value="home" scope="request" />
 
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - FurniCo</title>
 
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,500;0,600;0,700;1,400&family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
 
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
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
        <a href="${pageContext.request.contextPath}/login" title="Account" class="profile-icon"><i class="fa-regular fa-user"></i></a>
    </div>
</header>
 
<!-- LOGIN CARD -->
<section class="auth-wrap">
    <div class="auth-card">
 
        <div class="card-logo">
            <span class="logo-icon"><img src="${pageContext.request.contextPath}/images/logo.png" alt="FurniCo"></span>
            <span class="logo-text">Furni Co</span>
        </div>
 
        <h1>Welcome Back</h1>
        <p class="subtitle">Sign in to your account to continue</p>
 
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>
 
        <form action="${pageContext.request.contextPath}/login" method="post">
 
            <div class="field">
                <label>Email Address</label>
                <div class="input-wrap">
                    <i class="fa-regular fa-envelope left-icon"></i>
                    <input type="email" name="email" placeholder="you@example.com" required>
                </div>
            </div>
 
            <div class="field">
                <label>Password</label>
                <div class="input-wrap">
                    <i class="fa-solid fa-lock left-icon"></i>
                    <input type="password" name="password" placeholder="Enter your password" required id="pwd">
                    <button type="button" class="right-icon" onclick="togglePwd()" aria-label="Show or hide password">
                        <i class="fa-regular fa-eye-slash" id="pwdIcon"></i>
                    </button>
                </div>
            </div>
 
            <div class="row-line">
                <label class="remember">
                    <input type="checkbox" name="remember"> Remember me
                </label>
                <a href="${pageContext.request.contextPath}/login" class="forgot">Forgot password?</a>
            </div>
 
            <button class="btn-primary" type="submit">Sign In</button>
        </form>
 
        <p class="bottom-link">
            Don't have an account?
            <a href="${pageContext.request.contextPath}/register">Create Account</a>
        </p>
 
        <div class="divider">Admin Access</div>
 
        <a href="${pageContext.request.contextPath}/admin" class="btn-outline">
            <i class="fa-solid fa-table-columns"></i> Go to Admin Dashboard
        </a>
    </div>
</section>
 
<!-- FOOTER -->
<jsp:include page="/WEB-INF/pages/footer.jsp" />
 
<script>
    function togglePwd() {
        var pwd = document.getElementById("pwd");
        var icon = document.getElementById("pwdIcon");
        if (pwd.type === "password") {
            pwd.type = "text";
            icon.className = "fa-regular fa-eye";
        } else {
            pwd.type = "password";
            icon.className = "fa-regular fa-eye-slash";
        }
    }
</script>
 
</body>
</html>