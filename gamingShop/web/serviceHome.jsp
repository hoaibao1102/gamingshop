<%-- 
    Document   : serviceHome
    Created on : Sep 19, 2025
    Author     : ddhuy
--%>

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
         <%@ include file="/WEB-INF/jspf/head.jspf" %>
        <title>Gaming Shop - Dịch vụ</title>

        <!-- Swiper CSS -->
        <link
            rel="stylesheet"
            href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css"/>

        <!-- Custom CSS -->
        <link rel="stylesheet" href="assets/css/maincss.css">
        
        <!-- Custom CSS cho Services -->
        <style>
            .services-container {
                max-width: 100%;
                margin: 0 auto;
                padding: 20px;
            }
            
            .services-header {
                text-align: center;
                margin-bottom: 40px;
            }
            
            .services-header h2 {
                color: #333;
                font-size: 2.5rem;
                font-weight: bold;
                margin-bottom: 10px;
            }
            
            .services-header p {
                color: #666;
                font-size: 1.1rem;
            }
            
            .services-table-wrapper {
                background: #fff;
                border-radius: 12px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
                overflow: hidden;
                margin-top: 20px;
            }
            
            .sidebar{
                flex:3;
                background: linear-gradient(135deg,#2c3e50 0%,#34495e 100%);
                color:#fff;
                border-radius:20px;
                padding:24px;
                top:20px;
                height: fit-content;
            }
            
            .services-table {
                width: 100%;
                border-collapse: collapse;
                font-size: 16px;
            }
            
            .services-table thead {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
            }
            
            .services-table thead th {
                padding: 20px 15px;
                text-align: left;
                font-weight: 600;
                font-size: 18px;
                letter-spacing: 0.5px;
            }
            
            .services-table tbody tr {
                border-bottom: 1px solid #eee;
                transition: all 0.3s ease;
            }
            
            .services-table tbody tr:hover {
                background-color: #f8f9ff;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            }
            
            .services-table tbody tr:last-child {
                border-bottom: none;
            }
            
            .services-table tbody td {
                padding: 18px 15px;
                vertical-align: middle;
            }
            
            .service-name {
                font-weight: 600;
                color: #333;
                font-size: 16px;
                position: relative;
            }
            
            .service-name::before {
                content: "🎮";
                margin-right: 10px;
                font-size: 18px;
            }
            
            .service-price {
                font-weight: 700;
                color: #e74c3c;
                font-size: 18px;
                text-align: right;
            }
            
            .service-price::after {
                content: " VND";
                font-size: 14px;
                color: #666;
                font-weight: normal;
            }
            
            .empty-services {
                text-align: center;
                padding: 60px 20px;
                background: #fff;
                border-radius: 12px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
                margin-top: 20px;
            }
            
            .empty-services h3 {
                color: #333;
                font-size: 1.8rem;
                margin-bottom: 15px;
            }
            
            .empty-services p {
                color: #666;
                font-size: 1.1rem;
                margin-bottom: 25px;
            }
            
            .btn-back-home {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border: none;
                padding: 12px 24px;
                border-radius: 8px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-block;
            }
            
            .btn-back-home:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
            }
            
            /* Responsive */
            @media (max-width: 768px) {
                .services-table {
                    font-size: 14px;
                }
                
                .services-table thead th {
                    padding: 15px 10px;
                    font-size: 16px;
                }
                
                .services-table tbody td {
                    padding: 15px 10px;
                }
                
                .service-price {
                    font-size: 16px;
                }
                
                .services-header h2 {
                    font-size: 2rem;
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
                        <span class="marquee-item"><span class="badge">HOT</span> Dịch vụ chất lượng cao</span>
                        <span class="marquee-item"><span class="badge">NEW</span> Nhiều dịch vụ mới được cập nhật</span>
                        <span class="marquee-item"><span class="badge">SALE</span> Ưu đãi đặc biệt cho khách hàng thân thiết</span>
                        <span class="marquee-item"><a href="#">Xem tất cả dịch vụ →</a></span>
                    </div>
                </div>

                <!-- ====== Hero Slider (banner chạy qua) ====== -->
                <div class="hero-wrap">
                    <div class="swiper hero-slider">
                        <div class="swiper-wrapper">
                            <!-- Thay ảnh & link theo banner của bạn -->
                            <div class="swiper-slide">
                                <a href="#"><img src="https://i.pinimg.com/1200x/02/0b/b4/020bb4b5afb678cd58829cf05c04cced.jpg" alt="Dịch vụ 1"></a>
                            </div>
                            <div class="swiper-slide">
                                <a href="#"><img src="https://i.pinimg.com/1200x/f3/8d/c6/f38dc68007559c8ea03dcb2546bc1ab8.jpg" alt="Dịch vụ 2"></a>
                            </div>
                            <div class="swiper-slide">
                                <a href="#"><img src="https://i.pinimg.com/1200x/6a/4c/eb/6a4ceb3f4a5cd6da10507decea99381c.jpg" alt="Dịch vụ 3"></a>
                            </div>
                        </div>

                        <!-- Dots -->
                        <div class="swiper-pagination"></div>
                        <!-- Prev/Next -->
                        <div class="swiper-button-prev"></div>
                        <div class="swiper-button-next"></div>
                    </div>
                </div>

                <!-- ====== Services Content ====== -->
                <div class="services-container">
                    <div class="services-header">
                        <h2>Danh sách dịch vụ</h2>
                        <p>Chúng tôi cung cấp các dịch vụ gaming chất lượng cao với giá cả hợp lý</p>
                    </div>

                    <c:choose>
                        <c:when test="${not empty listServices}">
                            <!-- Services Table -->
                            <div class="services-table-wrapper">
                                <table class="services-table">
                                    <thead>
                                        <tr>
                                            <th>Loại dịch vụ</th>
                                            <th style="text-align: right;">Giá tiền</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="service" items="${listServices.content}">
                                            
                                                <tr onclick="viewServiceDetail(${service.id})" style="cursor: pointer;">
                                                    <td>
                                                        <div class="service-name">${service.service_type}</div>
                                                    </td>
                                                    <td>
                                                        <div class="service-price">
                                                            <fmt:formatNumber value="${service.price}" type="number" groupingUsed="true" maxFractionDigits="0" />
                                                        </div>
                                                    </td>
                                                </tr>
                                            
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            
                        </c:when>
                        <c:otherwise>
                            <!-- Empty State -->
                            <div class="empty-services">
                                <h3>Chưa có dịch vụ nào</h3>
                                <p>Hiện tại chúng tôi đang cập nhật thêm nhiều dịch vụ mới. Vui lòng quay lại sau!</p>
                                <a href="MainController?action=prepareHome" class="btn-back-home">
                                    Về trang chủ
                                </a>
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
            // Hero Slider
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

            // Function để xem chi tiết service (bạn có thể tùy chỉnh)
            function viewServiceDetail(serviceId) {
                window.location.href = 'MainController?action=getService&idService=' + serviceId;
            }
        </script>
    </body>
</html>