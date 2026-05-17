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
    <title>Admin Users - FurniCo</title>
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
        <a href="${pageContext.request.contextPath}/admin">Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/products">Products</a>
        <a href="${pageContext.request.contextPath}/admin/categories">Categories</a>
        <a href="${pageContext.request.contextPath}/admin/orders">Orders</a>
        <a href="${pageContext.request.contextPath}/admin/users" class="active">Users</a>
        <jsp:include page="/WEB-INF/pages/accountMenu.jsp" />
    </nav>
</header>

<main class="admin-wrap">
    <section class="page-head">
        <div>
            <span class="eyebrow">Admin Dashboard</span>
            <h1>User Management</h1>
        </div>
        <a class="btn-outline" href="${pageContext.request.contextPath}/admin">
            <i class="fa-solid fa-chart-line"></i> Dashboard
        </a>
    </section>

    <section class="request-stats">
        <div class="stat-card">
            <span>Total Users</span>
            <strong>${totalUsers}</strong>
        </div>
        <div class="stat-card">
            <span>Customers</span>
            <strong>${customerCount}</strong>
        </div>
        <div class="stat-card">
            <span>Admins</span>
            <strong>${adminCount}</strong>
        </div>
        <div class="stat-card">
            <span>New This Week</span>
            <strong>${newUsersThisWeek}</strong>
        </div>
    </section>

    <section class="panel user-table-panel">
        <div class="panel-head compact">
            <h2>Registered Users</h2>
            <span class="record-count">${fn:length(users)} records</span>
        </div>

        <form class="admin-user-filter card-filter-row" action="${pageContext.request.contextPath}/admin/users" method="get">
            <div class="field">
                <label>Search</label>
                <div class="filter-input">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <input type="text" name="keyword" value="${keyword}" placeholder="Search by name, email, phone">
                </div>
            </div>
            <div class="field">
                <label>Role</label>
                <select name="role">
                    <option value="" ${empty role ? 'selected' : ''}>All roles</option>
                    <option value="customer" ${role eq 'customer' ? 'selected' : ''}>Customer</option>
                    <option value="admin" ${role eq 'admin' ? 'selected' : ''}>Admin</option>
                </select>
            </div>
            <div class="field">
                <label>Sort</label>
                <select name="sortBy">
                    <option value="" ${empty sortBy ? 'selected' : ''}>Newest first</option>
                    <option value="name_asc" ${sortBy eq 'name_asc' ? 'selected' : ''}>Name A-Z</option>
                    <option value="name_desc" ${sortBy eq 'name_desc' ? 'selected' : ''}>Name Z-A</option>
                    <option value="email_asc" ${sortBy eq 'email_asc' ? 'selected' : ''}>Email A-Z</option>
                    <option value="role" ${sortBy eq 'role' ? 'selected' : ''}>Role</option>
                </select>
            </div>
            <div class="filter-actions">
                <button type="submit"><i class="fa-solid fa-filter"></i> Apply</button>
                <a href="${pageContext.request.contextPath}/admin/users">
                    <i class="fa-solid fa-rotate-left"></i> Reset
                </a>
            </div>
        </form>

        <div class="table-wrap">
            <table class="user-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>DOB</th>
                        <th>Role</th>
                        <th>Joined</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="user" items="${users}">
                        <tr>
                            <td>#${user.userId}</td>
                            <td>
                                <div class="user-cell">
                                    <span>${fn:substring(user.firstName, 0, 1)}${fn:substring(user.lastName, 0, 1)}</span>
                                    <strong>${user.firstName} ${user.lastName}</strong>
                                </div>
                            </td>
                            <td>${user.email}</td>
                            <td>${user.phone}</td>
                            <td><fmt:formatDate value="${user.dob}" pattern="dd MMM yyyy"/></td>
                            <td><span class="status-badge ${user.role}">${user.role}</span></td>
                            <td><fmt:formatDate value="${user.createdAt}" pattern="dd MMM yyyy"/></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty users}">
                        <tr>
                            <td colspan="7" class="empty-row">No users matched the selected filters.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </section>
</main>

</body>
</html>
