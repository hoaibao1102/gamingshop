<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<fmt:setLocale value="vi_VN"/>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>${empty editBanner ? 'Thêm banner' : 'Sửa banner'}</title>
        <%@ include file="/WEB-INF/jspf/head.jspf" %>
        <!-- App CSS đồng bộ -->
        <link rel="stylesheet" href="assets/css/maincss.css"/>

        <style>
            /* ===== Layout giống trang Post ===== */
            .wrapper{
                display:grid;
                grid-template-columns:260px 1fr;
                min-height:100vh
            }
            .sidebar{
                background:#111827
            }
            .Main_content{
                background:#f5f7fb;
                overflow-x:hidden
            }
            .container{
                padding:16px
            }

            .page-title{
                font-weight:700;
                letter-spacing:.2px;
                margin:0
            }
            .badge-soft{
                background:#eef2ff;
                color:#3b5bdb;
                padding:4px 10px;
                border-radius:999px;
                font-size:.85rem
            }

            .section{
                background:#fff;
                border:1px solid #e5e7eb;
                border-radius:14px
            }
            .section-hd{
                padding:14px 16px;
                border-bottom:1px solid #e5e7eb;
                font-weight:600;
                background:#f9fafb
            }
            .section-bd{
                padding:16px
            }

            .grid{
                display:grid;
                gap:12px
            }
            .grid-2{
                grid-template-columns:repeat(2,minmax(0,1fr))
            }
            .field{
                display:flex;
                flex-direction:column;
                gap:6px
            }
            .label{
                font-weight:600
            }
            .required::after{
                content:" *";
                color:#dc2626
            }
            .hint{
                font-size:.875rem;
                color:#6b7280
            }
            .input,.select,.textarea,.file{
                border:1px solid #d1d5db;
                border-radius:10px;
                padding:10px 12px;
                background:#fff;
                outline:none
            }

            .actions{
                position:sticky;
                bottom:0;
                background:#fff;
                border-top:1px solid #e5e7eb;
                padding:12px;
                display:flex;
                justify-content:flex-end;
                gap:8px;
                border-bottom-left-radius:14px;
                border-bottom-right-radius:14px
            }

            .btn{
                border:1px solid transparent;
                padding:10px 14px;
                border-radius:10px;
                cursor:pointer;
                font-weight:600
            }
            .btn.primary{
                background:#1d4ed8;
                color:#fde68a
            }
            .btn.line{
                background:#fff;
                border-color:#e5e7eb;
                color:#111827
            }
            .btn.ghost{
                background:#fff;
                border-color:#6b7280;
                color:#374151
            }
            .btn.ghost:hover{
                background:#ef4444;
                border-color:#ef4444;
                color:#fff
            }
            .btn.danger{
                background:#ef4444;
                color:#fff
            }

            .toast-stack{
                position:fixed;
                top:12px;
                right:12px;
                display:flex;
                flex-direction:column;
                gap:8px;
                z-index:1080
            }
            .toast{
                padding:12px 14px;
                border-radius:12px;
                box-shadow:0 6px 20px rgba(0,0,0,.08);
                display:flex;
                align-items:center;
                gap:10px
            }
            .toast.success{
                background:#ecfdf5;
                color:#065f46;
                border:1px solid #a7f3d0
            }
            .toast.error{
                background:#fef2f2;
                color:#991b1b;
                border:1px solid #fecaca
            }

            .breadcrumbs{
                display:flex;
                gap:8px;
                font-size:.95rem;
                color:#6b7280;
                margin-bottom:8px
            }
            .breadcrumbs a{
                color:inherit;
                text-decoration:none
            }
            .breadcrumbs .sep{
                color:#9ca3af
            }

            .img-row{
                display:flex;
                gap:16px;
                flex-wrap:wrap
            }
            .img-slot{
                width:320px;
                height:180px;
                display:flex;
                align-items:center;
                justify-content:center;
                background:#f3f4f6;
                border:1px dashed #d1d5db;
                border-radius:12px
            }
            .thumb{
                width:320px;
                height:180px;
                object-fit:cover;
                border-radius:12px;
                display:none
            }
            /* nút icon cơ bản */
            .btn.icon.only {
                padding: 8px 10px;
                border-radius: 10px;
            }
            .mobile-toggle {
                display: none;
            }

            /* ≤1024px: off-canvas sidebar + form 1 cột */
            @media (max-width: 1024px) {
                .wrapper {
                    grid-template-columns: 1fr;
                }
                .sidebar {
                    position: fixed;
                    inset: 0 auto 0 0;
                    width: 260px;
                    transform: translateX(-100%);
                    transition: transform .25s ease;
                    z-index: 1200;
                    box-shadow: 6px 0 20px rgba(0,0,0,.15);
                }
                .sidebar.is-open {
                    transform: translateX(0);
                }

                .sidebar-backdrop {
                    position: fixed;
                    inset: 0;
                    background: rgba(0,0,0,.25);
                    z-index: 1100;
                    display: none;
                }
                .sidebar-backdrop.show {
                    display: block;
                }

                .mobile-toggle {
                    display: inline-block;
                    border: 1px solid #e5e7eb;
                    background: #fff;
                    margin-right: 8px;
                }

                .grid-2 {
                    grid-template-columns: 1fr;
                }
                .container {
                    padding: 12px;
                }
                .actions {
                    padding: 10px;
                    gap: 6px;
                }

                /* ảnh co giãn theo màn */
                .thumb, .img-slot {
                    width: 100%;
                    max-width: 520px;
                    height: auto;
                    aspect-ratio: 16/9;
                }
                .img-slot {
                    min-height: 160px;
                }

                /* tránh grid/flex bóp chiều cao các ô */
                .grid, .section-bd, .field {
                    min-height: 0;
                }
            }

            /* ≤768px: giảm padding/chữ một chút */
            @media (max-width: 768px) {
                .page-title {
                    font-size: 1.1rem;
                }
                .badge-soft {
                    font-size: .78rem;
                    padding: 3px 8px;
                }
                .input, .select, .textarea, .file {
                    padding: 9px 10px;
                }
                .btn {
                    padding: 9px 12px;
                }
                .breadcrumbs {
                    font-size: .9rem;
                }
            }

            /* ≤480px: stack nút hành động */
            @media (max-width: 480px) {
                .actions {
                    flex-wrap: wrap;
                    justify-content: stretch;
                }
                .actions .btn {
                    flex: 1 1 auto;
                }
                .container {
                    padding: 10px 8px;
                }
                .section-hd, .section-bd {
                    padding: 12px;
                }
            }

            @media (max-width:1024px){
                .grid-2{
                    grid-template-columns:1fr
                }
            }
        </style>
    </head>
    <body>
        <!-- ===== Toasts ===== -->
        <div class="toast-stack">
            <c:if test="${not empty messageAddBanner}"><div class="toast success">${messageAddBanner}</div></c:if>
            <c:if test="${not empty messageUpdateBanner}"><div class="toast success">${messageUpdateBanner}</div></c:if>
            <c:if test="${not empty checkErrorAddBanner}"><div class="toast error">${checkErrorAddBanner}</div></c:if>
            <c:if test="${not empty checkErrorUpdateBanner}"><div class="toast error">${checkErrorUpdateBanner}</div></c:if>
            </div>

            <div class="wrapper">
                <div class="sidebar"><jsp:include page="sidebar.jsp"/></div>

            <div class="Main_content">
                <jsp:include page="header.jsp"/>

                <div class="container">
                    <!-- Header title + back -->
                    <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:12px;gap:12px;flex-wrap:wrap;">
                        <div>
                            <div class="breadcrumbs">
                                <a href="MainController?action=getAllBanner">Banners</a><span class="sep">›</span>
                                <span>${empty editBanner ? 'Thêm' : 'Chỉnh sửa'}</span>
                            </div>
                            <h2 class="page-title">
                                ${empty editBanner ? 'Thêm banner mới' : 'Chỉnh sửa banner'}
                                <span class="badge-soft" style="margin-left:8px;">Banner Management</span>
                            </h2>
                        </div>
                        <form action="MainController" method="post" autocomplete="off">
                            <input type="hidden" name="action" value="getAllBanner"/>
                            <button class="btn line" type="submit">Quay lại danh sách</button>
                        </form>
                    </div>

                    <!-- ===== Form ===== -->
                    <form id="bannerForm"
                          action="BannerController?action=${empty editBanner ? 'addBanner' : 'updateBanner'}"
                          method="post" enctype="multipart/form-data" autocomplete="off">

                        <c:if test="${not empty editBanner}">
                            <input type="hidden" name="id" value="${editBanner.id}"/>
                        </c:if>

                        <section class="section" style="margin-bottom:12px;">
                            <div class="section-hd">Thông tin banner</div>
                            <div class="section-bd">
                                <div class="grid grid-2">
                                    <div class="field">
                                        <label class="label required">Tiêu đề</label>
                                        <input class="input" type="text" name="title"
                                               value="${not empty editBanner.title ? editBanner.title : (not empty param.title ? param.title : '')}"
                                               placeholder="Nhập tiêu đề" required>
                                    </div>

                                    <div class="field">
                                        <label class="label required">Trạng thái</label>
                                        <select class="select" name="status" required>
                                            <option value="active"
                                                    ${ (not empty editBanner and editBanner.status eq 'active')
                                                       or (empty editBanner and param.status eq 'active') ? 'selected' : '' }>active</option>
                                            <option value="inactive"
                                                    ${ (not empty editBanner and editBanner.status eq 'inactive')
                                                       or (empty editBanner and param.status eq 'inactive') ? 'selected' : '' }>inactive</option>
                                        </select>
                                    </div>

                                    <div class="field" style="grid-column:1/-1;">
                                        <label class="label">Ảnh (tùy chọn)</label>
                                        <input class="file" type="file" id="imageFile" name="imageFile" accept="image/*"/>
                                        <div class="hint">Khuyên dùng 1000×450 hoặc 1100×450. &lt; 2MB.</div>

                                        <div class="img-row" style="margin-top:8px;">
                                            <c:choose>
                                                <c:when test="${not empty editBanner.image_url}">
                                                    <div id="placeholder" class="img-slot" style="display:none;"><span class="hint">Chưa có ảnh</span></div>
                                                    <img id="preview" class="thumb" style="display:block;"
                                                         src="${pageContext.request.contextPath}/${editBanner.image_url}" alt="Ảnh hiện tại"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <div id="placeholder" class="img-slot"><span class="hint">Chưa có ảnh</span></div>
                                                    <img id="preview" class="thumb" alt="Preview"/>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <c:if test="${not empty editBanner}">
                                            <div style="display:flex;gap:8px;margin-top:10px;">
                                                <button type="button" class="btn danger" onclick="deleteBannerImage('${editBanner.id}')">Xoá ảnh</button>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </section>

                        <!-- Actions -->
                        <div class="actions">
                            <button class="btn primary" type="submit">${empty editBanner ? 'Thêm banner' : 'Cập nhật banner'}</button>
                            <button class="btn line" type="reset">Làm mới</button>
                            <a class="btn ghost" href="MainController?action=getAllBanner">Hủy</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <jsp:include page="footer.jsp"/>

        <script>
            // Preview ảnh + ẩn/hiện placeholder
            (function () {
                const input = document.getElementById('imageFile');
                const img = document.getElementById('preview');
                const placeholder = document.getElementById('placeholder');
                const form = document.getElementById('bannerForm');

                let lastURL = null;
                if (!input || !img || !placeholder)
                    return;

                const showPlaceholder = () => {
                    placeholder.style.display = 'flex';
                    img.style.display = 'none';
                    img.removeAttribute('src');
                };
                const showImage = (url) => {
                    placeholder.style.display = 'none';
                    img.src = url;
                    img.style.display = 'block';
                };

                input.addEventListener('change', function () {
                    const file = this.files && this.files[0];

                    if (lastURL) {
                        URL.revokeObjectURL(lastURL);
                        lastURL = null;
                    }

                    if (file) {
                        if (!file.type.startsWith('image/')) {
                            alert('Vui lòng chọn đúng định dạng ảnh.');
                            this.value = '';
                            showPlaceholder();
                            return;
                        }
                        const url = URL.createObjectURL(file);
                        lastURL = url;
                        showImage(url);
                    } else {
                        // Không chọn file
                        if (!img.getAttribute('src'))
                            showPlaceholder();
                        else {
                            placeholder.style.display = 'none';
                            img.style.display = 'block';
                        }
                    }
                });

                // Reset về trạng thái ban đầu
                form.addEventListener('reset', function () {
                    setTimeout(() => {
                        const hasInitImg = ${empty editBanner || empty editBanner.image_url ? 'false' : 'true'};
                        if (!hasInitImg) {
                            if (lastURL) {
                                URL.revokeObjectURL(lastURL);
                                lastURL = null;
                            }
                            showPlaceholder();
                        } else {
                            placeholder.style.display = 'none';
                            img.style.display = 'block';
                            img.src = '${pageContext.request.contextPath}/${not empty editBanner.image_url ? editBanner.image_url : ""}';
                                            }
                                        }, 0);
                                    });

                                    window.addEventListener('beforeunload', () => {
                                        if (lastURL)
                                            URL.revokeObjectURL(lastURL);
                                    });
                                })();

                                // Xoá ảnh banner (gợi ý endpoint)
                                function deleteBannerImage(id) {
                                    if (!confirm('Xoá ảnh của banner #' + id + '?'))
                                        return;
                                    fetch('BannerController?action=deleteBannerImage', {
                                        method: 'POST',
                                        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                                        body: 'id=' + encodeURIComponent(id)
                                    }).then(r => r.text()).then(() => location.reload()).catch(() => alert('Có lỗi xảy ra khi xoá ảnh.'));
                                }
        </script>
    </body>
</html>
