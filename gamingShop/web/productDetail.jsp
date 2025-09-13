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
        <title>Gaming Shop</title>

        <style>
            /* =========================
   Base + Variables
========================= */
            :root{
                --bg: #f8fafc;
                --text: #1f2937;
                --muted: #6b7280;
                --accent: #7c3aed;
                --danger: #e11d48;
                --border: #e5e7eb;
                --card-shadow: 0 10px 40px rgba(0,0,0,.08);
            }

            *{
                box-sizing: border-box;
            }
            html, body{
                margin:0;
                padding:0;
                height:100%;
                width:100%;
                font-family: Inter, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
                background: var(--bg);
                color: var(--text);
            }

            /* =========================
               App Shell (giữ khung cũ)
            ========================= */
            .wrapper{
                display:flex;
                gap:20px;
                padding:0 20px;
                min-height:100vh;
                width:100vw;
            }
            .sidebar{
                flex:3;
                background: linear-gradient(135deg,#2c3e50 0%,#34495e 100%);
                color:#fff;
                border-radius:20px;
                padding:24px;
                box-shadow:var(--card-shadow);
                position: sticky;
                top:20px;
                height: fit-content;
            }
            .Main_content{
                flex:7;
                background:#fff;
                border-radius:20px;
                box-shadow:var(--card-shadow);
                display:flex;
                flex-direction:column;
                overflow:auto;
            }
            .container{
                padding:16px;
            }

            /* =========================
               Product Detail Layout
               - 4 phần (gallery) | 6 phần (info + description)
            ========================= */
            .product-detail{
                display:grid;
                gap:10px;
                align-items:start;
                grid-template-columns: minmax(420px, 3fr) minmax(0, 7fr);
            }

            /* ---------- LEFT: Gallery ---------- */
            .pd-left{
                background:#fff;
                border-radius:16px;
                box-shadow:var(--card-shadow);
                padding:16px;
            }
            .pd-main{
                width:100%;
                /* Chiều cao linh hoạt, không ép vuông để giữ tỉ lệ ảnh tự nhiên */
                height: clamp(380px, 48vh, 560px);
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
            }

            .pd-thumbs{
                margin-top:12px;
                display:grid;
                grid-template-columns: repeat(4, 1fr);
                gap:12px;
            }
            .pd-thumb{
                border:1px solid #eee;
                border-radius:10px;
                background:#fff;
                padding:6px;
                cursor:pointer;
                transition: transform .18s ease, box-shadow .18s ease, border-color .18s ease;
            }
            .pd-thumb img{
                width:100%;
                aspect-ratio: 1 / 1;
                object-fit:contain;
                display:block;
            }
            .pd-thumb:hover{
                transform: translateY(-2px);
                box-shadow: 0 6px 16px rgba(0,0,0,.06);
                border-color:#ddd;
            }
            .pd-thumb.is-active{
                border-color: var(--accent);
                box-shadow: 0 0 0 2px rgba(124,58,237,.12) inset;
            }

            /* ---------- RIGHT: Info + Description ---------- */
            .pd-right{
                position: sticky;
                top:16px;
                background:#fff;
                border-radius:16px;
                box-shadow:var(--card-shadow);
                padding:20px;
                height: fit-content;
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
                grid-template-columns: 110px 1fr;
                gap:12px;
                align-items:center;
                font-size:14px;
            }
            .pd-row b{
                color:var(--muted);
                font-weight:600;
            }
            .pd-row span{
                color:#111827;
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

            /* description_html nằm chung cột phải, ngay dưới info */
            .pd-desc{
                margin-top:16px;
                padding-top:16px;
                border-top:1px dashed var(--border);
            }
            .pd-desc h1,.pd-desc h2,.pd-desc h3{
                margin-top:0;
            }

            /* ---------- Empty state ---------- */
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

            /* =========================
               Scrollbar (tuỳ chọn)
            ========================= */
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

            /* =========================
               Responsive
            ========================= */
            /* Desktop hẹp */
            @media (max-width: 1440px){
                .product-detail{
                    grid-template-columns: minmax(420px, 3fr) minmax(0, 7fr);
                }
            }
            /* Tablet ngang / laptop nhỏ */
            @media (max-width: 1200px){
                .product-detail{
                    grid-template-columns: minmax(400px, 4fr) minmax(0, 6fr);
                    gap:20px;
                }
                .pd-main{
                    height: clamp(340px, 44vh, 520px);
                }
            }
            /* Tablet dọc & mobile lớn: xếp dọc */
            @media (max-width: 1024px){
                .product-detail{
                    grid-template-columns: 1fr;
                }
                .pd-right{
                    position: static;
                }
                .pd-main{
                    height: clamp(320px, 42vh, 520px);
                }
            }
            /* Mobile */
            @media (max-width: 640px){
                .container{
                    padding:16px;
                }
                .pd-thumbs{
                    grid-template-columns: repeat(4, 1fr);
                    gap:10px;
                }
                .pd-row{
                    grid-template-columns: 96px 1fr;
                }
            }

            /* Trợ năng: tắt animation nếu người dùng chọn giảm chuyển động */
            @media (prefers-reduced-motion: reduce){
                .pd-thumb{
                    transition: none;
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
                                </div>

                                <!-- RIGHT: Info + Description (6 phần) -->
                                <div class="pd-right">
                                    <div class="pd-name">${productDetail.name}</div>

                                    <div class="pd-basic">
                                        <div class="pd-row"><b>SKU</b><span>${productDetail.sku}</span></div>
                                        <div class="pd-row"><b>Loại</b><span>${productDetail.product_type}</span></div>
                                        <div class="pd-row pd-row-price">
                                            <b>Giá</b>
                                            <span><fmt:formatNumber value="${productDetail.price}" type="number" groupingUsed="true" maxFractionDigits="0"/> VND</span>
                                        </div>
                                        <div class="pd-row"><b>Bảo hành</b><span>${guaranteeProduct}</span></div>
                                        <div class="pd-row"><b>Bộ nhớ</b><span>${memoryProduct}</span></div>
                                    </div>

                                    <!-- Description_html nằm chung cột phải -->
                                    <div class="pd-desc">
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
                                <form action="MainController" method="get" style="margin-top:12px;">
                                    <input type="hidden" name="action" value="listProducts"/>
                                    <button class="btn-filter" type="submit">Xem tất cả sản phẩm</button>
                                </form>
                            </div>
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
        </script>
    </body>
</html>