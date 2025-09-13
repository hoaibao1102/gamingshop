<%-- 
    Document   : accessoriesUpdate
    Created on : Sep 10, 2025, 6:32:13 PM
    Author     : ddhuy
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${accessory != null ? 'Edit' : 'Add New'} Accessory</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            .form-container {
                max-width: 800px;
                margin: 2rem auto;
                padding: 2rem;
                background: #fff;
                border-radius: 10px;
                box-shadow: 0 0 20px rgba(0,0,0,0.1);
            }
            .image-preview {
                max-width: 200px;
                max-height: 200px;
                border-radius: 8px;
                border: 2px dashed #dee2e6;
                padding: 10px;
                margin-top: 10px;
            }
            .btn-custom {
                padding: 12px 30px;
                border-radius: 25px;
                font-weight: 600;
            }
            .alert-custom {
                border-radius: 10px;
                border: none;
                padding: 15px 20px;
            }
        </style>
    </head>
    <body class="bg-light">
        <div class="container-fluid">
            <!-- Header -->
            <div class="row">
                <div class="col-12">
                    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
                        <div class="container">
                            <a class="navbar-brand" href="#"><i class="fas fa-cogs me-2"></i>Accessory Management</a>
                            <div class="navbar-nav ms-auto">
                                <a class="nav-link" href="MainController?action=viewAllAccessories">
                                    <i class="fas fa-list me-1"></i>Back to List
                                </a>
                            </div>
                        </div>
                    </nav>
                </div>
            </div>

            <!-- Main Content -->
            <div class="form-container">
                <div class="text-center mb-4">
                    <h2 class="fw-bold">
                        <i class="fas ${accessory != null ? 'fa-edit' : 'fa-plus'} me-2"></i>
                        ${accessory != null ? 'Edit Accessory' : 'Add New Accessory'}
                    </h2>
                </div>

                <!-- Success Messages -->
                <c:if test="${not empty messageAddAccessory}">
                    <div class="alert alert-success alert-custom alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${messageAddAccessory}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${not empty messageEditAccessory}">
                    <div class="alert alert-success alert-custom alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${messageEditAccessory}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Error Messages -->
                <c:if test="${not empty checkErrorAddAccessory}">
                    <div class="alert alert-danger alert-custom alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>${checkErrorAddAccessory}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${not empty checkErrorEditAccessory}">
                    <div class="alert alert-danger alert-custom alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>${checkErrorEditAccessory}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Form -->
                <form action="MainController" method="post" enctype="multipart/form-data" class="needs-validation" novalidate>
                    <input type="hidden" name="action" value="${accessory != null ? 'editAccessory' : 'addAccessory'}">
                    <c:if test="${accessory != null}">
                        <input type="hidden" name="id" value="${accessory.id}">
                    </c:if>

                    <div class="row">
                        <!-- Left Column -->
                        <div class="col-md-6">
                            <!-- Accessory Name -->
                            <div class="mb-3">
                                <label for="name" class="form-label fw-semibold">
                                    <i class="fas fa-tag me-2"></i>Accessory Name <span class="text-danger">*</span>
                                </label>
                                <input type="text" class="form-control" id="name" name="name" 
                                       value="${accessory != null ? accessory.name : ''}" 
                                       placeholder="Enter accessory name" required>
                                <div class="invalid-feedback">
                                    Please provide a valid accessory name.
                                </div>
                            </div>

                            <!-- Quantity -->
                            <div class="mb-3">
                                <label for="quantity" class="form-label fw-semibold">
                                    <i class="fas fa-boxes me-2"></i>Quantity <span class="text-danger">*</span>
                                </label>
                                <input type="number" class="form-control" id="quantity" name="quantity" 
                                       value="${accessory != null ? accessory.quantity : ''}" 
                                       placeholder="Enter quantity" min="0" step="0.01" required>
                                <div class="invalid-feedback">
                                    Please provide a valid quantity.
                                </div>
                            </div>

                            <!-- Price -->
                            <div class="mb-3">
                                <label for="price" class="form-label fw-semibold">
                                    <i class="fas fa-dollar-sign me-2"></i>Price <span class="text-danger">*</span>
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text">$</span>
                                    <input type="number" class="form-control" id="price" name="price" 
                                           value="${accessory != null ? accessory.price : ''}" 
                                           placeholder="0.00" min="0" step="0.01" required>
                                    <div class="invalid-feedback">
                                        Please provide a valid price.
                                    </div>
                                </div>
                            </div>

                            <!-- Status -->
                            <div class="mb-3">
                                <label for="status" class="form-label fw-semibold">
                                    <i class="fas fa-toggle-on me-2"></i>Status
                                </label>
                                <select class="form-select" id="status" name="status">
                                    <option value="active" ${accessory != null && accessory.status == 'active' ? 'selected' : ''}>Active</option>
                                    <option value="inactive" ${accessory != null && accessory.status == 'inactive' ? 'selected' : ''}>Inactive</option>
                                    <option value="out_of_stock" ${accessory != null && accessory.status == 'out_of_stock' ? 'selected' : ''}>Out of Stock</option>
                                </select>
                            </div>
                            <!-- Gift -->
                            <div class="mb-3">
                                <label for="gift" class="form-label fw-semibold">
                                    <i class="fas fa-toggle-on me-2"></i>Gift
                                </label>
                                <select class="form-select" id="gift" name="gift">
                                    <option value="Phụ kiện tặng kèm" ${accessory != null && accessory.gift == 'Phụ kiện tặng kèm' ? 'selected' : ''}>Phụ kiện tặng kèm</option>
                                    <option value="Phụ kiện bán" ${accessory != null && accessory.gift == 'Phụ kiện bán' ? 'selected' : ''}>Phụ kiện bán</option>
                                    <option value="more" ${accessory != null && accessory.status == 'more' ? 'selected' : ''}>If u want u can add more</option>
                                </select>
                            </div>
                        </div>

                        <!-- Right Column -->
                        <div class="col-md-6">
                            <!-- Description -->
                            <div class="mb-3">
                                <label for="description" class="form-label fw-semibold">
                                    <i class="fas fa-align-left me-2"></i>Description
                                </label>
                                <textarea class="form-control" id="description" name="description" 
                                          rows="4" placeholder="Enter accessory description">${accessory != null ? accessory.description : ''}</textarea>
                            </div>

                            <!-- Current Image Display -->
                            <c:if test="${accessory != null && not empty accessory.image_url}">
                                <div class="mb-3">
                                    <label class="form-label fw-semibold">
                                        <i class="fas fa-image me-2"></i>Current Image
                                    </label>
                                    <div>
                                        <img src="${accessory.image_url}" alt="Current accessory image" 
                                             class="image-preview img-thumbnail">
                                    </div>
                                </div>
                            </c:if>

                            <!-- Image Upload -->
                            <div class="mb-3">
                                <label for="imageFile" class="form-label fw-semibold">
                                    <i class="fas fa-upload me-2"></i>${accessory != null ? 'Change' : 'Upload'} Image
                                </label>
                                <input type="file" class="form-control" id="imageFile" name="imageFile" 
                                       accept="image/*" onchange="previewImage(this)">
                                <small class="form-text text-muted">
                                    Supported formats: JPG, PNG, GIF (Max: 10MB)
                                </small>
                                <div id="imagePreview" class="mt-2"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="row mt-4">
                        <div class="col-12 text-center">
                            <button type="submit" class="btn btn-success btn-custom me-3">
                                <i class="fas ${accessory != null ? 'fa-save' : 'fa-plus'} me-2"></i>
                                ${accessory != null ? 'Update Accessory' : 'Add Accessory'}
                            </button>
                            <a href="MainController?action=viewAllAccessories" class="btn btn-secondary btn-custom">
                                <i class="fas fa-times me-2"></i>Cancel
                            </a>
                        </div>
                    </div>
                </form>

                <!-- Accessory Info (for edit mode) -->
                <c:if test="${accessory != null}">
                    <div class="mt-4 p-3 bg-light rounded">
                        <h6 class="fw-bold mb-2"><i class="fas fa-info-circle me-2"></i>Accessory Information</h6>
                        <div class="row">
                            <div class="col-md-6">
                                <small class="text-muted">ID: <strong>${accessory.id}</strong></small><br>
                                <small class="text-muted">Created: 
                                    <strong><fmt:formatDate value="${accessory.created_at}" pattern="dd/MM/yyyy HH:mm"/></strong>
                                </small>
                            </div>
                            <div class="col-md-6">
                                <small class="text-muted">Last Updated: 
                                    <strong><fmt:formatDate value="${accessory.updated_at}" pattern="dd/MM/yyyy HH:mm"/></strong>
                                </small>
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                           // Image preview function
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

                                           // Form validation
                                           (function () {
                                               'use strict';
                                               window.addEventListener('load', function () {
                                                   const forms = document.getElementsByClassName('needs-validation');
                                                   Array.prototype.filter.call(forms, function (form) {
                                                       form.addEventListener('submit', function (event) {
                                                           if (form.checkValidity() === false) {
                                                               event.preventDefault();
                                                               event.stopPropagation();
                                                           }
                                                           form.classList.add('was-validated');
                                                       }, false);
                                                   });
                                               }, false);
                                           })();

                                           // Auto hide alerts after 5 seconds
                                           setTimeout(function () {
                                               const alerts = document.querySelectorAll('.alert');
                                               alerts.forEach(function (alert) {
                                                   const bsAlert = new bootstrap.Alert(alert);
                                                   bsAlert.close();
                                               });
                                           }, 5000);
        </script>
    </body>
</html>