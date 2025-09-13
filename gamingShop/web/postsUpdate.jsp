<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dto.Posts" %>
<%
    Posts post = (Posts) request.getAttribute("post");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title><%= (post != null) ? "Sửa bài viết" : "Thêm bài viết" %></title>
        <link rel="stylesheet"
              href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
        <style>
            body {
                padding: 24px;
            }
            .form-section {
                max-width: 900px;
                margin: 0 auto;
            }
            .img-preview {
                max-height: 220px;
                display: none;
                margin-top: 8px;
            }
        </style>
    </head>
    <body>
        <div class="form-section">
            <h1 class="mb-3"><%= (post != null) ? "Sửa bài viết" : "Thêm bài viết" %></h1>

            <%
                String messageAddPosts = (String) request.getAttribute("messageAddPosts");
                String checkErrorAddPosts = (String) request.getAttribute("checkErrorAddPosts");
                String messageUpdatePosts = (String) request.getAttribute("messageUpdatePosts");
                String checkErrorUpdatePosts = (String) request.getAttribute("checkErrorUpdatePosts");
                String messageDeleteImg = (String) request.getAttribute("messageDeleteImg");
                String checkErrorDeleteImg = (String) request.getAttribute("checkErrorDeleteImg");
                
            %>

            <!-- In thông báo -->
            <% if (messageAddPosts != null) { %>
            <div class="alert alert-success"><%= messageAddPosts %></div>
            <% } else if (checkErrorAddPosts != null) { %>
            <div class="alert alert-danger"><%= checkErrorAddPosts %></div>
            <% } else if (messageUpdatePosts != null) { %>
            <div class="alert alert-success"><%= messageUpdatePosts %></div>
            <% } else if (checkErrorUpdatePosts != null) { %>
            <div class="alert alert-danger"><%= checkErrorUpdatePosts %></div>
            <% } else if (messageDeleteImg != null) { %>
            <div class="alert alert-success"><%= messageDeleteImg %></div>
            <% } else if (checkErrorDeleteImg != null) { %>
            <div class="alert alert-danger"><%= checkErrorDeleteImg %></div>
            <% } %>

            <form action="MainController" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="<%= (post != null) ? "updatePosts" : "addPosts" %>"/>
                <% if (post != null) { %>
                <input type="hidden" name="id" value="<%= post.getId() %>"/>
                <% } %>

                <div class="mb-3">
                    <label for="author" class="form-label">Tác giả</label>
                    <input type="text" class="form-control" id="author" name="author"
                           value="<%= (post != null && post.getAuthor()!=null) ? post.getAuthor() : "" %>">
                </div>

                <div class="mb-3">
                    <label for="title" class="form-label">Tiêu đề <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="title" name="title"
                           value="<%= (post != null && post.getTitle()!=null) ? post.getTitle() : "" %>" required>
                </div>

                <div class="mb-3">
                    <label for="publish_date" class="form-label">Ngày xuất bản</label>
                    <input type="date" class="form-control" id="publish_date" name="publish_date"
                           value="<%= (post != null && post.getPublish_date()!=null) ? 
                                new java.text.SimpleDateFormat("yyyy-MM-dd").format(post.getPublish_date()) : "" %>">
                </div>

                <div class="mb-3">
                    <label for="status" class="form-label">Trạng thái</label>
                    <select class="form-select" id="status" name="status">
                        <option value="1" <%= (post != null && post.getStatus()==1) ? "selected" : "" %>>Active</option>
                        <option value="0" <%= (post != null && post.getStatus()==0) ? "selected" : "" %>>Inactive</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="editor" class="form-label">Nội dung (HTML) <span class="text-danger">*</span></label>
                    <textarea class="form-control" id="editor" name="content_html" rows="8"><%= (post != null && post.getContent_html()!=null) ? post.getContent_html() : "" %></textarea>
                </div>

                <div class="mb-3">
                    <label for="imageFile" class="form-label">Ảnh đại diện</label>
                    <input class="form-control" type="file" id="imageFile" name="image" accept="image/*">
                    <%
                        if (post != null && post.getImage_url() != null && !post.getImage_url().isEmpty()) {
                    %>
                    <img id="preview" src="<%= request.getContextPath() + "/" + post.getImage_url() %>" class="img-preview" style="display:block;">
                    <% } else { %>
                    <img id="preview" class="img-preview">
                    <% } %>
                </div>

                <% if (post != null) { %>
                <button type="button" class="btn btn-danger" onclick="deletePost(<%= post.getId() %>)">
                    Xoá ảnh
                </button>
                <% } %>
                <div class="mt-4 d-flex gap-2">
                    <button type="submit" class="btn btn-primary">Lưu bài viết</button>
                    <button type="reset" class="btn btn-outline-secondary">Làm mới</button>
                    <a href="posts.jsp" class="btn btn-secondary">Back to List</a>
                </div>
                <br>
            </form>
        </div>

        <script>
            (function () {
            const ctx = '<%= request.getContextPath() %>';
            const form = document.querySelector('form');
            const input = document.getElementById('imageFile');
            const preview = document.getElementById('preview');
            const existing = document.getElementById('existingImageUrl');
            function normalize(url) {
            if (!url) return null;
            if (/^(https?:)?\/\//i.test(url) || url.startsWith('data:') || url.startsWith(ctx + '/')) return url;
            return ctx + '/' + url.replace(/^\/+/, '');
            }

            function show(url) {
            const finalUrl = normalize(url);
            if (!finalUrl) {
            preview.removeAttribute('src');
            preview.style.display = 'none';
            return;
            }
            preview.onload = () => { preview.style.display = 'block'; };
            preview.onerror = () => { preview.style.display = 'none'; };
            preview.src = finalUrl;
            }

            document.addEventListener('DOMContentLoaded', () => {
            const initial = existing?.value || preview.getAttribute('src') || null;
            show(initial);
            });
            input?.addEventListener('change', function () {
            const file = this.files?.[0];
            if (!file) { show(existing?.value || null); return; }
            const blobUrl = URL.createObjectURL(file);
            preview.onload = () => { preview.style.display = 'block'; URL.revokeObjectURL(blobUrl); };
            preview.onerror = () => { preview.style.display = 'none'; };
            preview.src = blobUrl;
            });
            form?.addEventListener('reset', () => {
            setTimeout(() => show(existing?.value || null));
            });
            })();
            function deletePost(postId) {
            if (!confirm("Bạn có chắc muốn xoá bài viết này?")) {
            return;
            }

            fetch("MainController", {
            method: "POST",
                    headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                    },
                    body: "action=deleteImagePost&id=" + encodeURIComponent(postId)
            })
                    .then(response => response.text())
                    .then(data => {
                    alert("Xoá thành công!");
                    // Ví dụ quay về danh sách bài viết
                    window.location.href = "psots.jsp";
                    })
                    .catch(err => {
                    console.error("Error:", err);
                    alert("Có lỗi xảy ra khi xoá.");
                    });
            }
        </script>

        <!-- TinyMCE -->
        <script src="https://cdn.tiny.cloud/1/9q1kybnxbgq2f5l3c8palpboawfgsnqsdd53b7gk5ny3dh19/tinymce/6/tinymce.min.js" referrerpolicy="origin"></script>
        <script>
            tinymce.init({
            selector: '#editor',
                    height: 400,
                    plugins: 'image link lists table code media',
                    toolbar: 'undo redo | bold italic underline | alignleft aligncenter alignright | ' +
                    'bullist numlist | link image media | table | code',
                    menubar: 'file edit view insert format tools table help',
                    automatic_uploads: true,
                    file_picker_types: 'file image media',
                    file_picker_callback: function (callback, value, meta) {
                    let input = document.createElement('input');
                    input.type = 'file';
                    if (meta.filetype === 'image') input.accept = 'image/*';
                    else if (meta.filetype === 'media') input.accept = 'video/mp4';
                    input.onchange = function () {
                    const file = this.files[0];
                    const formData = new FormData();
                    formData.append("file", file);
                    let uploadUrl = '<%= request.getContextPath() %>/UploadImageController';
                    if (meta.filetype === 'media') uploadUrl = '<%= request.getContextPath() %>/UploadVideoController';
                    fetch(uploadUrl, { method: 'POST', body: formData })
                            .then(r => r.json())
                            .then(json => { callback(json.location); });
                    };
                    input.click();
                    }
            });
        </script>
    </body>
</html>
