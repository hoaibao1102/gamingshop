<%-- 
    Document   : productDetail
    Created on : 12-09-2025, 17:24:22
    Author     : MSI PC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN" />
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <jsp:include page="header.jsp"/>
        <div class="custom-breadcrumb">
                    <i class="fas fa-home me-2"></i>
                    <a href="MainController?action=prepareHome">Trang chủ</a>
                    <i class="fas fa-chevron-right mx-2"></i>
                    <a href="placeController?action=destination&page=destinationjsp">Điểm đến</a>
                    <i class="fas fa-chevron-right mx-2"></i>
                    <a href="placeController?action=takeListTicket&location=${tourTicket.destination}">Du lịch ${tourTicket.destination}</a>
                    <i class="fas fa-chevron-right mx-2"></i>
                    <span class="current">Chi tiết tour</span>
        </div>
        <c:choose>
            <c:when test="${not empty productDetail}">
                Anh san pham<br>
                <c:forEach var="img" items="${productDetail.image}">
                    <img src="${img.image_url}" alt="alt"/>
                </c:forEach><br>
                ${productDetail.name}</br>
                ${productDetail.sku}</br>
                <fmt:formatNumber value="${productDetail.price}" type="number" groupingUsed="true" maxFractionDigits="0" /> VND</br>
                ${productDetail.product_type}</br>
                bao hanh: ${guaranteeProduct}</br>
                bo nho  : ${memoryProduct}</br>
                ${productDetail.description_html}</br>
              
              
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
    </body>
</html>
