<%-- 
    Document   : serviceUpdate
    Created on : Sep 16, 2025
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
                <c:when test="${not empty service && service.id > 0}">Edit Service</c:when>
                <c:otherwise>Add New Service</c:otherwise>
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
            .price-input {
                position: relative;
            }
            .currency-symbol {
                position: absolute;
                left: 10px;
                top: 50%;
                transform: translateY(-50%);
                color: #666;
                pointer-events: none;
            }
            .price-input input {
                padding-left: 25px;
            }
        </style>
    </head>
    <body>
        <h1>
            <c:choose>
                <c:when test="${not empty service && service.id > 0}">Edit Service: ${service.service_type}</c:when>
                <c:otherwise>Add New Service</c:otherwise>
            </c:choose>
        </h1>

        <!-- Navigation -->
        <a href="MainController?action=viewServiceList" class="btn btn-secondary">← Back to Services List</a>

        <!-- Messages -->
        <c:if test="${not empty checkErrorAddService}">
            <div class="error">${checkErrorAddService}</div>
        </c:if>
        <c:if test="${not empty checkErrorEditService}">
            <div class="error">${checkErrorEditService}</div>
        </c:if>
        <c:if test="${not empty checkErrorServiceDetail}">
            <div class="error">${checkErrorServiceDetail}</div>
        </c:if>
        <c:if test="${not empty messageAddService}">
            <div class="success">${messageAddService}</div>
        </c:if>
        <c:if test="${not empty messageEditService}">
            <div class="success">${messageEditService}</div>
        </c:if>

        <!-- Form -->
        <form method="post" action="MainController">
            <!-- Action & ID -->
            <c:choose>
                <c:when test="${not empty service && service.id > 0}">
                    <input type="hidden" name="action" value="editService">
                    <input type="hidden" name="id" value="${service.id}">
                </c:when>
                <c:otherwise>
                    <input type="hidden" name="action" value="addService">
                </c:otherwise>
            </c:choose>

            <!-- Service Type -->
            <div class="form-group">
                <label for="service_type">Service Type <span class="required">*</span></label>
                <input type="text" id="service_type" name="service_type" 
                       value="${service != null ? service.service_type : ''}" 
                       placeholder="e.g., Screen Repair, Battery Replacement, Water Damage Repair" 
                       required maxlength="100">
                <div class="help-text">Unique name for this service (max 100 characters)</div>
            </div>

            <!-- Price -->
            <div class="form-group">
                <label for="price">Price <span class="required">*</span></label>
                <div class="price-input">
                    <span class="currency-symbol">$</span>
                    <input type="number" id="price" name="price" 
                           value="${service != null ? service.price : ''}" 
                           placeholder="0.00" 
                           step="0.01" min="0" max="999999999.99"
                           required>
                </div>
                <div class="help-text">Service price in USD (e.g., 29.99)</div>
            </div>

            <!-- Description -->
            <div class="form-group">
                <label for="description_html">Description</label>
                <textarea id="description_html" name="description_html" 
                          placeholder="Enter detailed description of the service. HTML tags are supported for formatting.">${not empty service ? service.description_html : ''}</textarea>
                <div class="help-text">Detailed description of the service (HTML supported, max 10,000 characters)</div>
            </div>

            <!-- Status -->
            <div class="form-group">
                <label for="status">Status</label>
                <select id="status" name="status">
                    <option value="active" ${(service != null || service.status == 'active') ? 'selected' : ''}>Active</option>
                    <option value="inactive" ${service.status == 'inactive' ? 'selected' : ''}>Inactive</option>
                </select>
                <div class="help-text">Only active services are shown in service listings</div>
            </div>

            <!-- Current Service Details (Edit Mode) -->
            <c:if test="${service != null && service.id > 0}">
                <div class="form-group">
                    <label>Service ID:</label>
                    <span style="color: #666; font-weight: normal;">#${service.id}</span>
                </div>
                
                <div class="form-group">
                    <label>Current Price:</label>
                    <span style="color: #28a745; font-weight: bold; font-size: 16px;">
                        $<fmt:formatNumber value="${service.price}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                    </span>
                </div>
            </c:if>

            <!-- Timestamps (Edit Mode) -->
            <c:if test="${service != null && service.id > 0}">
                <div class="form-group">
                    <label>Created:</label>
                    <span style="color: #666;"><fmt:formatDate value="${service.created_at}" pattern="dd/MM/yyyy HH:mm:ss"/></span>
                </div>
                <c:if test="${not empty service.updated_at}">
                    <div class="form-group">
                        <label>Last Updated:</label>
                        <span style="color: #666;"><fmt:formatDate value="${service.updated_at}" pattern="dd/MM/yyyy HH:mm:ss"/></span>
                    </div>
                </c:if>
            </c:if>

            <!-- Submit Buttons -->
            <div class="form-group" style="margin-top: 30px;">
                <c:choose>
                    <c:when test="${service != null && service.id > 0}">
                        <input type="submit" value="Update Service" class="btn btn-success">
                    </c:when>
                    <c:otherwise>
                        <input type="submit" value="Create Service" class="btn btn-primary">
                    </c:otherwise>
                </c:choose>
                <a href="MainController?action=viewServiceList" class="btn btn-secondary">Cancel</a>
            </div>
        </form>

        <script>
            // Form validation
            document.querySelector('form').addEventListener('submit', function(e) {
                const serviceType = document.getElementById('service_type').value.trim();
                const price = document.getElementById('price').value;
                
                if (!serviceType) {
                    alert('Service type is required.');
                    e.preventDefault();
                    return;
                }
                
                if (!price || parseFloat(price) < 0) {
                    alert('Please enter a valid price.');
                    e.preventDefault();
                    return;
                }
                
                if (parseFloat(price) > 999999999.99) {
                    alert('Price is too large. Maximum allowed is $999,999,999.99');
                    e.preventDefault();
                    return;
                }
            });

            // Price input formatting
            document.getElementById('price').addEventListener('blur', function() {
                const value = parseFloat(this.value);
                if (!isNaN(value) && value >= 0) {
                    this.value = value.toFixed(2);
                }
            });
        </script>
    </body>
</html>
