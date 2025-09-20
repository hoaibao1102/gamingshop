<%-- 
    Document   : products
    Created on : Sep 2, 2025, 12:36:54 PM
    Author     : ADMIN
    Description: Trang quản trị sản phẩm — đồng bộ layout với trang chủ
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:setLocale value="vi_VN" />

<%@page import="dto.Accounts" %>
<%@page import="utils.AuthUtils" %>
<%@page import="java.util.List" %>
<%@page import="dto.Products" %>
<%@page import="dto.Product_images" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <%@ include file="/WEB-INF/jspf/head.jspf" %>
        <title>Gaming Shop — Quản lý sản phẩm</title>

        <!-- Swiper CSS (nếu cần cho banner nội bộ) -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
        <!-- Main CSS đồng bộ với trang chủ -->
        <link rel="stylesheet" href="assets/css/maincss.css" />

        <style>
            /* --- Chỉ bổ sung vài style cho trang quản trị (không phá vỡ maincss.css) --- */
            .admin-toolbar {
                display: flex;
                flex-wrap: wrap;
                align-items: center;
                gap: 12px;
                padding: 16px;
                background: #f3f4f6;
                border-radius: 12px;
                box-shadow: 0 6px 18px rgba(0,0,0,.1);
            }
            .admin-toolbar .title {
                font-size: 20px;
                font-weight: 700;
                color: #111827;
                margin-right: auto;
            }
            .admin-toolbar .search-form {
                display: flex;
                gap: 8px;
                align-items: center;
            }
            .admin-toolbar input[type="text"] {
                height: 40px;
                border-radius: 10px;
                border: 1px solid #d1d5db;
                background: #fff;
                color: #111827;
                padding: 0 12px;
                min-width: 280px;
            }
            .admin-toolbar .btn {
                height: 40px;
                border: 0;
                border-radius: 10px;
                padding: 0 14px;
                font-weight: 600;
                cursor: pointer;
            }
            .btn-primary {
                background: #2563eb;
                color: #fff;
            }
            .btn-secondary {
                background: #6b7280;
                color: #fff;
            }
            .btn-danger {
                background: #dc2626;
                color: #fff;
            }

            .products-card {
                margin-top: 16px;
                background: #fff;
                border: 1px solid #e5e7eb;
                border-radius: 16px;
                overflow: hidden;
            }
            .products-meta {
                display: flex;
                flex-wrap: wrap;
                gap: 8px;
                padding: 12px 16px;
                border-bottom: 1px solid #e5e7eb;
                background: #f9fafb;
            }
            .meta-pill {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 6px 10px;
                border-radius: 999px;
                font-size: 12px;
                background: #f3f4f6;
                color: #374151;
                border: 1px dashed #d1d5db;
            }
            .meta-pill .dot {
                width: 8px;
                height: 8px;
                border-radius: 999px;
                background: #22c55e;
            }

            .table-wrap {
                width: 100%;
                overflow: auto;
                background: #ffffff;
                border: 1px solid #e5e7eb;
                border-radius: 12px;
            }
            table.products {
                width: 100%;
                border-collapse: separate;
                border-spacing: 0;
                background: #ffffff;
                color: #111111;
            }
            table.products thead th {
                position: sticky;
                top: 0;
                background: #ffffff;
                color: #111111;
                text-align: left;
                font-weight: 700;
                padding: 12px 14px;
                border-bottom: 1px solid #e5e7eb;
                z-index: 1;
            }
            table.products tbody td {
                padding: 12px 14px;
                border-bottom: 1px solid #f1f5f9;
                color: #111111;
                vertical-align: top;
            }
            .prod-thumb {
                width: 72px;
                height: 72px;
                border-radius: 10px;
                object-fit: cover;
                border: 1px solid #d1d5db;
                background: #f9fafb;
            }
            .prod-name {
                font-weight: 700;
            }
            .prod-sku {
                font-size: 12px;
                opacity: .7;
            }
            .status-pill {
                display:inline-flex;
                align-items:center;
                gap:6px;
                padding:4px 10px;
                border-radius:999px;
                font-size:12px;
            }
            .status-active {
                background:#dcfce7;
                color:#166534;
                border:1px solid #16a34a;
            }

            .status-prominent {
                background:#DDA0DD;
                color:#166534;
                border:1px solid #16a34a;
            }

            .status-inactive {
                background:#fee2e2;
                color:#991b1b;
                border:1px solid #ef4444;
            }
            .row-actions .btn {
                height: 36px;
                padding: 0 16px;
                border-radius: 8px;
                font-size: 14px;
                font-weight: 600;
                color: #fff;
                border: none;
                cursor: pointer;
                transition: all 0.2s ease;
            }
            .row-actions .btn-secondary {
                background-color: #3b82f6; /* xanh dương */
            }
            .row-actions .btn-secondary:hover {
                background-color: #1d4ed8;
            }
            .row-actions .btn-danger {
                background-color: #ef4444; /* đỏ */
            }
            .row-actions .btn-danger:hover {
                background-color: #b91c1c;
            }
            .row-actions {
                display: flex;
                gap: 8px;
                justify-content: center;
            }


            /* Style lại nút tìm kiếm */
            .admin-toolbar .btn-primary {
                background-color: #2563eb;
                color: #fff;
                border: none;
                border-radius: 8px;
                padding: 0 16px;
                transition: all 0.2s ease;
            }
            .admin-toolbar .btn-primary:hover {
                background-color: #1d4ed8;
            }
            .admin-toolbar .btn-secondary {
                background-color: #6b7280;
                color: #fff;
                border: none;
                border-radius: 8px;
                padding: 0 16px;
                transition: all 0.2s ease;
                text-decoration: none;
            }
            .admin-toolbar .btn-secondary:hover {
                background-color: #4b5563;
            }

            .empty-state {
                text-align:center;
                padding: 48px 16px;
            }
            .empty-state h3 {
                color:#111827;
                margin-bottom:8px;
            }
            .empty-state p {
                color:#6b7280;
                margin-bottom:12px;
            }

            .alert {
                padding: 12px 14px;
                border-radius: 10px;
                margin-top: 12px;
            }
            .alert-success {
                background:#dcfce7;
                color:#166534;
                border:1px solid #16a34a;
            }
            .alert-danger {
                background:#fee2e2;
                color:#991b1b;
                border:1px solid #ef4444;
            }

            /* Pagination (tận dụng include nếu có) */
            .pagination-wrap {
                padding: 16px;
                display:flex;
                justify-content:center;
            }

            /* Zebra rows + hover */
            table.products tbody tr:nth-child(even) {
                background: #fafafa;
            }
            table.products tbody tr:hover {
                background: #f5f5f5;
            }

            /* Responsive */
            @media (max-width: 768px){
                .admin-toolbar .search-form {
                    width: 100%;
                }
                .admin-toolbar input[type="text"] {
                    flex: 1;
                    min-width: 0;
                }
                .table-wrap {
                    border-radius: 0;
                }
            }
        </style>
    </head>
    <body>
        <div class="wrapper">
            <div class="sidebar">
                <jsp:include page="sidebar.jsp"/>
            </div>

            <div class="Main_content">
                <jsp:include page="header.jsp"/>

                <!-- ===== Marquee dùng lại từ trang chủ để đồng bộ thông điệp ===== -->
                <div class="marquee-bar">
                    <div class="marquee-inner">
                        <span class="marquee-item"><span class="badge">ADMIN</span> Quản lý sản phẩm — thêm/sửa/xóa nhanh</span>
                        <span class="marquee-item"><span class="badge">TIP</span> Nhập tên sản phẩm để lọc chính xác</span>
                        <span class="marquee-item"><a href="MainController?action=getAllProducts">Làm mới danh sách →</a></span>
                    </div>
                </div>

                <div class="container">
                    <div class="admin-toolbar">
                        <div class="title">Danh sách sản phẩm</div>
                        <form action="MainController" method="post" class="search-form" autocomplete="off">
                            <input type="hidden" name="action" value="searchProduct"/>
                            <input type="text" name="keyword" value="${keyword != null ? keyword : ''}" placeholder="Nhập tên sản phẩm..." />
                            <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                        </form>

                        <form action="MainController" method="post" class="search-form" autocomplete="off">
                            <input type="hidden" name="action" value="showAddProductForm"/>
                            <button type="submit" class="btn btn-primary">+ Thêm sản phẩm</button>
                        </form>
                    </div>

                    <!-- Thông báo hệ thống -->
                    <c:if test="${not empty messageDeleteProduct}">
                        <div class="alert alert-success">${messageDeleteProduct}</div>
                    </c:if>
                    <c:if test="${not empty checkErrorDeleteProduct}">
                        <div class="alert alert-danger">${checkErrorDeleteProduct}</div>
                    </c:if>
                    <c:if test="${not empty checkErrorSearch}">
                        <div class="alert alert-danger">${checkErrorSearch}</div>
                    </c:if>
                    <c:if test="${not empty messageUpdateProductImage}">
                        <div class="alert alert-success">${messageUpdateProductImage}</div>
                    </c:if>
                    <c:if test="${not empty checkErrorUpdateProductImage}">
                        <div class="alert alert-danger">${checkErrorUpdateProductImage}</div>
                    </c:if>

                    <!-- Meta: tổng số, từ khóa, người đăng nhập -->
                    <div class="products-card">
                        <div class="products-meta">
                            <span class="meta-pill"><span class="dot"></span><b>Từ khóa:</b>&nbsp;${keyword != null && fn:length(keyword) > 0 ? keyword : '—'}</span>
                            <span class="meta-pill"><b>Tổng:</b>&nbsp;<c:choose>
                                    <c:when test="${not empty list}">${fn:length(list)}</c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose> sản phẩm</span>
                        </div>

                        <!-- Bảng sản phẩm -->
                        <c:choose>
                            <c:when test="${not empty list}">
                                <div class="table-wrap">
                                    <table class="products">
                                        <thead>
                                            <tr>
                                                <th>Ảnh</th>
                                                <th>ID</th>
                                                <th>Tên sản phẩm</th>
                                                <th>SKU</th>
                                                <th>Giá</th>
                                                <th>Loại</th>
                                                <th>Tồn kho</th>
                                                <th>Trạng thái</th>
                                                <th>Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="p" items="${list}">
                                                <tr>
                                                    <td>
                                                        <c:set var="imgUrl" value="">
                                                        </c:set>
                                                        <%
                                                          // Lấy ảnh đầu tiên nếu có
                                                          List<Product_images> imgs;
                                                          Products pp;
                                                          try {
                                                            pp = (Products) pageContext.findAttribute("p");
                                                            imgs = (pp != null) ? pp.getImage() : null;
                                                          } catch(Exception e){ imgs = null; }
                                                          String iUrl = (imgs != null && !imgs.isEmpty() && imgs.get(0) != null && imgs.get(0).getImage_url() != null && !imgs.get(0).getImage_url().isEmpty())
                                                            ? imgs.get(0).getImage_url()
                                                            : "assets/img/no-image.png";
                                                        %>
                                                        <img class="prod-thumb" src="<%= iUrl %>" alt="${p.name}" />
                                                    </td>
                                                    <td>${p.id}</td>
                                                    <td>
                                                        <div class="prod-name">${p.name}</div>
                                                        <div class="prod-sku">#${p.id}</div>
                                                    </td>
                                                    <td>${p.sku}</td>
                                                    <td>
                                                        <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true" maxFractionDigits="0" /> VND
                                                    </td>
                                                    <td>
                                                        <c:if test="${p.product_type == 'new'}">New</c:if>
                                                        <c:if test="${p.product_type == 'used'}">Like new</c:if>
                                                        </td>
                                                        <td>${p.quantity}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${p.status eq 'active'}">
                                                                <span class="status-pill status-active">Đang bán</span>
                                                            </c:when>
                                                            <c:when test="${p.status eq 'prominent'}">
                                                                <span class="status-pill status-prominent">Nổi bật</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="status-pill status-inactive">Ngừng</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <div class="row-actions">
                                                            <form action="MainController" method="post" style="display:inline;">
                                                                <input type="hidden" name="action" value="editMainProduct"/>
                                                                <input type="hidden" name="product_id" value="${p.id}"/>
                                                                <input type="hidden" name="price" value="${p.price}"/>
                                                                <input type="hidden" name="keyword" value="${keyword != null ? keyword : ''}" />
                                                                <input type="submit" value="Sửa" class="btn btn-secondary" />
                                                            </form>

                                                            <form action="MainController" method="post" style="display:inline;" onsubmit="return confirm('Xóa sản phẩm này?');">
                                                                <input type="hidden" name="action" value="deleteProduct"/>
                                                                <input type="hidden" name="product_id" value="${p.id}"/>
                                                                <input type="hidden" name="keyword" value="${keyword != null ? keyword : ''}" />
                                                                <input type="submit" value="Xóa" class="btn btn-danger" />
                                                            </form>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>

                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <h3>Không tìm thấy sản phẩm</h3>
                                    <p>Vui lòng thử lại với từ khóa khác hoặc bỏ lọc để xem tất cả.</p>
                                    <a href="MainController?action=getAllProducts" class="btn btn-primary">Xem tất cả sản phẩm</a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
        <jsp:include page="footer.jsp"/>                    
        <!-- Swiper JS (tuỳ chọn) -->
        <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
        <script>
                                                                // Bạn có thể tái sử dụng slider cho khối admin nếu cần sau này
        </script>
    </body>
</html>