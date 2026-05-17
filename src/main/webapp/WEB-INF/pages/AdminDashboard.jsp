<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - FurniCo</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/logo.png">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@500;600;700&family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css?v=6">
</head>
<body>

<header class="header">
    <a href="${pageContext.request.contextPath}/home" class="logo">
        <span class="logo-icon"><img src="${pageContext.request.contextPath}/images/logo.png" alt="FurniCo"></span>
        <span class="logo-text">Furni Co</span>
    </a>

    <nav class="main-nav">
        <a href="${pageContext.request.contextPath}/admin" class="active">Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/products">Products</a>
        <a href="${pageContext.request.contextPath}/admin/categories">Categories</a>
        <a href="${pageContext.request.contextPath}/admin/orders">Orders</a>
        <a href="${pageContext.request.contextPath}/admin/users">Users</a>
        <jsp:include page="/WEB-INF/pages/accountMenu.jsp" />
    </nav>
</header>

<main class="admin-wrap">
    <section class="page-head">
        <div>
            <span class="eyebrow">Admin Dashboard</span>
            <h1>FurniCo Overview</h1>
        </div>
        <a class="btn-outline" href="${pageContext.request.contextPath}/admin/orders">
            <i class="fa-solid fa-clipboard-list"></i> Review requests
        </a>
    </section>

    <section class="dashboard-grid">
        <a class="dashboard-card" href="${pageContext.request.contextPath}/admin/products">
            <span>Products</span>
            <strong>${productCount}</strong>
        </a>
        <a class="dashboard-card" href="${pageContext.request.contextPath}/admin/orders?status=pending">
            <span>Pending Requests</span>
            <strong><fmt:formatNumber value="${pendingCount}" minIntegerDigits="2"/></strong>
        </a>
        <a class="dashboard-card" href="${pageContext.request.contextPath}/admin/users">
            <span>Users</span>
            <strong>${totalUsers}</strong>
        </a>
        <a class="dashboard-card warning" href="${pageContext.request.contextPath}/admin/orders">
            <span>Low Stock</span>
            <strong><fmt:formatNumber value="${lowStockCount}" minIntegerDigits="2"/></strong>
        </a>
    </section>

    <section class="dashboard-panels">
        <div class="panel">
            <div class="panel-head compact">
                <h2>Recent Requests</h2>
                <a class="small-link" href="${pageContext.request.contextPath}/admin/orders">View all</a>
            </div>
            <div class="mini-list">
                <c:forEach var="item" items="${latestRequests}" begin="0" end="4">
                    <a href="${pageContext.request.contextPath}/admin/orders?selectedId=${item.requestId}">
                        <span>
                            <strong>${item.productName}</strong>
                            <small>${item.customerName} • Qty ${item.quantity}</small>
                        </span>
                        <span class="status-badge ${item.status}">${item.status}</span>
                    </a>
                </c:forEach>
                <c:if test="${empty latestRequests}">
                    <p class="empty-detail">No request activity yet.</p>
                </c:if>
            </div>
        </div>

        <div class="panel">
            <div class="panel-head compact">
                <h2>Newest Users</h2>
                <a class="small-link" href="${pageContext.request.contextPath}/admin/users">View all</a>
            </div>
            <div class="mini-list">
                <c:forEach var="user" items="${latestUsers}" begin="0" end="4">
                    <a href="${pageContext.request.contextPath}/admin/users?keyword=${user.email}">
                        <span>
                            <strong>${user.firstName} ${user.lastName}</strong>
                            <small>${user.email}</small>
                        </span>
                        <span class="status-badge ${user.role}">${user.role}</span>
                    </a>
                </c:forEach>
                <c:if test="${empty latestUsers}">
                    <p class="empty-detail">No users found.</p>
                </c:if>
            </div>
        </div>
    </section>
</main>

</body>
</html>
