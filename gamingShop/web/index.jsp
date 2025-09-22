<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN" />

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>SHOP GAME VIỆT 38 - Trang chủ</title>
        <%@ include file="/WEB-INF/jspf/head.jspf" %>
        <!-- Swiper CSS -->
        <link
            rel="stylesheet"
            href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css"/>
        <!--        Font chu-->
        <link href="https://fonts.googleapis.com/css2?family=Noto+Sans:wght@400;500;600;700;800&display=swap&subset=vietnamese" rel="stylesheet">

        <!-- Custom CSS -->
        <link rel="stylesheet" href="assets/css/maincss.css">
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

                <!-- ====== Filter Form (sau banner) ====== -->
                <c:if test="${not empty pageResult || not empty list}">
                    <jsp:include page="filter-form.jsp"/>
                </c:if>


                <!-- ====== Nội dung trang ====== -->
                <div class="container">
                    <h3>${nameProductsByCategory}</h3>
                    <c:choose>
                        <c:when test="${not empty listProductsByCategory}">
                            <c:set var="products" value="${listProductsByCategory.content}" />
                        </c:when>
                        <c:otherwise>
                            <c:set var="products" value="${not empty pageResult ? pageResult.content : list}" />
                        </c:otherwise>
                    </c:choose>

                    <c:choose>
                        <c:when test="${not empty products}">
                            <!-- Product Grid -->
                            <ul class="featured-list">
                                <c:forEach var="product" items="${products}">
                                    <c:if test="${product.status ne 'inactive'}">
                                        <li class="item">
                                            <form action="MainController" method="post" class="product-form">
                                                <c:choose>
                                                    <c:when test="${not empty isListProductsByCategory}">
                                                        <input type="hidden" name="idAccessory" value="${product.id}">
                                                        <input type="hidden" name="action" value="getAccessory">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <input type="hidden" name="idProduct" value="${product.id}">
                                                        <input type="hidden" name="action" value="getProduct">
                                                    </c:otherwise>
                                                </c:choose>

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
                                <button class="sb-title" onclick="resetFilter()" class="btn-filter">
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