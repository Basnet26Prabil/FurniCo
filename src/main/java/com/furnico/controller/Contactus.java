package com.furnico.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/contact")
public class Contactus extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // OPEN CONTACT PAGE
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/WEB-INF/pages/Contactus.jsp")
               .forward(request, response);
    }

    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        // VALIDATION
        if (fullName == null || email == null || subject == null || message == null ||
            fullName.trim().isEmpty() || email.trim().isEmpty() ||
            subject.trim().isEmpty() || message.trim().isEmpty()) {

            request.setAttribute("message", "Error: All fields are required.");
            request.setAttribute("messageType", "error");

            request.getRequestDispatcher("/WEB-INF/pages/Contactus.jsp")
                   .forward(request, response);
            return;
        }

        // SUCCESS 
        System.out.println("----- Contact Form Submission -----");
        System.out.println("Name: " + fullName);
        System.out.println("Email: " + email);
        System.out.println("Subject: " + subject);
        System.out.println("Message: " + message);
        System.out.println("-----------------------------------");

        request.setAttribute("message",
                "Thank you " + fullName + "! Your message has been sent successfully.");
        request.setAttribute("messageType", "success");

        request.getRequestDispatcher("/WEB-INF/pages/Contactus.jsp")
               .forward(request, response);
    }
}