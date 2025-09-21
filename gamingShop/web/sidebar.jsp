<%-- 
    Document   : sidebar
    Created on : 05-09-2025, 14:22:20
    Author     : MSI PC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<fmt:setLocale value="vi_VN" />
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <%@ include file="/WEB-INF/jspf/head.jspf" %>
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <title>Sidebar Sản phẩm nổi bật</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">

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
                --admin-gradient: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
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
            .nav-form {
                margin: 0;
                width: 100%;
            }

            /* Styling chung cho input submit và anchor */
            .nav-item, .sb-nav a{
                display:flex;
                align-items:center;
                justify-content:flex-start;
                padding:14px 16px;
                border-radius:14px;
                color:var(--ink);
                font-weight:600;
                text-decoration:none;
                box-shadow:0 4px 12px rgba(0,0,0,.08);
                transition:all .3s ease;
                border:1px solid #f1f5f9;
                position:relative;
                overflow:hidden;
                width:100%;
                font-size:14px;
                font-family:inherit;
                cursor:pointer;
                text-align:left;
                gap:10px;
                background: linear-gradient(145deg, #fff5f5, #e2e8f0);
                border-color: #fac8c8;
            }

            .nav-item::before, .sb-nav a::before{
                content:'';
                position:absolute;
                top:0;
                left:-100%;
                width:100%;
                height:100%;
                background:linear-gradient(90deg, transparent, rgba(255,255,255,0.8), transparent);
                transition:left .5s ease;
            }
            .nav-item:hover, .sb-nav a:hover{
                transform:translateY(-2px);
                box-shadow:0 8px 25px rgba(0,0,0,.15);
            }
            .sb-nav a:hover{
                background: linear-gradient(145deg, #ffffff, #f1f5f9);
            }
            .nav-item:hover{
                background: linear-gradient(145deg, #ffffff, #fef2f2);
                border-color:#fca5a5;
            }
            .nav-item:hover::before, .sb-nav a:hover::before{
                left:100%;
            }

            .nav-icon {
                font-size:16px;
                min-width:20px;
                text-align:center;
            }

            .divider{
                height:2px;
                background:linear-gradient(90deg, transparent, #e2e8f0, transparent);
                margin:0 0 20px 0;
                border:0;
                border-radius:1px;
            }

            /* Title */
            .sb-title{
                margin:20px 0 0 0;
                font-size:17px;
                font-weight:850;
                letter-spacing:.3px;
                color:#1e293b;
                padding:12px 20px;
                position:relative;
                overflow:hidden;
            }
            .sb-title::before{
                content:'';
                position:absolute;
                top:0;
                left:-100%;
                width:100%;
                height:100%;
                background:linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
                animation:shimmer 2s infinite;
            }
            @keyframes shimmer{
                0%{
                    left:-100%
                }
                100%{
                    left:100%
                }
            }

            /* List */
            .featured-list-sb{
                list-style:none;
                margin:0 0 20px 0;
                padding:0;
                display:grid;
                gap:16px;
            }
            p{
                color:#1296ba;
                text-align:center;
                font-style:italic;
            }

            .item-sb{
                background:#ffffff;
                border-radius:16px;
                overflow:hidden;
                box-shadow:0 6px 20px rgba(0,0,0,.08);
                transition:all .3s ease;
                border:1px solid #f1f5f9;
                position:relative;
                width:100%;
            }
            .item-sb::before{
                content:'';
                position:absolute;
                inset:0;
                background:linear-gradient(145deg, transparent, rgba(37,99,235,0.05));
                opacity:0;
                transition:opacity .3s ease;
                pointer-events:none;
            }
            .item-sb:hover{
                transform:translateY(-4px) scale(1.02);
                box-shadow:0 12px 35px rgba(0,0,0,.15);
            }
            .item-sb:hover::before{
                opacity:1;
            }

            .card{
                background:#ffffff;
                border:1px solid #f1f5f9;
                border-radius:16px;
                overflow:hidden;
                box-shadow:0 6px 20px rgba(0,0,0,.08);
                transition:all .3s ease;
            }
            .card:hover{
                transform:translateY(-4px) scale(1.02);
                box-shadow:0 12px 35px rgba(0,0,0,.15);
            }
            .card-link{
                display:block;
                text-decoration:none;
                color:inherit;
            }

            .thumb-btn-sb{
                border:none;
                background:none;
                padding:12px;
                width:100%;
                cursor:pointer;
                display:flex;
                flex-direction:column;
                gap:12px;
            }
            .image-price-container-sb{
                display:flex;
                gap:8px;
                align-items:stretch;
            }

            .thumb-sb{
                flex: 7;
                width: 80px;
                object-fit:cover;
                border-radius:10px;
                box-shadow:0 2px 8px rgba(0,0,0,.1);
                transition:transform .3s ease;
            }
            .thumb-btn-sb:hover .thumb-sb{
                transform:scale(1.02);
            }

            .price-box-sb{
                color:#e12e2e;
                flex: 0 0 36%;
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
            .price-text-sb{
                color:#dc3545;
                font-weight:800;
                font-size:12px;
                text-align:center;
                line-height:1.2;
                word-break:break-word;
                hyphens:auto;
            }
            .product-name{
                color:#000;
                font-weight:800;
                font-size:13px;
                text-align:center;
                line-height:1.3;
                padding:0 4px;
                word-break:break-word;
                hyphens:auto;
            }
            .thumb-btn-sb:hover .price-box-sb{
                background:#dee2e6;
            }

            .view-more-btn{
                width:100%;
                padding:5px;
                border:none;
                border-radius:16px;
                font-weight:500;
                font-size:14px;
                cursor:pointer;
                text-transform:uppercase;
                letter-spacing:1px;
                position:relative;
                overflow:hidden;
                transition:all .3s ease;
                font-family:inherit;
                background:var(--primary-blue);
                color:#fff;
            }
            .view-more-btn::before{
                content:'';
                position:absolute;
                top:0;
                left:-100%;
                width:100%;
                height:100%;
                background:linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
                transition:left .5s ease;
            }
            .view-more-btn:hover{
                background:var(--primary-blue-hover);
                transform:translateY(-2px);
                box-shadow:0 10px 30px rgba(29,78,216,.4);
            }
            .view-more-btn:hover::before{
                left:100%;
            }
            .view-more-btn:active{
                transform:translateY(0);
            }

            /* ==== Post cards in sidebar (ảnh trên - tiêu đề - ngày đăng) ==== */
            .post-thumb{
                width:100%;
                height:160px;
                object-fit:cover;
                display:block;
            }
            .post-body{
                padding:10px 12px 12px;
                display:flex;
                flex-direction:column;
                gap:6px;
            }
            .post-title{
                color:#000;
                font-weight:800;
                font-size:13px;
                text-align:center;
                line-height:1.3;
                padding:0 4px;
                word-break:break-word;
                hyphens:auto;
            }
            .post-date{
                display:block;
                text-align:center;
                font-size:12px;
                color:var(--muted);
            }
            .badge{
                display:inline-block;
                padding:2px 8px;
                border-radius:999px;
                font-size:11px;
                font-weight:700;
                background:#e5e7eb;
                color:#374151;
            }
            .badge.success{
                background:#dcfce7;
                color:#166534;
            }
            .badge.warning{
                background:#fef3c7;
                color:#92400e;
            }

            @media (max-width:768px){
                .sidebar{
                    max-width:100%;
                    border-radius:20px;
                    margin:10px;
                }
                .logo{
                    width:100px;
                    height:100px;
                }
                .thumb-sb{
                    height:70px;
                }
                .price-box-sb{
                    height:70px;
                }
                .price-text-sb{
                    font-size:10px;
                }
                .product-name{
                    font-size:11px;
                }
                .nav-item, .sb-nav a{
                    padding:12px 14px;
                    font-size:13px;
                }
            }
        </style>
    </head>
    <body>

        <aside class="sidebar">
            <!-- Logo -->
            <div class="logo-card">
                <img class="logo" src="assets/img/logo/logo.png" alt="Logo cửa hàng">
            </div>

            <!-- Menu -->
            <nav class="sb-nav">
                <a href="MainController?action=prepareHome">
                    <span class="nav-icon">🏠</span>
                    <span>Trang chủ</span>
                </a>

                <c:if test="${not empty user}">
                    <form action="MainController" method="post" class="nav-form">
                        <input type="hidden" name="action" value="searchBanner">
                        <input class="nav-item" type="submit" value="🪧️ Quản lý banners">
                    </form>
                    <form action="MainController" method="post" class="nav-form">
                        <input type="hidden" name="action" value="searchPosts">
                        <input class="nav-item" type="submit" value="🗂️ Quản lý bài posts">
                    </form>
                    <form action="MainController" method="post" class="search-form" autocomplete="off">
                        <input type="hidden" name="action" value="searchProduct"/>
                        <input class="nav-item" type="submit" value="📦 Quản lý sản phẩm">
                    </form>
                    <form action="MainController" method="post" class="nav-form">
                        <input type="hidden" name="action" value="viewAllAccessories">
                        <input class="nav-item" type="submit" value="🔧 Quản lý phụ kiện">
                    </form>
                    <form action="MainController" method="post" class="nav-form">
                        <input type="hidden" name="action" value="viewServiceList">
                        <input class="nav-item" type="submit" value="⚙️ Quản lý dịch vụ">
                    </form>
                    <form action="MainController" method="post" class="nav-form">
                        <input type="hidden" name="action" value="viewModelList">
                        <input class="nav-item" type="submit" value="🎮 Quản lý model"> 
                    </form>
                </c:if>
            </nav>

            <hr class="divider">

            <!-- Danh sách sản phẩm nổi bật: chỉ ẩn khi đang ở trang danh sách nổi bật -->
            <c:if test="${isListProminent != true}">
                <h3 class="sb-title">Nổi bật</h3>
                <c:choose>
                    <c:when test="${not empty listProductForSidebar}">
                        <c:set var="shown" value="0"/>
                        <ul class="featured-list-sb">
                            <c:forEach var="i" items="${listProductForSidebar}">
                                <c:if test="${i.status eq 'prominent' and shown < 3}">
                                    <li class="item-sb">
                                        <form action="MainController" method="post" class="card">
                                            <input type="hidden" name="action" value="getProduct"/>
                                            <input type="hidden" name="idProduct" value="${i.id}"/>

                                            <button type="submit" class="thumb-btn-sb">
                                                <div class="image-price-container-sb">
                                                    <img class="thumb-sb" src="${i.coverImg}" alt="${fn:escapeXml(i.name)}"/>
                                                    <div class="price-box-sb">
                                                        <div class="price-text-sb">
                                                            <fmt:formatNumber value="${i.price}" type="number" groupingUsed="true" maxFractionDigits="0" /> VND
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="product-name">${i.name}</div>
                                            </button>
                                        </form>
                                    </li>
                                    <c:set var="shown" value="${shown + 1}"/>
                                </c:if>
                            </c:forEach>
                        </ul>
                        <form action="MainController" method="post">
                            <input type="hidden" name="action" value="getProminentList">
                            <input class="view-more-btn" type="submit" value="Xem thêm">
                        </form>
                    </c:when>
                    <c:otherwise>
                        <p>Hiện danh sách đang trống!</p>
                    </c:otherwise>
                </c:choose>
            </c:if>

            <!-- Bài đăng gần đây -->
            <c:if test="${ not empty listPostForSidebar }">
                <c:set var="shown" value="0"/>
                <h3 class="sb-title">Bài đăng</h3>
                <ul class="featured-list-sb">
                    <c:forEach var="p" items="${listPostForSidebar}">
                        <c:if test="${p.status == 1 and shown <3}">
                            <c:set var="shown" value="${shown + 1}"/>
                            <li class="card">
                                <a class="card-link" href="MainController?action=viewPost&id=${p.id}" aria-label="Xem chi tiết ${fn:escapeXml(p.title)}">
                                    <c:choose>
                                        <c:when test="${not empty p.image_url}">
                                            <img class="post-thumb" src="${p.image_url}" alt="${fn:escapeXml(p.title)}" />
                                        </c:when>
                                        <c:otherwise>
                                            <img class="post-thumb" src="/assets/images/no-image.jpg" alt="No image" />
                                        </c:otherwise>
                                    </c:choose>

                                    <div class="post-body">
                                        <!-- Tiêu đề (giống style product-name) -->
                                        <span class="post-title">${p.title}</span>

                                        <!-- Ngày đăng kèm trạng thái -->
                                        <span class="post-date">
                                            <c:choose>
                                                <c:when test="${p.status == 1}">
                                                    Đã xuất bản : <fmt:formatDate value="${p.publish_date}" pattern="dd/MM/yyyy"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:if test="${isLoggedIn}">
                                                        Bản nháp : <fmt:formatDate value="${p.publish_date}" pattern="dd/MM/yyyy"/>
                                                    </c:if>
                                                </c:otherwise>
                                            </c:choose>
                                        </span>

                                    </div>
                                </a>
                            </li>
                        </c:if>
                    </c:forEach>
                </ul>
                <!-- Nút Xem thêm -->
                <form action="MainController" method="post">
                    <input type="hidden" name="action" value="searchPosts">
                    <input class="view-more-btn" type="submit" value="Xem thêm">
                </form>
            </c:if>
        </aside>

    </body>
</html>
