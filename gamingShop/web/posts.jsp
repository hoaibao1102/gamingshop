<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="utils.AuthUtils" %>
<c:set var="isLoggedIn" value="<%= AuthUtils.isLoggedIn(request) %>" />
<fmt:setLocale value="vi_VN"/>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>SHOP GAME VIỆT 38 - Quản lý Bài viết</title>
        <%@ include file="/WEB-INF/jspf/head.jspf" %>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
        <link rel="stylesheet" href="assets/css/maincss.css" />

        <style>
            /* ====== RESET NHẸ + BIẾN CƠ BẢN ====== */
            :root{
                --bg:#fff;
                --txt:#111827;
                --muted:#6b7280;
                --border:#e5e7eb;
                --soft:#f3f4f6;
                --soft-2:#f9fafb;
                --brand:#2563eb;
                --brand-600:#1d4ed8;
                --danger:#ef4444;
                --danger-600:#dc2626;
                --radius:12px;
                --shadow:0 8px 24px rgba(0,0,0,.08);
            }

            /* ====== LAYOUT CHUNG ====== */
            .container{
                width:100%;
                max-width:1200px;
                margin-inline:auto;
                padding:0 16px;
            }

            .page-header{
                display:flex;
                align-items:center;
                justify-content:space-between;
                gap:12px;
                margin:8px 0 12px;
            }
            .page-title{
                font-size:clamp(1.06rem,2.2vw,1.4rem);
                font-weight:700
            }
            .subtle{
                color:var(--muted);
                font-size:.95rem
            }

            .wrapper{
                background:var(--soft-2)
            }
            .Main_content{
                width:100%
            }

            /* ====== BUTTONS ====== */
            .btn{
                display:inline-flex;
                align-items:center;
                justify-content:center;
                gap:8px;
                cursor:pointer;
                border:1px solid transparent;
                border-radius:var(--radius);
                font-weight:700;
                padding:10px 16px;
                transition:background-color .2s ease, box-shadow .2s ease, transform .05s ease, opacity .2s;
            }
            .btn:disabled{
                opacity:.5;
                cursor:not-allowed
            }

            /* Nút chính xanh */
            .btn-primary{
                background:var(--brand);
                border-color:var(--brand);
                color:#fff;
            }
            .btn-primary:hover{
                background:var(--brand-600)
            }

            /* Nút viền (trắng nền) */
            .btn-outline{
                background:#fff;
                color:var(--txt);
                border-color:#11182733;
            }
            .btn-outline:hover{
                border-color:var(--txt);
                background:var(--soft);
            }

            /* Nút xoá (đỏ) */
            .btn-danger{
                background:var(--danger) !important;
                border-color:var(--danger) !important;
                color:#fff;
            }
            .btn-danger:hover{
                background:var(--danger-600)
            }

            /* Nút custom xanh (tìm kiếm/thêm) */
            .btn-custom{
                background:var(--brand) !important;
                ;
                border-color:var(--brand) !important;
                ;
                color:#fff !important;
                box-shadow:none;
            }
            .btn-custom:hover{
                background:var(--brand-600) !important;
                ;
                box-shadow:0 4px 12px rgba(37,99,235,.35) !important;
                ;
            }
            .btn-custom:active{
                transform:translateY(1px)
            }

            /* ====== TOOLBAR QUẢN TRỊ ====== */
            .admin-toolbar{
                display:flex;
                flex-wrap:wrap;
                align-items:center;
                gap:12px;
                padding:12px;
                background:var(--soft);
                border-radius:12px;
                box-shadow:0 6px 18px rgba(0,0,0,.08)
            }
            .admin-toolbar .title{
                font-size:20px;
                font-weight:700;
                color:var(--txt)
            }

            .header-actions{
                display:flex;
                align-items:center;
                gap:12px;
                flex:1 1 auto;
                min-width:260px
            }
            .header-actions .search-form,
            .header-actions .action-form{
                display:flex;
                align-items:center;
                gap:8px
            }
            .header-actions .search-form{
                flex:1 1 auto
            }
            .header-actions .search-form input[type="text"]{
                flex:1 1 280px;
                min-width:200px;
                height:40px;
                border-radius:10px;
                border:1px solid #d1d5db;
                background:#fff;
                color:var(--txt);
                padding:0 12px;
            }

            /* ====== THẺ (CARD) DANH SÁCH BÀI VIẾT ====== */
            .card-grid{
                display:grid;
                grid-template-columns:repeat(2,minmax(0,1fr));
                gap:1
                    px;
            }
            @media (min-width:640px){
                .card-grid{
                    grid-template-columns:repeat(3,minmax(0,1fr))
                }
            }
            @media (min-width:1024px){
                .card-grid{
                    grid-template-columns:repeat(4,minmax(0,1fr));
                    gap:16px
                }
            }

            .card{
                background:#fff;
                border:1px solid var(--border);
                border-radius:14px;
                overflow:hidden;
                display:flex;
                flex-direction:column;
                transition:transform .15s ease, box-shadow .15s ease;
            }
            .card:hover{
                box-shadow:var(--shadow);
                transform:translateY(-2px)
            }

            .card-link{
                display:block;
                color:inherit;
                text-decoration:none
            }

            .card .thumb{
                width:100%;
                height:auto;
                display:block;
                aspect-ratio:16/9;
                object-fit:cover;
                background:var(--soft); /* BỎ mọi max-width/margin cũ gây tràn */
            }

            .card .body{
                padding:15px
            }
            .card .title{
                font-weight:700;
                line-height:1.35;
                margin:0 0 6px;
                display:-webkit-box;
                -webkit-line-clamp:2;
                -webkit-box-orient:vertical;
                overflow:hidden;
                font-size:clamp(.95rem,1.7vw,1.02rem);
                min-height: calc(1.35em * 2); /* luôn giữ đủ 2 dòng */
            }
            .card .meta{
                display:flex;
                gap:8px;
                flex-wrap:wrap;
                color:var(--muted);
                font-size:.88rem;
                margin-bottom:8px
            }

            .card .actions{
                display:flex;
                justify-content:center;
                gap:10px;
                padding:10px;
                border-top:1px solid #f3f4f6;
            }
            .card .actions form{
                display:flex;
                gap:10px;
                width:100%;
                flex-wrap:wrap
            }
            .card .actions .btn{
                min-width:92px;
                border-radius:10px;
                flex:1 1 auto
            }

            /* ====== BADGE, ALERT ====== */
            .badge{
                display:inline-flex;
                align-items:center;
                gap:6px;
                border-radius:999px;
                padding:4px 10px;
                font-size:.75rem;
                border:1px solid var(--border);
                background:var(--soft-2)
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

            /* ====== PRODUCTS WRAPPER ====== */
            .products-card{
                margin-top:16px;
                background:#fff;
                border:1px solid var(--border);
                border-radius:16px;
                overflow:hidden
            }
            .products-meta{
                display:flex;
                flex-wrap:wrap;
                gap:8px;
                padding:10px 12px;
                border-bottom:1px solid var(--border);
                background:var(--soft-2)
            }
            .meta-pill{
                display:inline-flex;
                align-items:center;
                gap:6px;
                padding:6px 10px;
                border-radius:999px;
                font-size:12px;
                background:var(--soft);
                color:#374151;
                border:1px dashed #d1d5db
            }
            .meta-pill .dot{
                width:8px;
                height:8px;
                border-radius:999px;
                background:#22c55e
            }

            /* ====== MARQUEE (ẩn ở màn nhỏ) ====== */
            .marquee-bar{
                overflow:hidden
            }
            @media (max-width:576px){
                .marquee-bar{
                    display:none
                }
            }

            /* ====== EMPTY STATE ====== */
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

            /* ====== RESPONSIVE CHI TIẾT ====== */
            /* <= 1024px: gom toolbar */
            @media (max-width:1024px){
                .admin-toolbar .title{
                    margin:0
                }
            }

            /* <= 768px: xếp dọc, nút full width, lưới thoáng hơn */
            @media (max-width:768px){
                .admin-toolbar{
                    flex-direction:column;
                    align-items:stretch;
                    gap:10px
                }
                .header-actions{
                    flex-direction:column;
                    align-items:stretch;
                    width:100%
                }
                .header-actions .search-form,
                .header-actions .action-form{
                    width:100%
                }
                .header-actions .search-form input[type="text"]{
                    width:100%
                }
                .btn-custom, .btn-primary, .btn-outline, .btn-danger{
                    width:100%
                }

                .card-grid{
                    grid-template-columns:minmax(0,1fr);
                    gap:12px
                }
                .card .thumb{
                    aspect-ratio:1/1
                } /* vuông ở mobile, không set width cứng */
                .card .actions{
                    flex-direction:column
                }
                .card .actions .btn{
                    width:100%
                } /* nút chiếm đủ ngang */

                .products-meta{
                    gap:6px
                }
                .container{
                    padding:0 12px
                }
            }

            /* >= 1200px: thoáng hơn */
            @media (min-width:1200px){
                .card-grid{
                    gap:18px
                }
            }

            /* Tôn trọng người dùng giảm chuyển động */
            @media (prefers-reduced-motion:reduce){
                *{
                    animation:none!important;
                    transition:none!important
                }
            }
        </style>
    </head>

    <body>
        <div class="wrapper">
            <div class="sidebar"><jsp:include page="sidebar.jsp"/></div>

            <div class="Main_content">
                <jsp:include page="header.jsp"/>

                <!-- Marquee -->
                <div class="marquee-bar">
                    <div class="marquee-inner">
                        <span class="marquee-item"><span class="badge">HOT</span> Quản lý bài viết nhanh, gọn, trực quan</span>
                        <span class="marquee-item"><span class="badge">TIP</span> Dùng ô tìm kiếm để lọc theo tiêu đề</span>
                        <span class="marquee-item"><a href="#">Xem hướng dẫn biên tập →</a></span>
                    </div>
                </div>

                <div class="container">
                    <div class="admin-toolbar">
                        <div class="title">Danh sách bài post</div>
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

                    <!-- Alerts -->
                    <c:if test="${not empty checkErrorSearchPosts}"><div class="alert alert-danger">${checkErrorSearchPosts}</div></c:if>
                    <c:if test="${not empty messageSearchPosts}"><div class="alert alert-success">${messageSearchPosts}</div></c:if>
                    <c:if test="${not empty messageDeletePosts}"><div class="alert alert-success">${messageDeletePosts}</div></c:if>
                    <c:if test="${not empty checkErrorDeletePosts}"><div class="alert alert-danger">${checkErrorDeletePosts}</div></c:if>

                        <div class="products-card">
                        <c:if test="${isLoggedIn}">
                            <div class="products-meta">
                                <span class="meta-pill"><span class="dot"></span><b>Từ khóa:</b>&nbsp;${keyword != null && fn:length(keyword) > 0 ? keyword : '—'}</span>
                                <span class="meta-pill"><b>Tổng:</b>&nbsp;<c:choose><c:when test="${not empty list}">${fn:length(list)}</c:when><c:otherwise>0</c:otherwise></c:choose> bài đăng</span>
                                    </div><br>
                        </c:if>

                        <!-- List -->
                        <c:choose>
                            <c:when test="${not empty list}">
                                <ul class="card-grid" style="list-style:none;padding-left:0;margin:0">
                                    <c:forEach var="p" items="${list}">
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
                                                            <c:if test="${isLoggedIn}"><span class="badge">#${p.id}</span></c:if>
                                                            <span>Tác giả: <strong>${p.author}</strong></span>
                                                            <span><fmt:formatDate value="${p.publish_date}" pattern="dd/MM/yyyy"/></span>
                                                            <c:choose>
                                                                <c:when test="${p.status == 1}"><span class="badge success">Đã xuất bản</span></c:when>
                                                                <c:otherwise><c:if test="${isLoggedIn}"><span class="badge warning">Bản nháp</span></c:if></c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>
                                                </a>

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
        <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
    </body>
</html>
