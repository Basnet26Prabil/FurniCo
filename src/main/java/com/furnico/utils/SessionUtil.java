package com.furnico.utils;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public class SessionUtil {

    public static void setAttribute(HttpServletRequest request, String key, Object value) {
        HttpSession session = request.getSession(); // create if not exists
        session.setAttribute(key, value);
    }

    public static Object getAttribute(HttpServletRequest request, String key) {
        HttpSession session = request.getSession(false); // don't create new
        if (session != null) {
            return session.getAttribute(key);
        }
        return null;
    }

    public static void invalidate(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }
}