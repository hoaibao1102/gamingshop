<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, dto.Banners" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Quản lý Banners</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
        <style>
            body {
                background: #f6f7fb;
            }
            .card {
                border: 0;
                box-shadow: 0 10px 18px rgba(22,28,45,.06);
            }
            .thumb {
                width:100px;
                height:60px;
                object-fit:cover;
                border-radius:.25rem;
                border:1px solid #eee;
            }
            .preview {
                max-width:320px;
                max-height:180px;
                border:1px dashed #ddd;
                border-radius:.5rem;
            }
            .required::after {
                content:" *";
                color:#d6336c;
            }
            .badge-active{
                background:#198754;
            }
            .badge-inactive{
                background:#6c757d;
            }
            .table td,.table th{
                vertical-align: middle;
            }
        </style>
    </head>
    <body>
        <%
            String ctx = request.getContextPath();
            String messageAddBanner = (String) request.getAttribute("messageAddBanner");
            String messageUpdateBanner = (String) request.getAttribute("messageUpdateBanner");
            String checkErrorAddBanner = (String) request.getAttribute("checkErrorAddBanner");
            String checkErrorUpdateBanner = (String) request.getAttribute("checkErrorUpdateBanner");

            // Banner đang edit (nếu có)
            Banners editBanner = (Banners) request.getAttribute("editBanner");

            @SuppressWarnings("unchecked")
            List<Banners> banners = (List<Banners>) request.getAttribute("banners");
        %>

        <div class="container py-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h1 class="h3 m-0">Quản lý Banners</h1>
            </div>

            <% if (messageAddBanner != null) { %>
            <div class="alert alert-success alert-dismissible fade show"><%= messageAddBanner %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% } %>
            <% if (messageUpdateBanner != null) { %>
            <div class="alert alert-success alert-dismissible fade show"><%= messageUpdateBanner %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% } %>
            <% if (checkErrorAddBanner != null) { %>
            <div class="alert alert-danger alert-dismissible fade show"><%= checkErrorAddBanner %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% } %>
            <% if (checkErrorUpdateBanner != null) { %>
            <div class="alert alert-danger alert-dismissible fade show"><%= checkErrorUpdateBanner %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% } %>

            <div class="row g-4">
                <!-- Form thêm/cập nhật -->
                <div class="col-lg-5">
                    <div class="card">
                        <div class="card-header bg-white">
                            <strong><%= (editBanner != null ? "Cập nhật banner" : "Thêm banner") %></strong>
                        </div>
                        <div class="card-body">
                            <form method="post"
                                  action="BannerController?action=<%= (editBanner != null ? "updateBanner" : "addBanner") %>"
                                  enctype="multipart/form-data"
                                  id="bannerForm">

                                <% if (editBanner != null) { %>
                                <input type="hidden" name="id" value="<%= editBanner.getId() %>" />
                                <% } %>

                                <div class="mb-3">
                                    <label class="form-label required" for="title">Tiêu đề</label>
                                    <input type="text" class="form-control" id="title" name="title"
                                           value="<%= (editBanner != null 
                                                       ? editBanner.getTitle() 
                                                       : (request.getParameter("title") != null 
                                                            ? request.getParameter("title") 
                                                            : "")) %>"
                                           placeholder="Nhập tiêu đề" required />
                                </div>

                                <div class="mb-3">
                                    <label class="form-label required" for="status">Trạng thái</label>
                                    <select class="form-select" id="status" name="status" required>
                                        <option value="active"
                                                <%= (editBanner != null && "active".equals(editBanner.getStatus())) 
                                                    || (editBanner == null && "active".equals(request.getParameter("status"))) 
                                                    ? "selected" : "" %>>
                                            active
                                        </option>

                                        <option value="inactive"
                                                <%= (editBanner != null && "inactive".equals(editBanner.getStatus())) 
                                                    || (editBanner == null && "inactive".equals(request.getParameter("status"))) 
                                                    ? "selected" : "" %>>
                                            inactive
                                        </option>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label" for="imageFile">Ảnh (tùy chọn)</label>
                                    <input class="form-control" type="file" id="imageFile" name="imageFile" accept="image/*" />
                                    <small class="text-muted">Hỗ trợ JPG, PNG, GIF...</small>
                                </div>

                                <div class="mb-3">
                                    <% if (editBanner != null && editBanner.getImage_url() != null) { %>
                                    <img src="<%= ctx + "/" + editBanner.getImage_url() %>" class="preview" id="preview" alt="Preview" />
                                    <% } else { %>
                                    <img id="preview" class="preview d-none" alt="Preview" />
                                    <% } %>
                                </div>

                                <div class="d-flex gap-2">
                                    <button type="submit" class="btn btn-primary"><%= (editBanner != null ? "Cập nhật" : "Thêm mới") %></button>
                                    <button type="reset" class="btn btn-outline-secondary">Làm lại</button>
                                    <a class="btn btn-outline-secondary" href="MainController?action=getAllBannerActive">Danh sách banner</a>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            // Preview ảnh trước khi upload
            const imageInput = document.getElementById('imageFile');
            const previewImg = document.getElementById('preview');
            if (imageInput) {
                imageInput.addEventListener('change', function () {
                    const file = this.files && this.files[0];
                    if (!file) {
                        previewImg.classList.add('d-none');
                        previewImg.src = '';
                        return;
                    }
                    if (!file.type.startsWith('image/')) {
                        alert('Vui lòng chọn đúng định dạng ảnh.');
                        this.value = '';
                        previewImg.classList.add('d-none');
                        previewImg.src = '';
                        return;
                    }
                    const reader = new FileReader();
                    reader.onload = function (e) {
                        previewImg.src = e.target.result;
                        previewImg.classList.remove('d-none');
                    };
                    reader.readAsDataURL(file);
                });
            }
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
