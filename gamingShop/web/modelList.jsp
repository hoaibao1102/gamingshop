<%-- 
    Document   : modelList
    Created on : Sep 14, 2025, 9:43:50 PM
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
    <title>Models List</title>
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
    </style>
</head>
<body>
    <h1>Models Management</h1>
    
    <!-- Add New Button -->
    <a href="MainController?action=addModel" class="btn btn-add">Add New Model</a>
    
    <!-- Messages -->
    <c:if test="${not empty checkErrorModelList}">
        <div class="error">${checkErrorModelList}</div>
    </c:if>
    <c:if test="${not empty messageDeleteModel}">
        <div class="success">${messageDeleteModel}</div>
    </c:if>
    
    <!-- Models Table -->
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Model Type</th>
                <th>Description</th>
                <th>Image</th>
                <th>Status</th>
                <th>Created</th>
                <th>Updated</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${empty modelList}">
                    <tr><td colspan="8" style="text-align: center;">No models found</td></tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="model" items="${modelList}">
                        <tr>
                            <td>${model.id}</td>
                            <td><strong>${model.model_type}</strong></td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty model.description_html}">
                                        ${fn:substring(model.description_html, 0, 80)}...
                                    </c:when>
                                    <c:otherwise><em>No description</em></c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty model.image_url}">
                                        <img src="${model.image_url}" alt="Model Image" 
                                             style="width: 60px; height: 60px; object-fit: cover; border-radius: 4px;">
                                    </c:when>
                                    <c:otherwise><em>No image</em></c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <span style="color: ${model.status == 'active' ? 'green' : 'red'}; font-weight: bold;">
                                    ${model.status}
                                </span>
                            </td>
                            <td><fmt:formatDate value="${model.created_at}" pattern="dd/MM/yyyy"/></td>
                            <td><fmt:formatDate value="${model.updated_at}" pattern="dd/MM/yyyy"/></td>
                            <td>
                                <a href="MainController?action=showEditModel&id=${model.id}" class="btn btn-edit">Edit</a>
                                <c:if test="${model.status == 'active'}">
                                    <a href="MainController?action=deleteModel&id=${model.id}" class="btn btn-delete" 
                                       onclick="return confirm('Deactivate model: ${model.model_type}?')">Delete</a>
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
        Total: <strong>${fn:length(modelList)}</strong> model(s)
    </p>
</body>
</html>
