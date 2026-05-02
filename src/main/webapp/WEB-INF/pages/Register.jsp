<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
 <c:set var="activePage" value="home" scope="request" />
 
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account - FurniCo</title>
 
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,500;0,600;0,700;1,400&family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
 
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/register.css">
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
 
<!-- REGISTER CARD -->
<section class="auth-wrap">
    <div class="auth-card">
 
        <div class="card-logo">
            <span class="logo-icon"><img src="${pageContext.request.contextPath}/images/logo.png" alt="FurniCo"></span>
            <span class="logo-text">Furni Co</span>
        </div>
 
        <h1>Create Your Account</h1>
        <p class="subtitle">Join us to start shopping for timeless furniture</p>
 
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>
 
        <form action="${pageContext.request.contextPath}/register" method="post">
 
            <div class="form-grid">
 
                <div class="field">
                    <label>First Name</label>
                    <div class="input-wrap">
                        <i class="fa-regular fa-user left-icon"></i>
                        <input type="text" name="firstName" placeholder="" required>
                    </div>
                </div>
 
                <div class="field">
                    <label>Last Name</label>
                    <div class="input-wrap">
                        <i class="fa-regular fa-user left-icon"></i>
                        <input type="text" name="lastName" placeholder="" required>
                    </div>
                </div>
 
                <div class="field full">
                    <label>Email Address</label>
                    <div class="input-wrap">
                        <i class="fa-regular fa-envelope left-icon"></i>
                        <input type="email" name="email" placeholder="you@example.com" required>
                    </div>
                </div>
 
                <div class="field">
                    <label>Phone Number</label>
                    <div class="input-wrap">
                        <i class="fa-solid fa-phone left-icon"></i>
                        <input type="tel" name="phone" placeholder="+977-98XXXXXXXX" required>
                    </div>
                </div>
 
                <div class="field">
                    <label>Date of Birth</label>
                    <div class="input-wrap">
                        <i class="fa-regular fa-calendar left-icon"></i>
                        <input type="date" name="dob" required>
                    </div>
                </div>
 
                <div class="field">
                    <label>Password</label>
                    <div class="input-wrap">
                        <i class="fa-solid fa-lock left-icon"></i>
                        <input type="password" name="password" placeholder="Min. 6 characters" required>
                    </div>
                </div>
 
                <div class="field">
                    <label>Confirm Password</label>
                    <div class="input-wrap">
                        <i class="fa-solid fa-lock left-icon"></i>
                        <input type="password" name="confirmPassword" placeholder="Re-enter password" required>
                    </div>
                </div>
 
            </div>
 
            <button class="btn-primary" type="submit">Create Account</button>
        </form>
 
        <p class="bottom-link">
            Already have an account?
            <a href="${pageContext.request.contextPath}/login">Sign In</a>
        </p>
    </div>
</section>
 
<!-- FOOTER -->
<jsp:include page="/WEB-INF/pages/footer.jsp" /> 
 
</body>
</html>
    