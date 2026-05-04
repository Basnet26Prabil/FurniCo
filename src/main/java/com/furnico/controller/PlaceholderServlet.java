package com.furnico.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;


@WebServlet(asyncSupported = true, urlPatterns = { "/placeholder" })
public class PlaceholderServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public PlaceholderServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pageTitle = "Coming Soon";
        String pageIcon  = "circle-question";

        request.setAttribute("pageTitle", pageTitle);
        request.setAttribute("pageIcon",  pageIcon);
        request.getRequestDispatcher("/WEB-INF/pages/Placeholder.jsp")
                .forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}