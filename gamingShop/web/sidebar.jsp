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
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <!--<title>Sidebar Sản phẩm nổi bật</title>-->
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
                text-align: center;
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

            /* Grid layout for sidebar - thống nhất với productDetail */
            .featured-grid-sidebar {
                display: flex;
                flex-direction: column;
                gap: 12px;
                margin-bottom: 16px;
            }

            .grid-item-sb {
                width: 100%;
            }

            .grid-item-sb .card {
                width: 100%;
                height: 100%;
                background: #ffffff;
                border: 1px solid #f1f5f9;
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 6px 20px rgba(0,0,0,.08);
                transition: all .3s ease;
            }

            .grid-item-sb .card:hover {
                transform: translateY(-4px) scale(1.02);
                box-shadow: 0 12px 35px rgba(0,0,0,.15);
            }

            .grid-item-sb .thumb-btn-sb {
                width: 100%;
                height: 100%;
                display: flex;
                flex-direction: column;
                border: none;
                background: none;
                padding: 12px;
                cursor: pointer;
                gap: 8px;
            }

            /* List fallback */
            .featured-list-sb{
                list-style:none;
                margin:0 0 20px 0;
                padding:0;
                display:grid;
                gap:16px;
            }
            .sidebar p, .featured-list-sb p{
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
                gap:8px;
                align-items:center;
                text-align:center;
            }
            
            .image-price-container-sb{
                position: relative;
                width: 100%;
                height: 160px;
                flex-shrink: 0;
                display: flex;
                align-items: center;
                justify-content: center;
                overflow: hidden;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            }

            .thumb-sb{
                width: 100%;
                height: 100%;
                object-fit: cover;
                display: block;
                border-radius: 6px;
                transition: transform .3s ease;
                
            }
            
            .grid-item-sb .thumb-btn-sb:hover .thumb-sb{
                transform: scale(1.05);
            }

            .price-box-sb{
                position: absolute;
                bottom: 8px;
                right: 8px;
                background: linear-gradient(135deg, rgba(37,99,235,0.95), rgba(59,130,246,0.95));
                color: white;
                padding: 4px 8px;
                border-radius: 8px !important;
                font-size: 11px;
                font-weight: 700;
                box-shadow: 0 4px 12px rgba(37,99,235,0.3);
                border: 1px solid rgba(255,255,255,0.2);
                z-index: 10;
            }
            .price-text-sb{
                color: white;
                font-weight:700;
                font-size:12px;
                text-align:center;
                line-height:1.2;
                text-shadow: 0 1px 2px rgba(0,0,0,0.3);
            }
            .product-name{
                color: #111827;
                font-weight: 600;
                font-size: 13px;
                text-align: center;
                line-height: 1.4;
                width: 100%;
                word-break: break-word;
                display: -webkit-box;
                -webkit-line-clamp: 2;
                line-clamp: 2;
                -webkit-box-orient: vertical;
                overflow: hidden;
                margin-top: 4px;
            }
            .thumb-btn-sb:hover .price-box-sb{
                background: linear-gradient(135deg, rgba(59,130,246,0.95), rgba(37,99,235,0.95));
                transform: scale(1.05);
                box-shadow: 0 6px 16px rgba(37,99,235,0.4);
            }

            .view-more-btn{
                width: 100%;
                padding: 12px 24px;
                border: none;
                border-radius: 16px;
                font-weight: 600;
                font-size: 14px;
                cursor: pointer;
                text-transform: uppercase;
                letter-spacing: 1.5px;
                position: relative;
                overflow: hidden;
                transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
                font-family: inherit;

                /* Gradient xanh-tím hiện đại */
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: #fff;

                /* Hiệu ứng glassmorphism nhẹ */
                box-shadow: 0 8px 32px rgba(102, 126, 234, 0.3);
            }

            .view-more-btn::before{
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg,
                    transparent,
                    rgba(255, 255, 255, 0.4),
                    transparent
                    );
                transition: left 0.6s ease;
            }

            /* Thêm hiệu ứng shine */
            .view-more-btn::after{
                content: '';
                position: absolute;
                inset: 0;
                border-radius: 16px;
                padding: 2px;
                background: linear-gradient(135deg, #667eea, #764ba2, #f093fb);
                -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
                -webkit-mask-composite: xor;
                mask-composite: exclude;
                opacity: 0;
                transition: opacity 0.4s ease;
            }

            .view-more-btn:hover{
                background: linear-gradient(135deg, #5568d3 0%, #6a3e91 100%);
                transform: translateY(-3px) scale(1.02);
                box-shadow: 0 15px 40px rgba(102, 126, 234, 0.5),
                    0 5px 15px rgba(118, 75, 162, 0.3);
            }

            .view-more-btn:hover::before{
                left: 100%;
            }

            .view-more-btn:hover::after{
                opacity: 1;
            }

            .view-more-btn:active{
                transform: translateY(-1px) scale(0.98);
                box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
            }

            /* Thêm hiệu ứng glow khi focus */
            .view-more-btn:focus{
                outline: none;
                box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.2),
                    0 8px 32px rgba(102, 126, 234, 0.3);
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
                .image-price-container-sb{
                    width: 100%;
                    height: 140px;
                    border-radius: 10px;
                    box-shadow: 0 3px 8px rgba(0,0,0,0.1);
                }
                .thumb-btn-sb{
                    padding: 12px;
                    gap: 14px;
                }
                .price-text-sb{
                    font-size:11px;
                }
                .price-box-sb{
                    bottom: 6px;
                    right: 6px;
                    padding: 3px 6px;
                    border-radius: 6px;
                    font-size: 10px;
                    box-shadow: 0 3px 8px rgba(37,99,235,0.25);
                }
                .product-name{
                    font-size:12px;
                    margin-top: 2px;
                }
                .nav-item, .sb-nav a{
                    padding:12px 14px;
                    font-size:13px;
                }
            }
        </style>
    </head>
    <body>


            <!-- Logo -->
            <div class="logo-card">
                <c:choose>
                    <c:when test="${not empty applicationScope.logoPath and (fn:startsWith(applicationScope.logoPath, 'http') or fn:startsWith(applicationScope.logoPath, '/'))}">
                        <img class="logo" src="${applicationScope.logoPath}" alt="Logo cửa hàng" />
                    </c:when>
                    <c:otherwise>
                        <img class="logo" src="${pageContext.request.contextPath}/${applicationScope.logoPath != null ? applicationScope.logoPath : 'assets/img/logo/logo.png'}" alt="Logo cửa hàng" />
                    </c:otherwise>
                </c:choose>
            </div>

            <nav class="sb-nav">
                <a href="${pageContext.request.contextPath}/MainController?action=prepareHome">
                    <span class="nav-icon">🏠</span>
                    <span>Trang chủ</span>
                </a>

                <c:if test="${not empty user}">
                    <form action="${pageContext.request.contextPath}/MainController" method="post" class="nav-form">
                        <input type="hidden" name="action" value="searchBanner">
                        <input class="nav-item" type="submit" value="🪧️ Quản lý banners">
                    </form>
                    <form action="${pageContext.request.contextPath}/MainController" method="post" class="nav-form">
                        <input type="hidden" name="action" value="searchPosts">
                        <input class="nav-item" type="submit" value="🗂️ Quản lý bài đăng">
                    </form>

                    <form action="MainController" method="get" class="nav-form">
                        <input type="hidden" name="action" value="viewAllAccessories">
                        <input class="nav-item" type="submit" value="🔧 Quản lý phụ kiện">
                    </form>
                    <form action="${pageContext.request.contextPath}/MainController" method="post" class="nav-form">
                        <input type="hidden" name="action" value="viewServiceList">
                        <input class="nav-item" type="submit" value="⚙️ Quản lý dịch vụ">
                    </form>
                    <form action="${pageContext.request.contextPath}/MainController" method="post" class="nav-form">
                        <input type="hidden" name="action" value="viewModelList">
                        <input class="nav-item" type="submit" value="🎮 Quản lý sản phẩm"> 
                    </form>
                    <form method="get" action="MainController" class="nav-form">
                        <input type="hidden" name="action" value="goBannerTextForm">
                        <input class="nav-item" type="submit" value="📊 Sửa nội dung banner">
                    </form>
                </c:if>
            </nav>

            <hr class="divider">

<!-- Danh sách sản phẩm nổi bật: chỉ hiện khi có sản phẩm prominent -->
<c:if test="${isListProminent != true}">
    <!-- Kiểm tra trước xem có sản phẩm prominent không -->
    <c:set var="hasProminentProducts" value="false"/>
    <c:forEach var="i" items="${listProductForSidebar}">
        <c:if test="${i.status eq 'prominent'}">
            <c:set var="hasProminentProducts" value="true"/>
        </c:if>
    </c:forEach>
    
    <!-- Chỉ hiện mục khi có sản phẩm prominent -->
    <c:if test="${hasProminentProducts}">
        <h3 class="sb-title">NỔI BẬT</h3>
        <c:set var="shown" value="0"/>
        <div class="featured-grid-sidebar">
            <c:forEach var="i" items="${listProductForSidebar}">
                <c:if test="${i.status eq 'prominent' and shown < 3}">
                    <div class="grid-item-sb">
                        <form action="MainController" method="post" class="card">
                            <input type="hidden" name="action" value="getProduct"/>
                            <input type="hidden" name="idProduct" value="${i.id}"/>
                            <!-- Bấm vào cả card là submit -->
                            <button type="submit" class="thumb-btn-sb">
                                <!-- Container cho ảnh và giá -->
                                <div class="image-price-container-sb">
                                    <c:choose>
                                        <c:when test="${not empty i.coverImg and (fn:startsWith(i.coverImg, 'http') or fn:startsWith(i.coverImg, '/'))}">
                                            <img class="thumb-sb" src="${i.coverImg}" alt="${fn:escapeXml(i.name)}"/>
                                        </c:when>
                                        <c:when test="${not empty i.coverImg}">
                                            <img class="thumb-sb" src="${pageContext.request.contextPath}/${i.coverImg}" alt="${fn:escapeXml(i.name)}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <img class="thumb-sb" src="${pageContext.request.contextPath}/assets/images/no-image.jpg" alt="${fn:escapeXml(i.name)}"/>
                                        </c:otherwise>
                                    </c:choose>

                                    <div class="price-box-sb">
                                        <div class="price-text-sb">
                                            <fmt:formatNumber value="${i.price}" type="number" groupingUsed="true" maxFractionDigits="0" /> VND
                                        </div>
                                    </div>
                                </div>
                                <!-- Tên sản phẩm ở dưới -->
                                <div class="product-name">${i.name}</div>
                            </button>
                        </form>
                    </div>
                    <c:set var="shown" value="${shown + 1}"/>
                </c:if>
            </c:forEach>
        </div>
        <!-- Chỉ hiện nút xem thêm khi có sản phẩm prominent -->
        <form action="MainController" method="post">
            <input type="hidden" name="action" value="getProminentList">
            <input class="view-more-btn" type="submit" value="Xem thêm">
        </form>
    </c:if>
</c:if>

                <c:set var="shown" value="0"/>
                <h3 class="sb-title">BÀI ĐĂNG</h3>
                <ul class="featured-list-sb">
                    <c:forEach var="p" items="${listPostForSidebar}">
                        <c:if test="${p.status == 1 and shown < 3}">
                            <c:set var="shown" value="${shown + 1}"/>
                            <li class="card">
                                <a class="card-link" href="${pageContext.request.contextPath}/MainController?action=viewPost&id=${p.id}" aria-label="Xem chi tiết ${fn:escapeXml(p.title)}">
                                    <c:choose>
                                        <c:when test="${not empty p.image_url and (fn:startsWith(p.image_url, 'http') or fn:startsWith(p.image_url, '/'))}">
                                            <img class="post-thumb" src="${p.image_url}" alt="${fn:escapeXml(p.title)}" />
                                        </c:when>
                                        <c:when test="${not empty p.image_url}">
                                            <img class="post-thumb" src="${pageContext.request.contextPath}/${p.image_url}" alt="${fn:escapeXml(p.title)}" />
                                        </c:when>
                                        <c:otherwise>
                                            <img class="post-thumb" src="${pageContext.request.contextPath}/assets/images/no-image.jpg" alt="No image" />
                                        </c:otherwise>
                                    </c:choose>

                                    <div class="post-body">

                                        <!-- Tiêu đề (giống style product-name) -->
                                        <span class="product-name">${p.title}</span>

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

                <form action="${pageContext.request.contextPath}/MainController" method="post">

                    <input type="hidden" name="action" value="searchPosts">
                    <input class="view-more-btn" type="submit" value="Xem thêm">
                </form>
            </c:if>

        </aside>

    </body>
</html>
