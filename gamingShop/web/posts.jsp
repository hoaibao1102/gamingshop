<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="utils.AuthUtils" %>
<c:set var="isLoggedIn" value="<%= AuthUtils.isLoggedIn(request) %>" />
<fmt:setLocale value="vi_VN"/>

<%-- 
    Document   : products (redesigned)
    Created on : Sep 17, 2025
    Author     : ADMIN (refactor by AI)
    Notes      :
      - Bố cục, phong cách đồng bộ với trang chủ: wrapper/sidebar/header/footer
      - Thay bảng thô bằng thẻ "card" dạng lưới, kèm search + trạng thái + phân trang
      - Loại bỏ scriptlet, dùng JSTL + fmt
--%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Quản lý Bài viết</title>

        <!-- Swiper (đồng bộ với trang chủ, phòng khi dùng slider nội bộ) -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />

        <!-- Theme CSS (trang chủ) -->
        <link rel="stylesheet" href="assets/css/maincss.css" />

        <!-- Trang riêng -->
        <style>
            /* khối chung */
            .header-actions{
                display:flex;
                align-items:center;
                gap:12px;
            }
            .header-actions .search-form{
                display:flex;
                align-items:center;
                gap:8px;
                flex:1 1 auto;
            }
            .header-actions .search-form input[type="text"]{
                flex:1;
                min-width:220px;
                border-radius:12px;
            }
            .header-actions .action-form{
                display:flex;
                align-items:center;
                gap:8px;
                flex:0 0 auto;
            }
            .btn{
                display:inline-flex;
                align-items:center;
                justify-content:center;
                white-space:nowrap;
            }

            /* Nút xanh kiểu pill */
            .btn-custom{
                background:#2563eb;
                color:#fff;
                border:1px solid #2563eb;
                border-radius:12px;
                font-weight:700;
                padding:10px 16px;
            }
            .btn-custom:hover{
                background:#1d4ed8;
            }
            .page-header {
                display:flex;
                align-items:center;
                justify-content:space-between;
                gap:16px;
                margin:12px 0 16px
            }
            .page-title {
                font-size:1.4rem;
                font-weight:700
            }
            .subtle {
                color:#6b7280;
                font-size:.95rem
            }

            /* search */
            .search-bar {
                display:flex;
                gap:8px;
                align-items:center;
                width:100%
            }
            .search-bar input[type="text"]{
                flex:1;
                padding:10px 12px;
                border:1px solid #e5e7eb;
                border-radius:8px
            }
            .btn {
                cursor:pointer;
                border:0;
                padding:10px 14px;
                border-radius:10px;
                font-weight:600
            }
            .btn-primary {
                background:#111827;
                color:#fff
            }
            .btn-outline {
                background:#fff;
                color:#111827;
                border:1px solid #e5e7eb
            }
            .btn-danger {
                background:#ef4444;
                color:#fff
            }
            .btn:hover {
                opacity:.92
            }

            /* grid cards */
            .card-grid{
                display:grid;
                grid-template-columns:repeat(auto-fill,minmax(260px,1fr));
                gap:16px
            }
            .card{
                background:#fff;
                border:1px solid #e5e7eb;
                border-radius:14px;
                overflow:hidden;
                display:flex;
                flex-direction:column
            }
            .card .thumb {
                aspect-ratio: 16/9;
                width: 90%;               /* nhỏ hơn 100% một chút */
                max-width: 320px;         /* không vượt quá 320px */
                object-fit: cover;
                background: #f3f4f6;
                margin: 0 auto;           /* căn giữa trong card */
                border-radius: 8px;       /* bo góc nhẹ cho đẹp */
            }
            .card .body{
                padding:12px
            }
            .card .title{
                font-weight:700;
                line-height:1.3;
                margin-bottom:6px;
                display:block;
                display:-webkit-box;
                -webkit-line-clamp:2;
                -webkit-box-orient:vertical;
                overflow:hidden
            }
            .card .meta{
                display:flex;
                gap:8px;
                flex-wrap:wrap;
                color:#6b7280;
                font-size:.9rem;
                margin-bottom:10px
            }

            .badge{
                display:inline-flex;
                align-items:center;
                gap:6px;
                border-radius:999px;
                padding:4px 10px;
                font-size:.75rem;
                border:1px solid #e5e7eb;
                background:#f9fafb
            }
            .badge.success{
                color:#067647;
                background:#ecfdf5;
                border-color:#a7f3d0
            }
            .badge.warning{
                color:#92400e;
                background:#fffbeb;
                border-color:#fcd34d
            }
            .card .content{
                color:#374151;
                font-size:.95rem;
                display:-webkit-box;
                -webkit-line-clamp:3;
                -webkit-box-orient:vertical;
                overflow:hidden
            }
            .card .actions{
                display:flex;
                gap:8px;
                padding:12px;
                border-top:1px solid #f3f4f6;
                margin-top:auto
            }

            /* thông báo */
            .alert{
                padding:12px 14px;
                border-radius:10px;
                margin:10px 0
            }
            .alert-success{
                background:#ecfdf5;
                color:#065f46;
                border:1px solid #a7f3d0
            }
            .alert-danger{
                background:#fef2f2;
                color:#991b1b;
                border:1px solid #fecaca
            }

            /* empty */
            .empty-state{
                background:#fff;
                border:1px dashed #d1d5db;
                padding:24px;
                border-radius:14px;
                text-align:center
            }
            .empty-state h3{
                margin:0 0 6px
            }

            /* pagination placeholder (nếu có include) */
            .pagination-wrap{
                margin:16px 0
            }

            /* giữ nguyên layout chung từ trang chủ */
            .Main_content{
                width:100%
            }
            /* Compact mode overrides */
            .page-header{
                margin:8px 0 10px
            }
            .page-title{
                font-size:1.1rem
            }

            .search-bar input[type="text"]{
                padding:8px 10px
            }
            .btn{
                padding:8px 10px;
                border-radius:8px
            }
            .card-grid{
                grid-template-columns:repeat(auto-fill,minmax(220px,1fr));
                gap:12px
            }
            .card{
                border-radius:10px
            }
            .card .thumb{
                aspect-ratio:4/3
            }
            .card .body{
                padding:8px
            }
            .card .title{
                font-size:.98rem
            }

            .body .title{
                text-align: center;
                height: 45px;
                margin-top: 10px
            }
            .card .meta{
                font-size:.85rem;
                margin-bottom:6px
            }
            .badge{
                padding:3px 8px;
                font-size:.7rem
            }
            .card .actions{
                padding:8px
            }
            /* Ẩn mô tả */
            .card .content{
                display:none
            }
            /* Nút Tìm kiếm kiểu pill xanh */
            .btn-custom{
                background:#2563eb !important;
                color:#fff !important;
                border:1px solid #2563eb !important;
                border-radius:12px;
                font-weight:700;
                padding:10px 16px;
                transition:background-color .2s ease, box-shadow .2s ease, transform .05s ease
            }
            .btn-custom:hover{
                background:#1d4ed8 !important;
                box-shadow:0 4px 12px rgba(37,99,235,.35)
            }
            .btn-custom:active{
                transform:translateY(1px);
                box-shadow:inset 0 1px 3px rgba(0,0,0,.2)
            }
            .btn-custom:focus-visible{
                outline:2px solid #93c5fd;
                outline-offset:2px
            }
            /* Input bo tròn để đồng bộ với nút */
            .search-bar input[type="text"]{
                border-radius:12px
            }

            .btn-danger {
                background-color: #dc3545 !important;
                color: #fff !important;
                border: 1px solid #dc3545 !important;
            }

            .btn-danger:hover {
                background-color: #b02a37 !important;
                color: #fff !important;
            }
            .admin-toolbar {
                display: flex;
                flex-wrap: wrap;
                align-items: center;
                gap: 12px;
                padding: 16px;
                background: #f3f4f6;
                border-radius: 12px;
                box-shadow: 0 6px 18px rgba(0,0,0,.1);
            }
            .admin-toolbar .title {
                font-size: 20px;
                font-weight: 700;
                color: #111827;
                margin-right: 590px;
            }
            .admin-toolbar .search-form {
                display: flex;
                gap: 8px;
                align-items: center;
            }
            .admin-toolbar input[type="text"] {
                height: 40px;
                border-radius: 10px;
                border: 1px solid #d1d5db;
                background: #fff;
                color: #111827;
                padding: 0 12px;
                min-width: 280px;
            }
            .admin-toolbar .btn {
                height: 40px;
                border: 0;
                border-radius: 10px;
                padding: 0 14px;
                font-weight: 600;
                cursor: pointer;
            }
            /* Style lại nút tìm kiếm */
            .admin-toolbar .btn-primary {
                background-color: #2563eb;
                color: #fff;
                border: none;
                border-radius: 8px;
                padding: 0 18px;
                transition: all 0.2s ease;
            }
            .admin-toolbar .btn-primary:hover {
                background-color: #1d4ed8;
            }
            .admin-toolbar .btn-secondary {
                background-color: #6b7280;
                color: #fff;
                border: none;
                border-radius: 8px;
                padding: 0 16px;
                transition: all 0.2s ease;
                text-decoration: none;
            }
            .admin-toolbar .btn-secondary:hover {
                background-color: #4b5563;
            }

            .products-card {
                margin-top: 16px;
                background: #fff;
                border: 1px solid #e5e7eb;
                border-radius: 16px;
                overflow: hidden;
            }
            .products-meta {
                display: flex;
                flex-wrap: wrap;
                gap: 8px;
                padding: 12px 16px;
                border-bottom: 1px solid #e5e7eb;
                background: #f9fafb;
            }
            .meta-pill {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 6px 10px;
                border-radius: 999px;
                font-size: 12px;
                background: #f3f4f6;
                color: #374151;
                border: 1px dashed #d1d5db;
            }
            .meta-pill .dot {
                width: 8px;
                height: 8px;
                border-radius: 999px;
                background: #22c55e;
            }
            .card-link{
                display:block;
                color:inherit;
                text-decoration:none
            }
            .card:hover{
                box-shadow:0 8px 24px rgba(0,0,0,.08);
                transform:translateY(-2px);
                transition:.15s
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

                <!-- Marquee (đồng bộ phong cách) -->
                <div class="marquee-bar">
                    <div class="marquee-inner">
                        <span class="marquee-item"><span class="badge">HOT</span> Quản lý bài viết nhanh, gọn, trực quan</span>
                        <span class="marquee-item"><span class="badge">TIP</span> Dùng ô tìm kiếm để lọc theo tiêu đề</span>
                        <span class="marquee-item"><a href="#">Xem hướng dẫn biên tập →</a></span>
                    </div>
                </div>

                <div class="container">

                    <div class="admin-toolbar">
                        <div class="title">Danh sách sản phẩm</div>
                        <c:if test="${isLoggedIn}">
                            <div class="header-actions">
                                <form action="MainController" method="post" class="search-form" autocomplete="off">
                                    <input type="hidden" name="action" value="searchPosts"/>
                                    <input type="text" name="keyword" value="${keyword != null ? keyword : ''}" placeholder="Nhập tên bài post..." />
                                    <button type="submit" class="btn btn-custom">Tìm kiếm</button>
                                </form>

                                <form action="MainController" method="post" class="action-form">
                                    <input type="hidden" name="action" value="showAddPosts"/>
                                    <button class="btn btn-custom" type="submit">+ Thêm bài post</button>
                                </form>
                            </div>
                        </c:if>
                    </div>
                    <!-- Thông báo -->
                    <c:if test="${not empty checkErrorSearchPosts}">
                        <div class="alert alert-danger">${checkErrorSearchPosts}</div>
                    </c:if>
                    <c:if test="${not empty messageSearchPosts}">
                        <div class="alert alert-success">${messageSearchPosts}</div>
                    </c:if>
                    <c:if test="${not empty messageDeletePosts}">
                        <div class="alert alert-success">${messageDeletePosts}</div>
                    </c:if>
                    <c:if test="${not empty checkErrorDeletePosts}">
                        <div class="alert alert-danger">${checkErrorDeletePosts}</div>
                    </c:if>

                    <div class="products-card">
                        <c:if test="${isLoggedIn}">
                            <div class="products-meta">
                                <span class="meta-pill"><span class="dot"></span><b>Từ khóa:</b>&nbsp;${keyword != null && fn:length(keyword) > 0 ? keyword : '—'}</span>
                                <span class="meta-pill"><b>Tổng:</b>&nbsp;<c:choose>
                                        <c:when test="${not empty list}">${fn:length(list)}</c:when>
                                        <c:otherwise>0</c:otherwise>
                                    </c:choose> sản phẩm</span>
                            </div> <br>
                        </c:if>
                        <!-- Danh sách bài viết -->
                        <c:choose>
                            <c:when test="${not empty list}">
                                <ul class="card-grid" style="list-style:none; padding-left:0; margin:0">
                                    <c:forEach var="p" items="${list}">
                                        <!-- Chỉ hiển thị nếu đã login, hoặc bài đã xuất bản -->
                                        <c:if test="${isLoggedIn or p.status == 1}">
                                            <li class="card">
                                                <a class="card-link" href="MainController?action=viewPost&id=${p.id}" aria-label="Xem chi tiết ${fn:escapeXml(p.title)}">
                                                    <c:choose>
                                                        <c:when test="${not empty p.image_url}">
                                                            <img class="thumb" src="${p.image_url}" alt="${fn:escapeXml(p.title)}" />
                                                        </c:when>
                                                        <c:otherwise>
                                                            <img class="thumb" src="/assets/images/no-image.jpg" alt="No image" />
                                                        </c:otherwise>
                                                    </c:choose>

                                                    <div class="body">
                                                        <span class="title">${p.title}</span>
                                                        <div class="meta">
                                                            <c:if test="${isLoggedIn}">
                                                                <span class="badge">#${p.id}</span>
                                                            </c:if>
                                                            <span>Tác giả: <strong>${p.author}</strong></span>
                                                            <span><fmt:formatDate value="${p.publish_date}" pattern="dd/MM/yyyy"/></span>

                                                            <c:choose>
                                                                <c:when test="${p.status == 1}">
                                                                    <span class="badge success">Đã xuất bản</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <c:if test="${isLoggedIn}">
                                                                        <span class="badge warning">Bản nháp</span>
                                                                    </c:if>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        <!-- Mô tả bạn đang ẩn rồi -->
                                                    </div>
                                                </a>

                                                <!-- Hành động chỉ dành cho đã đăng nhập -->
                                                <div class="actions">
                                                    <c:if test="${isLoggedIn}">
                                                        <form action="MainController" method="post" style="display:inline-flex; gap:8px; width:100%">
                                                            <input type="hidden" name="keyword" value="${keyword != null ? keyword : ''}" />
                                                            <input type="hidden" name="id" value="${p.id}"/>
                                                            <button class="btn btn-outline" name="action" value="goToUpdatePosts" type="submit">Sửa</button>
                                                            <input type="hidden" name="deleteId" value="${p.id}"/>
                                                            <button class="btn btn-danger" name="action" value="deletePosts" type="submit"
                                                                    onclick="return confirm('Xoá bài viết #${p.id}?');">Xoá</button>
                                                        </form>
                                                    </c:if>
                                                </div>
                                            </li>
                                        </c:if>
                                    </c:forEach>
                                </ul>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <h3>Không tìm thấy bài viết</h3>
                                    <p>Thử đổi từ khoá tìm kiếm hoặc xem tất cả bài viết.</p>
                                    <form action="MainController" method="post" style="display:inline-flex; gap:8px">
                                        <input type="hidden" name="action" value="searchPosts"/>
                                        <input type="hidden" name="keyword" value=""/>
                                        <button class="btn btn-custom" type="submit">Xem tất cả</button>
                                    </form>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <br>
                    </div>
                </div>
            </div>
        </div>
        <jsp:include page="footer.jsp"/>
        <!-- Swiper JS (nếu dùng slider nội bộ) -->
        <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
    </body>
</html>
