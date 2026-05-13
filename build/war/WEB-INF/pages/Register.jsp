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
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/logo.png">
 
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
        <jsp:include page="/WEB-INF/pages/accountMenu.jsp" />
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

        <c:if test="${not empty errors}">
            <div class="error">
                <c:forEach var="message" items="${errors}">
                    <div>${message}</div>
                </c:forEach>
            </div>
        </c:if>
 
        <form action="${pageContext.request.contextPath}/register" method="post" id="registerForm">
 
            <div class="form-grid">
 
                <div class="field">
                    <label>First Name</label>
                    <div class="input-wrap">
                        <i class="fa-regular fa-user left-icon"></i>
                        <input type="text" name="firstName" placeholder="" required value="${firstName}">
                    </div>
                </div>
 
                <div class="field">
                    <label>Last Name</label>
                    <div class="input-wrap">
                        <i class="fa-regular fa-user left-icon"></i>
                        <input type="text" name="lastName" placeholder="" required value="${lastName}">
                    </div>
                </div>
 
                <div class="field full">
                    <label>Email Address</label>
                    <div class="input-wrap">
                        <i class="fa-regular fa-envelope left-icon"></i>
                        <input type="email" name="email" id="registerEmail" placeholder="you@example.com" required value="${email}">
                    </div>
                </div>
 
                <div class="field">
                    <label>Phone Number</label>
                    <div class="input-wrap">
                        <i class="fa-solid fa-phone left-icon"></i>
                        <input type="tel" name="phone" placeholder="+977-98XXXXXXXX" required value="${phone}">
                    </div>
                </div>
 
                <div class="field">
                    <label>Date of Birth</label>
                    <div class="input-wrap">
                        <i class="fa-regular fa-calendar left-icon"></i>
                        <input type="date" name="dob" required value="${dob}">
                    </div>
                </div>
 
                <div class="field">
                    <label>Password</label>
                    <div class="input-wrap">
                        <i class="fa-solid fa-lock left-icon"></i>
                        <input type="password" name="password" id="registerPassword" placeholder="Min. 6 characters" required>
                    </div>
                </div>
 
                <div class="field">
                    <label>Confirm Password</label>
                    <div class="input-wrap">
                        <i class="fa-solid fa-lock left-icon"></i>
                        <input type="password" name="confirmPassword" id="registerConfirmPassword" placeholder="Re-enter password" required>
                    </div>
                </div>
 
            </div>
 
            <button class="btn-primary" type="submit" id="registerSubmitBtn">Create Account</button>
        </form>
 
        <p class="bottom-link">
            Already have an account?
            <a href="${pageContext.request.contextPath}/login">Sign In</a>
        </p>
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

    document.getElementById("registerForm").addEventListener("submit", async function(event) {
        if (this.dataset.encrypted === "true") {
            return;
        }

        event.preventDefault();

        var submitButton = document.getElementById("registerSubmitBtn");
        var emailInput = document.getElementById("registerEmail");
        var passwordInput = document.getElementById("registerPassword");
        var confirmPasswordInput = document.getElementById("registerConfirmPassword");

        try {
            submitButton.disabled = true;
            submitButton.textContent = "Encrypting...";

            emailInput.value = await encryptFormValue(emailInput.value);
            passwordInput.value = await encryptFormValue(passwordInput.value);
            confirmPasswordInput.value = await encryptFormValue(confirmPasswordInput.value);

            this.dataset.encrypted = "true";
            this.submit();
        } catch (error) {
            submitButton.disabled = false;
            submitButton.textContent = "Create Account";
            alert("Could not encrypt the registration details. Please reload the page and try again.");
        }
    });
</script>
 
</body>
</html>
    
