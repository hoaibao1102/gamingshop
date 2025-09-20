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
        <%@ include file="/WEB-INF/jspf/head.jspf" %>
        <title>
            <c:choose>
                <c:when test="${not empty model && model.id > 0}">Edit Model</c:when>
                <c:otherwise>Add New Model</c:otherwise>
            </c:choose>
        </title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 20px;
            }
            .btn {
                padding: 8px 15px;
                margin: 5px;
                text-decoration: none;
                border: 1px solid #ccc;
                border-radius: 3px;
            }
            .btn-primary {
                background-color: #007bff;
                color: white;
                border-color: #007bff;
            }
            .btn-success {
                background-color: #28a745;
                color: white;
                border-color: #28a745;
            }
            .btn-secondary {
                background-color: #6c757d;
                color: white;
                border-color: #6c757d;
            }
            .form-group {
                margin: 15px 0;
            }
            .form-group label {
                display: block;
                margin-bottom: 5px;
                font-weight: bold;
            }
            .form-group input, .form-group textarea, .form-group select {
                width: 400px;
                padding: 8px;
                border: 1px solid #ddd;
                border-radius: 3px;
            }
            textarea {
                height: 120px;
                resize: vertical;
                font-family: inherit;
            }
            .error {
                color: red;
                padding: 10px;
                background-color: #ffe6e6;
                border: 1px solid #ff0000;
                margin: 10px 0;
            }
            .success {
                color: green;
                padding: 10px;
                background-color: #e6ffe6;
                border: 1px solid #00aa00;
                margin: 10px 0;
            }
            .required {
                color: red;
            }
            .help-text {
                font-size: 12px;
                color: #666;
                margin-top: 3px;
            }
            .current-image {
                border: 1px solid #ddd;
                padding: 10px;
                margin: 10px 0;
                background-color: #f9f9f9;
            }

            /* Updated image preview styles to match accessory */
            .image-preview {
                max-width: 200px;
                max-height: 200px;
                border-radius: 8px;
                border: 2px dashed #dee2e6;
                padding: 10px;
                margin-top: 10px;
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

            <!-- Image Upload -->
            <div class="form-group">
                <label for="imageFile">
                    <c:choose>
                        <c:when test="${not empty model && not empty model.image_url}">Upload New Image:</c:when>
                        <c:otherwise>Upload Image:</c:otherwise>
                    </c:choose>
                </label>
                <input type="file" id="imageFile" name="imageFile" accept="image/*" onchange="previewImage(this)">
                <div class="help-text">
                    Supported formats: JPG, JPEG, PNG, GIF, BMP, WEBP | Maximum file size: 5MB
                    <c:if test="${not empty model && not empty model.image_url}">
                        <br><strong>Leave empty to keep current image</strong>
                    </c:if>
                </div>
                <div id="imagePreview"></div>
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

        <!-- Updated JavaScript to match accessory preview -->
        <script>
            // Image preview function (matching accessory style)
            function previewImage(input) {
                const preview = document.getElementById('imagePreview');
                preview.innerHTML = '';

                if (input.files && input.files[0]) {
                    const reader = new FileReader();
                    reader.onload = function (e) {
                        const img = document.createElement('img');
                        img.src = e.target.result;
                        img.className = 'image-preview img-thumbnail';
                        img.alt = 'New image preview';
                        preview.appendChild(img);
                    }
                    reader.readAsDataURL(input.files[0]);
                }
            }
        </script>
    </body>
</html>