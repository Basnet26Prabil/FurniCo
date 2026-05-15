package com.furnico.controller;
 
import com.furnico.utils.FurnicoException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
 
import java.io.IOException;
 
/**
 * GlobalExceptionHandler catches all unhandled exceptions and errors
 * in the FurniCo application and forwards them to appropriate error pages.
 * Configured as an error page handler in web.xml.
 */
@SuppressWarnings("serial")
@WebServlet("/error")
public class FurnicoErrorServlet extends HttpServlet {
 
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleError(request, response);
    }
 
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleError(request, response);
    }
 
    /**
     * Handles errors by extracting exception info and routing to the error JSP.
     * Distinguishes between AppException (user-facing) and system exceptions.
     */
    private void handleError(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
 
        // Retrieve standard servlet error attributes
        Integer statusCode = (Integer) request.getAttribute("jakarta.servlet.error.status_code");
        Throwable throwable = (Throwable) request.getAttribute("jakarta.servlet.error.exception");
        String requestUri = (String) request.getAttribute("jakarta.servlet.error.request_uri");
 
        // Default values
        int code = (statusCode != null) ? statusCode : 500;
        String userMessage;
        String errorTitle;
 
        // Determine message based on exception type or status code
        if (throwable instanceof FurnicoException appEx) {
            // Our custom exception — show user-friendly message
            code = appEx.getStatusCode();
            userMessage = appEx.getMessage();
            errorTitle = getTitleForCode(code);
        } else {
            // Generic fallback
            userMessage = getDefaultMessage(code);
            errorTitle = getTitleForCode(code);
        }
 
        // Set attributes for the error JSP
        request.setAttribute("errorCode", code);
        request.setAttribute("errorTitle", errorTitle);
        request.setAttribute("errorMessage", userMessage);
        request.setAttribute("requestUri", requestUri != null ? requestUri : "Unknown");
 
        // Log server-side for debugging (not shown to user)
        if (throwable != null) {
            log("[FurniCo Error] URI: " + requestUri + " | Code: " + code, throwable);
        }
 
        response.setStatus(code);
        request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
    }
 
    /**
     * Returns a human-readable title for common HTTP status codes.
     * @param code HTTP status code
     * @return title string
     */
    private String getTitleForCode(int code) {
        return switch (code) {
            case 400 -> "Bad Request";
            case 401 -> "Unauthorized";
            case 403 -> "Access Forbidden";
            case 404 -> "Page Not Found";
            case 405 -> "Method Not Allowed";
            case 500 -> "Internal Server Error";
            case 503 -> "Service Unavailable";
            default  -> "Something Went Wrong";
        };
    }
 
    /**
     * Returns a default user-friendly message for common HTTP status codes.
     * @param code HTTP status code
     * @return message string
     */
    private String getDefaultMessage(int code) {
        return switch (code) {
            case 400 -> "The request could not be understood. Please check your input and try again.";
            case 401 -> "You need to log in to access this page.";
            case 403 -> "You do not have permission to access this resource.";
            case 404 -> "The page you are looking for could not be found. It may have been moved or deleted.";
            case 405 -> "The HTTP method used is not allowed for this endpoint.";
            case 500 -> "An unexpected server error occurred. Our team has been notified. Please try again later.";
            case 503 -> "The service is temporarily unavailable. Please try again in a few moments.";
            default  -> "An unexpected error occurred. Please try again or contact support.";
        };
    }
    /**
     * Utility method to manually forward exceptions from servlets.
     * Use this in Login/Register/Product servlets.
     */
    public static void forwardException(
            HttpServletRequest request,
            HttpServletResponse response,
            Throwable e,
            int statusCode,
            String message) throws ServletException, IOException {

        request.setAttribute("jakarta.servlet.error.status_code", statusCode);
        request.setAttribute("jakarta.servlet.error.exception", e);
        request.setAttribute("jakarta.servlet.error.request_uri", request.getRequestURI());

        request.setAttribute("custom_message", message);

        request.getRequestDispatcher("/error").forward(request, response);
    }
}