<%-- 
    Document   : modelUpdate
    Created on : Sep 14, 2025, 
    Author     : ddhuy
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:setLocale value="vi_VN" />

<!DOCTYPE html>
<html lang="vi">
    <head>

        <meta charset="UTF-8">
        <title>SHOP GAME VIỆT 38 — Quản lý model</title>
        <%@ include file="/WEB-INF/jspf/head.jspf" %>

        <!-- Swiper CSS -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css"/>

        <!-- App CSS -->
        <link rel="stylesheet" href="assets/css/maincss.css"/>

        <style>
            /* Utilities matching product style */
            .page-title {
                font-weight: 700;
                letter-spacing: .2px;
            }
            .wrapper {
                display: grid;
                grid-template-columns: 260px 1fr;
                min-height: 100vh;
            }
            .sidebar {
                background: #111827;
            }
            .Main_content {
                background: #f5f7fb;
            }

            .section {
                background: #fff;
                border: 1px solid #e5e7eb;
                border-radius: 14px;
            }
            .section .section-hd {
                padding: 14px 16px;
                border-bottom: 1px solid #e5e7eb;
                font-weight: 600;
                background:#f9fafb;
            }
            .section .section-bd {
                padding: 16px;
            }

            .grid {
                display: grid;
                gap: 12px;
            }
            .grid-2 {
                grid-template-columns: repeat(2, minmax(0,1fr));
            }
            .grid-3 {
                grid-template-columns: repeat(3, minmax(0,1fr));
            }

            .field {
                display:flex;
                flex-direction:column;
                gap:6px;
            }
            .label {
                font-weight:600;
            }
            .required::after {
                content:" *";
                color:#dc2626;
            }
            .hint {
                font-size:.875rem;
                color:#6b7280;
            }
            .input, .select, .textarea, .file {
                border:1px solid #d1d5db;
                border-radius:10px;
                padding:10px 12px;
                background:#fff;
                outline:none;
                transition: border-color 0.2s ease, box-shadow 0.2s ease;
            }
            .input:focus, .select:focus, .textarea:focus, .file:focus {
                border-color: #1d4ed8;
                box-shadow: 0 0 0 3px rgba(29, 78, 216, 0.1);
            }
            .textarea {
                min-height: 160px;
                resize: vertical;
            }

            .actions {
                position: sticky;
                bottom: 0;
                background:#fff;
                border-top:1px solid #e5e7eb;
                padding:12px;
                display:flex;
                justify-content:flex-end;
                gap:8px;
            }
            .btn {
                border:1px solid transparent;
                padding:10px 14px;
                border-radius:10px;
                cursor:pointer;
                font-weight:600;
                text-decoration: none;
                display: inline-block;
                transition: all 0.2s ease;
            }
            .btn.primary {
                background:#1d4ed8;
                color:#fff;
            }
            .btn.primary:hover {
                background:#1e40af;
                transform: translateY(-1px);
            }
            .btn.ghost {
                background:#fff;
                border-color:#6b7280;
                color:#374151;
            }
            .btn.ghost:hover {
                background:#f3f4f6;
                border-color:#4b5563;
            }

            .badge-soft {
                background:#eef2ff;
                color:#3b5bdb;
                padding:4px 10px;
                border-radius:999px;
                font-size:.85rem;
            }

            .toast-stack {
                position:fixed;
                top:12px;
                right:12px;
                display:flex;
                flex-direction:column;
                gap:8px;
                z-index:1080;
            }
            .toast {
                padding:12px 14px;
                border-radius:12px;
                box-shadow:0 6px 20px rgba(0,0,0,.08);
                display:flex;
                align-items:center;
                gap:10px;
                opacity: 0;
                transform: translateX(100%);
                animation: slideIn 0.3s ease forwards;
            }
            .toast.success {
                background:#ecfdf5;
                color:#065f46;
                border:1px solid #a7f3d0;
            }
            .toast.error {
                background:#fef2f2;
                color:#991b1b;
                border:1px solid #fecaca;
            }
            .toast.fade-out {
                animation: slideOut 0.3s ease forwards;
            }

            @keyframes slideIn {
                to {
                    opacity: 1;
                    transform: translateX(0);
                }
            }
            @keyframes slideOut {
                to {
                    opacity: 0;
                    transform: translateX(100%);
                }
            }

            .current-image {
                background:#f9fafb;
                border:1px solid #e5e7eb;
                border-radius:12px;
                padding:12px;
                text-align:center;
                margin-bottom:12px;
            }
            .current-image img {
                max-width: 200px;
                max-height: 200px;
                border-radius: 10px;
                object-fit: cover;
                border: 2px solid #e5e7eb;
            }
            .current-image-info {
                margin-top: 8px;
                font-size: 0.875rem;
                color: #6b7280;
            }

            .image-preview {
                max-width: 200px;
                max-height: 200px;
                border-radius: 10px;
                border: 2px dashed #d1d5db;
                object-fit: cover;
                margin-top: 10px;
                animation: fadeIn 0.3s ease;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: scale(0.9);
                }
                to {
                    opacity: 1;
                    transform: scale(1);
                }
            }

            .breadcrumbs {
                display:flex;
                gap:8px;
                font-size:.95rem;
                color:#6b7280;
                margin-bottom:8px;
            }
            .breadcrumbs a {
                color:inherit;
                text-decoration:none;
            }
            .breadcrumbs .sep {
                color:#9ca3af;
            }

            .info-section {
                background:#f8fafc;
                border:1px solid #e2e8f0;
                border-radius:10px;
                padding:12px;
                margin-bottom:12px;
            }
            .info-row {
                display:flex;
                justify-content:space-between;
                align-items:center;
                padding:4px 0;
            }
            .info-label {
                font-weight:600;
                color:#374151;
            }
            .info-value {
                color:#6b7280;
            }
            /* ==== Mobile trigger ==== */
            .btn.icon.only {
                padding: 8px 10px;
                border-radius: 10px;
            }
            .mobile-toggle {
                display: none;
            }

            /* ===== ≤1024px: sidebar off-canvas + form 1 cột ===== */
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

                /* Form từ 2–3 cột -> 1 cột, đệm nhỏ hơn */
                .grid-2, .grid-3 {
                    grid-template-columns: 1fr;
                }
                .container {
                    padding: 12px;
                }
                .section .section-hd, .section .section-bd {
                    padding: 12px;
                }

                /* Ảnh/preview co giãn đầy đủ chiều ngang */
                .current-image img, .image-preview {
                    max-width: 100%;
                    height: auto;
                }

                /* Tránh grid/flex bóp chiều cao con (hữu ích cho editor/ô nhập) */
                .grid, .section-bd, .field {
                    min-height: 0;
                }
            }

            /* ===== ≤768px: giảm cỡ chữ & padding ===== */
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

            /* ===== ≤480px: actions stack full-width ===== */
            @media (max-width: 480px) {
                .actions {
                    flex-wrap: wrap;
                    justify-content: stretch;
                    gap: 6px;
                }
                .actions .btn {
                    flex: 1 1 auto;
                }
                .container {
                    padding: 10px 8px;
                }
            }
            @media (max-width: 1024px) {
                .grid-2, .grid-3 {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>
    <body>
        <!-- Toast notifications với auto-hide sau 5s -->
        <div class="toast-stack">
            <c:if test="${not empty messageAddModel}">
                <div class="toast success" data-auto-hide="true">${messageAddModel}</div>
            </c:if>
            <c:if test="${not empty messageEditModel}">
                <div class="toast success" data-auto-hide="true">${messageEditModel}</div>
            </c:if>
            <c:if test="${not empty checkErrorAddModel}">
                <div class="toast error" data-auto-hide="true">${checkErrorAddModel}</div>
            </c:if>
            <c:if test="${not empty checkErrorEditModel}">
                <div class="toast error" data-auto-hide="true">${checkErrorEditModel}</div>
            </c:if>
            <c:if test="${not empty checkErrorModelDetail}">
                <div class="toast error" data-auto-hide="true">${checkErrorModelDetail}</div>
            </c:if>
        </div>

        <div class="wrapper">
            <!-- Sidebar -->
            <div class="sidebar">
                <jsp:include page="sidebar.jsp"/>
            </div>

            <div class="Main_content">
                <!-- Header -->
                <jsp:include page="header.jsp"/>

                <div class="container">
                    <div style="display:flex; align-items:center; justify-content:space-between; margin-bottom:12px; gap:12px; flex-wrap:wrap;">
                        <div>
                            <div class="breadcrumbs">
                                <a href="MainController?action=viewModelList">Models</a><span class="sep">›</span>
                                <span>${empty model ? 'Thêm' : 'Chỉnh sửa'}</span>
                            </div><br>
                            <h2 class="page-title" style="margin:0;">
                                <c:choose>
                                    <c:when test="${not empty model && model.id > 0}">Chỉnh sửa model</c:when>
                                    <c:otherwise>Thêm model mới</c:otherwise>
                                </c:choose>
                                <span class="badge-soft" style="margin-left:8px;">Model Management</span>
                            </h2>
                        </div>
                        <a href="MainController?action=viewModelList" class="btn ghost">Quay lại danh sách</a>
                    </div>

                    <!-- Main Form -->
                    <section class="section">
                        <div class="section-hd">Thông tin model</div>
                        <div class="section-bd">
                            <form id="modelForm" action="MainController" method="post" enctype="multipart/form-data">
                                <c:choose>
                                    <c:when test="${not empty model && model.id > 0}">
                                        <input type="hidden" name="action" value="editModel">
                                        <input type="hidden" name="id" value="${model.id}">
                                    </c:when>
                                    <c:otherwise>
                                        <input type="hidden" name="action" value="addModel">
                                    </c:otherwise>
                                </c:choose>

                                <div class="grid grid-2">
                                    <div class="field">
                                        <label class="label required">Tên Model</label>
                                        <input class="input" type="text" name="model_type" 
                                               value="${not empty model ? model.model_type : ''}" 
                                               placeholder="VD: PlayStation 5 (PS5), Sega Genesis Mini,... " 
                                               required maxlength="100">
                                        <div class="hint">Tên duy nhất cho model này (tối đa 100 ký tự)</div>
                                    </div>

                                    <div class="field">
                                        <label class="label required">Trạng thái</label>
                                        <select class="select" name="status" required>
                                            <option value="active" ${(empty model || model.status == 'active') ? 'selected' : ''}>Hoạt động</option>
                                            <option value="inactive" ${model.status == 'inactive' ? 'selected' : ''}>Ngưng hoạt động</option>
                                        </select>
                                        <div class="hint">Chỉ model active mới hiển thị trong danh sách sản phẩm</div>
                                    </div>

                                    <div class="field" style="grid-column:1 / -1;">
                                        <label class="label">Mô tả (HTML)</label>
                                        <textarea id="editor" name="description_html" class="textarea" 
                                                  placeholder="Nhập mô tả chi tiết về model. Hỗ trợ HTML để định dạng.">${not empty model ? model.description_html : ''}</textarea>
                                        <div class="hint">Mô tả chi tiết (hỗ trợ HTML, tối đa 10,000 ký tự)</div>
                                    </div>
                                </div>

                                <!-- Current Image Display (Edit Mode) -->
                                <c:if test="${not empty model && not empty model.image_url}">
                                    <div class="section" style="margin-top:12px;">
                                        <div class="section-hd">Ảnh hiện tại</div>
                                        <div class="section-bd">
                                            <div class="current-image">
                                                <img src="${model.image_url}" alt="Current Model Image">
                                                <div class="current-image-info">
                                                    File: ${fn:substringAfter(model.image_url, '/')}
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>

                                <!-- Image Upload Section -->
                                <div class="section" style="margin-top:12px;">
                                    <div class="section-hd">
                                        <c:choose>
                                            <c:when test="${not empty model && not empty model.image_url}">Cập nhật ảnh mới</c:when>
                                            <c:otherwise>Tải ảnh lên</c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="section-bd">
                                        <div class="field">
                                            <label class="label">Chọn ảnh</label>
                                            <input class="file" type="file" id="imageFile" name="imageFile" 
                                                   accept="image/*" onchange="previewImage(this)">
                                            <div class="hint">
                                                Định dạng hỗ trợ: JPG, JPEG, PNG, GIF, BMP, WEBP | Dung lượng tối đa: 5MB
                                                <c:if test="${not empty model && not empty model.image_url}">
                                                    <br><strong>Để trống nếu muốn giữ ảnh hiện tại</strong>
                                                </c:if>
                                            </div>
                                            <div id="imagePreview"></div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Info Section for Edit Mode -->
                                <c:if test="${not empty model && model.id > 0}">
                                    <div class="section" style="margin-top:12px;">
                                        <div class="section-hd">Thông tin hệ thống</div>
                                        <div class="section-bd">
                                            <div class="info-section">
                                                <div class="info-row">
                                                    <span class="info-label">ID Model:</span>
                                                    <span class="info-value">#${model.id}</span>
                                                </div>
                                                <div class="info-row">
                                                    <span class="info-label">Ngày tạo:</span>
                                                    <span class="info-value"><fmt:formatDate value="${model.created_at}" pattern="dd/MM/yyyy HH:mm:ss"/></span>
                                                </div>
                                                <c:if test="${not empty model.updated_at}">
                                                    <div class="info-row">
                                                        <span class="info-label">Cập nhật cuối:</span>
                                                        <span class="info-value"><fmt:formatDate value="${model.updated_at}" pattern="dd/MM/yyyy HH:mm:ss"/></span>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>

                                <div class="actions">
                                    <button class="btn primary" type="submit">
                                        <c:choose>
                                            <c:when test="${not empty model && model.id > 0}">Cập nhật Model</c:when>
                                            <c:otherwise>Tạo Model</c:otherwise>
                                        </c:choose>
                                    </button>
                                    <a class="btn ghost" href="MainController?action=viewModelList">Hủy</a>
                                </div>
                            </form>
                        </div>
                    </section>
                </div>
            </div>
        </div>

        <jsp:include page="footer.jsp"/>

        <!-- Swiper JS -->
        <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>

        <!-- TinyMCE -->
        <script src="https://cdn.tiny.cloud/1/9q1kybnxbgq2f5l3c8palpboawfgsnqsdd53b7gk5ny3dh19/tinymce/6/tinymce.min.js" referrerpolicy="origin"></script>

        <script>
                                                       // Auto-hide toast messages sau 5 giây
                                                       document.addEventListener('DOMContentLoaded', function () {
                                                           const toasts = document.querySelectorAll('.toast[data-auto-hide="true"]');
                                                           toasts.forEach(function (toast) {
                                                               setTimeout(function () {
                                                                   toast.classList.add('fade-out');
                                                                   setTimeout(function () {
                                                                       toast.remove();
                                                                   }, 300);
                                                               }, 5000); // 5 seconds
                                                           });
                                                       });

                                                       // Image preview function (matching product style với animation)
                                                       function previewImage(input) {
                                                           const preview = document.getElementById('imagePreview');
                                                           preview.innerHTML = '';

                                                           if (input.files && input.files[0]) {
                                                               const reader = new FileReader();
                                                               reader.onload = function (e) {
                                                                   const img = document.createElement('img');
                                                                   img.src = e.target.result;
                                                                   img.className = 'image-preview';
                                                                   img.alt = 'Preview ảnh mới';
                                                                   preview.appendChild(img);
                                                               }
                                                               reader.readAsDataURL(input.files[0]);
                                                           }
                                                       }

                                                       // TinyMCE init 
                                                       tinymce.init({
                                                           selector: '#editor',
                                                           height: 600,
                                                           plugins: 'image link lists table code media autoresize',
                                                           toolbar: 'undo redo | bold italic underline | alignleft aligncenter alignright | bullist numlist | link image media | table | code',
                                                           menubar: 'file edit view insert format tools table help',
                                                           automatic_uploads: true,
                                                           file_picker_types: 'file image media',
                                                           file_picker_callback: function (callback, value, meta) {
                                                               let input = document.createElement('input');
                                                               input.type = 'file';
                                                               if (meta.filetype === 'image')
                                                                   input.accept = 'image/*';
                                                               else if (meta.filetype === 'media')
                                                                   input.accept = 'video/mp4';
                                                               input.onchange = function () {
                                                                   let file = this.files[0];
                                                                   let formData = new FormData();
                                                                   formData.append('file', file);
                                                                   let uploadUrl = '${pageContext.request.contextPath}/UploadImageController';
                                                                   if (meta.filetype === 'media')
                                                                       uploadUrl = '${pageContext.request.contextPath}/UploadVideoController';
                                                                   fetch(uploadUrl, {method: 'POST', body: formData})
                                                                           .then(response => response.json())
                                                                           .then(json => callback(json.location));
                                                               };
                                                               input.click();
                                                           }
                                                       });

                                                       // Form validation
                                                       document.getElementById('modelForm').addEventListener('submit', function (e) {
                                                           const modelType = document.querySelector('input[name="model_type"]').value.trim();

                                                           if (!modelType) {
                                                               alert('Tên model là bắt buộc.');
                                                               e.preventDefault();
                                                               return;
                                                           }

                                                           if (modelType.length > 100) {
                                                               alert('Tên model không được vượt quá 100 ký tự.');
                                                               e.preventDefault();
                                                               return;
                                                           }
                                                       });
        </script>
    </body>
</html>