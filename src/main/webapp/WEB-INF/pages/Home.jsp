<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
 <c:set var="activePage" value="home" scope="request" />
 
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FurniCo - Timeless furniture for modern living</title>
 
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,500;0,600;0,700;1,400;1,500&family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
 
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
</head>
<body>
 
<!-- ===================== HEADER ===================== -->
<header class="header">
    <a href="${pageContext.request.contextPath}/home" class="logo">
        <span class="logo-icon"><img src="${pageContext.request.contextPath}/images/logo.png" alt="FurniCo"></span>
        <span class="logo-text">Furni Co</span>
    </a>
 
    <nav class="main-nav">
        <a href="${pageContext.request.contextPath}/home" class="active">Home</a>
        <a href="${pageContext.request.contextPath}/products">Shop</a>
        <a href="${pageContext.request.contextPath}/about">About</a>
        <a href="${pageContext.request.contextPath}/contact">Contact</a>
    </nav>
 
    <div class="header-icons">
        <a href="${pageContext.request.contextPath}/wishlist" title="Wishlist">
            <i class="fa-regular fa-heart"></i>
        </a>
        <a href="${pageContext.request.contextPath}/cart" title="Cart">
            <i class="fa-solid fa-bag-shopping"></i>
            <span class="cart-badge">0</span>
        </a>
        <a href="${pageContext.request.contextPath}/login" title="Account" class="profile-icon">
            <i class="fa-regular fa-user"></i>
        </a>
    </div>
</header>
 
<!-- ===================== HERO ===================== -->
<section class="hero">
    <div class="hero-text">
        <span class="eyebrow">New Season Collection</span>
        <h1>Timeless furniture <em>for modern living.</em></h1>
        <p>Discover handpicked sofas, beds, tables and lighting designed to make your home feel effortlessly elegant.</p>
        <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">Shop now</a>
        <a href="${pageContext.request.contextPath}/products?categoryId=1" class="btn btn-outline">View Sofas</a>
    </div>
    <div class="hero-image">
        <img src="${pageContext.request.contextPath}/images/hero.jpg" alt="FurniCo showroom"
             onerror="this.src='${pageContext.request.contextPath}/images/placeholder.jpg';">
    </div>
</section>
 
<!-- ===================== CATEGORIES ===================== -->
<section class="section">
    <div class="section-heading">
        <h2>Shop by <em>category</em></h2>
        <p>Find the perfect piece for every room.</p>
    </div>
 
    <div class="categories-grid">
        <c:forEach var="c" items="${categories}">
            <a class="cat-card" href="${pageContext.request.contextPath}/products?categoryId=${c.categoryId}">
                <div class="cat-circle">
                    <img src="${pageContext.request.contextPath}/images/${c.image}" alt="${c.categoryName}"
                         onerror="this.src='${pageContext.request.contextPath}/images/placeholder.jpg';">
                </div>
                <div class="cat-card-name">${c.categoryName}</div>
            </a>
        </c:forEach>
    </div>
</section>
 
<!-- ===================== SPRING SALE PROMO ===================== -->
<section class="spring-sale">
    <div class="spring-sale-img">
        <img src="${pageContext.request.contextPath}/images/spring-sale.jpg" alt="Spring Collection"
             onerror="this.src='${pageContext.request.contextPath}/images/placeholder.jpg';">
    </div>
    <div class="spring-sale-content">
        <span class="ss-eyebrow">Limited Time</span>
        <h2>Up to 30% Off <em>Spring Collection</em></h2>
        <p>Refresh your home with our spring essentials. Elegant sofas, dining sets, and accent pieces at exclusive prices for a limited time.</p>
        <a href="${pageContext.request.contextPath}/products" class="btn-sale">Shop the Sale</a>
 
        <div class="ss-stats">
            <div class="ss-stat">
                <div class="ss-stat-num">2,400+</div>
                <div class="ss-stat-label">Happy Customers</div>
            </div>
            <div class="ss-stat">
                <div class="ss-stat-num">500+</div>
                <div class="ss-stat-label">Products</div>
            </div>
            <div class="ss-stat">
                <div class="ss-stat-num">15+</div>
                <div class="ss-stat-label">Awards Won</div>
            </div>
        </div>
    </div>
</section>
 
