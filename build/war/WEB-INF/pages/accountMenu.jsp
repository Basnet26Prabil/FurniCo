<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:choose>
    <c:when test="${not empty sessionScope.userName}">
        <div class="account-menu-wrap">
            <button class="account-link" type="button" aria-label="Account menu">
                <span class="profile-icon"><i class="fa-regular fa-user"></i></span>
                <span class="account-meta">
                    <span class="account-name">${sessionScope.userName}</span>
                    <span class="account-role">${sessionScope.userRole}</span>
                </span>
                <i class="fa-solid fa-chevron-down account-caret"></i>
            </button>
            <div class="account-dropdown">
                <c:if test="${sessionScope.userRole eq 'admin'}">
                    <a href="${pageContext.request.contextPath}/admin/products">
                        <i class="fa-solid fa-table-columns"></i>
                        Admin Panel
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/orders">
                        <i class="fa-solid fa-clipboard-list"></i>
                        Customer Requests
                    </a>
                </c:if>
                <a href="${pageContext.request.contextPath}/logout">
                    <i class="fa-solid fa-arrow-right-from-bracket"></i>
                    Logout
                </a>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <a href="${pageContext.request.contextPath}/login" title="Account" class="profile-icon">
            <i class="fa-regular fa-user"></i>
        </a>
    </c:otherwise>
</c:choose>
