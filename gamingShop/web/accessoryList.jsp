<%-- 
    Document   : accessoryList (themed to match sidebar.jsp)
    Created on : Sep 12, 2025
    Author     : ddhuy (refined by ChatGPT)
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Accessories List</title>
    <style>
      :root {
        --ring: #e5e7eb;
        --ink: #111827;
        --muted: #6b7280;
        --chip: #e6e6e6;
        --shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
        --primary-blue: #2563eb;
        --primary-blue-hover: #1d4ed8;
        --light-blue: #dbeafe;
        --gradient-bg: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        --admin-gradient: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        --success-color: #22c55e;
        --success-hover: #16a34a;
        --danger-color: #ef4444;
        --danger-hover: #dc2626;
        --warning-color: #f59e0b;
        --warning-hover: #d97706;
        --card-border: #f1f5f9;
      }

      * { box-sizing: border-box; }

      body {
        font-family: system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial, sans-serif;
        margin: 0;
        padding: 20px;
        background: #fafafa;
        color: var(--ink);
        line-height: 1.6;
      }

      /* Header */
      h1 {
        background: var(--gradient-bg);
        color: white;
        padding: 24px 32px;
        border-radius: 20px;
        margin: 0 0 30px 0;
        font-size: 28px;
        font-weight: 800;
        text-align: center;
        box-shadow: var(--shadow);
        position: relative;
        overflow: hidden;
      }
      h1::before {
        content: "";
        position: absolute;
        inset: 0;
        left: -100%;
        background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
        animation: shimmer 3s infinite;
      }
      @keyframes shimmer {
        0% { left: -100%; }
        100% { left: 100%; }
      }

      /* Search Card */
      .search-form {
        background: #ffffff;
        padding: 24px;
        border-radius: 20px;
        margin-bottom: 20px;
        box-shadow: var(--shadow);
        border: 1px solid var(--card-border);
        position: relative;
        overflow: hidden;
      }
      .search-form::before {
        content: "";
        position: absolute;
        inset: 0;
        background: linear-gradient(145deg, transparent, rgba(37, 99, 235, 0.03));
        pointer-events: none;
      }
      .search-form input[type="text"] {
        padding: 14px 18px;
        margin-right: 12px;
        border: 2px solid #e2e8f0;
        border-radius: 16px;
        font-size: 14px;
        font-weight: 500;
        transition: all 0.3s ease;
        background: #f8fafc;
        min-width: 300px;
      }
      .search-form input[type="text"]:focus {
        outline: none;
        border-color: var(--primary-blue);
        background: white;
        box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        transform: translateY(-1px);
      }

      /* Buttons — unified with sidebar style */
      .btn {
        padding: 12px 20px;
        margin: 4px;
        text-decoration: none;
        border: 1px solid var(--card-border);
        border-radius: 16px;
        font-weight: 700;
        font-size: 14px;
        cursor: pointer;
        transition: all 0.3s ease;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        position: relative;
        overflow: hidden;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        font-family: inherit;
        background: linear-gradient(145deg, #ffffff, #f1f5f9);
        color: var(--ink);
      }
      .btn::before {
        content: "";
        position: absolute;
        inset: 0;
        left: -100%;
        background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.4), transparent);
        transition: left 0.5s ease;
      }
      .btn:hover::before { left: 100%; }
      .btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
      }
      .btn:focus-visible {
        outline: none;
        box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.25);
      }

      /* Variants */
      .btn-primary {
        background: var(--primary-blue);
        color: #ffffff;
        border-color: transparent;
      }
      .btn-primary:hover {
        background: var(--primary-blue-hover);
        box-shadow: 0 8px 25px rgba(37, 99, 235, 0.35);
      }
      .btn-success {
        background: var(--success-color);
        color: #ffffff;
        border-color: transparent;
      }
      .btn-success:hover { background: var(--success-hover); box-shadow: 0 8px 25px rgba(34, 197, 94, 0.3); }
      .btn-danger {
        background: var(--danger-color);
        color: #ffffff;
        border-color: transparent;
      }
      .btn-danger:hover { background: var(--danger-hover); box-shadow: 0 8px 25px rgba(239, 68, 68, 0.3); }
      .btn-warning {
        background: var(--warning-color);
        color: #ffffff;
        border-color: transparent;
      }
      .btn-warning:hover { background: var(--warning-hover); box-shadow: 0 8px 25px rgba(245, 158, 11, 0.3); }
      .btn-outline {
        background: #f8fafc;
        color: var(--ink);
        border-color: #e2e8f0;
      }
      .btn-outline:hover { background: var(--primary-blue); color: #fff; border-color: var(--primary-blue); }

      /* Special placements */
      .btn-add { margin-bottom: 20px; }

      .search-form button { /* submit */
        composes: btn btn-primary; /* hint-only; ignored by browsers */
        background: var(--primary-blue);
        color: white;
        border: none;
        padding: 14px 24px;
        border-radius: 16px;
        font-weight: 700;
        cursor: pointer;
        transition: all 0.3s ease;
        position: relative;
        overflow: hidden;
      }
      .search-form button::before {
        content: "";
        position: absolute;
        inset: 0;
        left: -100%;
        background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.35), transparent);
        transition: left 0.5s ease;
      }
      .search-form button:hover { background: var(--primary-blue-hover); transform: translateY(-2px); box-shadow: 0 8px 25px rgba(37, 99, 235, 0.3); }
      .search-form button:hover::before { left: 100%; }

      /* Messages */
      .error,
      .success { transition: all 0.3s ease; }
      .error {
        color: #dc2626;
        background: #fef2f2;
        padding: 16px 20px;
        margin: 16px 0;
        border-radius: 16px;
        border: 1px solid #fecaca;
        font-weight: 600;
        box-shadow: 0 4px 12px rgba(220, 38, 38, 0.1);
      }
      .success {
        color: #16a34a;
        background: #f0fdf4;
        padding: 16px 20px;
        margin: 16px 0;
        border-radius: 16px;
        border: 1px solid #bbf7d0;
        font-weight: 600;
        box-shadow: 0 4px 12px rgba(22, 163, 74, 0.1);
      }

      /* Table Container */
      .table-container {
        background: white;
        border-radius: 20px;
        overflow: hidden;
        box-shadow: var(--shadow);
        border: 1px solid var(--card-border);
        margin-bottom: 20px;
      }
      table { border-collapse: collapse; width: 100%; background: white; }
      th,
      td { padding: 16px 12px; text-align: left; border-bottom: 1px solid var(--card-border); vertical-align: middle; }
      th {
        background: linear-gradient(145deg, #f8fafc, #e2e8f0);
        font-weight: 800;
        color: #1e293b;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        font-size: 13px;
        position: sticky;
        top: 0;
        z-index: 10;
      }
      tbody tr { transition: all 0.3s ease; position: relative; }
      tbody tr::before {
        content: "";
        position: absolute;
        inset: 0;
        background: linear-gradient(145deg, transparent, rgba(37, 99, 235, 0.02));
        opacity: 0;
        transition: opacity 0.3s ease;
        pointer-events: none;
      }
      tbody tr:hover { transform: translateY(-2px); box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08); }
      tbody tr:hover::before { opacity: 1; }
      tbody tr:nth-child(even) { background: #fafbfc; }

      .price { font-weight: 800; color: var(--primary-blue); font-size: 16px; }

      /* Status pills */
      .status-pill {
        padding: 6px 12px;
        border-radius: 20px;
        font-weight: 800;
        display: inline-block;
        border: 1px solid transparent;
      }
      .status-active { color: var(--success-color); background: #f0fdf4; border-color: #bbf7d0; }
      .status-inactive { color: var(--danger-color); background: #fef2f2; border-color: #fecaca; }
      .status-out_of_stock { color: var(--warning-color); background: #fffbeb; border-color: #fed7aa; }

      /* Gift badges */
      .gift-badge { padding: 6px 12px; border-radius: 12px; font-size: 12px; font-weight: 700; display: inline-block; border: 1px solid transparent; }
      .gift-free { background-color: #f0fdf4; color: #16a34a; border-color: #bbf7d0; }
      .gift-sell { background-color: #fffbeb; color: #d97706; border-color: #fed7aa; }
      .gift-other { background-color: #f8fafc; color: #64748b; border-color: #e2e8f0; }

      /* Images */
      .thumb-60 { width: 60px; height: 60px; object-fit: cover; border-radius: 12px; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); transition: transform 0.3s ease; }
      .thumb-60:hover { transform: scale(1.05); }

      /* Info text */
      .info-text {
        margin-top: 20px;
        padding: 16px 20px;
        background: white;
        border-radius: 16px;
        color: var(--muted);
        font-weight: 500;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        border: 1px solid var(--card-border);
      }

      /* Pagination */
      .pagination {
        margin-top: 30px;
        text-align: center;
        padding: 20px;
        background: white;
        border-radius: 16px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        border: 1px solid var(--card-border);
      }
      .pagination .btn { margin: 0 8px; }

      /* Responsive */
      @media (max-width: 768px) {
        body { padding: 10px; }
        .search-form input[type="text"] { min-width: 200px; margin-bottom: 10px; }
        table { font-size: 14px; }
        th, td { padding: 8px 6px; }
        .btn { padding: 8px 12px; font-size: 12px; }
        h1 { font-size: 24px; padding: 20px; }
      }

      /* Empty state */
      .empty-state { text-align: center; padding: 60px 20px; color: var(--muted); font-style: italic; }
      .empty-state::before { content: "📦"; font-size: 48px; display: block; margin-bottom: 16px; opacity: 0.5; }
    </style>
  </head>
  <body>
    <h1>🔧 Quản lý phụ kiện</h1>

    <!-- Search Form -->
    <div class="search-form">
      <form action="MainController" method="get" autocomplete="off">
        <input type="hidden" name="action" value="searchAccessory" />
        <input type="text" name="keyword" placeholder="🔍 Tìm kiếm phụ kiện..." value="${keyword}" />
        <button type="submit" class="btn-primary">Tìm kiếm</button>
        <c:if test="${not empty keyword}">
          <a href="MainController?action=viewAllAccessories" class="btn btn-outline">✖️ Xóa bộ lọc</a>
        </c:if>
      </form>
    </div>

    <!-- Add New Button -->
    <a href="MainController?action=showAddAccessoryForm" class="btn btn-primary btn-add">➕ Thêm phụ kiện mới</a>

    <!-- Messages -->
    <c:if test="${not empty checkError}">
      <div class="error">❌ ${checkError}</div>
    </c:if>
    <c:if test="${not empty messageDeleteAccessory}">
      <div class="success">✅ ${messageDeleteAccessory}</div>
    </c:if>

    <!-- Search Results Info -->
    <c:if test="${not empty keyword}">
      <div class="search-info">🔍 Kết quả tìm kiếm cho: "<strong>${keyword}</strong>"</div>
    </c:if>

    <!-- Accessories Table -->
    <div class="table-container">
      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>Tên</th>
            <th>Mô tả</th>
            <th>Hình ảnh</th>
            <th>Số lượng</th>
            <th>Giá</th>
            <th>Trạng thái</th>
            <th>Loại quà</th>
            <th>Cập nhật</th>
            <th>Thao tác</th>
          </tr>
        </thead>
        <tbody>
          <c:choose>
            <c:when test="${empty accessories}">
              <tr>
                <td colspan="10" class="empty-state">Không tìm thấy phụ kiện nào</td>
              </tr>
            </c:when>
            <c:otherwise>
              <c:forEach var="accessory" items="${accessories}">
                <tr>
                  <td><strong>#${accessory.id}</strong></td>
                  <td><strong>${accessory.name}</strong></td>
                  <td>
                    <c:choose>
                      <c:when test="${not empty accessory.description}">
                        <c:choose>
                          <c:when test="${fn:length(accessory.description) > 50}">
                            ${fn:substring(accessory.description, 0, 50)}...
                          </c:when>
                          <c:otherwise>${accessory.description}</c:otherwise>
                        </c:choose>
                      </c:when>
                      <c:otherwise><em>Chưa có mô tả</em></c:otherwise>
                    </c:choose>
                  </td>
                  <td>
                    <c:choose>
                      <c:when test="${not empty accessory.image_url}">
                        <img src="${accessory.image_url}" alt="Hình phụ kiện" class="thumb-60" />
                      </c:when>
                      <c:otherwise><em>Không có ảnh</em></c:otherwise>
                    </c:choose>
                  </td>
                  <td style="text-align: center; font-weight: bold; font-size: 16px;">${accessory.quantity}</td>
                  <td class="price"><fmt:formatNumber value="${accessory.price}" pattern=",#0" /> VND</td>
                  <td>
                    <span class="status-pill status-${accessory.status}">
                      <c:choose>
                        <c:when test="${accessory.status == 'active'}">Hoạt động</c:when>
                        <c:when test="${accessory.status == 'inactive'}">Không hoạt động</c:when>
                        <c:when test="${accessory.status == 'out_of_stock'}">Hết hàng</c:when>
                        <c:otherwise>${accessory.status}</c:otherwise>
                      </c:choose>
                    </span>
                  </td>
                  <td>
                    <c:choose>
                      <c:when test="${accessory.gift == 'Phụ kiện tặng kèm'}">
                        <span class="gift-badge gift-free">🎁 Tặng kèm</span>
                      </c:when>
                      <c:when test="${accessory.gift == 'Phụ kiện bán'}">
                        <span class="gift-badge gift-sell">💰 Phụ kiện bán</span>
                      </c:when>
                      <c:otherwise>
                        <span class="gift-badge gift-other">${accessory.gift}</span>
                      </c:otherwise>
                    </c:choose>
                  </td>
                  <td><fmt:formatDate value="${accessory.updated_at}" pattern="dd/MM/yyyy" /></td>
                  <td>
                    <a href="ProductController?action=showEditAccessoryForm&id=${accessory.id}" class="btn btn-success">✏️ Sửa</a>
                    <a href="MainController?action=deleteAccessory&id=${accessory.id}" class="btn btn-danger" onclick="return confirmDelete('${accessory.name}')">🗑️ Xóa</a>
                  </td>
                </tr>
              </c:forEach>
            </c:otherwise>
          </c:choose>
        </tbody>
      </table>
    </div>

    <!-- Total count -->
    <div class="info-text">
      📊 Tổng cộng: <strong>${fn:length(accessories)}</strong> phụ kiện
      <c:if test="${not empty totalAccessories}"> (${totalAccessories} tổng trong cơ sở dữ liệu) </c:if>
    </div>

    <!-- Simple Pagination -->
    <c:if test="${not empty totalPages && totalPages > 1}">
      <div class="pagination">
        <c:if test="${currentPage > 1}">
          <a href="MainController?action=viewAllAccessories&page=${currentPage - 1}" class="btn btn-outline">⬅️ Trước</a>
        </c:if>
        <span>Trang ${currentPage} / ${totalPages}</span>
        <c:if test="${currentPage < totalPages}">
          <a href="MainController?action=viewAllAccessories&page=${currentPage + 1}" class="btn btn-outline">Sau ➡️</a>
        </c:if>
      </div>
    </c:if>

    <script>
      function confirmDelete(accessoryName) {
        return confirm('🗑️ Bạn có chắc muốn xóa phụ kiện: ' + accessoryName + ' không?');
      }
      // Auto hide messages after 5 seconds
      setTimeout(function () {
        var errorDiv = document.querySelector('.error');
        var successDiv = document.querySelector('.success');
        if (errorDiv) {
          errorDiv.style.opacity = '0';
          errorDiv.style.transform = 'translateY(-10px)';
          setTimeout(() => (errorDiv.style.display = 'none'), 300);
        }
        if (successDiv) {
          successDiv.style.opacity = '0';
          successDiv.style.transform = 'translateY(-10px)';
          setTimeout(() => (successDiv.style.display = 'none'), 300);
        }
      }, 5000);
      document.addEventListener('DOMContentLoaded', function () {
        const messages = document.querySelectorAll('.error, .success');
        messages.forEach((msg) => {
          msg.style.opacity = '0';
          msg.style.transform = 'translateY(-10px)';
          setTimeout(() => {
            msg.style.transition = 'all 0.3s ease';
            msg.style.opacity = '1';
            msg.style.transform = 'translateY(0)';
          }, 100);
        });
      });
    </script>
  </body>
</html>
