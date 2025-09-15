<%-- 
    Document   : modelUpdate
    Created on : Sep 14, 2025, 8:46:41 AM
    Author     : ddhuy
--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
   <title>
        <c:choose>
            <c:when test="${not empty model && model.id > 0}">Edit Model</c:when>
            <c:otherwise>Add New Model</c:otherwise>
        </c:choose>
    </title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .btn { padding: 8px 15px; margin: 5px; text-decoration: none; border: 1px solid #ccc; border-radius: 3px; }
        .btn-primary { background-color: #007bff; color: white; border-color: #007bff; }
        .btn-success { background-color: #28a745; color: white; border-color: #28a745; }
        .btn-secondary { background-color: #6c757d; color: white; border-color: #6c757d; }
        .form-group { margin: 15px 0; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input, .form-group textarea, .form-group select { 
            width: 400px; padding: 8px; border: 1px solid #ddd; border-radius: 3px; 
        }
        textarea { height: 120px; resize: vertical; font-family: inherit; }
        .error { color: red; padding: 10px; background-color: #ffe6e6; border: 1px solid #ff0000; margin: 10px 0; }
        .success { color: green; padding: 10px; background-color: #e6ffe6; border: 1px solid #00aa00; margin: 10px 0; }
        .required { color: red; }
        .help-text { font-size: 12px; color: #666; margin-top: 3px; }
        .current-image { border: 1px solid #ddd; padding: 10px; margin: 10px 0; background-color: #f9f9f9; }
        
        /* ===== STYLES MỚI CHO IMAGE PREVIEW ===== */
        .image-preview-container {
            border: 2px dashed #007bff;
            padding: 15px;
            margin: 10px 0;
            background-color: #f8f9ff;
            border-radius: 5px;
            text-align: center;
            position: relative;
        }
        
        .image-preview {
            max-width: 300px;
            max-height: 300px;
            object-fit: contain;
            border: 2px solid #007bff;
            border-radius: 5px;
            box-shadow: 0 2px 10px rgba(0,123,255,0.2);
        }
        
        .preview-info {
            margin-top: 10px;
            color: #666;
            font-size: 12px;
        }
        
        .preview-actions {
            margin-top: 10px;
        }
        
        .btn-remove {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 3px;
            cursor: pointer;
            font-size: 12px;
        }
        
        .btn-remove:hover {
            background-color: #c82333;
        }
        
        .preview-placeholder {
            color: #999;
            font-style: italic;
            padding: 20px;
        }
        
        .file-input-wrapper {
            position: relative;
            display: inline-block;
        }
        
        .file-input-custom {
            background-color: #007bff;
            color: white;
            padding: 8px 15px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            margin: 5px 0;
        }
        
        .file-input-custom:hover {
            background-color: #0056b3;
        }
        
        #imageFile {
            display: none;
        }
    </style>
</head>
<body>
    <h1>
        <c:choose>
            <c:when test="${not empty model && model.id > 0}">Edit Model: ${model.model_type}</c:when>
            <c:otherwise>Add New Model</c:otherwise>
        </c:choose>
    </h1>
    
    <!-- Navigation -->
    <a href="MainController?action=viewModelList" class="btn btn-secondary">← Back to Models List</a>
    
    <!-- Messages -->
    <c:if test="${not empty checkErrorAddModel}">
        <div class="error">${checkErrorAddModel}</div>
    </c:if>
    <c:if test="${not empty checkErrorEditModel}">
        <div class="error">${checkErrorEditModel}</div>
    </c:if>
    <c:if test="${not empty checkErrorModelDetail}">
        <div class="error">${checkErrorModelDetail}</div>
    </c:if>
    <c:if test="${not empty messageAddModel}">
        <div class="success">${messageAddModel}</div>
    </c:if>
    <c:if test="${not empty messageEditModel}">
        <div class="success">${messageEditModel}</div>
    </c:if>
    
    <!-- Form -->
    <form method="post" enctype="multipart/form-data" action="MainController">
        <!-- Action & ID -->
        <c:choose>
            <c:when test="${not empty model && model.id > 0}">
                <input type="hidden" name="action" value="editModel">
                <input type="hidden" name="id" value="${model.id}">
            </c:when>
            <c:otherwise>
                <input type="hidden" name="action" value="addModel">
            </c:otherwise>
        </c:choose>
        
        <!-- Model Type -->
        <div class="form-group">
            <label for="model_type">Model Type <span class="required">*</span></label>
            <input type="text" id="model_type" name="model_type" 
                   value="${not empty model ? model.model_type : ''}" 
                   placeholder="e.g., iPhone 15 Pro, Samsung Galaxy S24, PlayStation 5" 
                   required maxlength="100">
            <div class="help-text">Unique name for this model (max 100 characters)</div>
        </div>
        
        <!-- Description -->
        <div class="form-group">
            <label for="description_html">Description</label>
            <textarea id="description_html" name="description_html" 
                      placeholder="Enter detailed description of the model. HTML tags are supported for formatting.">${not empty model ? model.description_html : ''}</textarea>
            <div class="help-text">Detailed description (HTML supported, max 10,000 characters)</div>
        </div>
        
        <!-- Status -->
        <div class="form-group">
            <label for="status">Status</label>
            <select id="status" name="status">
                <option value="active" ${(empty model || model.status == 'active') ? 'selected' : ''}>Active</option>
                <option value="inactive" ${model.status == 'inactive' ? 'selected' : ''}>Inactive</option>
            </select>
            <div class="help-text">Only active models are shown in product listings</div>
        </div>
        
        <!-- Current Image Display (Edit Mode) -->
        <c:if test="${not empty model && not empty model.image_url}">
            <div class="form-group">
                <label>Current Image:</label>
                <div class="current-image">
                    <img src="${model.image_url}" alt="Current Model Image" 
                         style="max-width: 200px; max-height: 200px; object-fit: contain;">
                    <p style="margin: 5px 0; color: #666; font-size: 12px;">
                        File: ${fn:substringAfter(model.image_url, '/')}
                    </p>
                </div>
            </div>
        </c:if>
        
        <!-- Image Upload với Preview - PHẦN MỚI THÊM -->
        <div class="form-group">
            <label for="imageFile">
                <c:choose>
                    <c:when test="${not empty model && not empty model.image_url}">Upload New Image:</c:when>
                    <c:otherwise>Upload Image:</c:otherwise>
                </c:choose>
            </label>
            
            <!-- Custom File Input Button -->
            <div class="file-input-wrapper">
                <button type="button" class="file-input-custom" onclick="document.getElementById('imageFile').click()">
                    📁 Choose Image File
                </button>
                <input type="file" id="imageFile" name="imageFile" accept="image/*">
            </div>
            
            <!-- Image Preview Container -->
            <div id="imagePreviewContainer" class="image-preview-container" style="display: none;">
                <div id="imagePreview">
                    <div class="preview-placeholder">No image selected</div>
                </div>
                <div id="previewInfo" class="preview-info"></div>
                <div class="preview-actions">
                    <button type="button" class="btn-remove" onclick="removeImagePreview()">
                        ❌ Remove Image
                    </button>
                </div>
            </div>
            
            <div class="help-text">
                Supported formats: JPG, JPEG, PNG, GIF, BMP, WEBP | Maximum file size: 5MB
                <c:if test="${not empty model && not empty model.image_url}">
                    <br><strong>Leave empty to keep current image</strong>
                </c:if>
            </div>
        </div>
        
        <!-- Timestamps (Edit Mode) -->
        <c:if test="${not empty model && model.id > 0}">
            <div class="form-group">
                <label>Created:</label>
                <span style="color: #666;"><fmt:formatDate value="${model.created_at}" pattern="dd/MM/yyyy HH:mm:ss"/></span>
            </div>
            <c:if test="${not empty model.updated_at}">
                <div class="form-group">
                    <label>Last Updated:</label>
                    <span style="color: #666;"><fmt:formatDate value="${model.updated_at}" pattern="dd/MM/yyyy HH:mm:ss"/></span>
                </div>
            </c:if>
        </c:if>
        
        <!-- Submit Buttons -->
        <div class="form-group" style="margin-top: 30px;">
            <c:choose>
                <c:when test="${not empty model && model.id > 0}">
                    <input type="submit" value="Update Model" class="btn btn-success">
                </c:when>
                <c:otherwise>
                    <input type="submit" value="Create Model" class="btn btn-primary">
                </c:otherwise>
            </c:choose>
            <a href="MainController?action=viewModelList" class="btn btn-secondary">Cancel</a>
        </div>
    </form>

    <!-- ===== JAVASCRIPT MỚI THÊM CHO IMAGE PREVIEW ===== -->
    <script>
        // Biến global để lưu trữ file đã chọn
        let selectedImageFile = null;
        
        // Event listener cho file input
        document.getElementById('imageFile').addEventListener('change', function(event) {
            handleImageSelection(event);
        });
        
        // Hàm xử lý khi user chọn ảnh
        function handleImageSelection(event) {
            const file = event.target.files[0];
            const previewContainer = document.getElementById('imagePreviewContainer');
            const imagePreview = document.getElementById('imagePreview');
            const previewInfo = document.getElementById('previewInfo');
            
            if (file) {
                // Validate file type
                const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/bmp', 'image/webp'];
                if (!allowedTypes.includes(file.type)) {
                    alert('⚠️ Please select a valid image file (JPG, PNG, GIF, BMP, WEBP)');
                    event.target.value = '';
                    return;
                }
                
                // Validate file size (5MB max)
                const maxSize = 5 * 1024 * 1024; // 5MB in bytes
                if (file.size > maxSize) {
                    alert('⚠️ File size exceeds 5MB limit. Please choose a smaller file.');
                    event.target.value = '';
                    return;
                }
                
                // Lưu file đã chọn
                selectedImageFile = file;
                
                // Tạo FileReader để đọc file
                const reader = new FileReader();
                
                reader.onload = function(e) {
                    // Tạo img element để hiển thị preview
                    imagePreview.innerHTML = `
                        <img src="${e.target.result}" 
                             alt="Image Preview" 
                             class="image-preview"
                             onload="this.style.opacity=1"
                             style="opacity:0; transition: opacity 0.3s ease;">
                    `;
                    
                    // Hiển thị thông tin file
                    const fileSizeKB = (file.size / 1024).toFixed(1);
                    const fileSizeMB = (file.size / (1024 * 1024)).toFixed(2);
                    const sizeDisplay = file.size > 1024 * 1024 ? `${fileSizeMB} MB` : `${fileSizeKB} KB`;
                    
                    previewInfo.innerHTML = `
                        <strong>📄 File:</strong> ${file.name}<br>
                        <strong>📏 Size:</strong> ${sizeDisplay}<br>
                        <strong>🖼️ Type:</strong> ${file.type}<br>
                        <strong>✅ Status:</strong> <span style="color: green;">Ready to upload</span>
                    `;
                    
                    // Hiển thị preview container
                    previewContainer.style.display = 'block';
                    previewContainer.scrollIntoView({ behavior: 'smooth', block: 'center' });
                };
                
                reader.onerror = function() {
                    alert('❌ Error reading file. Please try again.');
                    removeImagePreview();
                };
                
                // Đọc file như base64 data URL
                reader.readAsDataURL(file);
                
            } else {
                // Không có file được chọn
                removeImagePreview();
            }
        }
        
        // Hàm xóa preview
        function removeImagePreview() {
            const fileInput = document.getElementById('imageFile');
            const previewContainer = document.getElementById('imagePreviewContainer');
            const imagePreview = document.getElementById('imagePreview');
            const previewInfo = document.getElementById('previewInfo');
            
            // Reset file input
            fileInput.value = '';
            selectedImageFile = null;
            
            // Ẩn preview container
            previewContainer.style.display = 'none';
            
            // Reset nội dung
            imagePreview.innerHTML = '<div class="preview-placeholder">No image selected</div>';
            previewInfo.innerHTML = '';
            
            console.log('🗑️ Image preview removed');
        }
        
        // Hàm kiểm tra trước khi submit form
        function validateFormBeforeSubmit() {
            const fileInput = document.getElementById('imageFile');
            
            if (fileInput.files.length > 0) {
                const file = fileInput.files[0];
                console.log('📤 Form will be submitted with image:', file.name);
            } else {
                console.log('📤 Form will be submitted without new image');
            }
            
            return true; // Allow form submission
        }
        
        // Thêm event listener cho form submit
        document.querySelector('form').addEventListener('submit', function(e) {
            return validateFormBeforeSubmit();
        });
        
        // Hiệu ứng drag & drop (bonus feature)
        const previewContainer = document.getElementById('imagePreviewContainer');
        
        ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
            previewContainer.addEventListener(eventName, preventDefaults, false);
        });
        
        function preventDefaults(e) {
            e.preventDefault();
            e.stopPropagation();
        }
        
        ['dragenter', 'dragover'].forEach(eventName => {
            previewContainer.addEventListener(eventName, highlight, false);
        });
        
        ['dragleave', 'drop'].forEach(eventName => {
            previewContainer.addEventListener(eventName, unhighlight, false);
        });
        
        function highlight(e) {
            previewContainer.style.borderColor = '#007bff';
            previewContainer.style.backgroundColor = '#e3f2fd';
        }
        
        function unhighlight(e) {
            previewContainer.style.borderColor = '#007bff';
            previewContainer.style.backgroundColor = '#f8f9ff';
        }
        
        previewContainer.addEventListener('drop', handleDrop, false);
        
        function handleDrop(e) {
            const dt = e.dataTransfer;
            const files = dt.files;
            
            if (files.length > 0) {
                document.getElementById('imageFile').files = files;
                handleImageSelection({ target: { files: files } });
            }
        }
        
        console.log('🎨 Image preview functionality loaded successfully!');
    </script>
</body>
</html>