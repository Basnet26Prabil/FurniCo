<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    request.setAttribute("activePage", "about");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>About Us - FURNI-CO</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/Nav.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/aboutus.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
<!-- Add this in your <head> section in Aboutus.jsp -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,500;0,600;0,700;1,400;1,500&family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">

<style>
  .hero { position:relative; height:400px; display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; padding:2rem 3rem; overflow:hidden; }
  .hero-bg-img { position:absolute; top:0; left:0; width:100%; height:100%; object-fit:cover; z-index:0; }
  .hero-overlay { position:absolute; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.52); z-index:1; }
  .hero-text { position:relative; z-index:99; display:flex; flex-direction:column; align-items:center; gap:1rem; }
  .hero-text h1 { color:#ffffff !important; font-family:'Playfair Display',serif; font-size:3rem; font-weight:600; text-shadow:0 2px 10px rgba(0,0,0,0.6); margin:0; }
  .hero-text p  { color:#ffffff !important; font-size:1rem; line-height:1.8; max-width:680px; text-shadow:0 1px 6px rgba(0,0,0,0.5); margin:0; opacity:0.92; }
</style>
</head>
<body>

<!-- HEADER -->
<%@ include file="/WEB-INF/pages/common/Header.jsp" %>

<!-- HERO -->
<section class="hero">

  <img class="hero-bg-img"
       src="${pageContext.request.contextPath}/images/hero img.jpg"
       alt=""
       aria-hidden="true">

  <div class="hero-overlay"></div>

  <div class="hero-text">
    <h1>Welcome</h1>
    <p>Welcome to Furni-Co, your trusted online destination for modern, stylish, and affordable furniture.
       At Furni-Co, we believe that a home is more than just a place—it's a feeling. That's why we are
       dedicated to helping you create spaces that reflect your personality, comfort, and lifestyle.</p>
  </div>

</section>

<!-- ABOUT -->
<section class="about-section">
  <div class="about-content">
    <div class="about-block">
      <h2>Our Mission</h2>
      <p>Our mission is to make premium furniture accessible to everyone at affordable prices while
         ensuring excellent quality and customer satisfaction.</p>
    </div>
    <div class="about-block">
      <h2>Why Choose Us</h2>
      <p>We carefully select every product to ensure it meets high standards of quality and design.
         Our goal is to make your shopping experience smooth, secure, and enjoyable from browsing
         to delivery.</p>
    </div>
  </div>

  <div class="about-image">
    <div class="about-image-placeholder">
      <!-- FIX: Consistent EL syntax -->
      <img src="${pageContext.request.contextPath}/images/showrom.jpg" alt="Our showroom">
    </div>
    <div class="about-image-badge">
      <span class="num">7+</span>
      <span class="lbl">Years of Trust</span>
    </div>
  </div>
</section>

<!-- TEAM -->
<div class="team-section">
  <h2 class="team-title">Meet Our Team</h2>

  <p class="team-subtitle">The creative minds behind Furni-Co</p>

  <div class="team-grid">

    <div class="team-card">
      <div class="team-avatar">
        <img src="${pageContext.request.contextPath}/images/girl1.jpg" alt="Anuja Rai">
      </div>
      <div class="team-name">AnujaRai</div>
      <div class="team-role">Founder</div>
    </div>

    <div class="team-card">
      <div class="team-avatar">
        <img src="${pageContext.request.contextPath}/images/girl2.jpg" alt="Nitisha Basnet">
      </div>
      <div class="team-name">NitishaBasnet</div>
      <div class="team-role">CO-Founder</div>
    </div>

    <div class="team-card">
      <div class="team-avatar">
        <img src="${pageContext.request.contextPath}/images/girl3.jpg" alt="Garima Khadka">
      </div>
      <!-- FIX 2: Removed stray underscore -->
      <div class="team-name">GarimaKhadka</div>
      <div class="team-role">Designer</div>
    </div>

    <div class="team-card">
      <div class="team-avatar">
        <img src="${pageContext.request.contextPath}/images/mem4.jpg" alt="Prabil Basnet">
      </div>
      <div class="team-name">PrabilBasnet</div>
      <div class="team-role">Supervisor</div>
    </div>

    <div class="team-card">
      <div class="team-avatar">
        <img src="${pageContext.request.contextPath}/images/mem5.jpg" alt="Umanga Shah">
      </div>
     
      <div class="team-name">UmangaShah</div>
      <div class="team-role">Manager</div>
    </div>

    <div class="team-card">
      <div class="team-avatar">
        <!-- FIX 4: Changed duplicate img1.jpg to img3.jpg -->
        <img src="${pageContext.request.contextPath}/images/mem6.jpg" alt="Paurakh">
      </div>
      <div class="team-name">Paurakh</div>
      <div class="team-role">Manager</div>
    </div>

  </div>
</div>

 
<!-- ===================== FOOTER ===================== -->
<jsp:include page="/WEB-INF/pages/footer.jsp" /> 

</body>
</html>