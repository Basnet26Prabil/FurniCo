<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Contact-Us - FurniCo</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;1,400&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Nav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contactus.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">

</head>
<body>

<%@ include file="/WEB-INF/pages/common/Header.jsp" %>

<main class="contact-container">

    <div class="contact-header">
        <h1>Get in Touch</h1>
        <p>
            We'd love to hear from you. Whether you have a question about features,
            pricing, or anything else, our team is ready to help.
        </p>
    </div>

    <div class="contact-wrapper">

        <!-- CONTACT INFO -->
        <div class="contact-info">

            <h2>Contact Information</h2>
            <p>Fill the form and we will reply within 24 hours.</p>

            <div class="info-item">
                <div class="info-icon">
                    <i class="fa-solid fa-phone"></i>
                </div>
                <div class="info-text">
                    <h4>Phone</h4>
                    <!-- FIX: plain text -->
                    <p>9800030036</p>
                </div>
            </div>

            <div class="info-item">
                <div class="info-icon">
                    <i class="fa-solid fa-envelope"></i>
                </div>
                <div class="info-text">
                    <h4>Email</h4>
                    <!-- FIX: Removed markdown link syntax -->
                    <p>support@Furnico.com</p>
                </div>
            </div>

            <div class="info-item">
                <div class="info-icon">
                    <i class="fa-solid fa-location-dot"></i>
                </div>
                <div class="info-text">
                    <h4>Address</h4>
                    <!-- FIX: Removed stray underscores -->
                    <p>Kathmandu, Nepal</p>
                </div>
            </div>

        </div>

        <!-- CONTACT FORM -->
        <div class="contact-form">

            <h2>Send a Message</h2>

            <c:if test="${not empty requestScope.message}">
                <div class="message-alert">${requestScope.message}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/contact" method="post">

                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="fullName" class="form-control"
                           placeholder="John Doe" required>
                </div>

                <div class="form-group">
                    <label>Email</label>
                    <!-- FIX: Removed markdown link syntax from placeholder -->
                    <input type="email" name="email" class="form-control"
                           placeholder="john@example.com" required>
                </div>

                <div class="form-group">
                    <label>Subject</label>
                    <input type="text" name="subject" class="form-control"
                           placeholder="How can we help?" required>
                </div>

                <div class="form-group">
                    <label>Message</label>
                    <textarea name="message" class="form-control"
                              placeholder="Your message..." required></textarea>
                </div>

                <button type="submit" class="submit-btn">Send Message</button>

            </form>

        </div>

    </div>

</main>

<%@ include file="/WEB-INF/pages/common/Footer.jsp" %>

</body>
</html>