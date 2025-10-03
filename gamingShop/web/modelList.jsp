<%-- 
    Document   : modelList
    Created on : Sep 14, 2025, 9:43:50 PM
    Author     : ddhuy
    Description: Trang quản trị models — đồng bộ layout với trang chủ
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>

        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>SHOP GAME VIỆT 38 — Quản Lý Models</title>
        <%@ include file="/WEB-INF/jspf/head.jspf" %>
        <!-- Swiper CSS (nếu cần cho banner nội bộ) -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
        <!-- Main CSS đồng bộ với trang chủ -->
        <link rel="stylesheet" href="assets/css/maincss.css" />
        <!-- Breadcrumbs CSS -->
        <link rel="stylesheet" href="assets/css/breadcrumbs.css" />

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
                color: #0d1424;
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
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                font-size: 14px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }
            .btn-primary {
                background: linear-gradient(135deg, #2563eb, #3b82f6) !important;
                color: #fff !important;
                border: none !important;
            }
            .btn-primary:hover {
                background: linear-gradient(135deg, #1d4ed8, #2563eb) !important;
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(37, 99, 235, 0.3);
                color: #fff !important;
            }
            
            /* Đảm bảo nút thêm loại sản phẩm có màu */
            .admin-toolbar .btn.btn-primary {
                background: linear-gradient(135deg, #2563eb, #3b82f6) !important;
                color: #ffffff !important;
                border: none !important;
                text-decoration: none !important;
            }
            
            .admin-toolbar .btn.btn-primary:hover {
                background: linear-gradient(135deg, #1d4ed8, #2563eb) !important;
                color: #ffffff !important;
            }
            .btn-secondary {
                background: linear-gradient(135deg, #6b7280, #9ca3af);
                color: #fff;
            }
            .btn-secondary:hover {
                background: linear-gradient(135deg, #4b5563, #6b7280);
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(107, 114, 128, 0.3);
            }
            .btn-danger {
                background: linear-gradient(135deg, #dc2626, #ef4444);
                color: #fff;
            }
            .btn-danger:hover {
                background: linear-gradient(135deg, #b91c1c, #dc2626);
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(220, 38, 38, 0.3);
            }

            .models-card {
                margin-top: 16px;
                background: #fff;
                border: 1px solid #e5e7eb;
                border-radius: 16px;
                overflow: hidden;
            }
            .models-meta {
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
            table.models {
                width: 100%;
                border-collapse: separate;
                border-spacing: 0;
                background: #ffffff;
                color: #111111;
            }
            table.models thead th {
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
            table.models tbody td {
                padding: 12px 14px;
                border-bottom: 1px solid #f1f5f9;
                color: #111111;
                vertical-align: top;
            }
            .model-thumb {
                width: 72px;
                height: 72px;
                border-radius: 10px;
                object-fit: cover;
                border: 1px solid #d1d5db;
                background: #f9fafb;
            }
            .model-name {
                font-weight: 700;
            }
            .model-id {
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
            .status-inactive {
                background:#fee2e2;
                color:#991b1b;
                border:1px solid #ef4444;
            }
            .row-actions .btn {
                height: 36px;
                padding: 0 16px;
                border-radius: 8px;
                font-size: 13px;
                font-weight: 600;
                color: #fff;
                border: none;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                min-width: 70px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                position: relative;
                overflow: hidden;
            }
            .row-actions .btn::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
                transition: left 0.5s;
            }
            .row-actions .btn:hover::before {
                left: 100%;
            }
            .row-actions .btn-secondary {
                background: linear-gradient(135deg, #3b82f6, #60a5fa);
            }
            .row-actions .btn-secondary:hover {
                background: linear-gradient(135deg, #2563eb, #3b82f6);
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(59, 130, 246, 0.3);
            }
            .row-actions .btn-danger {
                background: linear-gradient(135deg, #ef4444, #f87171);
            }
            .row-actions .btn-danger:hover {
                background: linear-gradient(135deg, #dc2626, #ef4444);
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(239, 68, 68, 0.3);
            }
            .row-actions {
                display: flex;
                gap: 8px;
                justify-content: center;
                align-items: center;
            }

            /* Nút "Xem Thêm" đặc biệt */
            .search-form input[type="submit"] {
                height: 36px;
                padding: 0 16px;
                border-radius: 8px;
                font-size: 13px;
                font-weight: 600;
                color: #fff;
                border: none;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                min-width: 80px;
                background: linear-gradient(135deg, #059669, #10b981);
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }
            .search-form input[type="submit"]:hover {
                background: linear-gradient(135deg, #047857, #059669);
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(5, 150, 105, 0.3);
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
                opacity: 1;
                transition: opacity 0.5s ease-out;
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
            .alert.fade-out {
                opacity: 0;
            }

            /* Zebra rows + hover */
            table.models tbody tr:nth-child(even) {
                background: #fafafa;
            }
            table.models tbody tr:hover {
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
                        <span class="marquee-item"><span class="badge">ADMIN</span> Quản lý models — thêm/sửa/xóa nhanh</span>
                        <span class="marquee-item"><span class="badge">TIP</span> Nhập loại model để lọc chính xác</span>
                        <span class="marquee-item"><a href="MainController?action=viewModelList">Làm mới danh sách →</a></span>
                    </div>
                </div>

                <div class="container">
                    <div class="admin-toolbar">
                        <div class="title">Danh sách các loại sản phẩm</div>

                        <a href="MainController?action=showAddModel" class="btn btn-primary">+ Thêm loại sản phẩm</a>
                    </div>

                    <!-- Thông báo hệ thống -->
                    <c:if test="${not empty checkErrorModelList}">
                        <div class="alert alert-danger">${checkErrorModelList}</div>
                    </c:if>
                    <c:if test="${not empty messageDeleteModel}">
                        <div class="alert alert-success">${messageDeleteModel}</div>
                    </c:if>

                    <!-- Meta: tổng số models -->
                    <div class="models-card">
                        <div class="models-meta">
                            <span class="meta-pill"><span class="dot"></span><b>Tổng:</b>&nbsp;<c:choose>
                                        <c:when test="${not empty modelList}">${fn:length(modelList)}</c:when>
                                        <c:otherwise>0</c:otherwise>
                                </c:choose> loại sản phẩm</span>
                        </div>

                        <!-- Bảng models -->
                        <c:choose>
                            <c:when test="${not empty modelList}">
                                <div class="table-wrap">
                                    <table class="models">
                                        <thead>
                                            <tr>
                                                <th>Loại sản phẩm</th>
                                                <th>Trạng thái</th>
                                                <th>Tạo</th>
                                                <th>Cập nhật</th>
                                                <th style="display: flex; justify-content: center; align-items: center;">Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="model" items="${modelList}">
                                                <tr>
                                                    <td>
                                                        <div class="model-name">${model.model_type}</div>
                                                        <div class="model-id">#${model.id}</div>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${model.status eq 'active'}">
                                                                <span class="status-pill status-active">Hoạt động</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="status-pill status-inactive">Ngừng</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td><fmt:formatDate value="${model.created_at}" pattern="dd/MM/yyyy"/></td>
                                                    <td><fmt:formatDate value="${model.updated_at}" pattern="dd/MM/yyyy"/></td>
                                                    <td>
                                                        <div class="row-actions">
                                                            <form action="MainController" method="post" class="search-form" autocomplete="off">
                                                                <input type="hidden" name="model_id" value="${model.id}"/>
                                                                <input type="hidden" name="action" value="searchProduct"/>
                                                                <input class="nav-item" type="submit" value="Xem Thêm">
                                                            </form>
                                                            <a href="MainController?action=showEditModel&id=${model.id}" class="btn btn-secondary">Sửa</a>
                                                            <c:if test="${model.status == 'active'}">
                                                                <a href="MainController?action=deleteModel&id=${model.id}" class="btn btn-danger" 
                                                                   onclick="return confirmDelete('${model.model_type}')">Xóa</a>
                                                            </c:if>
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
                                    <h3>Không tìm thấy model</h3>
                                    <p>Hiện tại chưa có model nào trong hệ thống.</p>
                                    <a href="MainController?action=showAddModel" class="btn btn-primary" style="margin-top: 12px;">+ Thêm Model mới</a>
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
                                                                       function confirmDelete(modelType) {
                                                                           return confirm('Bạn có chắc chắn muốn vô hiệu hóa model: ' + modelType + '?');
                                                                       }

                                                                       // Auto hide messages after 5 seconds
                                                                       setTimeout(function () {
                                                                           var alerts = document.querySelectorAll('.alert');
                                                                           alerts.forEach(function (alert) {
                                                                               alert.classList.add('fade-out');
                                                                               setTimeout(function () {
                                                                                   alert.style.display = 'none';
                                                                               }, 500); // Wait for fade animation to complete
                                                                           });
                                                                       }, 5000);
        </script>
    </body>
</html>
