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
    <title>Admin Orders - FurniCo</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/logo.png">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@500;600;700&family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css?v=5">
</head>
<body>

<header class="header">
    <a href="${pageContext.request.contextPath}/home" class="logo">
        <span class="logo-icon"><img src="${pageContext.request.contextPath}/images/logo.png" alt="FurniCo"></span>
        <span class="logo-text">Furni Co</span>
    </a>

    <nav class="main-nav">
        <a href="${pageContext.request.contextPath}/home">Storefront</a>
        <a href="${pageContext.request.contextPath}/admin/products">Products</a>
        <a href="${pageContext.request.contextPath}/admin/orders" class="active">Orders</a>
        <jsp:include page="/WEB-INF/pages/accountMenu.jsp" />
    </nav>
</header>

<main class="admin-wrap">
    <section class="page-head">
        <div>
            <span class="eyebrow">Admin Dashboard</span>
            <h1>Orders and Requests</h1>
        </div>
        <a class="btn-outline" href="${pageContext.request.contextPath}/admin/products">
            <i class="fa-solid fa-boxes-stacked"></i> Products
        </a>
    </section>

    <c:if test="${param.success eq 'approved'}">
        <div class="success">Request approved successfully.</div>
    </c:if>
    <c:if test="${param.success eq 'rejected'}">
        <div class="success">Request rejected successfully.</div>
    </c:if>

    <section class="request-stats">
        <div class="stat-card">
            <span>Pending Requests</span>
            <strong><fmt:formatNumber value="${pendingCount}" minIntegerDigits="2"/></strong>
            <small>need review</small>
        </div>
        <div class="stat-card">
            <span>Approved Today</span>
            <strong><fmt:formatNumber value="${approvedTodayCount}" minIntegerDigits="2"/></strong>
            <small>ready to process</small>
        </div>
        <div class="stat-card">
            <span>Low Stock Alerts</span>
            <strong><fmt:formatNumber value="${lowStockCount}" minIntegerDigits="2"/></strong>
            <small>check product stock</small>
        </div>
        <div class="stat-card wide">
            <span>Most Requested Category</span>
            <strong>${mostRequestedCategory}</strong>
            <small>based on active requests</small>
        </div>
    </section>

    <section class="panel request-filter-panel">
        <form class="admin-request-filter" action="${pageContext.request.contextPath}/admin/orders" method="get">
            <strong>Filter Requests</strong>
            <input type="text" name="keyword" value="${keyword}" placeholder="Search by customer/product">
            <select name="status">
                <option value="" ${empty status ? 'selected' : ''}>Status: All</option>
                <option value="pending" ${status eq 'pending' ? 'selected' : ''}>Pending</option>
                <option value="approved" ${status eq 'approved' ? 'selected' : ''}>Approved</option>
                <option value="rejected" ${status eq 'rejected' ? 'selected' : ''}>Rejected</option>
            </select>
            <select name="dateRange">
                <option value="" ${empty dateRange ? 'selected' : ''}>Date: All</option>
                <option value="today" ${dateRange eq 'today' ? 'selected' : ''}>Today</option>
                <option value="week" ${dateRange eq 'week' ? 'selected' : ''}>This week</option>
                <option value="month" ${dateRange eq 'month' ? 'selected' : ''}>This month</option>
            </select>
            <button type="submit">Apply</button>
            <a href="${pageContext.request.contextPath}/admin/orders">Reset</a>
        </form>
    </section>

    <section class="request-layout">
        <div class="panel request-list-panel">
            <div class="panel-head compact">
                <h2>Customer Requests</h2>
                <span class="record-count">${fn:length(requests)} records</span>
            </div>

            <div class="table-wrap">
                <table class="request-table">
                    <thead>
                        <tr>
                            <th>Req ID</th>
                            <th>Customer</th>
                            <th>Product</th>
                            <th>Qty</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${requests}">
                            <tr class="${selectedRequest.requestId == item.requestId ? 'selected-row' : ''}">
                                <td>REQ-${item.requestId}</td>
                                <td>
                                    <strong>${item.customerName}</strong>
                                    <small>${item.customerEmail}</small>
                                </td>
                                <td>${item.productName}</td>
                                <td>${item.quantity}</td>
                                <td><span class="status-badge ${item.status}">${item.status}</span></td>
                                <td>
                                    <a class="table-view-btn" href="${pageContext.request.contextPath}/admin/orders?selectedId=${item.requestId}&keyword=${keyword}&status=${status}&dateRange=${dateRange}">
                                        View
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty requests}">
                            <tr>
                                <td colspan="6" class="empty-row">No customer requests found.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>

        <aside class="panel request-detail-panel">
            <h2>Request Detail</h2>
            <p class="detail-subtitle">Selected request preview</p>

            <c:choose>
                <c:when test="${not empty selectedRequest}">
                    <div class="detail-line"><strong>Customer:</strong> ${selectedRequest.customerName}</div>
                    <div class="detail-line"><strong>Email:</strong> ${selectedRequest.customerEmail}</div>
                    <div class="detail-line"><strong>Product:</strong> ${selectedRequest.productName}</div>
                    <div class="detail-line"><strong>Quantity:</strong> ${selectedRequest.quantity}</div>
                    <div class="detail-line"><strong>Status:</strong> <span class="status-badge ${selectedRequest.status}">${selectedRequest.status}</span></div>
                    <div class="detail-line">
                        <strong>Requested:</strong>
                        <fmt:formatDate value="${selectedRequest.requestedAt}" pattern="dd MMM yyyy"/>
                    </div>

                    <div class="message-box">
                        <strong>Message:</strong>
                        <p>
                            <c:choose>
                                <c:when test="${not empty selectedRequest.note}">${selectedRequest.note}</c:when>
                                <c:otherwise>No additional note provided.</c:otherwise>
                            </c:choose>
                        </p>
                    </div>

                    <c:if test="${selectedRequest.status eq 'pending'}">
                        <div class="request-actions">
                            <form action="${pageContext.request.contextPath}/admin/orders" method="post">
                                <input type="hidden" name="action" value="approve">
                                <input type="hidden" name="requestId" value="${selectedRequest.requestId}">
                                <button type="submit" class="dispatch-btn">Approve</button>
                            </form>
                            <form action="${pageContext.request.contextPath}/admin/orders" method="post">
                                <input type="hidden" name="action" value="reject">
                                <input type="hidden" name="requestId" value="${selectedRequest.requestId}">
                                <button type="submit" class="reject-btn">Reject</button>
                            </form>
                        </div>
                    </c:if>
                </c:when>
                <c:otherwise>
                    <p class="empty-detail">Select a request to view details.</p>
                </c:otherwise>
            </c:choose>
        </aside>
    </section>
</main>

</body>
</html>
