<%-- Document : serviceHome Created on : Sep 19, 2025 Author : ddhuy --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> 
<fmt:setLocale value="vi_VN" />

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8" />
        <title>SHOP GAME VIỆT 38 - Dịch vụ</title>
        <%@ include file="/WEB-INF/jspf/head.jspf" %>
        <!-- Swiper CSS -->
        <link
            rel="stylesheet"
            href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css"
            />

        <!-- Custom CSS -->
        <link rel="stylesheet" href="assets/css/maincss.css" />
        <link rel="stylesheet" href="assets/css/no-border-radius.css" />

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
                padding: 8px;
            }

            .services-table {
                width: 100%;
                border-collapse: separate;
                border-spacing: 0 10px;
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

            .services-table thead th:first-child {
                border-radius: 8px 0 0 8px;
            }

            .services-table thead th:last-child {
                border-radius: 0 8px 8px 0;
            }

            .services-table tbody tr {
                transition: all 0.3s ease;
                margin-bottom: 10px;
            }

            .services-table tbody td {
                padding: 0;
                vertical-align: middle;
            }

            .service-link-row {
                display: block;
                text-decoration: none;
                color: inherit;
                background: #f8f9ff;
                border-radius: 8px;
                transition: all 0.3s ease;
                border: 2px solid transparent;
            }

            .service-link-row:hover {
                background: linear-gradient(135deg, rgba(102, 126, 234, 0.08) 0%, rgba(118, 75, 162, 0.08) 100%);
                border-color: #667eea;
                transform: translateX(8px);
                box-shadow: 0 6px 20px rgba(102, 126, 234, 0.15);
            }

            .service-row-content {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 20px 20px;
            }

            .service-name {
                font-weight: 600;
                color: #333;
                font-size: 16px;
                position: relative;
                transition: color 0.3s ease;
            }

            .service-name::before {
                content: "🎮";
                margin-right: 12px;
                font-size: 18px;
                display: inline-block;
                transition: transform 0.3s ease;
            }

            .service-link-row:hover .service-name {
                color: #667eea;
            }

            .service-link-row:hover .service-name::before {
                transform: scale(1.2) rotate(10deg);
            }

            .service-price {
                font-weight: 700;
                color: #e74c3c;
                font-size: 18px;
                text-align: right;
                transition: all 0.3s ease;
            }

            .service-link-row:hover .service-price {
                color: #c0392b;
                transform: scale(1.05);
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

            /* Responsive - đồng bộ với index.jsp */
            @media (max-width: 1230px) {
                .wrapper {
                    gap: 15px;
                    padding: 0 15px;
                }

                .sidebar {
                    flex: 2.5;
                }

                .Main_content {
                    flex: 7.5;
                }
            }

            @media (max-width: 968px) {
                .wrapper {
                    gap: 12px;
                    padding: 0 10px;
                }

                .sidebar {
                    flex: 2;
                    padding: 16px;
                }

                .Main_content {
                    flex: 8;
                }
            }

            @media (max-width: 768px) {
                .wrapper {
                    padding: 2px;
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

                .services-table {
                    font-size: 14px;
                    border-spacing: 0 8px;
                }

                .services-table thead th {
                    padding: 15px 10px;
                    font-size: 16px;
                }

                .service-row-content {
                    padding: 16px 14px;
                }

                .service-price {
                    font-size: 16px;
                }

                .services-header h2 {
                    font-size: 2rem;
                }

                .services-container {
                    padding: 16px;
                }

                .service-link-row:hover {
                    transform: translateX(4px);
                }
            }

            @media (max-width: 480px) {
                .services-container {
                    padding: 12px;
                }

                .services-header h2 {
                    font-size: 1.8rem;
                }

                .services-table thead th {
                    padding: 12px 8px;
                    font-size: 14px;
                }

                .service-row-content {
                    padding: 14px 12px;
                }

                .services-table {
                    border-spacing: 0 6px;
                }

                .service-name {
                    font-size: 14px;
                }

                .service-name::before {
                    font-size: 16px;
                    margin-right: 8px;
                }
            }
        </style>
    </head>
    <body>
        <div class="wrapper">
            <div class="sidebar">
                <jsp:include page="sidebar.jsp" />
            </div>

            <div class="Main_content">
                <jsp:include page="header.jsp" />

                <!-- ====== Marquee (thanh thông báo chạy ngang) ====== -->
                <div class="marquee-bar">
                    <div class="marquee-inner">
                        <span class="marquee-item"
                              ><span class="badge">HOT</span> Dịch vụ chất lượng cao</span
                        >
                        <span class="marquee-item"
                              ><span class="badge">NEW</span> Nhiều dịch vụ mới được cập
                            nhật</span
                        >
                        <span class="marquee-item"
                              ><span class="badge">SALE</span> Ưu đãi đặc biệt cho khách hàng
                            thân thiết</span
                        >
                        <span class="marquee-item"
                              ><a href="#">Xem tất cả dịch vụ →</a></span
                        >
                    </div>
                </div>

                <!-- ====== Hero Slider (banner chạy qua) ====== -->
                <div class="hero-wrap">
                    <div class="swiper hero-slider">
                        <div class="swiper-wrapper">
                            <c:forEach var="b" items="${topBanners}">
                                <div class="swiper-slide">
                                    <a href="#">
                                        <img src="${b.image_url}" alt="${fn:escapeXml(b.title)}" />
                                    </a>
                                </div>
                            </c:forEach>
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
                        <p>
                            Chúng tôi cung cấp các dịch vụ gaming chất lượng cao với giá cả
                            hợp lý
                        </p>
                    </div>

                    <c:choose>
                        <c:when test="${not empty listServices}">
                            <!-- Services Table -->
                            <div class="services-table-wrapper">
                                <table class="services-table">
                                    <thead>
                                        <tr>
                                            <th>Loại dịch vụ</th>
                                            <th style="text-align: right">Giá tiền</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="service" items="${listServices.content}">
                                            <tr>
                                                <td colspan="2" style="padding:0; border:none;">
                                                    <c:choose>
                                                        <c:when test="${not empty service}">
                                                            <!-- Có slug: đi theo route đẹp /service/{slug} -->
                                                            <a href="${pageContext.request.contextPath}/service/${service.slug}" class="service-link-row">
                                                                <div class="service-row-content">
                                                                    <div class="service-name">${service.service_type}</div>
                                                                    <div class="service-price">
                                                                        <fmt:formatNumber value="${service.price}" type="number" groupingUsed="true" maxFractionDigits="0"/> VND
                                                                    </div>
                                                                </div>
                                                            </a>
                                                        </c:when>
                                                    </c:choose>
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
                                <p>
                                    Hiện tại chúng tôi đang cập nhật thêm nhiều dịch vụ mới. 
                                    Vui lòng quay lại sau!
                                </p>
                                <a href="MainController?action=prepareHome" class="btn-back-home">
                                    Về trang chủ
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <jsp:include page="footer.jsp" />

        <!-- Swiper JS -->
        <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
        <script>
            // Hero Slider
            const heroSwiper = new Swiper(".hero-slider", {
                loop: true,
                autoplay: {delay: 3000, disableOnInteraction: false},
                speed: 700,
                spaceBetween: 16,
                pagination: {el: ".hero-slider .swiper-pagination", clickable: true},
                navigation: {
                    nextEl: ".hero-slider .swiper-button-next",
                    prevEl: ".hero-slider .swiper-button-prev",
                },
                grabCursor: true,
                effect: "slide",
            });

            // Function để xem chi tiết service (bạn có thể tùy chỉnh)
            function viewServiceDetail(serviceId) {
                window.location.href =
                        "MainController?action=getService&idService=" + serviceId;
            }
        </script>
    </body>
</html>
