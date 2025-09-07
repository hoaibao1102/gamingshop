<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN" />

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Gaming Shop - Trang chủ</title>

        <!-- Swiper CSS -->
        <link
            rel="stylesheet"
            href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css"
            />

        <style>
            :root {
                --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                --secondary-gradient: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
                --success-gradient: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
                --dark-gradient: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
                --card-shadow: 0 10px 40px rgba(0,0,0,0.1);
                --hover-shadow: 0 20px 60px rgba(0,0,0,0.2);
                --text-dark: #2c3e50;
                --text-light: #ffffff;
                --bg-light: #f8fafc;
                --border-light: rgba(255,255,255,0.2);
            }

            html, body {
                margin: 0;
                padding: 0;
                height: 100%;
                width: 100%;
                font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
                background: var(--bg-light);
                scroll-behavior: smooth;
            }

            .wrapper {
                padding: 0 20px;
                display: flex;
                min-height: 100vh;
                width: 100vw;
                gap: 20px;
            }

            .sidebar {
                flex: 3;
                background: var(--dark-gradient);
                color: var(--text-light);
                padding: 24px;
                box-sizing: border-box;
                border-radius: 20px;
                box-shadow: var(--card-shadow);
                position: sticky;
                top: 20px;
                height: fit-content;
            }

            .Main_content {
                flex: 7;
                background: linear-gradient(180deg, #ffffff 0%, #f8fafc 100%);
                box-sizing: border-box;
                overflow-y: auto;
                border-radius: 20px;
                box-shadow: var(--card-shadow);
                position: relative;
            }

            .container {
                padding: 24px;
            }

            h1 {
                margin: 0;
                color: var(--text-dark);
                font-weight: 800;
                background: var(--primary-gradient);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
            }

            /* ====== Marquee - Modern Animation ====== */
            .marquee-bar {
                background: var(--primary-gradient);
                color: var(--text-light);
                padding: 12px 0;
                overflow: hidden;
                position: relative;
                font-size: 14px;
                font-weight: 600;
                box-shadow: 0 4px 20px rgba(102, 126, 234, 0.3);
                backdrop-filter: blur(10px);
            }
            .marquee-bar::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: linear-gradient(90deg,
                    rgba(255,255,255,0.1) 0%,
                    transparent 50%,
                    rgba(255,255,255,0.1) 100%);
                animation: shimmer 3s ease-in-out infinite;
            }
            @keyframes shimmer {
                0%, 100% {
                    opacity: 0;
                }
                50% {
                    opacity: 1;
                }
            }
            .marquee-inner {
                display: inline-block;
                white-space: nowrap;
                will-change: transform;
                animation: marquee 20s linear infinite;
            }
            .marquee-item {
                display: inline-flex;
                align-items: center;
                gap: 12px;
                margin-right: 50px;
                opacity: 0.95;
            }
            .marquee-item a {
                color: var(--text-light);
                text-decoration: none;
                transition: all 0.3s ease;
                padding: 4px 8px;
                border-radius: 6px;
            }
            .marquee-item a:hover {
                background: rgba(255,255,255,0.2);
                transform: scale(1.05);
            }
            .marquee-item .badge {
                background: linear-gradient(135deg, #ff6b6b 0%, #ee5a52 100%);
                color: var(--text-light);
                font-size: 11px;
                font-weight: 700;
                padding: 4px 10px;
                border-radius: 20px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                box-shadow: 0 2px 8px rgba(238, 90, 82, 0.4);
                animation: pulse 2s ease-in-out infinite;
            }
            @keyframes pulse {
                0%, 100% {
                    transform: scale(1);
                }
                50% {
                    transform: scale(1.05);
                }
            }
            .marquee-bar:hover .marquee-inner {
                animation-play-state: paused;
            }
            @keyframes marquee {
                from {
                    transform: translateX(100%);
                }
                to {
                    transform: translateX(-100%);
                }
            }

            /* ====== Hero Slider - Ultra Modern ====== */
            .hero-wrap {
                width: 100%;
                padding: 24px 24px 0 24px;
            }
            .hero-slider {
                width: 100%;
                height: clamp(220px, 35vw, 480px);
                border-radius: 24px;
                overflow: hidden;
                box-shadow: var(--card-shadow);
                position: relative;
            }
            .hero-slider::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: linear-gradient(45deg,
                    transparent 30%,
                    rgba(255,255,255,0.1) 50%,
                    transparent 70%);
                pointer-events: none;
                z-index: 1;
                opacity: 0;
                transition: opacity 0.5s ease;
            }
            .hero-slider:hover::before {
                opacity: 1;
            }
            .hero-slider .swiper-wrapper {
                align-items: stretch;
            }
            .hero-slider .swiper-slide {
                position: relative;
                overflow: hidden;
                border-radius: 24px;
                transition: transform 0.5s ease;
            }
            .hero-slider .swiper-slide-active {
                transform: scale(1.02);
            }
            .hero-slider .swiper-slide a,
            .hero-slider .swiper-slide img {
                display: block;
                width: 100%;
                height: 100%;
            }
            .hero-slider .swiper-slide img {
                object-fit: cover;
                transition: transform 0.7s ease;
                filter: brightness(1.1) contrast(1.05);
            }
            .hero-slider .swiper-slide:hover img {
                transform: scale(1.1);
            }

            /* Navigation Buttons - Glassmorphism */
            .hero-slider .swiper-button-prev,
            .hero-slider .swiper-button-next {
                --swiper-navigation-size: 20px;
                background: rgba(255,255,255,0.2);
                backdrop-filter: blur(10px);
                border: 1px solid rgba(255,255,255,0.3);
                width: 50px;
                height: 50px;
                border-radius: 50%;
                transition: all 0.3s ease;
                color: white;
                font-weight: bold;
            }
            .hero-slider .swiper-button-prev:hover,
            .hero-slider .swiper-button-next:hover {
                background: rgba(255,255,255,0.3);
                transform: scale(1.1);
                box-shadow: 0 8px 32px rgba(0,0,0,0.3);
            }

            /* Pagination - Modern Dots */
            .hero-slider .swiper-pagination-bullet {
                width: 12px;
                height: 12px;
                opacity: 0.4;
                background: white;
                border-radius: 50%;
                transition: all 0.3s ease;
            }
            .hero-slider .swiper-pagination-bullet-active {
                opacity: 1;
                background: var(--primary-gradient);
                width: 30px;
                border-radius: 6px;
                transform: scale(1.2);
            }

            /* ====== Fixed Product Grid Structure ====== */
            .featured-list {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 24px;
                list-style: none;
                padding: 0;
                margin: 24px 0;
            }

            .featured-list .item {
                background: linear-gradient(145deg, #ffffff 0%, #f8fafc 100%);
                border-radius: 20px;
                overflow: hidden;
                box-shadow: var(--card-shadow);
                transition: all 0.4s cubic-bezier(0.25, 0.8, 0.25, 1);
                border: 1px solid rgba(255,255,255,0.8);
                position: relative;
                display: flex;
                flex-direction: column;
                height: 100%;
            }

            .product-form {
                margin: 0;
                height: 100%;
                width: 100%;
            }

            .product-button {
                background: none;
                border: none;
                padding: 0;
                margin: 0;
                width: 100%;
                height: 100%;
                cursor: pointer;
                display: flex;
                flex-direction: column;
                text-align: left;
                transition: all 0.4s cubic-bezier(0.25, 0.8, 0.25, 1);
            }

            .product-content {
                display: flex;
                flex-direction: column;
                height: 100%;
                width: 100%;
            }

            .product-button:hover {
                transform: translateY(-8px) scale(1.02);
            }

            .item:hover {
                box-shadow: var(--hover-shadow);
            }

            .item::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: var(--primary-gradient);
                opacity: 0;
                transition: opacity 0.3s ease;
                z-index: 1;
                pointer-events: none;
            }

            .item:hover::before {
                opacity: 0.05;
            }

            .thumb {
                width: 100%;
                height: 200px;
                object-fit: cover;
                transition: transform 0.5s ease;
                filter: brightness(1.05);
            }

            .product-button:hover .thumb {
                transform: scale(1.1);
            }

            .meta {
                padding: 20px;
                display: flex;
                flex-direction: column;
                gap: 8px;
                flex-grow: 1;
                position: relative;
                z-index: 2;
                color: var(--text-dark);
            }

            .product-name {
                background: var(--primary-gradient);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
                font-weight: 600;
                font-size: 16px;
                line-height: 1.4;
                margin-bottom: 8px;
            }

            .product-price {
                text-align: center;
                font-size: 16px;
                font-weight: 600;
                color: #e11d48;
                margin-top: auto;
            }

            /* Button focus states for accessibility */
            .product-button:focus {
                outline: 2px solid var(--primary-gradient);
                outline-offset: 2px;
            }

            .product-button:focus:not(:focus-visible) {
                outline: none;
            }
            .featured-list form {
                margin: 0;
                height: 100%;
            }
            .item {
                background: linear-gradient(145deg, #ffffff 0%, #f8fafc 100%);
                border-radius: 20px;
                overflow: hidden;
                box-shadow: var(--card-shadow);
                transition: all 0.4s cubic-bezier(0.25, 0.8, 0.25, 1);
                border: 1px solid rgba(255,255,255,0.8);
                cursor: pointer;
                position: relative;
                display: flex;
                flex-direction: column;
            }
            .item::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: var(--primary-gradient);
                opacity: 0;
                transition: opacity 0.3s ease;
                z-index: 1;
            }
            .item:hover {
                transform: translateY(-8px) scale(1.02);
                box-shadow: var(--hover-shadow);
            }
            .item:hover::before {
                opacity: 0.05;
            }
            .thumb {
                width: 100%;
                height: 200px;
                object-fit: cover;
                transition: transform 0.5s ease;
                filter: brightness(1.05);
            }
            .item:hover .thumb {
                transform: scale(1.1);
            }
            .meta {
                padding: 20px;
                text-decoration: none;
                color: var(--text-dark);
                display: flex;
                flex-direction: column;
                gap: 8px;
                flex-grow: 1;
                position: relative;
                z-index: 2;
            }
            .meta .cell:first-child:not(:last-child){
                background: var(--primary-gradient);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                margin: -10px 0px;
                background-clip: text;
                font-weight: 600;
                font-size: 16px;
                line-height: 1.4;
            }

            .meta .cell:last-child {
                font-size: 16px;
                font-weight: 600;
                color: #e11d48;
                margin-top: auto;
            }

            /* Empty state styling */
            .empty-state {
                text-align: center;
                padding: 60px 20px;
                color: var(--text-dark);
            }

            .empty-state h3 {
                background: var(--primary-gradient);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
                font-size: 24px;
                margin-bottom: 16px;
            }

            .empty-state p {
                font-size: 16px;
                opacity: 0.7;
                margin-bottom: 24px;
            }

            /* ====== Responsive Design ====== */
            @media (max-width: 1200px) {
                .featured-list {
                    grid-template-columns: repeat(3, 1fr);
                    gap: 20px;
                }
            }

            @media (max-width: 968px) {
                .featured-list {
                    grid-template-columns: repeat(2, 1fr);
                    gap: 18px;
                }
            }

            @media (max-width: 768px) {
                .wrapper {
                    padding: 10px;
                    flex-direction: column;
                    gap: 15px;
                }
                .sidebar {
                    display: none;
                }
                .Main_content {
                    flex: 1;
                    border-radius: 16px;
                }
                .hero-wrap {
                    padding: 16px 16px 0 16px;
                }
                .hero-slider {
                    height: clamp(180px, 50vw, 320px);
                    border-radius: 16px;
                }
                .hero-slider .swiper-slide {
                    border-radius: 16px;
                }
                .hero-slider .swiper-button-prev,
                .hero-slider .swiper-button-next {
                    width: 40px;
                    height: 40px;
                    --swiper-navigation-size: 16px;
                }
                .featured-list {
                    grid-template-columns: repeat(2, 1fr);
                    gap: 16px;
                }
                .container {
                    padding: 16px;
                }
            }

            @media (max-width: 480px) {
                .featured-list {
                    grid-template-columns: 1fr;
                    gap: 16px;
                }
            }

            /* ====== Additional Animations ====== */
            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
            .item {
                animation: fadeInUp 0.6s ease-out;
            }
            .item:nth-child(even) {
                animation-delay: 0.1s;
            }
            .item:nth-child(3n) {
                animation-delay: 0.2s;
            }

            /* Scrollbar Styling */
            .Main_content::-webkit-scrollbar {
                width: 8px;
            }
            .Main_content::-webkit-scrollbar-track {
                background: #f1f1f1;
                border-radius: 4px;
            }
            .Main_content::-webkit-scrollbar-thumb {
                background: var(--primary-gradient);
                border-radius: 4px;
            }
            .Main_content::-webkit-scrollbar-thumb:hover {
                background: var(--secondary-gradient);
            }
        </style>
    </head>
    <body>
        <div class="wrapper">
            <div class="sidebar">
                <jsp:include page="sidebar.jsp"/>
            </div>

            <div class="Main_content">
                <jsp:include page="header.jsp"/>

                <!-- ====== Marquee (thanh thông báo chạy ngang) ====== -->
                <div class="marquee-bar">
                    <div class="marquee-inner">
                        <span class="marquee-item"><span class="badge">HOT</span> Mua 2 tặng 1 phụ kiện chính hãng</span>
                        <span class="marquee-item"><span class="badge">NEW</span> Hàng mới về mỗi ngày — xem ngay</span>
                        <span class="marquee-item"><span class="badge">SALE</span> Giảm đến 40% cho bộ sưu tập tuần này</span>
                        <span class="marquee-item"><a href="#">Xem tất cả khuyến mãi →</a></span>
                    </div>
                </div>

                <!-- ====== Hero Slider (banner chạy qua) ====== -->
                <div class="hero-wrap">
                    <div class="swiper hero-slider">
                        <div class="swiper-wrapper">
                            <!-- Thay ảnh & link theo banner của bạn -->
                            <div class="swiper-slide">
                                <a href="#"><img src="/assets/banners/banner-1.jpg" alt="Khuyến mãi 1"></a>
                            </div>
                            <div class="swiper-slide">
                                <a href="#"><img src="/assets/banners/banner-2.jpg" alt="Khuyến mãi 2"></a>
                            </div>
                            <div class="swiper-slide">
                                <a href="#"><img src="/assets/banners/banner-3.jpg" alt="Khuyến mãi 3"></a>
                            </div>
                            <div class="swiper-slide">
                                <a href="#"><img src="/assets/banners/banner-3.jpg" alt="Khuyến mãi 4"></a>
                            </div>
                            <div class="swiper-slide">
                                <a href="#"><img src="/assets/banners/banner-3.jpg" alt="Khuyến mãi 5"></a>
                            </div>
                        </div>

                        <!-- Dots -->
                        <div class="swiper-pagination"></div>
                        <!-- Prev/Next -->
                        <div class="swiper-button-prev"></div>
                        <div class="swiper-button-next"></div>
                    </div>
                </div>

                <!-- ====== Filter Form (sau banner) ====== -->
                <jsp:include page="filter-form.jsp"/>

                <!-- ====== Nội dung trang ====== -->
                <div class="container">
                    <c:set var="products" value="${not empty pageResult ? pageResult.content : list}" />

                    <c:choose>
                        <c:when test="${not empty products}">
                            <!-- Product Grid -->
                            <ul class="featured-list">
                                <c:forEach var="product" items="${products}">
                                    <c:if test="${product.status ne 'inactive'}">
                                        <li class="item">
                                            <form action="MainController" method="get" class="product-form">
                                                <input type="hidden" name="id" value="${product.id}">
                                                <input type="hidden" name="action" value="getProduct">

                                                <button type="submit" class="product-button">
                                                    <div class="product-content">
                                                        <c:choose>
                                                            <c:when test="${not empty product.coverImg}">
                                                                <img class="thumb" src="${product.coverImg}" alt="${product.name}">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <img class="thumb" src="/assets/images/no-image.jpg" alt="No image available">
                                                            </c:otherwise>
                                                        </c:choose>

                                                        <div class="meta">
                                                            <span class="product-name">${product.name}</span>
                                                            <span class="product-price">
                                                                <fmt:formatNumber value="${product.price}" type="number" groupingUsed="true" maxFractionDigits="0" /> VND
                                                            </span>
                                                        </div>
                                                    </div>
                                                </button>
                                            </form>
                                        </li>
                                    </c:if>
                                </c:forEach>
                            </ul>
                            <!-- Pagination -->
                            <jsp:include page="pagination.jsp"/>
                            <!-- Pagination Section -->
                        </c:when>
                        <c:otherwise>
                            <!-- Empty State -->
                            <div class="empty-state">
                                <h3>Không tìm thấy sản phẩm</h3>
                                <p>Hiện tại không có sản phẩm nào phù hợp với tiêu chí tìm kiếm của bạn.</p>
                                <button onclick="resetFilter()" class="btn-filter">
                                    Xem tất cả sản phẩm
                                </button>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <jsp:include page="footer.jsp"/>

        <!-- Swiper JS -->
        <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
        <script>
                    const heroSwiper = new Swiper('.hero-slider', {
                        loop: true,
                        autoplay: {delay: 3000, disableOnInteraction: false},
                        speed: 700,
                        spaceBetween: 16,
                        pagination: {el: '.hero-slider .swiper-pagination', clickable: true},
                        navigation: {
                            nextEl: '.hero-slider .swiper-button-next',
                            prevEl: '.hero-slider .swiper-button-prev'
                        },
                        grabCursor: true,
                        effect: 'slide'
                    });

                    
        </script>
    </body>
</html>