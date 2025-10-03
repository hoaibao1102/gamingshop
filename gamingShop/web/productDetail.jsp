<%-- 
    Document   : productDetail
    Created on : 12-09-2025, 17:24:22
    Author     : MSI PC
--%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:setLocale value="vi_VN" />

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <title>SHOP GAME VIỆT 38</title>
        <%@ include file="/WEB-INF/jspf/head.jspf" %>
        <!-- Breadcrumbs CSS -->
        <link rel="stylesheet" href="assets/css/breadcrumbs.css" />
        <style>
            /* =========================
   Base + Variables (giữ gọn)
========================= */
            :root{
                --bg:#f8fafc;
                --text:#111827;
                --muted:#6b7280;
                --accent:#7c3aed;
                --danger:#e11d48;
                --border:#e5e7eb;
                --shadow:0 10px 40px rgba(0,0,0,.08);
            }
            *{
                box-sizing:border-box;
            }
            html,body{
                margin:0;
                padding:0;
                width:100%;
                height:100%;
                background:var(--bg);
                color:var(--text);
                font-family:Inter,-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Oxygen,Ubuntu,Cantarell,sans-serif;
            }

            /* =========================
               App Shell
            ========================= */
            .wrapper{
                display:flex;
                gap:20px;
                padding:0 20px;
                min-height:100vh;
                width:100%;
            }
            .sidebar{
                flex:3;
                background:linear-gradient(135deg,#2c3e50,#34495e);
                color:#fff;
                border-radius:20px;
                padding:24px;
                box-shadow:var(--shadow);
                position:sticky;
                top:20px;
                height:fit-content;
            }
            .Main_content{
                flex:7;
                background:#fff;
                border-radius:20px;
                box-shadow:var(--shadow);
                display:flex;
                flex-direction:column;
                min-width:0; /* chống tràn */
            }
            .container{
                padding:16px 20px;
            }


            /* =========================
               Product Detail
            ========================= */
            .product-detail{
                display:grid;
                gap:20px;
                align-items:start;
                grid-template-columns:minmax(420px,3fr) minmax(0,7fr);
            }

            /* Gallery */
            .pd-left{
                background:#fff;
                border-radius:16px;
                box-shadow:var(--shadow);
                padding:16px;
            }
            .pd-main{
                width:100%;
                height:clamp(380px,48vh,560px);
                border:1px solid #eee;
                border-radius:12px;
                overflow:hidden;
                display:flex;
                align-items:center;
                justify-content:center;
                background:#fff;
            }
            .pd-main img{
                width:100%;
                height:100%;
                object-fit:contain;
                display:block;
            }

            /* Reset button để không bị viền/spacing lạ trên mobile */
            .pd-thumbs{
                margin-top:12px;
                display:grid;
                grid-template-columns:repeat(4,1fr);
                gap:12px;
            }
            .pd-thumb{
                -webkit-appearance:none;
                appearance:none;
                background:#fff;
                border:1px solid #eee;
                border-radius:10px;
                padding:6px;
                cursor:pointer;
                transition:transform .18s ease, box-shadow .18s ease, border-color .18s ease;
            }
            .pd-thumb img{
                width:100%;
                aspect-ratio:1/1;
                object-fit:contain;
                display:block;
            }
            .pd-thumb:hover{
                transform:translateY(-2px);
                box-shadow:0 6px 16px rgba(0,0,0,.06);
                border-color:#ddd;
            }
            .pd-thumb.is-active{
                border-color:var(--accent);
                box-shadow:0 0 0 2px rgba(124,58,237,.12) inset;
            }

            /* Info + Description */
            .pd-right{
                position:sticky;
                top:16px;
                background:#fff;
                border-radius:16px;
                box-shadow:var(--shadow);
                padding:20px;
                height:fit-content;
            }
            .pd-name{
                margin:0 0 12px;
                font-size:22px;
                font-weight:800;
                line-height:1.3;
            }
            .pd-basic{
                display:grid;
                gap:10px;
                margin-bottom:16px;
            }
            .pd-row{
                display:grid;
                grid-template-columns:110px 1fr;
                gap:12px;
                align-items:center;
                font-size:14px;
            }
            .pd-row b{
                color:var(--muted);
                font-weight:600;
            }
            .pd-row span{
                color:var(--text);
                font-weight:600;
            }
            .pd-row-price{
                background:#f9fafb;
                border:1px solid #f0f0f0;
                border-radius:12px;
                padding:14px 16px;
                margin-top:6px;
            }
            .pd-row-price span{
                color:var(--danger);
                font-size:20px;
                font-weight:800;
            }

            /* Description: CHỐT căn lề + khoảng cách, tránh lệch */
            .pd-desc{
                margin-top:16px;
                padding-top:16px;
                border-top:1px dashed var(--border);
                font-size:14px;
                line-height:1.65;
                color:#1f2937;
            }
            .pd-desc > *:first-child{
                margin-top:0;
            }
            .pd-desc h1,.pd-desc h2,.pd-desc h3{
                margin:12px 0 8px;
                line-height:1.3;
            }
            .pd-desc p{
                margin:8px 0;
            }
            .pd-desc ul, .pd-desc ol{
                padding-left:20px;
                margin:8px 0;
            }
            .pd-desc img, .pd-desc iframe{
                max-width:100%;
                height:auto;
                display:block;
                margin:10px auto;
            }
            .pd-desc table{
                width:100%;
                border-collapse:collapse;
                overflow:auto;
                display:block;
            }
            .pd-desc table td, .pd-desc table th{
                border:1px solid #e5e7eb;
                padding:8px;
            }

            .pd-accessories {
                margin-top: 15px;
                padding: 15px;
                border: 1px solid #e0e0e0;
                border-radius: 8px;
                background-color: #fafafa;
                font-family: Arial, sans-serif;
            }

            .pd-accessories b {
                display: block;
                font-size: 16px;
                margin-bottom: 8px;
                color: #333;
            }

            .pd-accessories ul {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .pd-accessories li {
                position: relative;
                padding-left: 24px;
                margin-bottom: 6px;
                font-size: 14px;
                color: #555;
            }

            .pd-accessories li::before {
                content: "🎁";
                position: absolute;
                left: 0;
                top: 0;
            }
            /* Breadcrumbs hiện đại */
            .breadcrumbs {
                display: flex;
                align-items: center;
                gap: 8px;
                font-size: 0.9rem;
                color: #6b7280;
                margin-bottom: 16px;
                padding: 12px 16px;
                background: linear-gradient(135deg, #f8fafc, #f1f5f9);
                border: 1px solid #e2e8f0;
                border-radius: 12px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            }
            .breadcrumbs a {
                color: #3b82f6;
                text-decoration: none;
                font-weight: 500;
                padding: 4px 8px;
                border-radius: 6px;
                transition: all 0.2s ease;
                position: relative;
            }
            .breadcrumbs a:hover {
                background: rgba(59, 130, 246, 0.1);
                color: #1d4ed8;
                transform: translateY(-1px);
            }
            .breadcrumbs .sep {
                color: #9ca3af;
                font-weight: 600;
                font-size: 1rem;
                margin: 0 2px;
            }
            .breadcrumbs .current {
                color: #111827;
                font-weight: 600;
                background: rgba(255, 255, 255, 0.8);
                padding: 4px 8px;
                border-radius: 6px;
                border: 1px solid #e5e7eb;
            }
            
            /* Breadcrumbs animations và micro-interactions */
            .breadcrumbs a::before {
                content: '';
                position: absolute;
                bottom: 0;
                left: 50%;
                width: 0;
                height: 2px;
                background: #3b82f6;
                transition: all 0.3s ease;
                transform: translateX(-50%);
            }
            .breadcrumbs a:hover::before {
                width: 80%;
            }
            .breadcrumbs .sep {
                transition: all 0.2s ease;
            }
            .breadcrumbs a:hover + .sep {
                color: #3b82f6;
                transform: scale(1.1);
            }

            /* Empty state */
            .empty-state{
                text-align:center;
                padding:60px 20px;
            }
            .empty-state h3{
                font-size:24px;
                margin-bottom:10px;
            }
            .empty-state p{
                font-size:16px;
                opacity:.8;
            }

            /* Scrollbar nhẹ cho phần chính */
            .Main_content::-webkit-scrollbar{
                width:8px;
            }
            .Main_content::-webkit-scrollbar-track{
                background:#f1f5f9;
                border-radius:4px;
            }
            .Main_content::-webkit-scrollbar-thumb{
                background:#d1d5db;
                border-radius:4px;
            }
            .Main_content::-webkit-scrollbar-thumb:hover{
                background:#9ca3af;
            }
            .sd-actions {
                display: flex;
                flex-wrap: wrap;          /* tự động xuống hàng nếu chật */
                gap: 12px;                /* khoảng cách giữa các nút */
                margin-top: 20px;
                justify-content: center;  /* căn giữa các nút */
            }

            .btn-service {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                padding: 10px 18px;
                font-size: 15px;
                font-weight: 500;
                border-radius: 8px;
                border: none;
                cursor: pointer;
                text-decoration: none;    /* áp dụng cho thẻ <a> */
                transition: all 0.25s ease;
            }

            .btn-primary {
                background-color: #007bff;
                color: #fff;
            }

            .btn-primary:hover {
                background-color: #0069d9;
            }

            .btn-secondary {
                background-color: #f1f3f5;
                color: #333;
            }

            .btn-secondary:hover {
                background-color: #e2e6ea;
            }

            .btn-service:active {
                transform: scale(0.96);   /* hiệu ứng nhấn */
            }

            .pd-desc-title {
                font-size: 18px;
                text-align: center;
                font-weight: 600;
                color: #111827;
                margin-bottom: 14px;
                padding-bottom: 8px;
                border-bottom: 2px solid #007bff; /* gạch dưới màu xanh */
                display: flex;
                justify-content: center;   /* căn giữa ngang */
                align-items: center;
                gap: 6px;
            }
            /* =========================
               Responsive (đã rút gọn)
            ========================= */

            /* ≤1280px: coi như mobile-tablet (match Home) */
            @media (max-width:1280px){
                html,body{
                    overflow-x:hidden;
                }

                .wrapper{
                    display:block;
                    padding:0 !important;
                    gap:0 !important;
                    min-height:100dvh;
                }
                .sidebar{
                    display:none !important;
                }

                .Main_content{
                    width:100% !important;
                    max-width:100% !important;
                    border-radius:0 !important;
                    box-shadow:none !important;
                    overflow:visible;
                }
                .container{
                    padding:12px 12px 20px !important;
                }
                
                .breadcrumbs {
                    padding: 8px 12px !important;
                    font-size: 0.85rem !important;
                    flex-wrap: wrap !important;
                    margin-bottom: 12px !important;
                }
                .breadcrumbs a {
                    padding: 3px 6px !important;
                }

                .product-detail{
                    grid-template-columns:1fr !important;
                    gap:6px !important;
                }

                .pd-left{
                    margin-right: -10px;
                    padding:0 !important;
                    border-radius:0 !important;
                    box-shadow:none !important;
                }
                .pd-main{
                    border:none !important;
                    border-radius:0 !important;
                    height:clamp(240px,42vh,420px) !important;
                }

                /* Thumbs chuyển sang cuộn ngang, tránh lệch hàng */
                .pd-thumbs{
                    display:flex !important;
                    gap:4px !important;
                    padding:10px 12px 4px !important;
                    overflow-x:auto !important;
                    -webkit-overflow-scrolling:touch;
                    scroll-snap-type:x mandatory;
                    scrollbar-width:none;
                }
                .pd-thumbs::-webkit-scrollbar{
                    display:none;
                }
                .pd-thumb{
                    flex:0 0 96px !important;
                    scroll-snap-align:start;
                }
                /* Thông tin: bỏ sticky để không lệch khi cuộn, đồng bộ padding */
                .pd-right{
                    position:static !important;
                    top:auto !important;
                    padding:14px 12px !important;
                    margin:0 !important;
                    border-radius:12px !important;
                    box-shadow:0 10px 40px rgba(0,0,0,.06);
                }
                .pd-name{
                    font-size:18px !important;
                    margin:0 0 10px !important;
                }
                .pd-row{
                    grid-template-columns:96px 1fr !important;
                    gap:10px !important;
                    font-size:13.5px !important;
                }
                .pd-row-price{
                    padding:12px !important;
                }
                .pd-row-price span{
                    font-size:18px !important;
                }

                /* Description: khoá lề trái/phải khớp container để không bị “lệch hàng” */
                .pd-desc{
                    margin-top:14px !important;
                    padding-top:14px !important;
                    padding-left:2px;
                    padding-right:2px; /* tinh chỉnh nhỏ cho khớp ảnh/thumbs */
                }
            }


            /* ≤640px: tinh chỉnh tap-target & chiều cao ảnh */
            @media (max-width:640px){
                .container{
                    padding:10px 10px 16px !important;
                }
                .pd-main{
                    height:clamp(220px,38vh,380px) !important;
                }
                .pd-thumb{
                    flex:0 0 88px !important;
                }
                
                .breadcrumbs {
                    padding: 6px 10px !important;
                    font-size: 0.8rem !important;
                    margin-bottom: 10px !important;
                }
                .breadcrumbs a {
                    padding: 2px 4px !important;
                    font-size: 0.8rem !important;
                }
                .breadcrumbs .sep {
                    font-size: 0.9rem !important;
                }
            }

            /* Accessibility */
            @media (prefers-reduced-motion:reduce){
                .pd-thumb{
                    transition:none !important;
                }
            }

            /* CSS cho layout 4 cột */
            .featured-grid-4cols {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 15px;
                margin-bottom: 20px;
            }

            .grid-item-sb {
                width: 100%;
            }

            .grid-item-sb .card {
                width: 100%;
                height: 100%;
            }

            .grid-item-sb .thumb-btn-sb {
                width: 100%;
                height: 100%;
                display: flex;
                flex-direction: column;
            }

            /* Responsive cho màn hình nhỏ hơn */
            @media (max-width: 1200px) {
                .featured-grid-4cols {
                    grid-template-columns: repeat(3, 1fr);
                }
            }

            @media (max-width: 768px) {
                .featured-grid-4cols {
                    grid-template-columns: repeat(2, 1fr);
                    gap: 10px;
                }

                .sd-actions {
                    flex-direction: column;
                    align-items: stretch; /* full width theo container */
                }

                .btn-service {
                    width: 100%; /* nút chiếm full chiều ngang */
                    font-size: 16px;
                }
                
                .breadcrumbs {
                    padding: 8px 12px;
                    font-size: 0.85rem;
                    flex-wrap: wrap;
                }
                .breadcrumbs a {
                    padding: 3px 6px;
                }
            }

            @media (max-width: 480px) {
                .featured-grid-4cols {
                    grid-template-columns: 1fr;
                }
            }

        </style>
    </head>

    <body>
        <div class="wrapper">
            <!-- Sidebar -->
            <div class="sidebar">
                <jsp:include page="sidebar.jsp"/>
            </div>

            <!-- Main -->
            <div class="Main_content">
                <!-- Header -->
                <jsp:include page="header.jsp"/>

                <!-- ====== Nội dung trang ====== -->
                <div class="container">
                    <div class="breadcrumbs">
                        <a href="MainController?action=${breadCrumbs}">Danh sách sản phẩm</a>
                        <span class="sep">›</span>
                        <span class="current">Chi tiết sản phẩm</span>
                    </div>
                    <c:choose>
                        <c:when test="${not empty productDetail}">
                            <div class="product-detail">
                                <!-- LEFT: Gallery (4 phần) -->
                                <div class="pd-left">
                                    <c:set var="firstImg"
                                           value="${(not empty productDetail.image and not empty productDetail.image[0].image_url) 
                                                    ? productDetail.image[0].image_url 
                                                    : '/assets/images/no-image.jpg'}" />
                                    <div class="pd-main">
                                        <img id="pd-main-img" src="${firstImg}" alt="${productDetail.name}" loading="eager"/>
                                    </div>

                                    <div class="pd-thumbs" id="pd-thumbs">
                                        <c:forEach var="img" items="${productDetail.image}" varStatus="s">
                                            <c:if test="${not empty img.image_url}">
                                                <button type="button"
                                                        class="pd-thumb${s.index == 0 ? ' is-active' : ''}"
                                                        data-src="${img.image_url}"
                                                        aria-label="Ảnh ${s.count}">
                                                    <img src="${img.image_url}" alt="${productDetail.name}" loading="lazy"/>
                                                </button>
                                            </c:if>
                                        </c:forEach>
                                    </div>


                                    <!--                                    //===========================================================================-->

                                </div>



                                <!-- RIGHT: Info + Description (6 phần) -->
                                <div class="pd-right">
                                    <div class="pd-name">${productDetail.name}</div>

                                    <div class="pd-basic">
                                        <div class="pd-row"><b>SKU</b><span>${productDetail.sku}</span></div>
                                        <div class="pd-row">
                                            <b>Loại</b>
                                            <span>
                                                <c:choose>
                                                    <c:when test="${productDetail.product_type == 'nintendo'}">
                                                        Nintendo
                                                    </c:when>
                                                    <c:when test="${productDetail.product_type == 'sony'}">
                                                        Sony
                                                    </c:when>
                                                    <c:otherwise>
                                                        Hãng khác
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <div class="pd-row pd-row-price">
                                            <b>Giá</b>
                                            <span><fmt:formatNumber value="${productDetail.price}" type="number" groupingUsed="true" maxFractionDigits="0"/> VND</span>
                                        </div>
                                        <div class="pd-row"><b>Bảo hành</b><span>${guaranteeProduct}</span></div>
                                        <div class="pd-row"><b>Bộ nhớ</b><span>${memoryProduct}</span></div>
                                    </div>

                                    <c:if test="${not empty accessories}">
                                        <div class="pd-accessories">
                                            <b>Phụ kiện tặng kèm:</b>
                                            <ul>
                                                <c:forEach var="acc" items="${accessories}">
                                                    <li>
                                                        ${acc.name} (x${acc.quantity})
                                                    </li>
                                                </c:forEach>
                                            </ul>
                                        </div>
                                    </c:if>

                                    <hr>

                                    <div class="sd-actions">
                                        <button onclick="bookService('${serviceDetail.id}', '${serviceDetail.service_type}', '${serviceDetail.price}')" class="btn-service btn-primary">
                                            🛒 Đặt hàng qua Zalo
                                        </button>
                                        <button onclick="callDirectly()" class="btn-service btn-secondary">
                                            📞 Gọi trực tiếp
                                        </button>
                                        <a href="MainController?action=listMayChoiGame" class="btn-service btn-secondary">
                                            📋 Xem sản phẩm khác
                                        </a>
                                    </div>

                                    <!-- Description_html nằm chung cột phải -->
                                    <div class="pd-desc">
                                        <div class="pd-desc-title">
                                            📝 Mô tả sản phẩm
                                        </div>
                                        ${productDetail.description_html}
                                    </div>
                                </div>
                            </div>
                        </c:when>

                        <c:otherwise>
                            <div class="empty-state">
                                <h3>Không tìm thấy sản phẩm</h3>
                                <p>Hiện tại không có sản phẩm nào phù hợp với tiêu chí của bạn.</p>
                                <c:if test="${not empty checkErrorDeleteProduct}">
                                    <p><c:out value="${checkErrorDeleteProduct}"/></p>
                                </c:if>
                                <form action="MainController" method="post" style="margin-top:12px;">
                                    <input type="hidden" name="action" value="listProducts"/>
                                    <button class="btn-filter" type="submit">Xem tất cả sản phẩm</button>
                                </form>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>



                <!--                                     >>> DIV MỚI CHÈN Ở ĐÂY <<< ===============================================-->
                <div class="pd-left-extra">
                    <h3 class="extra-title">NHỮNG SẢN PHẨM LIÊN QUAN </h3>
                    <c:choose>
                        <c:when test="${not empty list_pro}">
                            <c:set var="shown" value="0"/>
                            <div class="featured-grid-4cols">
                                <c:forEach var="i" items="${list_pro}">
                                    <c:if test="${ shown < 8}">
                                        <div class="grid-item-sb">
                                            <form action="MainController" method="post" class="card">
                                                <input type="hidden" name="action" value="getProduct"/>
                                                <input type="hidden" name="idProduct" value="${i.id}"/>
                                                <!-- Bấm vào cả card là submit -->
                                                <button type="submit" class="thumb-btn-sb">
                                                    <!-- Container cho ảnh và giá -->
                                                    <div class="image-price-container-sb">
                                                        <img class="thumb-sb" src="${i.coverImg}" alt="${i.name}" style="height:130px;"/>
                                                        <div class="price-box-sb">
                                                            <div class="price-text-sb"><fmt:formatNumber value="${i.price}" type="number" groupingUsed="true" maxFractionDigits="0" />
                                                                VND</div>
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
                        </c:when>
                        <c:otherwise>
                            <p>Hiện danh sách đang trống!</p>
                        </c:otherwise>
                    </c:choose>
                </div>




            </div>
        </div>

        <!-- Footer đặt NGOÀI wrapper để luôn hiển thị khi body cuộn -->
        <jsp:include page="footer.jsp"/>

        <script>
            (function () {
                const main = document.getElementById('pd-main-img');
                const thumbsWrap = document.getElementById('pd-thumbs');
                if (!main || !thumbsWrap)
                    return;

                thumbsWrap.addEventListener('click', function (e) {
                    const btn = e.target.closest('.pd-thumb');
                    if (!btn)
                        return;
                    const src = btn.getAttribute('data-src');
                    if (!src || main.src === src)
                        return;
                    main.src = src;

                    document.querySelectorAll('.pd-thumb.is-active')
                            .forEach(el => el.classList.remove('is-active'));
                    btn.classList.add('is-active');
                }, false);
            })();

            // ===== CONFIG - Thay đổi thông tin liên hệ ở đây =====
            const SHOP_CONFIG = {
                zaloId: '0357394235', // Thay bằng Zalo ID thực tế
                phoneNumber: '0357394235', // Thay bằng SĐT thực tế
                shopName: 'SHOP GAME VIỆT'
            };

            // ===== MAIN FUNCTIONS =====

            // Đặt dịch vụ qua Zalo
            function bookService(serviceId, serviceName, price) {
                // Log user interest (optional - có thể bỏ nếu không cần track)
                logUserInterest(serviceId, 'book_service');

                // Tạo message template
                const message = "🎮 ĐẶT DỊCH VỤ - " + SHOP_CONFIG.shopName + "\n\n" +
                        "📋 Dịch vụ: " + serviceName + "\n" +
                        "💰 Giá: " + new Intl.NumberFormat('vi-VN').format(price) + " VND\n" +
                        "🆔 Mã: #SV" + serviceId + "\n\n" +
                        "Xin chào! Tôi muốn đặt dịch vụ trên. Vui lòng tư vấn thêm cho tôi.";

                // Mở Zalo
                const zaloUrl = "https://zalo.me/" + SHOP_CONFIG.zaloId + "?message=" + encodeURIComponent(message);
                window.open(zaloUrl, '_blank');
            }

            // Tư vấn dịch vụ qua Zalo  
            function consultService(serviceName) {
                const message = "💬 TƯ VẤN DỊCH VỤ - " + SHOP_CONFIG.shopName + "\n\n" +
                        "📋 Về dịch vụ: " + serviceName + "\n\n" +
                        "Xin chào! Tôi cần được tư vấn thêm về dịch vụ này. Cảm ơn!";

                const zaloUrl = "https://zalo.me/" + SHOP_CONFIG.zaloId + "?message=" + encodeURIComponent(message);
                window.open(zaloUrl, '_blank');
            }

            // Gọi điện trực tiếp
            function callDirectly() {
                if (confirm("Gọi đến " + SHOP_CONFIG.phoneNumber + "?")) {
                    window.open("tel:" + SHOP_CONFIG.phoneNumber, '_self');
                }
            }

            // Log user interest (optional - để tracking)
            function logUserInterest(serviceId, action) {
                // Có thể gọi API để log, hoặc bỏ nếu không cần
                fetch('MainController', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: `action=logServiceInterest&serviceId=${serviceId}&interestType=${action}`
                }).catch(e => console.log('Tracking failed:', e)); // Silent fail
            }

            // ===== UI EFFECTS =====
            document.addEventListener('DOMContentLoaded', function () {
                // Hover effects
                const actionButtons = document.querySelectorAll('.btn-service');
                actionButtons.forEach(btn => {
                    btn.addEventListener('mouseenter', function () {
                        this.style.transform = 'translateY(-2px)';
                    });
                    btn.addEventListener('mouseleave', function () {
                        this.style.transform = 'translateY(0)';
                    });
                });

                // Success notification after page load (if redirected back)
                const urlParams = new URLSearchParams(window.location.search);
                if (urlParams.get('contacted') === 'true') {
                    showNotification('✅ Cảm ơn bạn đã liên hệ! Chúng tôi sẽ phản hồi sớm nhất.', 'success');
                }
            });

            // Simple notification system
            function showNotification(message, type = 'info') {
                const notification = document.createElement('div');
                notification.style.cssText =
                        "position: fixed; top: 20px; right: 20px; z-index: 9999;" +
                        "padding: 12px 20px; border-radius: 8px; color: white; font-weight: 600;" +
                        "background: " + (type === 'success' ? '#10b981' : '#3b82f6') + ";" +
                        "box-shadow: 0 4px 12px rgba(0,0,0,0.15); cursor: pointer;" +
                        "transform: translateX(100%); transition: transform 0.3s ease;";
                notification.textContent = message;
                notification.onclick = () => notification.remove();

                document.body.appendChild(notification);
                setTimeout(() => notification.style.transform = 'translateX(0)', 100);
                setTimeout(() => notification.remove(), 5000);
            }
        </script>
    </body>
</html>