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
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/logo.png">
 
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
        <jsp:include page="/WEB-INF/pages/accountMenu.jsp" />
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

        <c:if test="${not empty errors}">
            <div class="error">
                <c:forEach var="message" items="${errors}">
                    <div>${message}</div>
                </c:forEach>
            </div>
        </c:if>

        <c:if test="${not empty success}">
            <div class="success">${success}</div>
        </c:if>
 
        <form action="${pageContext.request.contextPath}/login" method="post" id="loginForm">
 
            <div class="field">
                <label>Email Address</label>
                <div class="input-wrap">
                    <i class="fa-regular fa-envelope left-icon"></i>
                    <input type="email" name="email" id="loginEmail" placeholder="you@example.com" required value="${not empty email ? email : cookie.rememberedEmail.value}">
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
                    <input type="checkbox" name="remember" ${not empty cookie.rememberedEmail ? 'checked' : ''}> Remember me
                </label>
                <a href="${pageContext.request.contextPath}/login" class="forgot">Forgot password?</a>
            </div>
 
            <button class="btn-primary" type="submit" id="loginSubmitBtn">Sign In</button>
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
    const FORM_SECRET_KEY = "FurniCoSecretKey";

    function bytesToBase64(bytes) {
        var binary = "";
        for (var i = 0; i < bytes.length; i++) {
            binary += String.fromCharCode(bytes[i]);
        }
        return btoa(binary);
    }

    async function encryptFormValue(value) {
        var encoder = new TextEncoder();
        var key = await crypto.subtle.importKey(
            "raw",
            encoder.encode(FORM_SECRET_KEY),
            { name: "AES-GCM" },
            false,
            ["encrypt"]
        );
        var iv = crypto.getRandomValues(new Uint8Array(12));
        var encrypted = new Uint8Array(await crypto.subtle.encrypt(
            { name: "AES-GCM", iv: iv },
            key,
            encoder.encode(value)
        ));
        var payload = new Uint8Array(iv.length + encrypted.length);
        payload.set(iv, 0);
        payload.set(encrypted, iv.length);
        return bytesToBase64(payload);
    }

    document.getElementById("loginForm").addEventListener("submit", async function(event) {
        if (this.dataset.encrypted === "true") {
            return;
        }

        event.preventDefault();

        var submitButton = document.getElementById("loginSubmitBtn");
        var emailInput = document.getElementById("loginEmail");
        var passwordInput = document.getElementById("pwd");

        try {
            submitButton.disabled = true;
            submitButton.textContent = "Encrypting...";

            emailInput.value = await encryptFormValue(emailInput.value);
            passwordInput.value = await encryptFormValue(passwordInput.value);

            this.dataset.encrypted = "true";
            this.submit();
        } catch (error) {
            submitButton.disabled = false;
            submitButton.textContent = "Sign In";
            alert("Could not encrypt the login details. Please reload the page and try again.");
        }
    });

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
