<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>JSP Page</title>

        <!-- Swiper CSS -->
        <link
            rel="stylesheet"
            href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css"
            />

        <style>
            html, body {
                margin: 0;
                padding: 0;
                height: 100%;
                width: 100%;
                font-family: Arial, sans-serif;
            }

            .wrapper {
                padding: 0 20px;
                display: flex;
                height: 100vh;   /* full màn hình */
                width: 100vw;
            }

            .sidebar {
                flex: 3; /* 3 phần */
                background-color: #34495e;
                color: #fff;
                padding: 20px;
                box-sizing: border-box;
            }

            .Main_content {
                flex: 7; /* 7 phần */
                background-color: #f5f5f5;
                box-sizing: border-box;
                overflow-y: auto; /* cho phép cuộn khi nội dung dài */
            }

            .container {
                padding: 20px;
            }

            h1 {
                margin: 0;
                color: #2c3e50;
            }


            /* ====== Marquee ====== */
            .marquee-bar {
                background: #111;
                color: #fff;
                padding: 8px 0;
                overflow: hidden;
                position: relative;
                font-size: 14px;
                line-height: 1;
            }
            .marquee-inner {
                display: inline-block;
                white-space: nowrap;
                will-change: transform;
                animation: marquee 18s linear infinite;
            }
            .marquee-item {
                display: inline-flex;
                align-items: center;
                gap: 10px;
                margin-right: 40px;
                opacity:.9;
            }
            .marquee-item a {
                color: #fff;
                text-decoration: none;
            }
            .marquee-item .badge {
                background:#e11d48;
                color:#fff;
                font-size:12px;
                padding:2px 6px;
                border-radius:999px;
            }
            .marquee-bar:hover .marquee-inner {
                animation-play-state: paused;
            }
            @keyframes marquee {
                from {
                    transform: translateX(100%);
                }
                to   {
                    transform: translateX(-100%);
                }
            }


            /* ====== Hero slider (Swiper) ====== */
            .hero-wrap {
                width: 100%;
                padding: 16px 20px 0 20px;
            }
            .hero-slider {
                width: 100%;
                height: clamp(180px, 32vw, 420px);
            }
            .hero-slider .swiper-wrapper {
                align-items: stretch;
            }
            .hero-slider .swiper-slide {
                position: relative;
                overflow: hidden;
                border-radius: 10px;
            }
            .hero-slider .swiper-slide a,
            .hero-slider .swiper-slide img {
                display: block;
                width: 100%;
                height: 100%;
            }
            .hero-slider .swiper-slide img {
                object-fit: cover;
            }
            /* Nút điều hướng */
            .hero-slider .swiper-button-prev,
            .hero-slider .swiper-button-next {
                --swiper-navigation-size: 24px;
                background: rgba(0,0,0,.35);
                width: 38px;
                height: 38px;
                border-radius: 999px;
            }
            .hero-slider .swiper-button-prev:hover,
            .hero-slider .swiper-button-next:hover {
                background: rgba(0,0,0,.55);
            }
            /* Dots */
            .hero-slider .swiper-pagination-bullet {
                opacity:.6;
            }
            .hero-slider .swiper-pagination-bullet-active {
                opacity:1;
            }

            /* 🔹 Responsive cho mobile */
            @media (max-width: 768px) {
                .wrapper {
                    padding: 0px;
                    flex-direction: column; /* Xếp theo cột */
                }
                .sidebar {
                    display: none; /* Ẩn sidebar */
                }
                .Main_content {
                    flex: 1; /* Chiếm toàn bộ chiều ngang */
                }
                .hero-wrap {
                    padding: 8px 0 0 0;
                }
                .hero-slider {
                    height: clamp(150px, 45vw, 280px);
                    border-radius: 0;
                }
                .hero-slider .swiper-slide {
                    border-radius: 0;
                }
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

                <!-- ====== Nội dung trang ====== -->
                <div class="container">
                    <h1>Hello World!</h1>
                 
                </div>
            </div>
        </div>

        <jsp:include page="footer.jsp"/>


        <!-- Swiper JS -->
        <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
        <script>
            const heroSwiper = new Swiper('.hero-slider', {
                loop: true,
                autoplay: {delay: 3500, disableOnInteraction: false},
                speed: 700,
                spaceBetween: 16,
                pagination: {el: '.hero-slider .swiper-pagination', clickable: true},
                navigation: {
                    nextEl: '.hero-slider .swiper-button-next',
                    prevEl: '.hero-slider .swiper-button-prev'
                },
                grabCursor: true,
                effect: 'slide' // có thể đổi 'fade' nếu bạn thích
            });
        </script>
    </body>
</html>
