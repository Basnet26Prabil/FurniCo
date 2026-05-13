package com.furnico.utils;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

import com.furnico.model.ProductModel;

public class ValidationUtil {

    private static final Pattern NAME_PATTERN = Pattern.compile("^[A-Za-z ]{2,50}$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^(\\+977[- ]?)?9[78][0-9]{8}$");
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");

    private ValidationUtil() {
    }

    public static boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    public static List<String> validateRegistration(String firstName, String lastName, String email,
                                                    String phone, String dob, String password,
                                                    String confirmPassword) {
        List<String> errors = new ArrayList<>();

        if (isBlank(firstName) || !NAME_PATTERN.matcher(firstName.trim()).matches()) {
            errors.add("First name must contain only letters and spaces.");
        }
        if (isBlank(lastName) || !NAME_PATTERN.matcher(lastName.trim()).matches()) {
            errors.add("Last name must contain only letters and spaces.");
        }
        if (isBlank(email) || !EMAIL_PATTERN.matcher(email.trim()).matches()) {
            errors.add("Please enter a valid email address.");
        }
        if (isBlank(phone) || !PHONE_PATTERN.matcher(phone.trim()).matches()) {
            errors.add("Please enter a valid Nepali mobile number.");
        }
        if (isBlank(dob)) {
            errors.add("Date of birth is required.");
        }
        if (isBlank(password) || password.length() < 6) {
            errors.add("Password must be at least 6 characters long.");
        }
        if (password != null && !password.equals(confirmPassword)) {
            errors.add("Passwords do not match.");
        }

        return errors;
    }

    public static List<String> validateLogin(String email, String password) {
        List<String> errors = new ArrayList<>();

        if (isBlank(email) || !EMAIL_PATTERN.matcher(email.trim()).matches()) {
            errors.add("Please enter a valid email address.");
        }
        if (isBlank(password)) {
            errors.add("Password is required.");
        }

        return errors;
    }

    public static List<String> validateProduct(ProductModel product) {
        List<String> errors = new ArrayList<>();

        if (product == null) {
            errors.add("Product information is missing.");
            return errors;
        }

        if (isBlank(product.getProductName()) || product.getProductName().trim().length() < 2) {
            errors.add("Product name must be at least 2 characters long.");
        }
        if (product.getCategoryId() <= 0) {
            errors.add("Please select a product category.");
        }
        if (product.getPrice() <= 0) {
            errors.add("Price must be greater than zero.");
        }
        if (isBlank(product.getDescription())) {
            errors.add("Product description is required.");
        }
        if (isBlank(product.getImage())) {
            errors.add("Image file name is required.");
        }
        if (product.getStock() < 0) {
            errors.add("Stock cannot be negative.");
        }

        return errors;
    }
}
