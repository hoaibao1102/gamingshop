<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<fmt:setLocale value="vi_VN"/>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>${empty post ? 'Thêm bài viết' : 'Sửa bài viết'}</title>
        <%@ include file="/WEB-INF/jspf/head.jspf" %>
        <!-- App CSS đồng bộ -->
        <link rel="stylesheet" href="assets/css/maincss.css"/>

        <style>
            /* ===== Layout giống trang quản lý sản phẩm ===== */
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
            .textarea{
                min-height:220px
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
            .btn.warn{
                background:#f59e0b;
                color:#111827
            }
            .btn.danger{
                background:#ef4444;
                color:#fff
            }
            .btn.line{
                background:#fff;
                border-color:#e5e7eb;
                color:#111827
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

            .img-slot{
                width: 250px;
                height: 200px;
                display:flex;
                align-items:center;
                justify-content:center;
                background:#f3f4f6;
                border:1px dashed #d1d5db;
                border-radius:12px
            }
            .thumb{
                width: 250px;
                height: 200px;
                /*aspect-ratio:5/4;*/
                object-fit:cover;
                border-radius:12px;
                display:none
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

            /* ===== Base tweaks (giữ desktop) ===== */
            .btn.icon.only {
                padding: 8px 10px;
                border-radius: 10px;
            }
            .mobile-toggle {
                display: none;
            }

            /* ===== ≤ 1024px: chuyển 1 cột, sidebar off-canvas ===== */
            @media (max-width: 1024px) {
                .wrapper {
                    grid-template-columns: 1fr;           /* 1 cột */
                }
                .sidebar {
                    position: fixed;
                    inset: 0 auto 0 0;                    /* left sheet */
                    width: 260px;
                    transform: translateX(-100%);
                    transition: transform .25s ease;
                    z-index: 1200;
                    box-shadow: 6px 0 20px rgba(0,0,0,.15);
                }
                .sidebar.is-open {
                    transform: translateX(0);
                }
                /* backdrop khi mở sidebar */
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

                .Main_content {
                    overflow-x: hidden;
                }
                .container {
                    padding: 12px;
                }

                .grid-2 {
                    grid-template-columns: 1fr;
                } /* form 1 cột */
                .actions {
                    position: sticky;
                    bottom: 0;
                    padding: 10px;
                    gap: 6px;
                }

                .mobile-toggle {
                    display: inline-block;
                    border: 1px solid #e5e7eb;
                    background: #fff;
                    margin-right: 8px;
                }

                /* ảnh preview co giãn */
                .thumb, .img-slot {
                    width: 100%;
                    max-width: 480px;
                    height: auto;
                    aspect-ratio: 5/4;
                }
                .img-slot {
                    min-height: 160px;
                }

                /* tránh flex/grid bóp chiều cao editor */
                .grid, .section-bd, .field {
                    min-height: 0;
                }
            }

            /* ===== ≤ 768px: giảm kích thước chữ/padding ===== */
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

            /* ===== ≤ 480px: stack nút, thu gọn margin ===== */
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
                .section-hd {
                    padding: 12px;
                }
                .section-bd {
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
            <c:if test="${not empty messageAddPosts}"><div class="toast success">${messageAddPosts}</div></c:if>
            <c:if test="${not empty messageUpdatePosts}"><div class="toast success">${messageUpdatePosts}</div></c:if>
            <c:if test="${not empty messageDeleteImg}"><div class="toast success">${messageDeleteImg}</div></c:if>

            <c:if test="${not empty checkErrorAddPosts}"><div class="toast error">${checkErrorAddPosts}</div></c:if>
            <c:if test="${not empty checkErrorUpdatePosts}"><div class="toast error">${checkErrorUpdatePosts}</div></c:if>
            <c:if test="${not empty checkErrorDeleteImg}"><div class="toast error">${checkErrorDeleteImg}</div></c:if>
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
                                <a href="MainController?action=searchPosts">Bài viết</a><span class="sep">›</span>
                                <span>${empty post ? 'Thêm' : 'Chỉnh sửa'}</span>
                            </div>
                            <h2 class="page-title">
                                ${empty post ? 'Thêm bài viết mới' : 'Chỉnh sửa bài viết'}
                                <span class="badge-soft" style="margin-left:8px;">Post Management</span>
                            </h2>
                        </div>
                        <form action="MainController" method="post" autocomplete="off">
                            <input type="hidden" name="action" value="searchPosts"/>
                            <button class="btn line" type="submit">Quay lại danh sách</button>
                        </form>
                    </div>

                    <!-- ===== Form ===== -->
                    <form id="postForm" action="MainController" method="post" enctype="multipart/form-data" autocomplete="off">
                        <input type="hidden" name="action" value="${empty post ? 'addPosts' : 'updatePosts'}"/>
                        <c:if test="${not empty post}">
                            <input type="hidden" name="id" value="${post.id}"/>
                        </c:if>

                        <!-- Thông tin chính -->
                        <section class="section" style="margin-bottom:12px;">
                            <div class="section-hd">Thông tin bài viết</div>
                            <div class="section-bd">
                                <div class="grid grid-2">
                                    <div class="field">
                                        <label class="label">Tác giả</label>
                                        <input class="input" type="text" name="author" value="${not empty post.author ? post.author : ''}" placeholder="VD: Admin">
                                        <div class="hint">Bỏ trống sẽ mặc định là <b>Admin</b>.</div>
                                    </div>

                                    <div class="field">
                                        <label class="label required">Tiêu đề</label>
                                        <input class="input" type="text" name="title" value="${not empty post.title ? post.title : ''}" required placeholder="Nhập tiêu đề bài viết">
                                    </div>

                                    <div class="field">
                                        <label class="label">Ngày xuất bản</label>
                                        <input class="input" type="date" name="publish_date"
                                               value="<fmt:formatDate value='${post.publish_date}' pattern='yyyy-MM-dd'/>">
                                        <div class="hint">Bỏ trống sẽ tự lấy ngày hôm nay.</div>
                                    </div>

                                    <div class="field">
                                        <label class="label required">Trạng thái</label>
                                        <select class="select" name="status" required>
                                            <option value="1" ${not empty post && post.status==1 ? 'selected' : ''}>Đã xuất bản</option>
                                            <option value="0" ${not empty post && post.status==0 ? 'selected' : ''}>Bản nháp</option>
                                        </select>
                                    </div>

                                    <div class="field" style="grid-column:1/-1;">
                                        <label class="label required">Nội dung (HTML)</label>
                                        <textarea id="editor" name="content_html" class="textarea" >${not empty post.content_html ? post.content_html : ''}</textarea>
                                        <div class="hint">Hỗ trợ chèn ảnh/video trực tiếp (TinyMCE).</div>
                                    </div>
                                </div>
                            </div>
                        </section>

                        <!-- Ảnh đại diện -->
                        <section class="section" style="margin-bottom:12px;">
                            <div class="section-hd">Ảnh đại diện</div>
                            <div class="section-bd">
                                <div class="grid">
                                    <div class="field" style="max-width:560px;">
                                        <label class="label">Tải ảnh</label>
                                        <input class="file" type="file" id="imageFile" name="image" accept="image/*"/>
                                        <div class="hint">Tỷ lệ gợi ý 250x200. Dung lượng &lt; 5MB.</div>

                                        <c:choose>
                                            <c:when test="${not empty post.image_url}">
                                                <div id="placeholder" class="img-slot" style="display:none;margin-top:8px;">
                                                    <span class="hint">Chưa có ảnh</span>
                                                </div>
                                                <img id="preview" class="thumb" style="display:block;margin-top:8px;"
                                                     src="${pageContext.request.contextPath}/${post.image_url}" alt="Ảnh hiện tại"/>
                                            </c:when>
                                            <c:otherwise>
                                                <div id="placeholder" class="img-slot" style="margin-top:8px;">
                                                    <span class="hint">Chưa có ảnh</span>
                                                </div>
                                                <img id="preview" class="thumb" style="margin-top:8px;" alt="Preview"/>
                                            </c:otherwise>
                                        </c:choose>

                                        <c:if test="${not empty post}">
                                            <div style="display:flex;gap:8px;margin-top:10px;">
                                                <button type="button" class="btn danger" onclick="deleteCover('${post.id}')">Xoá ảnh</button>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </section>

                        <!-- Actions -->
                        <div class="actions">
                            <button class="btn primary" type="submit">${empty post ? 'Thêm bài viết' : 'Cập nhật bài viết'}</button>
                            <button class="btn line" type="reset">Làm mới</button>
                            <a class="btn ghost" href="MainController?action=searchPosts">Hủy</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <jsp:include page="footer.jsp"/>

        <!-- TinyMCE -->
        <script src="https://cdn.tiny.cloud/1/9q1kybnxbgq2f5l3c8palpboawfgsnqsdd53b7gk5ny3dh19/tinymce/6/tinymce.min.js" referrerpolicy="origin"></script>
        <script>
                                                    tinymce.init({
                                                        selector: '#editor',
                                                        height: 600,
                                                        plugins: 'image link lists table code media autoresize',
                                                        toolbar: 'undo redo | bold italic underline | alignleft aligncenter alignright | bullist numlist | link image media | table | code',
                                                        menubar: 'file edit view insert format tools table help',
                                                        automatic_uploads: true,
                                                        file_picker_types: 'file image media',
                                                        file_picker_callback: function (callback, value, meta) {
                                                            const input = document.createElement('input');
                                                            input.type = 'file';
                                                            if (meta.filetype === 'image')
                                                                input.accept = 'image/*';
                                                            else if (meta.filetype === 'media')
                                                                input.accept = 'video/mp4';
                                                            input.onchange = function () {
                                                                const file = this.files[0];
                                                                const fd = new FormData();
                                                                fd.append('file', file);
                                                                let url = '${pageContext.request.contextPath}/UploadImageController';
                                                                if (meta.filetype === 'media')
                                                                    url = '${pageContext.request.contextPath}/UploadVideoController';
                                                                fetch(url, {method: 'POST', body: fd})
                                                                        .then(r => r.json())
                                                                        .then(json => callback(json.location));
                                                            };
                                                            input.click();
                                                        }
                                                    });

                                                    // ==== Preview ảnh: Ẩn/hiện placeholder đúng cách ====
                                                    (function () {
                                                        const input = document.getElementById('imageFile');
                                                        const img = document.getElementById('preview');
                                                        const placeholder = document.getElementById('placeholder');
                                                        const form = document.getElementById('postForm');

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

                                                        // Khi chọn file
                                                        input.addEventListener('change', function () {
                                                            const file = this.files && this.files[0];

                                                            if (lastURL) {
                                                                URL.revokeObjectURL(lastURL);
                                                                lastURL = null;
                                                            }

                                                            if (file) {
                                                                const url = URL.createObjectURL(file);
                                                                lastURL = url;
                                                                showImage(url);
                                                            } else {
                                                                // Không chọn file -> nếu đã có ảnh cũ thì giữ, không thì hiện placeholder
                                                                if (!img.getAttribute('src'))
                                                                    showPlaceholder();
                                                                else {
                                                                    placeholder.style.display = 'none';
                                                                    img.style.display = 'block';
                                                                }
                                                            }
                                                        });

                                                        // Khi reset form -> về lại trạng thái ban đầu
                                                        form.addEventListener('reset', function () {
                                                            setTimeout(() => {
                                                                if (${empty post || empty post.image_url ? 'true' : 'false'}) {
                                                                    if (lastURL) {
                                                                        URL.revokeObjectURL(lastURL);
                                                                        lastURL = null;
                                                                    }
                                                                    showPlaceholder();
                                                                } else {
                                                                    placeholder.style.display = 'none';
                                                                    img.style.display = 'block';
                                                                    img.src = '${pageContext.request.contextPath}/${post.image_url}';
                                                                                    }
                                                                                }, 0);
                                                                            });

                                                                            window.addEventListener('beforeunload', () => {
                                                                                if (lastURL)
                                                                                    URL.revokeObjectURL(lastURL);
                                                                            });
                                                                        })();

                                                                        // Xoá ảnh đại diện
                                                                        function deleteCover(postId) {
                                                                            if (!confirm('Xoá ảnh đại diện của bài viết #' + postId + '?'))
                                                                                return;
                                                                            fetch('MainController?action=deleteImagePost', {
                                                                                method: 'POST',
                                                                                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                                                                                body: 'id=' + encodeURIComponent(postId)
                                                                            })
                                                                                    .then(r => r.text())
                                                                                    .then(() => location.reload())
                                                                                    .catch(() => alert('Có lỗi xảy ra khi xoá ảnh.'));
                                                                        }
        </script>
    </body>
</html>
