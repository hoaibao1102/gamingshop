<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="utils.AuthUtils" %>
<c:set var="isLoggedIn" value="<%= AuthUtils.isLoggedIn(request) %>" />
<fmt:setLocale value="vi_VN"/>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <%@ include file="/WEB-INF/jspf/head.jspf" %>
        <title>${post.title} — Bài viết</title>
        <link rel="stylesheet" href="assets/css/maincss.css" />

        <style>
            /* Chặn mọi tràn ngang lặt vặt */
            html, body, .Main_content{
                overflow-x:hidden;
            }

            /* ===== Khối tiêu đề & byline ===== */
            .article{
                max-width:820px;
                margin:18px auto;
                padding:0 20px;
            }
            .article h1.title{
                font-size:clamp(1.9rem, 3.2vw, 2.6rem);
                line-height:1.18;
                font-weight:800;
                letter-spacing:-.01em;
                margin:8px 0 10px;
                color:#0b1020;
            }
            .byline{
                display:flex;
                align-items:center;
                gap:10px;
                flex-wrap:wrap;
                color:#374151;
                margin-bottom:10px;
            }
            .avatar{
                width:36px;
                height:36px;
                border-radius:999px;
                background:#111827;
                color:#fff;
                display:inline-flex;
                align-items:center;
                justify-content:center;
                font-weight:700;
            }
            .author{
                font-weight:700;
                text-transform:uppercase;
                letter-spacing:.02em;
            }
            .state-badge{
                display:inline-flex;
                align-items:center;
                gap:6px;
                padding:4px 10px;
                border-radius:999px;
                font-size:.8rem;
                border:1px solid #e5e7eb;
                background:#f9fafb;
                color:#6b7280;
            }
            .state-badge.success{
                color:#067647;
                background:#ecfdf5;
                border-color:#a7f3d0;
            }
            .state-badge.draft{
                color:#92400e;
                background:#fffbeb;
                border-color:#fcd34d;
            }

            /* Ngày/giờ: 1 dòng + ellipsis */
            .pub-date{
                color:#6b7280;
                font-size:.95rem;
                white-space:nowrap;
                overflow:hidden;
                text-overflow:ellipsis;
                min-width:0;
                max-width:min(60vw, 360px);
            }
            .pub-date .tz{
                margin-left:4px;
                opacity:.7;
            }

            /* ===== Utilities (nút) ===== */
            .action-pills{
                display:flex;
                gap:8px;
                margin-left:auto;
                flex-wrap:wrap;
            }
            .btn{
                display:inline-flex;
                align-items:center;
                gap:6px;
                padding:8px 12px;
                border-radius:999px;
                border:1px solid #e5e7eb;
                background:#fff;
                color:#111827;
                text-decoration:none;
                font-weight:600;
                cursor:pointer;
            }
            .btn:hover{
                background:#f9fafb;
            }
            .btn-primary{
                background:#007bff !important;
                color:#fff !important;
                border:1px solid #007bff !important;
            }
            .btn-primary:hover{
                background:#1d4ed8 !important;
            }
            .btn-danger{
                background:#dc3545 !important;
                color:#fff !important;
                border:1px solid #dc3545 !important;
            }
            .btn-danger:hover{
                background:#b02a37 !important;
            }

            /* ===== Nội dung ===== */
            .content{
                margin:18px auto 28px;
                max-width:820px;
                padding:0 20px;
            }
            .prose{
                font-size:1.05rem;
                line-height:1.85;
                color:#111827;
            }
            .prose h2,.prose h3,.prose h4{
                margin:18px 0 8px;
                line-height:1.35;
                color:#0b1020;
            }
            .prose ul,.prose ol{
                padding-left:22px;
                margin:12px 0;
            }
            .prose blockquote{
                border-left:4px solid #e5e7eb;
                padding-left:12px;
                color:#374151;
                margin:14px 0;
            }
            .prose img,.prose video,.prose iframe{
                max-width:100%;
                border-radius:12px;
            }
            .prose code{
                background:#f3f4f6;
                padding:2px 6px;
                border-radius:6px;
            }

            .divider {
                width: 100%;        /* chiều dài = 50% so với container */
                margin: 2px auto; /* căn giữa */
                border: none;
                height: 2px;
                background: #000;  /* màu đen */
            }

            /* ==== Recent posts ==== */
            .recent-wrap{
                max-width:1000px;
                margin:0 auto 32px;
                padding:0 20px;
            }
            .recent-title{
                font-size:1.2rem;
                font-weight:800;
                margin:8px 0 12px;
                color:#0b1020;
            }
            .recent-grid{
                display:grid;
                grid-template-columns:repeat(auto-fill,minmax(220px,1fr));
                gap:12px;
            }
            .recent-card{
                display:block;
                background:#fff;
                border:1px solid #e5e7eb;
                border-radius:12px;
                overflow:hidden;
                text-decoration:none;
                color:inherit;
                transition:transform .06s ease;
            }
            .recent-card:hover{
                background:#f9fafb;
                transform:translateY(-1px);
            }
            .recent-thumb{
                width:100%;
                aspect-ratio:16/9;
                object-fit:cover;
                background:#f3f4f6;
            }
            .recent-body{
                padding:10px;
            }
            .recent-name{
                font-weight:700;
                line-height:1.3;
                margin-bottom:6px;
                display:-webkit-box;
                -webkit-line-clamp:2;
                -webkit-box-orient:vertical;
                overflow:hidden;
            }
            .recent-meta{
                font-size:.9rem;
                color:#6b7280;
                display:flex;
                gap:8px;
                flex-wrap:wrap;
            }

            /* ====== Recent posts (cards) ====== */
            .recent-wrap{
                max-width:1000px;
                margin:18px auto 32px;
                padding:0 20px;
            }

            .recent-title{
                text-align: center;
                font-size:1.15rem;
                font-weight:800;
                color:#0b1020;
                display:flex;
                align-items:center;
                gap:10px;
                margin:0 0 12px;
            }
            .recent-title::after{
                content:"";
                height:2px;
                flex:1 1 auto;
                background:linear-gradient(90deg,#e5e7eb,transparent 60%);
                border-radius:999px;
            }

            .recent-grid{
                display:grid;
                grid-template-columns:repeat(auto-fill,minmax(230px,1fr));
                gap:14px;
            }

            .recent-card{
                display:block;
                background:#fff;
                border:1px solid #e5e7eb;
                border-radius:14px;
                overflow:hidden;                /* cho hiệu ứng zoom ảnh */
                text-decoration:none;
                color:inherit;
                transition:transform .08s ease, box-shadow .15s ease, border-color .15s ease;
                will-change:transform;
            }
            .recent-card:hover{
                transform:translateY(-2px);
                box-shadow:0 10px 24px rgba(0,0,0,.08);
                border-color:#e0e7ff;
            }
            .recent-card:focus-visible{
                outline:2px solid #93c5fd;
                outline-offset:2px;
            }

            /* Ảnh 16:9, cover + zoom nhẹ khi hover */
            .recent-thumb{
                width:100%;
                aspect-ratio:16/9;
                object-fit:cover;
                display:block;
                background:#f3f4f6;
                transform:scale(1.001);
                transition:transform .35s ease;
            }
            .recent-card:hover .recent-thumb{
                transform:scale(1.05);
            }

            .recent-body{
                padding:10px 12px 12px;
                display:grid;
                gap:6px;
            }

            .recent-name{
                font-weight:700;
                line-height:1.28;
                color:#111827;
                /* 2 dòng + ... */
                display:-webkit-box;
                -webkit-line-clamp:2;
                -webkit-box-orient:vertical;
                overflow:hidden;
                min-height:2.56em; /* giữ chiều cao đều */
            }

            /* Meta: nhỏ, dịu, tự xuống dòng đẹp */
            .recent-meta{
                font-size: 5rem;
                font-size: .95rem;
                color:#6b7280;
                display:flex;
                flex-wrap:wrap;
                gap:8px;
                align-items:center;
            }

            /* Dấu chấm phân tách đẹp hơn khi wrap */
            .recent-meta span{
                display:inline-flex;
                align-items:center;
            }

            /* ====== Responsive tweaks ====== */
            @media (max-width:640px){
                .recent-wrap{
                    padding:0 16px;
                }
                .recent-grid{
                    grid-template-columns:repeat(2,minmax(0,1fr));
                    gap:10px;
                }
            }
            @media (max-width:420px){
                .recent-grid{
                    grid-template-columns:1fr;
                }
            }

            @media (max-width:720px){
                .action-pills{
                    width:100%;
                    justify-content:flex-start;
                }
                .article{
                    padding:0 16px;
                }
                .content{
                    padding:0 16px;
                }
            }
            @media (max-width:640px){
                .pub-date{
                    flex-basis:100%;
                    max-width:100%;
                    text-align:left;
                    margin-top:4px;
                }
            }
        </style>
    </head>
    <body>
        <div class="wrapper">
            <div class="sidebar"><jsp:include page="sidebar.jsp"/></div>
            <div class="Main_content">
                <jsp:include page="header.jsp"/>

                <!-- Tiêu đề + Byline + công cụ + Ngày/giờ -->
                <section class="article">
                    <h1 class="title">${post.title}</h1>

                    <div style="display:flex; gap:12px; align-items:center; flex-wrap:wrap">
                        <div class="byline">
                            <span class="avatar">
                                <c:set var="firstChar" value="${(not empty post.author) ? fn:toUpperCase(fn:substring(post.author,0,1)) : 'A'}"/>
                                ${firstChar}
                            </span>
                            <span class="author">${post.author}</span>

                            <c:choose>
                                <c:when test="${post.status == 1}">
                                    <span class="state-badge success">Đã xuất bản</span>
                                </c:when>
                                <c:otherwise>
                                    <c:if test="${isLoggedIn}">
                                        <span class="state-badge draft">Bản nháp</span>
                                    </c:if>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="action-pills">
                            <button class="btn" type="button" id="copyLinkBtn">🔗 Sao chép liên kết</button>
                            <c:if test="${isLoggedIn}">
                                <form action="MainController" method="post" style="display:flex; gap:8px">
                                    <input type="hidden" name="id" value="${post.id}"/>
                                    <button class="btn btn-primary" name="action" value="goToUpdatePosts" type="submit">✏️ Sửa</button>
                                    <button class="btn btn-danger" name="action" value="deletePosts" type="submit"
                                            onclick="return confirm('Xoá bài viết #${post.id}?');">🗑️ Xoá</button>
                                </form>
                            </c:if>
                            <!-- Nút quay lại danh sách (ai cũng thấy) -->
                            <form action="MainController" method="post" autocomplete="off" style="display:flex">
                                <input type="hidden" name="action" value="searchPosts"/>
                                <button class="btn ghost" type="submit">Quay lại danh sách</button>
                            </form>
                        </div><br>

                        <div class="pub-date">
                            <fmt:formatDate value="${post.publish_date}" pattern="dd/MM/yyyy"/>
                            <span class="tz">GMT+7</span>
                        </div>
                    </div>
                </section>

                <hr class="divider">

                <!-- Nội dung -->
                <section class="content">
                    <div class="prose">
                        <c:out value="${post.content_html}" escapeXml="false"/>
                    </div>
                </section>
                <hr class="divider">
                <c:if test="${not empty requestScope.recentPosts}">
                    <section class="recent-wrap">
                        <div class="recent-title">Bài viết gần đây</div>
                        <div class="recent-grid">
                            <c:forEach var="rp" items="${requestScope.recentPosts}">
                                <c:if test="${isLoggedIn or rp.status == 1}">
                                    <a class="recent-card" href="MainController?action=viewPost&id=${rp.id}">
                                        <c:choose>
                                            <c:when test="${not empty rp.image_url}">
                                                <img class="recent-thumb" src="${rp.image_url}" alt="${fn:escapeXml(rp.title)}"/>
                                            </c:when>
                                            <c:otherwise>
                                                <img class="recent-thumb" src="/assets/images/no-image.jpg" alt="No image"/>
                                            </c:otherwise>
                                        </c:choose>

                                        <div class="recent-body">
                                            <div class="recent-name">${rp.title}</div>
                                            <div class="recent-meta">
                                                <span><fmt:formatDate value="${rp.publish_date}" pattern="dd/MM"/></span>
                                                <span>•</span>
                                                <span>${rp.author}</span>
                                                <!-- Nhãn Bản nháp: chỉ hiện cho người đã đăng nhập -->
                                                <c:if test="${isLoggedIn && rp.status != 1}">
                                                    <span>•</span><span>Bản nháp</span>
                                                </c:if>
                                            </div>
                                        </div>
                                    </a>
                                </c:if>
                            </c:forEach>
                        </div>
                    </section>
                </c:if>
            </div>

        </div>

        <jsp:include page="footer.jsp"/>

        <script>
            // Copy link
            document.getElementById('copyLinkBtn')?.addEventListener('click', () => {
                const btn = document.getElementById('copyLinkBtn');
                navigator.clipboard.writeText(location.href).then(() => {
                    btn.textContent = '✅ Đã sao chép';
                    setTimeout(() => btn.textContent = '🔗 Sao chép liên kết', 1200);
                });
            });
        </script>
    </body>
</html>