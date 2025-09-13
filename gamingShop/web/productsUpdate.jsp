<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dto.Products, java.util.List, dto.Product_images, dto.Models, dto.Memories, dto.Guarantees" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Product Management</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"/>
        <style>
            .img-preview {
                max-height: 150px;
                display: none;
                margin-top: 8px;
            }
        </style>
    </head>
    <body class="bg-light">
        <%
            // Khai báo mess và checkError
            Products product = (Products) request.getAttribute("product");
            String messageAddProduct = (String) request.getAttribute("messageAddProduct");
            String checkErrorAddProduct = (String) request.getAttribute("checkErrorAddProduct");
            String messageEditProduct = (String) request.getAttribute("messageEditProduct");
            String checkErrorEditProduct = (String) request.getAttribute("checkErrorEditProduct");
            String messageUpdateProductMain = (String) request.getAttribute("messageUpdateProductMain");
            String checkErrorUpdateProductMain = (String) request.getAttribute("checkErrorUpdateProductMain");
            String messageUpdateProductImage = (String) request.getAttribute("messageUpdateProductImage");
            String checkErrorUpdateProductImage = (String) request.getAttribute("checkErrorUpdateProductImage");
            String messageDeleteImg = (String) request.getAttribute("messageDeleteImg");
            String checkErrorDeleteImg = (String) request.getAttribute("checkErrorDeleteImg");
            
            // Khai bào list Images
            List<Product_images> productImages = (List<Product_images>) request.getAttribute("productImages");
            boolean justAdded = (messageAddProduct != null);
            
            // Khai báo các list liên quan tới products để lấy type thay vì id
            List<Models> modelTypes = (List<Models>) request.getAttribute("modelTypes");
            List<Memories> memoryTypes = (List<Memories>) request.getAttribute("memoryTypes");
            List<Guarantees> guaranteeTypes = (List<Guarantees>) request.getAttribute("guaranteeTypes");
        %>
        <div class="container mt-5">
            <h2 class="mb-4"><%= (product != null) ? "Edit Product" : "Add New Product" %></h2>

            <!-- In thông báo -->
            <% if (messageAddProduct != null) { %>
            <div class="alert alert-success"><%= messageAddProduct %></div>
            <% } else if (checkErrorAddProduct != null) { %>
            <div class="alert alert-danger"><%= checkErrorAddProduct %></div>
            <% } else if (checkErrorEditProduct != null) { %>
            <div class="alert alert-danger"><%= checkErrorEditProduct %></div>
            <% } else if (messageEditProduct != null) { %>
            <div class="alert alert-success"><%= messageEditProduct %></div>
            <% } else if (messageUpdateProductMain != null) { %>
            <div class="alert alert-success"><%= messageUpdateProductMain %></div>
            <% } else if (checkErrorUpdateProductMain != null) { %>
            <div class="alert alert-danger"><%= checkErrorUpdateProductMain %></div>
            <% } else if (messageUpdateProductImage != null) { %>
            <div class="alert alert-success"><%= messageUpdateProductImage %></div>
            <% } else if (checkErrorUpdateProductImage != null) { %>
            <div class="alert alert-danger"><%= checkErrorUpdateProductImage %></div>
            <% } else if (messageDeleteImg != null) { %>
            <div class="alert alert-success"><%= messageDeleteImg %></div>
            <% } else if (checkErrorDeleteImg != null) { %>
            <div class="alert alert-danger"><%= checkErrorDeleteImg %></div>
            <% } %>

            <!-- Form -->
            <form action="MainController" method="post" enctype="multipart/form-data">
                <!-- Nếu có product thì update, nếu không thì add -->
                <input type="hidden" name="action" value="<%= (product != null) ? "editMainProduct" : "addProduct" %>"/>
                <% if (product != null) { %>
                <input type="hidden" name="product_id" value="<%= product.getId() %>"/>
                <% } %>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Product Name</label>
                        <input type="text" name="name" class="form-control"
                               value="<%= (product != null) ? product.getName() : "" %>" required/>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">SKU</label>
                        <input type="text" name="sku" class="form-control"
                               value="<%= (product != null) ? product.getSku() : "" %>" required/>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Price</label>
                        <input type="number" step="0.01" name="price" class="form-control"
                               value="<%= (product != null) ? product.getPrice() : "" %>" required/>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Quantity</label>
                        <input type="number" name="quantity" class="form-control"
                               value="<%= (product != null) ? product.getQuantity() : "" %>" required/>
                    </div>

                    <div class="col-md-4 mb-3">
                        <label class="form-label">Product Type</label>
                        <select name="product_type" class="form-select" required>
                            <option value="new" <%= (product != null && "new".equals(product.getProduct_type())) ? "selected" : "" %>>New</option>
                            <option value="used" <%= (product != null && "old".equals(product.getProduct_type())) ? "selected" : "" %>>Used</option>
                        </select>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Model</label>
                        <select name="model_id" class="form-select" required>
                            <%
                                if (modelTypes != null) {
                                    for (Models m : modelTypes) {
                                        String selected = (product != null && m.getId() == product.getModel_id()) ? "selected" : "";
                            %>
                            <option value="<%= m.getId() %>" <%= selected %>><%= m.getModel_type() %></option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </div>

                    <div class="col-md-4 mb-3">
                        <label class="form-label">Memory</label>
                        <select name="memory_id" class="form-select" required>
                            <%
                                if (memoryTypes != null) {
                                    for (Memories mem : memoryTypes) {
                                        String selected = (product != null && mem.getId() == product.getMemory_id()) ? "selected" : "";
                            %>
                            <option value="<%= mem.getId() %>" <%= selected %>><%= mem.getMemory_type() %></option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </div>    


                    <div class="col-md-4 mb-3">
                        <label class="form-label">Guarantee</label>
                        <select name="guarantee_id" class="form-select" required>
                            <%
                                if (guaranteeTypes != null) {
                                    for (Guarantees g : guaranteeTypes) {
                                        String selected = (product != null && g.getId() == product.getGuarantee_id()) ? "selected" : "";
                            %>
                            <option value="<%= g.getId() %>" <%= selected %>><%= g.getGuarantee_type() %></option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Specification (HTML)</label>
                    <textarea id="editor" name="spec_html" class="form-control" rows="5"><%= (product != null) ? product.getDescription_html() : "" %></textarea>
                </div>

                <div class="mb-3">
                    <label class="form-label">Status</label>
                    <select name="status" class="form-select">
                        <option value="active" <%= (product != null && "active".equals(product.getStatus())) ? "selected" : "" %>>Active</option>
                        <option value="inactive" <%= (product != null && "inactive".equals(product.getStatus())) ? "selected" : "" %>>Inactive</option>
                        <option value="prominent" <%= (product != null && "prominent".equals(product.getStatus())) ? "selected" : "" %>>Prominent</option>
                    </select>
                </div>

                <!-- Upload nhiều ảnh -->
                <div class="mb-3">
                    <% if (product == null) { %>
                    <!-- Add mode: cho upload tối đa 4 ảnh -->
                    <label class="form-label">Upload Images (max 4)</label>
                    <div class="row g-2">
                        <div class="col-md-3">
                            <input type="file" name="imageFile1" id="imageFile1" class="form-control" accept="image/*"/>
                            <img id="preview1" class="img-preview" alt="Preview 1">
                        </div>
                        <div class="col-md-3">
                            <input type="file" name="imageFile2" id="imageFile2" class="form-control" accept="image/*"/>
                            <img id="preview2" class="img-preview" alt="Preview 2">
                        </div>
                        <div class="col-md-3">
                            <input type="file" name="imageFile3" id="imageFile3" class="form-control" accept="image/*"/>
                            <img id="preview3" class="img-preview" alt="Preview 3">
                        </div>
                        <div class="col-md-3">
                            <input type="file" name="imageFile4" id="imageFile4" class="form-control" accept="image/*"/>
                            <img id="preview4" class="img-preview" alt="Preview 4">
                        </div>
                    </div>
                    <% } else if (justAdded) { %>
                    <!-- Vừa Add xong: hiển thị ảnh vừa upload -->
                    <% if (productImages != null && !productImages.isEmpty()) { %>
                    <div class="mt-3">
                        <p>Current Images:</p>
                        <div class="d-flex flex-wrap gap-2">
                            <% for (Product_images img : productImages) { %>
                            <img src="<%= request.getContextPath() %>/<%= img.getImage_url() %>"
                                 class="img-thumbnail" style="max-width:150px;"/>
                            <% } %>
                        </div>
                    </div>
                    <% } else { %>
                    <p class="text-muted">No images available for this product.</p>
                    <% } %>
                    <% } %>
                </div>

                <button type="submit" class="btn btn-primary">
                    <%= (product != null) ? "Update Product" : "Add Product" %>
                </button>
                <a href="welcome.jsp" class="btn btn-secondary">Back to List</a>
            </form>
        </div>

        <%-- Hiển thị + cập nhật 4 slot ảnh bằng 1 form --%>
        <% if (product != null && !justAdded) { %>
        <div class="mt-5">
            <h2 class="mb-4">Manage Product Images (Update all)</h2>
            <%
                // Chuẩn hóa 4 slot theo sort_order 1..4
                Product_images[] slots = new Product_images[4];
                if (productImages != null) {
                    for (Product_images im : productImages) {
                        int so = im.getSort_order();
                        if (so >= 1 && so <= 4) slots[so - 1] = im;
                    }
                }
            %>
            <form action="MainController" method="post" enctype="multipart/form-data" class="border rounded p-3">
                <input type="hidden" name="action" value="editImageProduct"/>
                <input type="hidden" name="product_id" value="<%= product.getId() %>"/>
                <input type="hidden" name="deleteImgId" id="deleteImgId" />

                <div class="row">
                    <% for (int i = 0; i < 4; i++) {
                           int slot = i + 1;
                           Product_images slotImg = slots[i];
                    %>
                    <div class="col-md-3 mb-4 text-center">
                        <% if (slotImg != null) { %>
                        <!-- Ảnh cũ -->
                        <img src="<%= request.getContextPath() %>/<%= slotImg.getImage_url() %>"
                             class="img-thumbnail mb-2" style="max-width:200px; height:auto;"
                             id="preview<%= slot %>_old"/>
                        <div class="text-muted mb-2">Slot <%= slot %> (Giữ nguyên nếu không chọn ảnh mới)</div>

                        <!-- Nút xoá ảnh -->
                        <button type="button" class="btn btn-sm btn-danger mb-2"
                                onclick="deleteImage('<%= slotImg.getId() %>', '<%= product.getId() %>')">
                            Xoá ảnh
                        </button>

                        <% } else { %>
                        <!-- Placeholder -->
                        <div class="mb-2" style="height:200px; display:flex; align-items:center; justify-content:center; background:#f8f9fa;">
                            <span class="text-muted">No Image (Slot <%= slot %>)</span>
                        </div>
                        <img id="preview<%= slot %>_old" style="display:none;"/>
                        <% } %>

                        <!-- Input + preview ảnh mới -->
                        <input type="file" id="imageFile<%= slot %>" name="imageFile<%= slot %>" accept="image/*"
                               class="form-control form-control-sm"/>
                        <img id="preview<%= slot %>" class="img-thumbnail mt-2" style="max-width:200px; display:none;"/>
                    </div>
                    <% } %>
                </div>

                <div class="text-center">
                    <button type="submit" class="btn btn-warning">Update Images</button>
                </div>
            </form>
        </div>
        <% } %>

        <script>
            // Bind preview cho từng input
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
                        img.style.display = 'block';
                    } else {
                        img.removeAttribute('src');
                        img.style.display = 'none';
                    }
                });

                // Khi rời trang/refresh, thu hồi URL
                window.addEventListener('beforeunload', function () {
                    if (lastURL)
                        URL.revokeObjectURL(lastURL);
                });
            }

            bindPreview('imageFile1', 'preview1');
            bindPreview('imageFile2', 'preview2');
            bindPreview('imageFile3', 'preview3');
            bindPreview('imageFile4', 'preview4');

            // Reset form -> ẩn tất cả preview
            const form = document.querySelector('form');
            if (form) {
                form.addEventListener('reset', function () {
                    setTimeout(() => {
                        ['preview1', 'preview2', 'preview3', 'preview4'].forEach(id => {
                            const img = document.getElementById(id);
                            if (img) {
                                img.removeAttribute('src');
                                img.style.display = 'none';
                            }
                        });
                    }, 0);
                });
            }

            function deleteImage(imgId, productId) {
                if (!confirm("Bạn có chắc muốn xoá ảnh này không?"))
                    return;

                fetch("MainController?action=deleteImageProduct", {
                    method: "POST",
                    headers: {"Content-Type": "application/x-www-form-urlencoded"},
                    body: "deleteImgId=" + imgId + "&product_id=" + productId
                })
                        .then(res => res.text())
                        .then(data => {
                            console.log(data);
                            location.reload(); // reload lại trang sau khi xoá
                        })
                        .catch(err => console.error(err));
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
