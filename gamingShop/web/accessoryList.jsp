<%-- 
    Document   : accessoryList
    Created on : Sep 12, 2025
    Author     : ddhuy
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Accessories List</title>
        <style>
            body { font-family: Arial, sans-serif; margin: 20px; }
            table { border-collapse: collapse; width: 100%; margin-top: 20px; }
            th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
            th { background-color: #f2f2f2; }
            .btn { padding: 5px 10px; margin: 2px; text-decoration: none; border: 1px solid #ccc; }
            .btn-edit { background-color: #4CAF50; color: white; }
            .btn-delete { background-color: #f44336; color: white; }
            .btn-add { background-color: #008CBA; color: white; }
            .error { color: red; margin: 10px 0; }
            .success { color: green; margin: 10px 0; }
            .price { font-weight: bold; color: #2196F3; }
            .status-active { color: green; font-weight: bold; }
            .status-inactive { color: red; font-weight: bold; }
            .status-out_of_stock { color: orange; font-weight: bold; }
            .search-form { margin: 10px 0; padding: 15px; background-color: #f9f9f9; border-radius: 5px; }
            .search-form input { padding: 8px; margin-right: 10px; border: 1px solid #ddd; border-radius: 4px; }
            .search-form button { padding: 8px 15px; background-color: #008CBA; color: white; border: none; border-radius: 4px; }
        </style>
    </head>
    <body>
        <h1>Accessories Management</h1>
        
        <!-- Search Form -->
        <div class="search-form">
            <form action="MainController" method="get">
                <input type="hidden" name="action" value="searchAccessory">
                <input type="text" name="keyword" placeholder="Search accessories..." value="${keyword}">
                <button type="submit">Search</button>
                <c:if test="${not empty keyword}">
                    <a href="MainController?action=viewAllAccessories" class="btn">Clear</a>
                </c:if>
            </form>
        </div>
        
        <!-- Add New Button -->
        <a href="MainController?action=showAddAccessoryForm" class="btn btn-add">Add New Accessory</a>
        
        <!-- Messages -->
        <c:if test="${not empty checkError}">
            <div class="error">${checkError}</div>
        </c:if>
        <c:if test="${not empty messageDeleteAccessory}">
            <div class="success">${messageDeleteAccessory}</div>
        </c:if>
        
        <!-- Search Results Info -->
        <c:if test="${not empty keyword}">
            <p style="color: #666; font-style: italic;">Search results for: "<strong>${keyword}</strong>"</p>
        </c:if>
        
        <!-- Accessories Table -->
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Description</th>
                    <th>Image</th>
                    <th>Quantity</th>
                    <th>Price</th>
                    <th>Status</th>
                    <th>Gift Type</th>
                    <th>Updated</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty accessories}">
                        <tr><td colspan="10" style="text-align: center;">No accessories found</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="accessory" items="${accessories}">
                            <tr>
                                <td>${accessory.id}</td>
                                <td><strong>${accessory.name}</strong></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty accessory.description}">
                                            <c:choose>
                                                <c:when test="${fn:length(accessory.description) > 50}">
                                                    ${fn:substring(accessory.description, 0, 50)}...
                                                </c:when>
                                                <c:otherwise>
                                                    ${accessory.description}
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise><em>No description</em></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty accessory.image_url}">
                                            <img src="${accessory.image_url}" alt="Accessory Image" 
                                                 style="width: 60px; height: 60px; object-fit: cover; border-radius: 4px;">
                                        </c:when>
                                        <c:otherwise><em>No image</em></c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="text-align: center; font-weight: bold;">
                                    ${accessory.quantity}
                                </td>
                                <td class="price">
                                    $<fmt:formatNumber value="${accessory.price}" pattern="#,##0.00"/>
                                </td>
                                <td>
                                    <span class="status-${accessory.status}">
                                        <c:choose>
                                            <c:when test="${accessory.status == 'active'}">Active</c:when>
                                            <c:when test="${accessory.status == 'inactive'}">Inactive</c:when>
                                            <c:when test="${accessory.status == 'out_of_stock'}">Out of Stock</c:when>
                                            <c:otherwise>${accessory.status}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${accessory.gift == 'Phụ kiện tặng kèm'}">
                                            <span style="background-color: #e8f5e8; padding: 2px 6px; border-radius: 3px; font-size: 12px; color: #2e7d2e;">
                                                Tặng kèm
                                            </span>
                                        </c:when>
                                        <c:when test="${accessory.gift == 'Phụ kiện bán'}">
                                            <span style="background-color: #fff3e0; padding: 2px 6px; border-radius: 3px; font-size: 12px; color: #e65100;">
                                                Phụ kiện bán
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="background-color: #f0f0f0; padding: 2px 6px; border-radius: 3px; font-size: 12px;">
                                                ${accessory.gift}
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <fmt:formatDate value="${accessory.updated_at}" pattern="dd/MM/yyyy"/>
                                </td>
                                <td>
                                    <a href="ProductController?action=showEditAccessoryForm&id=${accessory.id}" class="btn btn-edit">Edit</a>
                                    <a href="MainController?action=deleteAccessory&id=${accessory.id}" class="btn btn-delete" 
                                       onclick="return confirmDelete('${accessory.name}')">Delete</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
        
        <!-- Total count -->
        <p style="margin-top: 10px; color: #666;">
            Total: <strong>${fn:length(accessories)}</strong> accessory(s)
            <c:if test="${not empty totalAccessories}">
                (${totalAccessories} total in database)
            </c:if>
        </p>
        
        <!-- Simple Pagination -->
        <c:if test="${not empty totalPages && totalPages > 1}">
            <div style="margin-top: 20px; text-align: center;">
                <c:if test="${currentPage > 1}">
                    <a href="MainController?action=viewAllAccessories&page=${currentPage - 1}" class="btn">&laquo; Previous</a>
                </c:if>
                
                <span style="margin: 0 10px;">Page ${currentPage} of ${totalPages}</span>
                
                <c:if test="${currentPage < totalPages}">
                    <a href="MainController?action=viewAllAccessories&page=${currentPage + 1}" class="btn">Next &raquo;</a>
                </c:if>
            </div>
        </c:if>

        <script>
            function confirmDelete(accessoryName) {
                return confirm('Are you sure you want to delete accessory: ' + accessoryName + '?');
            }
            
            // Auto hide messages after 5 seconds
            setTimeout(function() {
                var errorDiv = document.querySelector('.error');
                var successDiv = document.querySelector('.success');
                if (errorDiv) errorDiv.style.display = 'none';
                if (successDiv) successDiv.style.display = 'none';
            }, 5000);
        </script>
    </body>
</html>