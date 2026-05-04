<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.HttpServletRequest" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="activePage" value="requests" scope="request" />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Requests - FurniCo</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,500;0,600;0,700;1,400;1,500&family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/requests.css">
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
        <a href="${pageContext.request.contextPath}/cart" title="Cart">
            <i class="fa-solid fa-bag-shopping"></i>
        </a>
        <a href="${pageContext.request.contextPath}/login" title="Account" class="profile-icon">
            <i class="fa-regular fa-user"></i>
        </a>
    </div>
</header>

<!-- ===================== PAGE HERO ===================== -->
<section class="page-hero">
    <div class="page-hero-text">
        <span class="eyebrow">Your Account</span>
        <h1>My <em>Requests</em></h1>
        <p>Track all the product requests you've submitted. Pending requests can be cancelled.</p>
    </div>
</section>

<!-- ===================== MAIN ===================== -->
<main class="requests-main">

    <%-- Flash messages --%>
    <c:if test="${param.success eq 'submitted'}">
        <div class="alert alert-success">
            <i class="fa-solid fa-circle-check"></i>
            Your request has been submitted successfully! Our team will review it shortly.
        </div>
    </c:if>
    <c:if test="${param.success eq 'cancelled'}">
        <div class="alert alert-info">
            <i class="fa-solid fa-circle-info"></i>
            Your request has been cancelled.
        </div>
    </c:if>
    <c:if test="${not empty requestError}">
        <div class="alert alert-error">
            <i class="fa-solid fa-circle-exclamation"></i>
            ${requestError}
        </div>
    </c:if>

    <c:choose>

        <%-- ── NO REQUESTS ── --%>
        <c:when test="${empty requests}">
            <div class="empty-state">
                <div class="empty-icon"><i class="fa-regular fa-paper-plane"></i></div>
                <h2>No requests yet</h2>
                <p>Browse our products and use the <strong>Apply</strong> button to request items you're interested in.</p>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">
                    Browse Products
                </a>
            </div>
        </c:when>

        <%-- ── REQUESTS TABLE ── --%>
        <c:otherwise>
            <div class="requests-table-wrap">
                <table class="requests-table">
                    <thead>
                        <tr>
                            <th>Product</th>
                            <th>Unit Price</th>
                            <th>Qty</th>
                            <th>Total</th>
                            <th>Note</th>
                            <th>Date</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="req" items="${requests}">
                            <tr>
                                <td class="td-product">
                                    <img src="${pageContext.request.contextPath}/images/${req.productImage}"
                                         alt="${req.productName}"
                                         onerror="this.src='${pageContext.request.contextPath}/images/placeholder.jpg';">
                                    <span>${req.productName}</span>
                                </td>
                                <td>Rs. <fmt:formatNumber value="${req.productPrice}" type="number" maxFractionDigits="0"/></td>
                                <td>${req.quantity}</td>
                                <td>Rs. <fmt:formatNumber value="${req.productPrice * req.quantity}" type="number" maxFractionDigits="0"/></td>
                                <td class="td-note">
                                    <c:choose>
                                        <c:when test="${not empty req.note}">${req.note}</c:when>
                                        <c:otherwise><span class="muted">—</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <fmt:formatDate value="${req.requestedAt}" pattern="dd MMM yyyy"/>
                                </td>
                                <td>
                                    <span class="status-badge status-${req.status}">
                                        <c:choose>
                                            <c:when test="${req.status eq 'pending'}">
                                                <i class="fa-regular fa-clock"></i> Pending
                                            </c:when>
                                            <c:when test="${req.status eq 'approved'}">
                                                <i class="fa-solid fa-check"></i> Approved
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fa-solid fa-xmark"></i> Rejected
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>
                                <td>
                                    <c:if test="${req.status eq 'pending'}">
                                        <form method="post"
                                              action="${pageContext.request.contextPath}/requests"
                                              onsubmit="return confirm('Cancel this request?')">
                                            <input type="hidden" name="action"     value="cancel">
                                            <input type="hidden" name="requestId"  value="${req.requestId}">
                                            <button type="submit" class="btn-cancel">
                                                Cancel
                                            </button>
                                        </form>
                                    </c:if>
                                    <c:if test="${req.status ne 'pending'}">
                                        <span class="muted">—</span>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <div class="continue-row">
                <a href="${pageContext.request.contextPath}/products" class="btn btn-outline">
                    <i class="fa-solid fa-arrow-left"></i> Continue Shopping
                </a>
            </div>
        </c:otherwise>
    </c:choose>

</main>

<!-- ===================== FOOTER ===================== -->
<jsp:include page="/WEB-INF/pages/footer.jsp" />

</body>
</html>