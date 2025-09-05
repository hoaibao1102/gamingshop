<%-- 
    Document   : sidebar
    Created on : 05-09-2025, 14:22:20
    Author     : MSI PC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN" />
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <title>Sidebar Sản phẩm nổi bật</title>
        <style>
            :root{
                --ring:#e5e7eb;
                --ink:#111827;
                --muted:#6b7280;
                --chip:#e6e6e6;
                --shadow:0 6px 18px rgba(0,0,0,.08);
                --primary-blue: #2563eb;
                --primary-blue-hover: #1d4ed8;
                --light-blue: #dbeafe;
                --gradient-bg: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            }
            *{
                box-sizing:border-box
            }
            body{
                margin:0;
                font-family:system-ui,-apple-system,Segoe UI,Roboto,Helvetica,Arial,sans-serif;
                color:var(--ink);
                background:#fafafa
            }

            /* Sidebar */
            .sidebar{
                width:100%;
                max-width:300px;
                background:#ffffff;
                border-radius:20px;
                padding:20px;
                box-shadow:0 10px 40px rgba(0,0,0,.1);
                position:sticky;
                top:20px;
                border:1px solid #f1f5f9;
            }

            /* Logo card */
            .logo-card{
                background:var(--gradient-bg);
                border-radius:18px;
                padding:24px 16px 12px;
                display:grid;
                place-items:center;
                box-shadow:0 8px 32px rgba(102, 126, 234, 0.3);
                margin-bottom:20px;
            }
            .logo{
                width:120px;
                height:120px;
                border-radius:50%;
                object-fit:cover;
                display:block;
                box-shadow:0 12px 28px rgba(0,0,0,.25);
                border:4px solid rgba(255,255,255,0.2);
            }

            /* Menu dưới logo */
            .sb-nav {
                display: flex;
                flex-direction: column;
                margin: 0 0 20px 0;
                gap: 12px;
            }
            .sb-nav a {
                display: flex;
                align-items: center;
                padding: 14px 16px;
                border-radius: 14px;
                background: linear-gradient(145deg, #f8fafc, #e2e8f0);
                color: var(--ink);
                font-weight: 600;
                text-decoration: none;
                box-shadow: 0 4px 12px rgba(0,0,0,.08);
                transition: all 0.3s ease;
                border:1px solid #f1f5f9;
                position: relative;
                overflow: hidden;
            }
            .sb-nav a::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255,255,255,0.8), transparent);
                transition: left 0.5s ease;
            }
            .sb-nav a:hover {
                background: linear-gradient(145deg, #ffffff, #f1f5f9);
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(0,0,0,.15);
            }
            .sb-nav a:hover::before {
                left: 100%;
            }

            .divider{
                height:2px;
                background:linear-gradient(90deg, transparent, #e2e8f0, transparent);
                margin:0 0 20px 0;
                border:0;
                border-radius:1px;
            }

            /* Title - Sản phẩm nổi bật */
            .sb-title{
                margin:0 0 20px 0;
                font-size:18px;
                font-weight:800;
                letter-spacing:.3px;
                color:#1e293b;
                text-align:center;
                background:var(--primary-blue);
                color:white;
                padding:12px 20px;
                border-radius:25px;
                box-shadow:0 6px 20px rgba(37, 99, 235, 0.3);
                position:relative;
                overflow:hidden;
            }
            .sb-title::before {
                content:'';
                position:absolute;
                top:0;
                left:-100%;
                width:100%;
                height:100%;
                background:linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
                animation:shimmer 2s infinite;
            }
            @keyframes shimmer {
                0% {
                    left: -100%;
                }
                100% {
                    left: 100%;
                }
            }

            /* List */
            .featured-list{
                list-style:none;
                margin:0 0 20px 0;
                padding:0;
                display:grid;
                gap:16px;
            }
            p{
                color: #1296ba;
                text-align:center;
                font-style:italic;
            }
            .item{
                background:#ffffff;
                border-radius:16px;
                overflow:hidden;
                box-shadow:0 6px 20px rgba(0,0,0,.08);
                transition: all .3s ease;
                border:1px solid #f1f5f9;
                position:relative;
                width: 77%;
            }
            .item::before {
                content:'';
                position:absolute;
                top:0;
                left:0;
                right:0;
                bottom:0;
                background:linear-gradient(145deg, transparent, rgba(37, 99, 235, 0.05));
                opacity:0;
                transition:opacity .3s ease;
                pointer-events:none;
            }
            .item:hover{
                transform:translateY(-4px) scale(1.02);
                box-shadow:0 12px 35px rgba(0,0,0,.15);
            }
            .item:hover::before {
                opacity:1;
            }

            /* Form và button styling */
            .card {
                margin:0;
                padding:0;
            }
            .thumb-btn {
                border:none;
                background:none;
                padding:12px;
                width:100%;
                cursor:pointer;
                display:flex;
                flex-direction:column;
                gap:12px;
            }

            /* Container cho ảnh và giá */
            .image-price-container {
                display:flex;
                gap:8px;
                align-items:stretch;
            }

            /* Ảnh chiếm 7 phần */
            .thumb{
                flex: 7;
                height:80px;
                object-fit:cover;
                border-radius:10px;
                box-shadow:0 2px 8px rgba(0,0,0,.1);
                transition:transform .3s ease;
            }
            .thumb-btn:hover .thumb {
                transform:scale(1.02);
            }

            /* Giá chiếm 3 phần */
            .price-box{
                flex: 3;
                height:80px;
                background:#f8f9fa;
                border-radius:10px;
                display:flex;
                align-items:center;
                justify-content:center;
                text-decoration:none;
                box-shadow:0 2px 8px rgba(0,0,0,.05);
                border:1px solid #e9ecef;
                transition:background .3s ease;
            }

            .price-text {
                color:#dc3545;
                font-weight:800;
                font-size:12px;
                text-align:center;
                line-height: 1.2;
                word-break: break-word;
                hyphens: auto;
            }

            /* Tên sản phẩm ở dưới */
            .product-name {
                color:#000000;
                font-weight:800;
                font-size:13px;
                text-align:center;
                line-height:1.3;
                padding:0 4px;
                word-break: break-word;
                hyphens: auto;
            }

            .thumb-btn:hover .price-box {
                background:#dee2e6;
            }

            /* Nút Xem thêm */
            .view-more-btn {
                width:100%;
                padding:16px;
                background:var(--primary-blue);
                color:white;
                border:none;
                border-radius:16px;
                font-weight:700;
                font-size:14px;
                cursor:pointer;
                text-transform:uppercase;
                letter-spacing:1px;
                position:relative;
                overflow:hidden;
                transition:all .3s ease;
                box-shadow:0 6px 20px rgba(37, 99, 235, 0.3);
            }
            .view-more-btn::before {
                content:'';
                position:absolute;
                top:0;
                left:-100%;
                width:100%;
                height:100%;
                background:linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
                transition:left .5s ease;
            }
            .view-more-btn:hover {
                background:var(--primary-blue-hover);
                transform:translateY(-2px);
                box-shadow:0 10px 30px rgba(29, 78, 216, 0.4);
            }
            .view-more-btn:hover::before {
                left:100%;
            }
            .view-more-btn:active {
                transform:translateY(0);
            }

            /* Responsive: full width khi màn hình hẹp */
            @media (max-width: 768px){
                .sidebar{
                    max-width:100%;
                    border-radius:20px;
                    margin:10px;
                }
                .logo{
                    width:100px;
                    height:100px;
                }
                .thumb{
                    height:70px;
                }
                .price-box{
                    height:70px;
                }
                .price-text{
                    font-size:10px;
                }
                .product-name{
                    font-size:11px;
                }
            }
        </style>
    </head>
    <body>

        <aside class="sidebar">
            <!-- Logo -->
            <div class="logo-card">
                <img class="logo" src="https://via.placeholder.com/220x220.png?text=LOGO" alt="Logo cửa hàng">
            </div>

            <!-- Menu -->
            <nav class="sb-nav">
                <a href="index.jsp">🏠 Trang chủ</a>
                <a href="#">📰 Bài đăng gần đây</a>
            </nav>

            <hr class="divider">

            <!-- Danh sách sản phẩm nổi bật -->
            <h3 class="sb-title">Sản phẩm nổi bật</h3>
            <c:choose>
                <c:when test="${not empty list}">
                    <c:set var="shown" value="0"/>
                    <ul class="featured-list">
                        <c:forEach var="i" items="${list}">
                            <c:if test="${i.status eq 'prominent' and shown < 4}">
                                <li class="item">
                                    <form action="MainController" method="get" class="card">
                                        <input type="hidden" name="action" value="getProduct"/>
                                        <input type="hidden" name="id" value="${i.id}"/>

                                        <!-- Bấm vào cả card là submit -->
                                        <button type="submit" class="thumb-btn">
                                            <!-- Container cho ảnh và giá -->
                                            <div class="image-price-container">
                                                <img class="thumb" src="${i.image.image_url}" alt="${i.name}"/>
                                                <div class="price-box">
                                                    <div class="price-text"><fmt:formatNumber value="${i.price}" type="number" groupingUsed="true" maxFractionDigits="0" />
                                                        VND</div>
                                                </div>
                                            </div>
                                            <!-- Tên sản phẩm ở dưới -->
                                            <div class="product-name">${i.name}</div>
                                        </button>
                                    </form>
                                </li>
                                <c:set var="shown" value="${shown + 1}"/>
                            </c:if>
                        </c:forEach>
                    </ul>

                </c:when>
                <c:otherwise>
                    <p>Hiện danh sách đang trống!</p>
                </c:otherwise>
            </c:choose>

            <!-- Nút Xem thêm -->
            <form action="MainController" method="get">
                <input type="hidden" name="action" value="getProminentList">
                <input class="view-more-btn" type="submit"  value="Xem thêm">
            </form>


        </aside>

    </body>
</html>