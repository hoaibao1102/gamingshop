<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, dto.Banners" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Quản lý Banners (scriptlet)</title>
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
            String checkErrorAddBanner = (String) request.getAttribute("checkErrorAddBanner");
            String checkError = (String) request.getAttribute("checkError");
            @SuppressWarnings("unchecked")
            List<Banners> banners = (List<Banners>) request.getAttribute("banners");
        %>

        <div class="container py-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h1 class="h3 m-0">Quản lý Banners</h1>
                <a class="btn btn-outline-secondary btn-sm" href="BannersController?action=getAllBannerActive">Tải lại</a>
            </div>

            <% if (messageAddBanner != null && !messageAddBanner.isEmpty()) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <%= messageAddBanner %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% } %>
            <% if (checkErrorAddBanner != null && !checkErrorAddBanner.isEmpty()) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <%= checkErrorAddBanner %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% } %>
            <% if (checkError != null && !checkError.isEmpty()) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <%= checkError %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% } %>

            <div class="row g-4">
                <!-- Form thêm mới -->
                <div class="col-lg-5">
                    <div class="card">
                        <div class="card-header bg-white">
                            <strong>Thêm banner</strong>
                        </div>
                        <div class="card-body">
                            <form method="post" action="BannersController?action=addBanner" enctype="multipart/form-data" id="bannerForm">
                                <div class="mb-3">
                                    <label class="form-label required" for="title">Tiêu đề</label>
                                    <input type="text" class="form-control" id="title" name="title" placeholder="Nhập tiêu đề" required />
                                </div>

                                <div class="mb-3">
                                    <label class="form-label required" for="status">Trạng thái</label>
                                    <select class="form-select" id="status" name="status" required>
                                        <option value="active">active</option>
                                        <option value="inactive" selected>inactive</option>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label" for="imageFile">Ảnh (tùy chọn)</label>
                                    <input class="form-control" type="file" id="imageFile" name="imageFile" accept="image/*" />
                                    <small class="text-muted">Hỗ trợ JPG, PNG, GIF...</small>
                                </div>

                                <div class="mb-3">
                                    <img id="preview" class="preview d-none" alt="Preview" />
                                </div>

                                <div class="d-flex gap-2">
                                    <button type="submit" class="btn btn-primary">Thêm mới</button>
                                    <button type="reset" class="btn btn-outline-secondary">Làm lại</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Danh sách banners -->
                <div class="col-lg-7">
                    <div class="card">
                        <div class="card-header bg-white d-flex justify-content-between align-items-center">
                            <strong>Danh sách</strong>
                            <form class="d-flex" method="get" action="BannersController">
                                <input type="hidden" name="action" value="search" />
                                <input class="form-control form-control-sm me-2" type="search" name="q" placeholder="Tìm theo tiêu đề..." value="<%= request.getParameter("q") != null ? request.getParameter("q") : "" %>" />
                                <button class="btn btn-sm btn-outline-primary" type="submit">Tìm</button>
                            </form>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th style="width:70px">ID</th>
                                            <th style="width:120px">Ảnh</th>
                                            <th>Tiêu đề</th>
                                            <th style="width:120px">Trạng thái</th>
                                            <th style="width:160px" class="text-end">Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            if (banners != null && !banners.isEmpty()) {
                                                for (Banners b : banners) {
                                                    String badgeClass = "badge-inactive";
                                                    if ("active".equalsIgnoreCase(b.getStatus())) badgeClass = "badge-active";
                                        %>
                                        <tr>
                                            <td><%= b.getId() %></td>
                                            <td>
                                                <%
                                                  if (b.getImage_url() != null && !b.getImage_url().isEmpty()) {
                                                %>
                                                <img class="thumb" src="<%= ctx %>/<%= b.getImage_url() %>" alt="thumb"/>
                                                <%
                                                  } else {
                                                %>
                                                <span class="text-muted">(không có)</span>
                                                <%
                                                  }
                                                %>
                                            </td>
                                            <td>
                                                <div class="fw-semibold"><%= b.getTitle() %></div>
                                                <small class="text-muted">#<%= b.getId() %></small>
                                            </td>
                                            <td>
                                                <span class="badge <%= badgeClass %>"><%= b.getStatus() %></span>
                                            </td>
                                            <td class="text-end">
                                                <a class="btn btn-sm btn-outline-secondary" href="BannersController?action=edit&id=<%= b.getId() %>">Sửa</a>
                                                <a class="btn btn-sm btn-outline-danger" href="BannersController?action=delete&id=<%= b.getId() %>"
                                                   onclick="return confirm('Xoá banner #<%= b.getId() %>?');">Xoá</a>
                                            </td>
                                        </tr>
                                        <%
                                                }
                                            } else {
                                        %>
                                        <tr>
                                            <td colspan="5" class="text-center text-muted py-4">Chưa có banner nào</td>
                                        </tr>
                                        <%
                                            }
                                        %>
                                    </tbody>
                                </table>
                            </div>
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
