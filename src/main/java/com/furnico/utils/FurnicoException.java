package com.furnico.utils;

//com.furnico.utils.FurnicoException
public class FurnicoException extends Exception {
 private int statusCode;

 public FurnicoException(String message) {
     super(message);
     this.statusCode = 500;
 }

 public FurnicoException(String message, int statusCode) {
     super(message);
     this.statusCode = statusCode;
 }

 public FurnicoException(String message, Throwable cause) {
     super(message, cause);
     this.statusCode = 500;
 }

 public int getStatusCode() { return statusCode; }
}