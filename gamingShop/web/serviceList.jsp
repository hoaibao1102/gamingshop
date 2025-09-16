<%-- 
    Document   : serviceList
    Created on : Sep 16, 2025
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
        <title>Services List</title>
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
        </style>
    </head>
    <body>
        <h1>Services Management</h1>
        
        <!-- Add New Button -->
        <a href="MainController?action=showAddService" class="btn btn-add">Add New Service</a>
        
        <!-- Messages -->
        <c:if test="${not empty checkErrorServiceList}">
            <div class="error">${checkErrorServiceList}</div>
        </c:if>
        <c:if test="${not empty messageDeleteService}">
            <div class="success">${messageDeleteService}</div>
        </c:if>
        
        <!-- Services Table -->
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Service Name</th>
                    <th>Description</th>
                    <th>Price</th>
                    <th>Status</th>
                    <th>Created</th>
                    <th>Updated</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty serviceList}">
                        <tr><td colspan="11" style="text-align: center;">No services found</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="service" items="${serviceList}">
                            <tr>
                                <td>${service.id}</td>
                                <td><strong>${service.service_type}</strong></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty service.description_html}">
                                            ${fn:substring(service.description_html, 0, 80)}...
                                        </c:when>
                                        <c:otherwise><em>No description</em></c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="price">
                                    <fmt:formatNumber value="${service.price}" type="currency" 
                                                    currencySymbol="$" maxFractionDigits="0"/>
                                </td>
                                <td>
                                    <span style="color: ${service.status == 'active' ? 'green' : 'red'}; font-weight: bold;">
                                        ${service.status}
                                    </span>
                                </td>
                                <td><fmt:formatDate value="${service.created_at}" pattern="dd/MM/yyyy"/></td>
                                <td><fmt:formatDate value="${service.updated_at}" pattern="dd/MM/yyyy"/></td>
                                <td>
                                    <a href="MainController?action=showEditService&id=${service.id}" class="btn btn-edit">Edit</a>
                                    <c:if test="${service.status == 'active'}">
                                        <a href="MainController?action=deleteService&id=${service.id}" class="btn btn-delete" 
                                           onclick="return confirm('Deactivate service: ${service.service_type}?')">Delete</a>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
        
        <!-- Total count -->
        <p style="margin-top: 10px; color: #666;">
            Total: <strong>${fn:length(serviceList)}</strong> service(s)
        </p>
    </body>
</html>