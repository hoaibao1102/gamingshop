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

        <!-- ====== CSS đồng bộ layout với trang chủ (Cách A: body cuộn, footer ngoài wrapper) ====== -->
        <style>
            :root{
                --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                --secondary-gradient: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
                --success-gradient: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
                --dark-gradient: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
                --card-shadow: 0 10px 40px rgba(0,0,0,0.1);
                --hover-shadow: 0 20px 60px rgba(0,0,0,0.2);
                --text-dark: #2c3e50;
                --text-light: #ffffff;
                --bg-light: #f8fafc;
                --border-soft: rgba(255,255,255,0.8);
            }

            html,body{
                margin:0;
                padding:0;
                height:100%;
                width:100%;
                font-family:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen,Ubuntu,Cantarell,sans-serif;
                background:var(--bg-light);
                color:var(--text-dark);
                scroll-behavior:smooth;
            }

            /* ====== Khung giống trang chủ ====== */
            .wrapper{
                padding:0 20px;
                display:flex;
                gap:20px;
                min-height:100vh;
                width:100vw;
                box-sizing:border-box;
            }
            .sidebar{
                flex:3;
                background:var(--dark-gradient);
                color:var(--text-light);
                padding:24px;
                border-radius:20px;
                box-shadow:var(--card-shadow);
                position:sticky;
                top:20px;
                height:fit-content;
            }
            .Main_content{
                flex:7;
                background:linear-gradient(180deg,#ffffff 0%,#f8fafc 100%);
                border-radius:20px;
                box-shadow:var(--card-shadow);
                position:relative;

                /* CÁCH A: body sẽ cuộn, KHÔNG cuộn bên trong hộp */
                overflow: visible; /* hoặc có thể xóa dòng này */
            }
            .container{
                padding:24px
            }

            /* Scrollbar của Main_content (giữ để đồng bộ visual, dù không dùng cuộn nội bộ) */
            .Main_content::-webkit-scrollbar{
                width:8px
            }
            .Main_content::-webkit-scrollbar-track{
                background:#f1f1f1;
                border-radius:4px
            }
            .Main_content::-webkit-scrollbar-thumb{
                background:var(--primary-gradient);
                border-radius:4px
            }
            .Main_content::-webkit-scrollbar-thumb:hover{
                background:var(--secondary-gradient)
            }

            /* ====== Card dùng chung ====== */
            .card{
                background:linear-gradient(145deg,#ffffff 0%,#f8fafc 100%);
                border-radius:20px;
                box-shadow:var(--card-shadow);
                border:1px solid var(--border-soft);
            }

            /* ====== Lưới trang chi tiết ====== */
            .product-detail{
                display:grid;
                grid-template-columns: 1.25fr 1fr;
                gap:24px;
            }

            /* ====== Gallery trái ====== */
            .pd-gallery{
                padding:16px;
                display:flex;
                flex-direction:column;
                gap:12px;
            }
            .pd-main{
                position:relative;
                border-radius:16px;
                overflow:hidden;
            }
            #pd-main-img{
                width:100%;
                height:clamp(280px, 38vw, 520px);
                object-fit:cover;
                display:block;
                filter:brightness(1.05) contrast(1.03);
                transition:transform .6s ease;
            }
            .pd-main:hover #pd-main-img{
                transform:scale(1.02)
            }

            .pd-nav{
                position:absolute;
                inset:0;
                display:flex;
                align-items:center;
                justify-content:space-between;
                padding:0 8px;
                pointer-events:none;
            }
            .pd-arrow{
                pointer-events:auto;
                width:48px;
                height:48px;
                border-radius:50%;
                border:1px solid rgba(255,255,255,.35);
                background:rgba(255,255,255,.25);
                backdrop-filter: blur(10px);
                color:#fff;
                font-size:22px;
                font-weight:700;
                display:flex;
                align-items:center;
                justify-content:center;
                cursor:pointer;
                transition:.25s;
            }
            .pd-arrow:hover{
                transform:scale(1.08);
                box-shadow:0 8px 32px rgba(0,0,0,.25)
            }

            .pd-thumbs{
                display:grid;
                grid-template-columns: repeat(4, 1fr);
                gap:10px;
            }
            .pd-thumb{
                border:none;
                padding:0;
                cursor:pointer;
                border-radius:12px;
                overflow:hidden;
                background:#fff;
                position:relative;
                outline-offset:2px;
                transition:transform .2s ease, box-shadow .2s ease;
            }
            .pd-thumb img{
                width:100%;
                height:90px;
                object-fit:cover;
                display:block;
                transition:transform .35s ease;
            }
            .pd-thumb:hover{
                transform:translateY(-2px);
                box-shadow:var(--hover-shadow)
            }
            .pd-thumb:hover img{
                transform:scale(1.06)
            }
            .pd-thumb.is-active{
                box-shadow:0 0 0 2px #fff, 0 0 0 4px rgba(102,126,234,.8);
            }

            /* ====== Thông tin phải ====== */
            .pd-info{
                padding:20px;
                display:flex;
                flex-direction:column;
                gap:16px;
            }
            .pd-title{
                font-size:clamp(20px, 2.2vw, 28px);
                font-weight:800;
                line-height:1.2;
                margin-bottom:4px;
                background:var(--primary-gradient);
                -webkit-background-clip:text;
                background-clip:text;
                -webkit-text-fill-color:transparent;
            }
            .pd-sku{
                font-size:13px;
                opacity:.75
            }
            .pd-price{
                font-size:clamp(18px, 2vw, 22px);
                font-weight:800;
                color:#e11d48;
            }
            .pd-attrs{
                display:grid;
                grid-template-columns:1fr;
                gap:10px;
                padding:12px;
                border-radius:14px;
                background:rgba(102,126,234,.06);
                border:1px dashed rgba(102,126,234,.25);
            }
            .pd-attr strong{
                margin-right:6px
            }

            .pd-actions{
                display:flex;
                gap:12px;
                flex-wrap:wrap;
                margin-top:4px;
            }
            .btn-primary, .btn-ghost, .btn-filter{
                appearance:none;
                border:none;
                cursor:pointer;
                padding:12px 16px;
                border-radius:14px;
                font-weight:700;
                transition:.25s;
                box-shadow: var(--card-shadow);
            }
            .btn-primary{
                background:var(--primary-gradient);
                color:#fff
            }
            .btn-primary:hover{
                transform:translateY(-2px) scale(1.02);
                box-shadow:var(--hover-shadow)
            }

            .btn-ghost{
                background:#fff;
                color:#374151;
                border:1px solid rgba(0,0,0,.06);
            }
            .btn-ghost:hover{
                transform:translateY(-2px);
                box-shadow:var(--hover-shadow)
            }

            .btn-filter{
                background:var(--success-gradient);
                color:#fff
            }

            /* ====== Mô tả dưới ====== */
            .pd-desc{
                grid-column: 1 / -1;
                padding:20px;
            }
            .pd-desc h3{
                margin:0 0 10px 0;
                font-size:20px;
                font-weight:800;
                background:var(--primary-gradient);
                -webkit-background-clip:text;
                background-clip:text;
                -webkit-text-fill-color:transparent;
            }
            .pd-desc .content{
                line-height:1.65;
                font-size:15px
            }
            .pd-desc .content img{
                max-width:100%;
                height:auto
            }

            /* ====== Empty state ====== */
            .empty-state{
                text-align:center;
                padding:60px 20px;
                color:var(--text-dark);
            }
            .empty-state h3{
                font-size:24px;
                margin:0 0 8px 0;
                background:var(--primary-gradient);
                -webkit-background-clip:text;
                background-clip:text;
                -webkit-text-fill-color:transparent;
            }
            .empty-state p{
                opacity:.7
            }

            /* ====== Hiệu ứng ====== */
            @keyframes fadeInUp{
                from{
                    opacity:0;
                    transform:translateY(30px)
                }
                to{
                    opacity:1;
                    transform:translateY(0)
                }
            }
            .pd-gallery, .pd-info, .pd-desc{
                animation:fadeInUp .6s ease-out
            }

            /* ====== Responsive giống trang chủ ====== */
            @media (max-width: 1200px){
                .product-detail{
                    grid-template-columns: 1.1fr 0.9fr
                }
            }
            @media (max-width: 968px){
                .wrapper{
                    padding:10px;
                    flex-direction:column;
                    gap:15px
                }
                .sidebar{
                    display:none
                }
                .Main_content{
                    flex:1;
                    border-radius:16px
                }
                .container{
                    padding:16px
                }
                .product-detail{
                    grid-template-columns: 1fr
                }
                #pd-main-img{
                    height:clamp(220px, 55vw, 420px)
                }
            }
            @media (max-width: 480px){
                .pd-thumbs{
                    grid-template-columns: repeat(4, 1fr);
                    gap:8px
                }
                .pd-thumb img{
                    height:72px
                }
                .pd-actions{
                    flex-direction:column
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
                                <!-- ====== Cột trái: Gallery ====== -->
                                <div class="pd-gallery card">
                                    <div class="pd-main">
                                        <c:set var="firstImg"
                                               value="${(not empty productDetail.image and not empty productDetail.image[0].image_url) 
                                                        ? productDetail.image[0].image_url 
                                                        : (not empty productDetail.coverImg ? productDetail.coverImg : '/assets/images/no-image.jpg')}" />
                                        <img id="pd-main-img" src="${firstImg}" alt="${productDetail.name}" loading="eager" />

                                        <!-- Nút điều hướng ảnh -->
                                        <div class="pd-nav" aria-hidden="false">
                                            <button type="button" class="pd-arrow pd-arrow--prev" id="pd-prev" aria-label="Ảnh trước">‹</button>
                                            <button type="button" class="pd-arrow pd-arrow--next" id="pd-next" aria-label="Ảnh sau">›</button>
                                        </div>
                                    </div>

                                    <div class="pd-thumbs" id="pd-thumbs">
                                        <c:choose>
                                            <c:when test="${not empty productDetail.image}">
                                                <c:forEach var="img" items="${productDetail.image}" varStatus="s">
                                                    <c:if test="${s.count <= 5 && not empty img.image_url}">
                                                        <button type="button" class="pd-thumb" data-src="${img.image_url}" aria-label="Xem ảnh ${s.count}">
                                                            <img src="${img.image_url}" alt="${productDetail.name}" loading="lazy" />
                                                        </button>
                                                    </c:if>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <button type="button" class="pd-thumb is-active" data-src="${firstImg}" aria-label="Xem ảnh 1">
                                                    <img src="${firstImg}" alt="${productDetail.name}" loading="lazy" />
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <!-- ====== Cột phải: Thông tin sản phẩm ====== -->
                                <div class="pd-info card">
                                    <div class="pd-title"><c:out value="${productDetail.name}" /></div>
                                    <div class="pd-sku">
                                        <c:if test="${not empty productDetail.sku}">
                                            SKU: <c:out value="${productDetail.sku}" />
                                        </c:if>
                                    </div>

                                    <div class="pd-price">
                                        <fmt:formatNumber value="${productDetail.price}" type="number" groupingUsed="true" maxFractionDigits="0" /> VND
                                    </div>

                                    <div class="pd-attrs">
                                        <div class="pd-attr"><strong>Loại:</strong> <span><c:out value="${productDetail.product_type}" default="Không xác định"/></span></div>
                                        <div class="pd-attr"><strong>Bảo hành:</strong> <span><c:out value="${guaranteeProduct}" default="Liên hệ"/></span></div>
                                        <div class="pd-attr"><strong>Bộ nhớ:</strong> <span><c:out value="${memoryProduct}" default="Tùy phiên bản"/></span></div>
                                        <c:if test="${not empty productDetail.brand}">
                                            <div class="pd-attr"><strong>Thương hiệu:</strong> <span><c:out value="${productDetail.brand}" /></span></div>
                                        </c:if>

                                        <!-- ====== Mô tả chi tiết ====== -->
                                        <div class="pd-desc card">
                                            <h3>Mô tả sản phẩm</h3>
                                            <div class="content">
                                                <c:choose>
                                                    <c:when test="${not empty productDetail.description_html}">
                                                        <c:out value="${productDetail.description_html}" escapeXml="false" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <p>Chưa có mô tả chi tiết cho sản phẩm này.</p>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:when>

                        <c:otherwise>
                            <div class="empty-state">
                                <h3>Không tìm thấy sản phẩm</h3>
                                <p>Hiện tại không có sản phẩm nào phù hợp với tiêu chí của bạn.</p>
                                <c:if test="${not empty checkErrorDeleteProduct}">
                                    <p style="opacity:.8;"><c:out value="${checkErrorDeleteProduct}"/></p>
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

        <!-- JS gallery: đổi ảnh + prev/next + bàn phím -->
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const main = document.getElementById('pd-main-img');
                const btnPrev = document.getElementById('pd-prev');
                const btnNext = document.getElementById('pd-next');
                const thumbsWrap = document.getElementById('pd-thumbs');
                if (!main || !thumbsWrap)
                    return;

                let thumbs = Array.from(thumbsWrap.querySelectorAll('.pd-thumb')).slice(0, 4);
                if (thumbs.length === 0) {
                    if (btnPrev)
                        btnPrev.hidden = true;
                    if (btnNext)
                        btnNext.hidden = true;
                    return;
                }
                thumbs.forEach(t => t.setAttribute('type', 'button'));
                if (btnPrev)
                    btnPrev.setAttribute('type', 'button');
                if (btnNext)
                    btnNext.setAttribute('type', 'button'); // << sửa lỗi dấu ) thừa

                let images = thumbs
                        .map(t => t.getAttribute('data-src') || (t.querySelector('img') && t.querySelector('img').getAttribute('src')))
                        .filter(Boolean);

                const mainAttrSrc = main.getAttribute('src');
                if (mainAttrSrc && !images.includes(mainAttrSrc))
                    images.unshift(mainAttrSrc);
                images = images.filter((v, i, a) => a.indexOf(v) === i);

                if (images.length < 2) {
                    if (btnPrev)
                        btnPrev.hidden = true;
                    if (btnNext)
                        btnNext.hidden = true;
                }

                let idx = 0;
                function render(i) {
                    if (!images.length)
                        return;
                    idx = (i + images.length) % images.length;
                    const nextSrc = images[idx];
                    if (nextSrc)
                        main.setAttribute('src', nextSrc);
                    thumbs.forEach(t => t.classList.remove('is-active'));
                    if (thumbs[idx])
                        thumbs[idx].classList.add('is-active');
                }

                thumbs.forEach((t) => {
                    t.addEventListener('click', function (e) {
                        e.preventDefault();
                        e.stopPropagation();
                        const src = t.getAttribute('data-src') || (t.querySelector('img') && t.querySelector('img').getAttribute('src'));
                        const i = images.indexOf(src);
                        render(i >= 0 ? i : 0);
                    });
                });

                if (btnPrev)
                    btnPrev.addEventListener('click', function (e) {
                        e.preventDefault();
                        e.stopPropagation();
                        render(idx - 1);
                    });
                if (btnNext)
                    btnNext.addEventListener('click', function (e) {
                        e.preventDefault();
                        e.stopPropagation();
                        render(idx + 1);
                    });

                window.addEventListener('keydown', function (e) {
                    if (e.key === 'ArrowLeft')
                        render(idx - 1);
                    if (e.key === 'ArrowRight')
                        render(idx + 1);
                });

                const found = images.indexOf(mainAttrSrc);
                render(found >= 0 ? found : 0);
            });
        </script>
    </body>
</html>
