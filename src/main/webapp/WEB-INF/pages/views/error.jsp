<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%
    // Read Tomcat's automatic error attributes
    Integer statusCode = (Integer) request.getAttribute("jakarta.servlet.error.status_code");
    String message = (String) request.getAttribute("jakarta.servlet.error.message");

    // Set errorCode
    if (statusCode == null) statusCode = 500;
    request.setAttribute("errorCode", statusCode);

    // Set errorTitle based on code
    String title = "Unexpected Error";
    if (statusCode == 404) title = "Page Not Found";
    else if (statusCode == 401) title = "Unauthorized";
    else if (statusCode == 403) title = "Access Denied";
    else if (statusCode == 500) title = "Server Error";
    request.setAttribute("errorTitle", title);

    // Set errorMessage only if not already set by a servlet
    if (request.getAttribute("errorMessage") == null) {
        if (message != null && !message.isEmpty()) {
            request.setAttribute("errorMessage", message);
        }
    }
%>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error ${errorCode} | FurniCo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/error.css">
</head>
<body>

<div class="error-container">

    <a href="${pageContext.request.contextPath}/home" class="logo">FURNI<span>CO</span></a>

    <div class="error-code">${errorCode}</div>
    <div class="error-title">${errorTitle}</div>

    <div class="error-message">
        <c:choose>
            <c:when test="${not empty errorMessage}">
                ${errorMessage}
            </c:when>
            <c:otherwise>
                An unexpected error has occurred. Please try again or return to the homepage.
            </c:otherwise>
        </c:choose>
    </div>

    <div class="btn-group">
        <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">
            ← Back to Home
        </a>
        <a href="javascript:history.back()" class="btn btn-secondary">
            Go Back
        </a>
    </div>

</div>

</body>
</html>
