<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Page Not Found | FurniCo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/error-styles.css"> 
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-dark: #1F1F1F;
            --accent: #C49A6C;
            --cream: #F8F5F2;
            --text-gray: #666;
        }
        
        body {
            margin: 0;
            padding: 0;
            font-family: 'Outfit', sans-serif;
            background-color: var(--cream);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--bg-dark);
        }

        .error-container {
            text-align: center;
            padding: 2rem;
            max-width: 600px;
            width: 90%;
        }

        .error-code {
            font-size: 8rem;
            font-weight: 600;
            margin: 0;
            color: var(--accent);
            line-height: 1;
            letter-spacing: -5px;
        }

        .error-title {
            font-size: 2rem;
            margin: 1rem 0;
            font-weight: 600;
            text-transform: uppercase;
        }

        .error-message {
            color: var(--text-gray);
            font-size: 1.1rem;
            margin-bottom: 2.5rem;
            line-height: 1.6;
        }

        .error-actions {
            display: flex;
            gap: 1rem;
            justify-content: center;
        }

        .btn {
            padding: 0.8rem 2rem;
            border-radius: 4px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            cursor: pointer;
            border: none;
            font-family: inherit;
        }

        .btn-primary {
            background-color: var(--bg-dark);
            color: white;
        }

        .btn-primary:hover {
            background-color: var(--accent);
            transform: translateY(-2px);
        }

        .btn-secondary {
            background-color: transparent;
            color: var(--bg-dark);
            border: 2px solid var(--bg-dark);
        }

        .btn-secondary:hover {
            background-color: var(--bg-dark);
            color: white;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-content">
            <h1 class="error-code">404</h1>
            <h2 class="error-title">Page Not Found</h2>
            <p class="error-message">
                Oops! It seems the furniture or page you are looking for has been misplaced or doesn't exist.
            </p>
            <div class="error-actions">
                <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Return to Homepage</a>
                <button onclick="history.back()" class="btn btn-secondary">Go Back</button>
            </div>
        </div>
    </div>
</body>
</html>
