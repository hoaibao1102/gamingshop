<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Thêm bài viết</title>
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
            <c:choose>
                <c:when test="${not empty post}">
                    <h1 class="mb-3">Sửa bài viết</h1>
                </c:when>
                <c:otherwise>
                    <h1 class="mb-3">Thêm bài viết</h1>
                </c:otherwise>
            </c:choose>


            <!-- Thông báo từ servlet -->
            <%
                String msgSuccess = (String) request.getAttribute("messageAddPost");
                String warning = (String) request.getAttribute("warning");
                String errAdd = (String) request.getAttribute("checkErrorAddPost");
                String err = (String) request.getAttribute("checkError");
                dto.Posts post = (dto.Posts) request.getAttribute("post");
            %>
            <% if (msgSuccess != null) { %>
            <div class="alert alert-success"><%= msgSuccess %></div>
            <% } %>
            <% if (warning != null) { %>
            <div class="alert alert-warning"><%= warning %></div>
            <% } %>
            <% if (errAdd != null) { %>
            <div class="alert alert-danger"><%= errAdd %></div>
            <% } %>
            <% if (err != null) { %>
            <div class="alert alert-danger"><%= err %></div>
            <% } %>

            <!-- Nếu vừa thêm xong -->
            <% if (post != null) { 
                java.util.Date pubDate = post.getPublish_date();
                String formattedDate = (pubDate != null)
                    ? new SimpleDateFormat("yyyy-MM-dd").format(pubDate)
                    : "(chưa đặt)";
            %>
            <div class="card mb-4">
                <div class="card-header">Bài viết vừa tạo</div>
                <div class="card-body">
                    <p><strong>ID:</strong> <%= post.getId() %></p>
                    <p><strong>Tiêu đề:</strong> <%= post.getTitle() %></p>
                    <p><strong>Tác giả:</strong> <%= post.getAuthor() %></p>
                    <p><strong>Ngày xuất bản:</strong> <%= formattedDate %></p>
                    <p><strong>Trạng thái:</strong> <%= post.getStatus() %></p>
                    <% if (post.getImage_url() != null) { %>
                    <img src="<%= request.getContextPath() + "/" + post.getImage_url() %>"
                         alt="Ảnh bài viết" style="max-height:220px;">
                    <% } %>
                </div>
            </div>
            <% } %>


            <!-- FORM thêm mới -->
            <form action="MainController" method="get" enctype="multipart/form-data">
                <input type="hidden" name="action" value="${not empty post ? 'updatePosts' : 'addPosts'}"/>

                <c:if test="${not empty post}">
                    <input type="hidden" name="id" value="${post.id}">
                </c:if>

                <div class="mb-3">
                    <label for="title" class="form-label">Tiêu đề<span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="title" name="title"
                           value="${not empty post ? post.title : '' }"  required>
                </div>

                <div class="mb-3">
                    <label for="content_html" class="form-label">Nội dung (HTML)<span class="text-danger">*</span></label>
                    <textarea class="form-control" id="editor" name="content_html" rows="8" required> ${not empty post ? post.content_html : '' } </textarea>
                </div>

                <div class="row g-3">
                    <div class="col-sm-6">
                        <label for="status" class="form-label">Trạng thái</label>
                        <select class="form-select" id="status" name="status">
                            <option value="1" ${not empty post && post.status == 1 ? 'selected' : ''}>Active</option>
                            <option value="0" ${not empty post && post.status == 0 ? 'selected' : ''}>Inactive</option>
                        </select>
                    </div>
                </div>

                <div class="mb-3 mt-3">
                    <label for="imageFile" class="form-label">Ảnh đại diện</label>

                    <!-- file input: KHÔNG set value -->
                    <input class="form-control" type="file" id="imageFile" name="imageFile" accept="image/*" >

                    <!-- ảnh preview: nếu đang edit thì show luôn ảnh cũ -->
                    <img id="preview" class="img-preview"
                         src="${not empty post && not empty post.image_url ? post.image_url : ''}"
                         alt="Preview"
                         style="${not empty post && not empty post.image_url ? 'display:block' : 'display:none'}">

                    <!-- tuỳ chọn: giữ URL ảnh cũ để server biết nếu người dùng không upload ảnh mới -->
                    <input type="hidden" name="existingImageUrl"
                           value="${not empty post ? post.image_url : ''}">
                </div>

                <div class="mt-4 d-flex gap-2">
                    <button type="submit" class="btn btn-primary">Lưu bài viết</button>
                    <button type="reset" class="btn btn-outline-secondary">Làm mới</button>
                </div><br>
                <a href="welcome.jsp" class="btn btn-secondary">Back to List</a>
            </form>
        </div>

        <script>
            // Preview ảnh
            const input = document.getElementById('imageFile');
            const preview = document.getElementById('preview');
            input.addEventListener('change', function () {
                const [file] = input.files || [];
                if (file) {
                    preview.src = URL.createObjectURL(file);
                    preview.style.display = 'block';
                } else {
                    preview.src = '';
                    preview.style.display = 'none';
                }
            });
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

                // Cho phép nhiều loại file picker
                file_picker_types: 'file image media',

                // Callback xử lý upload
                file_picker_callback: function (callback, value, meta) {
                    let input = document.createElement('input');
                    input.setAttribute('type', 'file');

                    if (meta.filetype === 'image') {
                        input.setAttribute('accept', 'image/*');
                    } else if (meta.filetype === 'media') {
                        input.setAttribute('accept', 'video/mp4');
                    }

                    input.onchange = function () {
                        let file = this.files[0];
                        let formData = new FormData();
                        formData.append("file", file);

                        // Upload ảnh hoặc video
                        let uploadUrl = '<%= request.getContextPath() %>/UploadImageController';
                        if (meta.filetype === 'media') {
                            uploadUrl = '<%= request.getContextPath() %>/UploadVideoController';
                        }

                        fetch(uploadUrl, {
                            method: 'POST',
                            body: formData
                        })
                                .then(response => response.json())
                                .then(json => {
                                    callback(json.location);
                                });
                    };

                    input.click();
                }
            });
        </script>
    </body>
</html>