<!-- ===================== BEST SELLERS ===================== -->
<section class="section featured-section">
    <div class="section-heading">
        <h2>Popular <em>picks</em></h2>
        <p>Our most-loved pieces this season.</p>
    </div>
 
    <div class="product-grid">
        <c:forEach var="p" items="${products}">
            <c:if test="${p.bestSeller}">
                <article class="product-card">
                    <div class="product-image">
                        <span class="best-seller-pill">Best Seller</span>
                        <a href="${pageContext.request.contextPath}/product?id=${p.productId}">
                            <img src="${pageContext.request.contextPath}/images/${p.image}" alt="${p.productName}"
                                 onerror="this.src='${pageContext.request.contextPath}/images/placeholder.jpg';">
                        </a>
                    </div>
                    <div class="product-body">
                        <div class="product-cat">${fn:toUpperCase(p.categoryName)}</div>
                        <h3 class="product-name">
                            <a href="${pageContext.request.contextPath}/product?id=${p.productId}">${p.productName}</a>
                        </h3>
                        <div class="product-rating">
                            <span class="stars">
                                <c:forEach begin="1" end="5" var="i">
                                    <c:choose>
                                        <c:when test="${i le p.rating}"><i class="fa-solid fa-star"></i></c:when>
                                        <c:when test="${i - 0.5 le p.rating}"><i class="fa-solid fa-star-half-stroke"></i></c:when>
                                        <c:otherwise><i class="fa-regular fa-star"></i></c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </span>
                            <span>(${p.ratingCount})</span>
                        </div>
                        <div class="product-footer">
                            <div class="product-price">Rs. <fmt:formatNumber value="${p.price}" type="number" maxFractionDigits="0"/></div>
                            <form method="post" action="${pageContext.request.contextPath}/cart" style="display:inline;">
                                <input type="hidden" name="action"    value="add">
                                <input type="hidden" name="productId" value="${p.productId}">
                                <input type="hidden" name="qty"       value="1">
                                <input type="hidden" name="redirectTo" value="/cart">
                                <button type="submit" class="cart-btn" title="Add to cart">
                                    <i class="fa-solid fa-bag-shopping"></i>
                                </button>
                            </form>
                        </div>
                    </div>
                </article>
            </c:if>
        </c:forEach>
    </div>
 
    <div class="view-all-row">
        <a href="${pageContext.request.contextPath}/products" class="btn btn-outline" style="margin-left:0;">View all products</a>
    </div>
</section>
 
<!-- ===================== TESTIMONIALS ===================== -->
<section class="section testimonials-section">
    <div class="section-heading">
        <h2>What our <em>customers say</em></h2>
        <p>Real stories from people who've made FurniCo part of their home.</p>
    </div>
 
    <div class="testimonials-grid">
 
        <div class="testimonial-card">
            <div class="t-stars">
                <i class="fa-solid fa-star"></i>
                <i class="fa-solid fa-star"></i>
                <i class="fa-solid fa-star"></i>
                <i class="fa-solid fa-star"></i>
                <i class="fa-solid fa-star"></i>
            </div>
            <p class="t-quote">"The Luna Velvet Sofa transformed our living room. The colour is even richer in person and the craftsmanship is beautiful. Delivery was on time too."</p>
            <div class="t-customer">
                <div class="t-avatar" style="background:#C49A6C;">A</div>
                <div>
                    <div class="t-name">Anjali Sharma</div>
                    <div class="t-loc">Kathmandu, Nepal</div>
                </div>
            </div>
        </div>
 
        <div class="testimonial-card">
            <div class="t-stars">
                <i class="fa-solid fa-star"></i>
                <i class="fa-solid fa-star"></i>
                <i class="fa-solid fa-star"></i>
                <i class="fa-solid fa-star"></i>
                <i class="fa-solid fa-star"></i>
            </div>
            <p class="t-quote">"I was hesitant to buy furniture online but FurniCo made it easy. The Aurora Dining Table looks straight out of a magazine. Highly recommend."</p>
            <div class="t-customer">
                <div class="t-avatar" style="background:#1F1A17;">R</div>
                <div>
                    <div class="t-name">Rohan Pradhan</div>
                    <div class="t-loc">Lalitpur, Nepal</div>
                </div>
            </div>
        </div>
 
        <div class="testimonial-card">
            <div class="t-stars">
                <i class="fa-solid fa-star"></i>
                <i class="fa-solid fa-star"></i>
                <i class="fa-solid fa-star"></i>
                <i class="fa-solid fa-star"></i>
                <i class="fa-solid fa-star-half-stroke"></i>
            </div>
            <p class="t-quote">"Beautiful pieces and great customer service. The Arc Floor Lamp is the centrepiece of our reading nook. Already planning my next order."</p>
            <div class="t-customer">
                <div class="t-avatar" style="background:#5a5247;">S</div>
                <div>
                    <div class="t-name">Sneha Thapa</div>
                    <div class="t-loc">Bhaktapur, Nepal</div>
                </div>
            </div>
        </div>
 
    </div>
</section>
 
<!-- ===================== FOOTER ===================== -->
<jsp:include page="/WEB-INF/pages/footer.jsp" />
</body>
</html>