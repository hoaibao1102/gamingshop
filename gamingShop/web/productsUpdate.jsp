<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:setLocale value="vi_VN" />

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Gaming Shop — Quản lý sản phẩm</title>

        <!-- Swiper CSS (nếu cần dùng cho UI khác) -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css"/>

        <!-- App CSS (đồng bộ tông với trang chủ) -->
        <link rel="stylesheet" href="assets/css/maincss.css"/>

        <style>
            /* Các tiện ích nhỏ phù hợp với maincss.css */
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
            .grid-4 {
                grid-template-columns: repeat(4, minmax(0,1fr));
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
            }
            .textarea {
                min-height: 160px;
            }

            .tabs {
                display:flex;
                gap:8px;
                margin-bottom:16px;
            }
            .tab-btn {
                padding:10px 12px;
                border-radius:10px;
                border:1px solid #e5e7eb;
                background:#fff;
                cursor:pointer;
                font-weight:600;
            }
            .tab-btn.active {
                background:#111827;
                color:#fff;
                border-color:#111827;
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
            }
            .btn.primary {
                background:#1d4ed8;
                color:#fde68a;
            }
            .btn.ghost {
                background:#fff;
                border-color:#6b7280;
                color:#374151;
            }
            .btn.ghost:hover {
                background:#ef4444;
                border-color:#ef4444;
                color:#fff;
            }
            .btn.warn {
                background:#f59e0b;
                color:#111827;
            }
            .btn.danger {
                background:#ef4444;
                color:#fff;
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

            .img-slot {
                min-height:200px;
                display:flex;
                align-items:center;
                justify-content:center;
                background:#f3f4f6;
                border:1px dashed #d1d5db;
                border-radius:12px;
            }
            .thumb {
                max-width: 200px;
                height: auto;
                border-radius: 10px;
            }

            /* Pills cho điều hướng nhỏ */
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

            .btn.danger {
                background-color: #fff;   /* nền trắng */
                color: #000;              /* chữ đen */
                border: 1px solid #dc3545; /* viền đỏ cho rõ nút */
                transition: all 0.3s ease; /* hiệu ứng mượt */
            }

            .btn.danger:hover {
                background-color: #dc3545; /* nền đỏ */
                color: #fff;               /* chữ trắng */
            }
            @media (max-width: 1024px) {
                .grid-3 {
                    grid-template-columns: 1fr;
                }
                .grid-4 {
                    grid-template-columns: 1fr 1fr;
                }
            }
            @media (max-width: 640px) {
                .grid-2, .grid-4 {
                    grid-template-columns: 1fr;
                }
            }

            /* ==== Make image slots equal-sized & aligned ==== */
            #tab-images .field {
                background:#fff;
                border:1px solid #e5e7eb;
                border-radius:12px;
                padding:12px;
                display:flex;
                flex-direction:column;
                gap:10px;
                height:100%;
            }
            .grid-4 {
                align-items: stretch;
            }
            #tab-images .thumb {
                width:100%;
                aspect-ratio: 4 / 3;
                object-fit: cover;
                border-radius:10px;
            }
            #tab-images .img-slot {
                width:100%;
                aspect-ratio: 4 / 3;
                display:flex;
                align-items:center;
                justify-content:center;
                background:#f3f4f6;
                border:1px dashed #d1d5db;
                border-radius:12px;
            }
            #tab-images .btn {
                width:100%;
            }
            #tab-images .file {
                width:100%;
            }
        </style>
    </head>
    <body>
        <!-- ======= Toast thông báo ======= -->
        <div class="toast-stack">
            <c:if test="${not empty messageAddProduct}">
                <div class="toast success">${messageAddProduct}</div>
            </c:if>
            <c:if test="${not empty messageEditProduct}">
                <div class="toast success">${messageEditProduct}</div>
            </c:if>
            <c:if test="${not empty messageUpdateProductMain}">
                <div class="toast success">${messageUpdateProductMain}</div>
            </c:if>
            <c:if test="${not empty messageUpdateProductImage}">
                <div class="toast success">${messageUpdateProductImage}</div>
            </c:if>
            <c:if test="${not empty messageDeleteImg}">
                <div class="toast success">${messageDeleteImg}</div>
            </c:if>

            <c:if test="${not empty checkErrorAddProduct}">
                <div class="toast error">${checkErrorAddProduct}</div>
            </c:if>
            <c:if test="${not empty checkErrorEditProduct}">
                <div class="toast error">${checkErrorEditProduct}</div>
            </c:if>
            <c:if test="${not empty checkErrorUpdateProductMain}">
                <div class="toast error">${checkErrorUpdateProductMain}</div>
            </c:if>
            <c:if test="${not empty checkErrorUpdateProductImage}">
                <div class="toast error">${checkErrorUpdateProductImage}</div>
            </c:if>
            <c:if test="${not empty checkErrorDeleteImg}">
                <div class="toast error">${checkErrorDeleteImg}</div>
            </c:if>
        </div>

        <div class="wrapper">
            <!-- Sidebar (dùng lại từ trang chủ) -->
            <div class="sidebar">
                <jsp:include page="sidebar.jsp"/>
            </div>

            <div class="Main_content">
                <!-- Header (dùng lại từ trang chủ) -->
                <jsp:include page="header.jsp"/>

                <div class="container">
                    <div style="display:flex; align-items:center; justify-content:space-between; margin-bottom:12px; gap:12px; flex-wrap:wrap;">
                        <h2 class="page-title" style="margin:0;">
                            <c:choose>
                                <c:when test="${not empty product}">Chỉnh sửa sản phẩm</c:when>
                                <c:otherwise>Thêm sản phẩm mới</c:otherwise>
                            </c:choose>
                            <span class="badge-soft" style="margin-left:8px;">Product Management</span>
                        </h2>

                        <form action="MainController" method="post" autocomplete="off">
                            <input type="hidden" name="action" value="searchProduct"/>
                            <button class="btn ghost" type="submit">Quay lại danh sách</button>
                        </form>
                    </div>

                    <!-- Tabs -->
                    <div class="tabs" role="tablist">
                        <button class="tab-btn active" data-tab-target="#tab-main" aria-selected="true">Thông tin chính</button>
                        <c:if test="${not empty product}">
                            <button class="tab-btn" data-tab-target="#tab-images" aria-selected="false">Ảnh sản phẩm</button>
                        </c:if>
                    </div>

                    <div class="tab-panels">
                        <!-- ===== TAB: MAIN ===== -->
                        <section id="tab-main" class="section" role="tabpanel" aria-labelledby="main-tab">
                            <div class="section-hd">Thông tin sản phẩm</div>
                            <div class="section-bd">
                                <form id="mainForm" action="MainController" method="post" enctype="multipart/form-data">
                                    <input type="hidden" name="action" value="${not empty product ? 'editMainProduct' : 'addProduct'}"/>
                                    <c:if test="${not empty product}">
                                        <input type="hidden" name="product_id" value="${product.id}"/>
                                    </c:if>

                                    <div class="grid grid-2">
                                        <div class="field">
                                            <label class="label required">Tên sản phẩm</label>
                                            <input class="input" type="text" name="name" value="${not empty product ? product.name : ''}" required>
                                            <div class="hint">Tên hiển thị cho khách hàng.</div>
                                        </div>

                                        <div class="field">
                                            <label class="label required">SKU</label>
                                            <input class="input" type="text" name="sku" value="${not empty product ? product.sku : ''}" required>
                                        </div>

                                        <div class="field">
                                            <label class="label required">Giá bán</label>
                                            <div style="display:flex; gap:8px; align-items:center;">
                                                <input class="input" type="number" step="0.01" min="0" name="price" value="${not empty product ? product.price : ''}" required style="flex:1;">
                                                <span style="color:#6b7280; font-weight:600;">VND</span>
                                            </div>
                                            <div class="hint">Nhập số nguyên, hệ thống sẽ format khi hiển thị.</div>
                                        </div>

                                        <div class="field">
                                            <label class="label required">Số lượng</label>
                                            <input class="input" type="number" min="0" name="quantity" value="${not empty product ? product.quantity : ''}" required>
                                        </div>

                                        <div class="field">
                                            <label class="label required">Loại hàng</label>
                                            <select class="select" name="product_type" required>
                                                <option value="new" ${not empty product && product.product_type == 'new' ? 'selected' : ''}>Hàng mới</option>
                                                <option value="used" ${not empty product && (product.product_type == 'used' || product.product_type == 'old') ? 'selected' : ''}>Hàng đã qua sử dụng</option>
                                            </select>
                                        </div>

                                        <div class="field">
                                            <label class="label required">Model</label>
                                            <select class="select" name="model_id" required>
                                                <c:forEach var="m" items="${modelTypes}">
                                                    <option value="${m.id}" ${not empty product && m.id == product.model_id ? 'selected' : ''}>${m.model_type}</option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <div class="field">
                                            <label class="label">Bộ nhớ</label>
                                            <select class="select" name="memory_id">
                                                <c:forEach var="mem" items="${memoryTypes}">
                                                    <option value="${mem.id}" ${not empty product && mem.id == product.memory_id ? 'selected' : ''}>${mem.memory_type}</option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <div class="field">
                                            <label class="label">Bảo hành</label>
                                            <select class="select" name="guarantee_id">
                                                <c:forEach var="g" items="${guaranteeTypes}">
                                                    <option value="${g.id}" ${not empty product && g.id == product.guarantee_id ? 'selected' : ''}>${g.guarantee_type}</option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <div class="field" style="grid-column:1 / -1;">
                                            <label class="label">Thông số / Mô tả (HTML)</label>
                                            <textarea id="editor" name="spec_html" class="textarea">${not empty product ? product.description_html : ''}</textarea>
                                            <div class="hint">Bạn có thể chèn ảnh/video trực tiếp (TinyMCE).</div>
                                        </div>

                                        <div class="field">
                                            <label class="label required">Trạng thái</label>
                                            <select class="select" name="status">
                                                <option value="active" ${not empty product && product.status == 'active' ? 'selected' : ''}>Hoạt động</option>
                                                <option value="inactive" ${not empty product && product.status == 'inactive' ? 'selected' : ''}>Ngừng hoạt động</option>
                                                <option value="prominent" ${not empty product && product.status == 'prominent' ? 'selected' : ''}>Nổi bật sản phẩm</option>
                                            </select>
                                        </div>

                                        <div class="section" style="margin-top:16px;">
                                            <div class="section-hd">Phụ kiện tặng kèm</div>
                                            <div class="section-bd">
                                                <div class="grid grid-2">
                                                    <c:forEach var="acc" items="${giftAccessories}">
                                                        <div class="field" style="border:1px solid #e5e7eb; border-radius:10px; padding:10px;">
                                                            <label class="label">
                                                                <input type="checkbox" name="accessoryIds" value="${acc.id}"/>
                                                                ${acc.name}
                                                            </label>
                                                            <input class="input" type="number" name="accessoryQty_${acc.id}" min="1" value="1"/>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                                <div class="hint">Chọn phụ kiện tặng kèm cho sản phẩm này.</div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Ảnh khi thêm mới -->
                                    <div class="section" style="margin-top:12px;">
                                        <div class="section-hd">${empty product ? 'Ảnh sản phẩm' : ''}</div>
                                        <div class="section-bd">
                                            <c:choose>
                                                <c:when test="${empty product}">
                                                    <p class="hint">Tối đa 4 ảnh. Ảnh đầu tiên sẽ làm ảnh bìa.</p>
                                                    <div class="grid grid-4">
                                                        <div class="field">
                                                            <label class="label">Ảnh 1</label>
                                                            <input class="file" type="file" name="imageFile1" id="imageFile1" accept="image/*"/>
                                                            <img id="preview1" class="thumb" style="display:none; margin-top:8px;" alt="Preview 1"/>
                                                        </div>
                                                        <div class="field">
                                                            <label class="label">Ảnh 2</label>
                                                            <input class="file" type="file" name="imageFile2" id="imageFile2" accept="image/*"/>
                                                            <img id="preview2" class="thumb" style="display:none; margin-top:8px;" alt="Preview 2"/>
                                                        </div>
                                                        <div class="field">
                                                            <label class="label">Ảnh 3</label>
                                                            <input class="file" type="file" name="imageFile3" id="imageFile3" accept="image/*"/>
                                                            <img id="preview3" class="thumb" style="display:none; margin-top:8px;" alt="Preview 3"/>
                                                        </div>
                                                        <div class="field">
                                                            <label class="label">Ảnh 4</label>
                                                            <input class="file" type="file" name="imageFile4" id="imageFile4" accept="image/*"/>
                                                            <img id="preview4" class="thumb" style="display:none; margin-top:8px;" alt="Preview 4"/>
                                                        </div>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:choose>
                                                        <c:when test="${empty productImages}">
                                                            <p class="hint">Ảnh hiện tại:</p>
                                                            <div style="display:flex; flex-wrap:wrap; gap:10px; justify-content:center;">
                                                                <c:forEach var="img" items="${productImages}">
                                                                    <img class="thumb" src="${pageContext.request.contextPath}/${img.image_url}" alt="${product.name}"/>
                                                                </c:forEach>
                                                            </div>
                                                        </c:when>
                                                        <c:when test="${empty productImages}">
                                                            <p class="hint">Sản phẩm chưa có ảnh.</p>
                                                        </c:when>
                                                    </c:choose>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <div class="actions">
                                        <button class="btn primary" type="submit">
                                            <c:choose><c:when test="${not empty product}">Cập nhật sản phẩm</c:when><c:otherwise>Thêm sản phẩm</c:otherwise></c:choose>
                                                </button>
                                                <a class="btn ghost" href="MainController?action=searchProduct">Hủy</a>
                                            </div>
                                        </form>
                                    </div>
                                </section>

                                <!-- ===== TAB: IMAGES ===== -->
                        <c:if test="${not empty product}">
                            <section id="tab-images" class="section" role="tabpanel" aria-labelledby="images-tab" hidden>
                                <div class="section-hd">Quản lý ảnh (4 slot — cập nhật đồng loạt)</div>
                                <div class="section-bd">
                                    <form id="imagesForm" action="MainController" method="post" enctype="multipart/form-data" class="p-2">
                                        <input type="hidden" name="action" value="editImageProduct"/>
                                        <input type="hidden" name="product_id" value="${product.id}"/>
                                        <input type="hidden" name="deleteImgId" id="deleteImgId"/>

                                        <div class="grid grid-4">
                                            <c:forEach var="slot" begin="1" end="4">
                                                <div class="field" style="text-align:center;">
                                                    <div class="hint">Slot ${slot}</div>

                                                    <!-- Tìm ảnh phù hợp slot -->
                                                    <c:set var="slotImg" value=""/>
                                                    <c:forEach var="im" items="${productImages}">
                                                        <c:if test="${im.sort_order == slot}">
                                                            <c:set var="slotImg" value="${im}"/>
                                                        </c:if>
                                                    </c:forEach>

                                                    <c:choose>
                                                        <c:when test="${not empty slotImg}">
                                                            <img id="preview${slot}_old" class="thumb" style="margin-bottom:8px;" src="${pageContext.request.contextPath}/${slotImg.image_url}" alt="Slot ${slot}"/>
                                                            <div style="display:grid; gap:8px; margin-bottom:8px;">
                                                                <button class="btn danger" type="button" onclick="deleteImage('${slotImg.id}', '${product.id}')">Xóa ảnh</button>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="img-slot" style="margin-bottom:8px;">
                                                                <span class="hint">Chưa có ảnh</span>
                                                            </div>
                                                            <img id="preview${slot}_old" class="thumb" style="display:none;"/>
                                                        </c:otherwise>
                                                    </c:choose>

                                                    <input class="file" type="file" id="imageFile${slot}" name="imageFile${slot}" accept="image/*"/>
                                                    <img id="preview${slot}" class="thumb" style="display:none; margin-top:8px;"/>
                                                </div>
                                            </c:forEach>
                                        </div>

                                        <div style="text-align:center; margin-top:16px;">
                                            <button class="btn warn" type="submit" 
                                                    style="width:auto; padding:8px 20px; font-size:14px; border-radius:8px;">
                                                Cập nhật ảnh
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </section>
                        </c:if>
                    </div>
                </div>


            </div>
        </div>
        <jsp:include page="footer.jsp"/>
        <!-- Swiper JS (nếu dùng nơi khác) -->
        <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>

        <!-- TinyMCE -->
        <script src="https://cdn.tiny.cloud/1/9q1kybnxbgq2f5l3c8palpboawfgsnqsdd53b7gk5ny3dh19/tinymce/6/tinymce.min.js" referrerpolicy="origin"></script>

        <script>
                                                                    // Tabs logic (thuần JS, không phụ thuộc Bootstrap)
                                                                    const tabButtons = document.querySelectorAll('.tab-btn');
                                                                    const panels = document.querySelectorAll('[role="tabpanel"]');
                                                                    tabButtons.forEach(btn => {
                                                                        btn.addEventListener('click', () => {
                                                                            tabButtons.forEach(b => b.classList.remove('active'));
                                                                            btn.classList.add('active');
                                                                            const target = btn.getAttribute('data-tab-target');
                                                                            panels.forEach(p => {
                                                                                if ('#' + p.id === target) {
                                                                                    p.hidden = false;
                                                                                } else {
                                                                                    p.hidden = true;
                                                                                }
                                                                            });
                                                                        });
                                                                    });

                                                                    // Preview hình ảnh cho input file
                                                                    function bindPreview(inputId, imgId) {
                                                                        const input = document.getElementById(inputId);
                                                                        const img = document.getElementById(imgId);
                                                                        let lastURL = null;
                                                                        if (!input || !img)
                                                                            return;
                                                                        input.addEventListener('change', function () {
                                                                            const file = this.files && this.files[0];
                                                                            if (lastURL) {
                                                                                URL.revokeObjectURL(lastURL);
                                                                                lastURL = null;
                                                                            }
                                                                            if (file) {
                                                                                const url = URL.createObjectURL(file);
                                                                                lastURL = url;
                                                                                img.src = url;
                                                                                img.style.display = 'inline-block';
                                                                            } else {
                                                                                img.removeAttribute('src');
                                                                                img.style.display = 'none';
                                                                            }
                                                                        });
                                                                        window.addEventListener('beforeunload', function () {
                                                                            if (lastURL)
                                                                                URL.revokeObjectURL(lastURL);
                                                                        });
                                                                    }
                                                                    ['1', '2', '3', '4'].forEach(n => {
                                                                        bindPreview('imageFile' + n, 'preview' + n);
                                                                        // vùng tab ảnh và vùng thêm mới dùng cùng id preview (theo số), vẫn ổn vì không đồng thời hiển thị
                                                                        bindPreview('imageFile' + n, 'preview' + n);
                                                                    });

                                                                    // Xóa ảnh qua controller
                                                                    function deleteImage(imgId, productId) {
                                                                        if (!confirm('Bạn có chắc muốn xoá ảnh này không?'))
                                                                            return;
                                                                        fetch('MainController?action=deleteImageProduct', {
                                                                            method: 'POST',
                                                                            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                                                                            body: 'deleteImgId=' + encodeURIComponent(imgId) + '&product_id=' + encodeURIComponent(productId)
                                                                        })
                                                                                .then(res => res.text())
                                                                                .then(() => location.reload())
                                                                                .catch(err => console.error(err));
                                                                    }

                                                                    // TinyMCE init
                                                                    tinymce.init({
                                                                        selector: '#editor',
                                                                        height: 420,
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
        </script>
    </body>
</html>
