<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:setLocale value="vi_VN" />

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>SHOP GAME VIỆT 38 — Quản lý Banners</title>
        <%@ include file="/WEB-INF/jspf/head.jspf" %>
        <!-- Swiper CSS (nếu cần, đồng bộ với trang chủ) -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
        <!-- Main CSS đồng bộ với trang chủ -->
        <link rel="stylesheet" href="assets/css/maincss.css" />

        <style>
            /* --- Bổ sung style cho trang quản trị (không phá vỡ maincss.css) --- */
            .admin-toolbar{
                display:flex;
                flex-wrap:wrap;
                align-items:center;
                gap:12px;
                padding:16px;
                background:#f3f4f6;
                border-radius:12px;
                box-shadow:0 6px 18px rgba(0,0,0,.1)
            }
            .admin-toolbar .title{
                font-size:20px;
                font-weight:700;
                color:#111827;
                margin-right:auto
            }
            .admin-toolbar .search-form{
                display:flex;
                gap:8px;
                align-items:center
            }
            .admin-toolbar input[type="text"]{
                height:40px;
                border-radius:10px;
                border:1px solid #d1d5db;
                background:#fff;
                color:#111827;
                padding:0 12px;
                min-width:280px
            }
            .admin-toolbar .btn{
                height:40px;
                border:0;
                border-radius:10px;
                padding:0 14px;
                font-weight:600;
                cursor:pointer
            }
            .btn-primary {
                background-color: #2563eb !important; /* xanh dương */
                color: #fff;
                border: none;
                border-radius: 8px;
                padding: 0 16px;
                transition: all 0.2s ease;
            }
            .btn-primary:hover {
                background-color: #1d4ed8; /* xanh dương đậm hơn khi hover */
            }
            .btn-secondary{
                background:#6b7280;
                color:#fff
            }
            .btn-danger{
                background:#dc2626;
                color:#fff
            }

            .banners-card{
                margin-top:16px;
                background:#fff;
                border:1px solid #e5e7eb;
                border-radius:16px;
                overflow:hidden
            }
            .banners-meta{
                display:flex;
                flex-wrap:wrap;
                gap:8px;
                padding:12px 16px;
                border-bottom:1px solid #e5e7eb;
                background:#f9fafb
            }
            .meta-pill{
                display:inline-flex;
                align-items:center;
                gap:6px;
                padding:6px 10px;
                border-radius:999px;
                font-size:12px;
                background:#f3f4f6;
                color:#374151;
                border:1px dashed #d1d5db
            }
            .meta-pill .dot{
                width:8px;
                height:8px;
                border-radius:999px;
                background:#22c55e
            }

            .table-wrap{
                width:100%;
                overflow:auto;
                background:#ffffff;
                border:1px solid #e5e7eb;
                border-radius:12px
            }
            table.banners{
                width:100%;
                border-collapse:separate;
                border-spacing:0;
                background:#ffffff;
                color:#111111
            }
            table.banners thead th{
                position:sticky;
                top:0;
                background:#ffffff;
                color:#111111;
                text-align:left;
                font-weight:700;
                padding:12px 14px;
                border-bottom:1px solid #e5e7eb;
                z-index:1
            }
            table.banners tbody td{
                padding:12px 14px;
                border-bottom:1px solid #f1f5f9;
                color:#111111;
                vertical-align:top
            }
            .ban-thumb{
                width:72px;
                height:72px;
                border-radius:10px;
                object-fit:cover;
                border:1px solid #d1d5db;
                background:#f9fafb
            }
            .ban-title{
                font-weight:700
            }
            .status-pill{
                display:inline-flex;
                align-items:center;
                gap:6px;
                padding:4px 10px;
                border-radius:999px;
                font-size:12px
            }
            .status-active{
                background:#dcfce7;
                color:#166534;
                border:1px solid #16a34a
            }
            .status-inactive{
                background:#fee2e2;
                color:#991b1b;
                border:1px solid #ef4444
            }

            .row-actions{
                display:flex;
                gap:8px;
                justify-content:center
            }
            .row-actions .btn{
                height:36px;
                padding:0 16px;
                border-radius:8px;
                font-size:14px;
                font-weight:600;
                color:#fff;
                border:none;
                cursor:pointer;
                transition:all .2s
            }
            .row-actions .btn-secondary{
                background-color:#3b82f6
            }
            .row-actions .btn-secondary:hover{
                background-color:#1d4ed8
            }
            .row-actions .btn-danger{
                background-color:#ef4444
            }
            .row-actions .btn-danger:hover{
                background-color:#b91c1c
            }

            .empty-state{
                text-align:center;
                padding:48px 16px
            }
            .empty-state h3{
                color:#111827;
                margin-bottom:8px
            }
            .empty-state p{
                color:#6b7280;
                margin-bottom:12px
            }

            .alert{
                padding:12px 14px;
                border-radius:10px;
                margin-top:12px
            }
            .alert-success{
                background:#dcfce7;
                color:#166534;
                border:1px solid #16a34a
            }
            .alert-danger{
                background:#fee2e2;
                color:#991b1b;
                border:1px solid #ef4444
            }

            table.banners tbody tr:nth-child(even){
                background:#fafafa
            }
            table.banners tbody tr:hover{
                background:#f5f5f5
            }

            @media (max-width:768px){
                .admin-toolbar .search-form{
                    width:100%
                }
                .admin-toolbar input[type="text"]{
                    flex:1;
                    min-width:0
                }
                .table-wrap{
                    border-radius:0
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

                <!-- ===== Marquee (đồng bộ cách dùng ở trang sản phẩm) ===== -->
                <div class="marquee-bar">
                    <div class="marquee-inner">
                        <span class="marquee-item"><span class="badge">ADMIN</span> Quản lý Banners — thêm/sửa/xoá nhanh</span>
                        <span class="marquee-item"><span class="badge">TIP</span> Nhập tiêu đề để lọc chính xác</span>
                        <span class="marquee-item"><a href="BannerController?action=getAllBanners">Làm mới danh sách →</a></span>
                    </div>
                </div>

                <div class="container">
                    <!-- THÔNG BÁO HỆ THỐNG -->
                    <c:if test="${not empty messageDeleteBanners}">
                        <div class="alert alert-success">${messageDeleteBanners}</div>
                    </c:if>
                    <c:if test="${not empty checkErrorDeleteBanners}">
                        <div class="alert alert-danger">${checkErrorDeleteBanners}</div>
                    </c:if>
                    <c:if test="${not empty checkErrorSearch}">
                        <div class="alert alert-danger">${checkErrorSearch}</div>
                    </c:if>
                    <c:if test="${not empty messageUpdateBanner}">
                        <div class="alert alert-success">${messageUpdateBanner}</div>
                    </c:if>
                    <c:if test="${not empty checkErrorUpdateBanner}">
                        <div class="alert alert-danger">${checkErrorUpdateBanner}</div>
                    </c:if>

                    <!-- TOOLBAR -->
                    <div class="admin-toolbar">
                        <div class="title">Danh sách Banners</div>

                        <!-- Tìm kiếm -->
                        <form action="BannerController" method="post" class="search-form" autocomplete="off">
                            <input type="hidden" name="action" value="searchBanner"/>
                            <input type="text" name="keyword" value="${keyword != null ? keyword : ''}" placeholder="Nhập tiêu đề banner..." />
                            <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                        </form>

                        <!-- (Tuỳ chọn) Thêm mới -->
                        <form action="MainController" method="post" class="search-form" autocomplete="off">
                            <input type="hidden" name="action" value="showAddBannerForm"/>
                            <button type="submit" class="btn btn-primary">+ Thêm banner</button>
                        </form>
                    </div>

                    <!-- THẺ DANH SÁCH -->
                    <div class="banners-card">
                        <!-- Meta: từ khoá & tổng số -->
                        <div class="banners-meta">
                            <span class="meta-pill"><span class="dot"></span><b>Từ khóa:</b>&nbsp;${keyword != null && fn:length(keyword) > 0 ? keyword : '—'}</span>
                            <span class="meta-pill"><b>Tổng:</b>&nbsp;
                                <c:choose>
                                    <c:when test="${not empty list}">${fn:length(list)}</c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose> banner
                            </span>
                        </div>

                        <!-- BẢNG -->
                        <c:choose>
                            <c:when test="${not empty list}">
                                <div class="table-wrap">
                                    <table class="banners">
                                        <thead>
                                            <tr>
                                                <th>Ảnh</th>
                                                <th>ID</th>
                                                <th style="text-align:center;">Tiêu đề</th>
                                                <th style="text-align:center;">Trạng thái</th>
                                                <th style="text-align: center;">Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="b" items="${list}">
                                                <tr>
                                                    <td>
                                                        <c:set var="imgUrl"
                                                               value="${(b.image_url != null && fn:length(b.image_url) > 0) ? pageContext.request.contextPath.concat('/').concat(b.image_url) : 'assets/img/no-image.png'}"/>
                                                        <img class="ban-thumb" src="${imgUrl}" alt="${b.title}" />
                                                    </td>
                                                    <td>${b.id}</td>
                                                    <td style="text-align:center;">
                                                        <div class="ban-title">${b.title}</div>
                                                        <div class="prod-sku">#${b.id}</div>
                                                    </td>
                                                    <td style="text-align:center;">
                                                        <c:choose>
                                                            <c:when test="${fn:toLowerCase(b.status) eq 'active'}">
                                                                <span class="status-pill status-active">Đang hiển thị</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="status-pill status-inactive">Ẩn</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <div class="row-actions">
                                                            <form action="MainController" method="post" style="display:inline;">
                                                                <input type="hidden" name="action" value="editBanners"/>
                                                                <input type="hidden" name="id" value="${b.id}"/>
                                                                <input type="hidden" name="keyword" value="${keyword != null ? keyword : ''}" />
                                                                <input type="submit" value="Sửa" class="btn btn-secondary" />
                                                            </form>

                                                            <form action="MainController" method="post" style="display:inline;"
                                                                  onsubmit="return confirm('Xoá banner này?');">
                                                                <input type="hidden" name="action" value="deleteBanner"/>
                                                                <input type="hidden" name="id" value="${b.id}"/>
                                                                <input type="hidden" name="keyword" value="${keyword != null ? keyword : ''}" />
                                                                <input type="submit" value="Xoá" class="btn btn-danger" />
                                                            </form>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <h3>Không tìm thấy banner</h3>
                                    <p>Vui lòng thử lại với từ khóa khác hoặc bỏ lọc để xem tất cả.</p>
                                    <a href="BannerController?action=getAllBanners" class="btn btn-primary">Xem tất cả banners</a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="footer.jsp"/>

        <!-- Swiper JS (nếu cần) -->
        <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
    </body>
</html>
