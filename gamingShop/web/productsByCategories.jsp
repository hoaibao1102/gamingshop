<%-- 
    Document   : productsByCategories
    Created on : Sep 12, 2025, 6:47:49 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Product list</title>
        <style>
            .Main_content {
                background: linear-gradient(180deg, #ffffff 0%, #f8fafc 100%);
                box-sizing: border-box;
                overflow-y: auto;
                border-radius: 20px;
                box-shadow: var(--card-shadow);
                position: relative;
            }
        </style>
    </head>
    <body>
        <!-- ====== Nội dung trang ====== -->
                <div class="container">

                    <c:choose>
                        <c:when test="${not empty list}">
                            <!-- Product Grid -->
                            <ul class="featured-list">
                                <c:forEach var="product" items="${list}">
                                    <c:if test="${product.status ne 'inactive'}">
                                        <li class="item">
                                            <form action="MainController" method="get" class="product-form">
                                                <input type="hidden" name="idProduct" value="${product.id}">
                                                <input type="hidden" name="action" value="getProduct">

                                                <button type="submit" class="product-button">
                                                    <div class="product-content">
                                                        <c:choose>
                                                            <c:when test="${not empty product.coverImg}">
                                                                <img class="thumb" src="${product.coverImg}" alt="${product.name}">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <img class="thumb" src="/assets/images/no-image.jpg" alt="No image available">
                                                            </c:otherwise>
                                                        </c:choose>

                                                        <div class="meta">
                                                            <span class="product-name">${product.name}</span>
                                                            <span class="product-price">
                                                                <fmt:formatNumber value="${product.price}" type="number" groupingUsed="true" maxFractionDigits="0" /> VND
                                                            </span>
                                                        </div>
                                                    </div>
                                                </button>
                                            </form>
                                        </li>
                                    </c:if>
                                </c:forEach>
                            </ul>
                            <!-- Pagination -->
                            <jsp:include page="pagination.jsp"/>
                            <!-- Pagination Section -->
                        </c:when>
                        <c:otherwise>
                            <!-- Empty State -->
                            <div class="empty-state">
                                <h3>Không tìm thấy sản phẩm</h3>
                                <p>Hiện tại không có sản phẩm nào phù hợp với tiêu chí tìm kiếm của bạn.</p>
                                <button onclick="resetFilter()" class="btn-filter">
                                    Xem tất cả sản phẩm
                                </button>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
    </body>
</html>
