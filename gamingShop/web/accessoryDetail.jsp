<%-- 
    Document   : acccessoryDetail
    Author     : ddhuy
--%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<fmt:setLocale value="vi_VN" />

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <title>Chi tiết phụ kiện - Gaming Shop</title>

        <style>
            /* =========================
   Base + Variables
========================= */
            :root{
                --bg: #f8fafc;
                --text: #1f2937;
                --muted: #6b7280;
                --accent: #7c3aed;
                --danger: #e11d48;
                --success: #059669;
                --warning: #d97706;
                --border: #e5e7eb;
                --card-shadow: 0 10px 40px rgba(0,0,0,.08);
            }

            *{
                box-sizing: border-box;
            }
            html, body{
                margin:0;
                padding:0;
                height:100%;
                width:100%;
                font-family: Inter, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
                background: var(--bg);
                color: var(--text);
            }

            /* =========================
               App Shell
            ========================= */
            .wrapper{
                display:flex;
                gap:20px;
                padding:0 20px;
                min-height:100vh;
                width:100vw;
            }
            .sidebar{
                flex:3;
                background: linear-gradient(135deg,#2c3e50 0%,#34495e 100%);
                color:#fff;
                border-radius:20px;
                padding:24px;
                top:20px;
                height: fit-content;
            }
            .Main_content{
                flex:7;
                background:#fff;
                border-radius:20px;
                display:flex;
                flex-direction:column;
                overflow:auto;
            }
            .container{
                padding:16px;
            }

            /* =========================
               Breadcrumb
            ========================= */
            .breadcrumb{
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 8px;
                font-size: 14px;
                color: var(--muted);
            }
            .breadcrumb a{
                color: var(--accent);
                text-decoration: none;
            }
            .breadcrumb a:hover{
                text-decoration: underline;
            }

            /* =========================
               Accessory Detail Layout
            ========================= */
            .accessory-detail{
                display:grid;
                gap:24px;
                align-items:start;
                grid-template-columns: minmax(420px, 4fr) minmax(0, 6fr);
            }

            /* ---------- LEFT: Image ---------- */
            .ad-left{
                background:#fff;
                border-radius:16px;
                padding:20px;
            }
            .ad-main{
                width:100%;
                border:1px solid #eee;
                border-radius:12px;
                overflow:hidden;
                display:flex;
                align-items:center;
                justify-content:center;
                background:#f9fafb;
            }
            .ad-main img{
                width:100%;
                height:100%;
                object-fit:contain;
                transition: transform 0.3s ease;
            }
            .ad-main:hover img{
                transform: scale(1.05);
            }

            /* ---------- RIGHT: Info + Description ---------- */
            .ad-right{
                top:16px;
                background:#fff;
                border-radius:16px;
                padding:24px;
                height: fit-content;
            }
            .ad-name{
                margin:0 0 16px;
                font-size:24px;
                font-weight:800;
                line-height:1.3;
                color: var(--text);
            }
            .ad-id{
                margin-bottom: 20px;
                font-size: 14px;
                color: var(--muted);
                font-weight: 500;
            }

            .ad-basic{
                display:grid;
                gap:12px;
                margin-bottom:20px;
            }
            .ad-row{
                display:grid;
                grid-template-columns: 120px 1fr;
                gap:12px;
                align-items:center;
                font-size:15px;
                padding: 8px 0;
                border-bottom: 1px solid #f3f4f6;
            }
            .ad-row:last-child{
                border-bottom: none;
            }
            .ad-row b{
                color:var(--muted);
                font-weight:600;
            }
            .ad-row span{
                color:#111827;
                font-weight:600;
            }

            .ad-row-price{
                background: linear-gradient(135deg, #fef3f2 0%, #fef2f2 100%);
                border:1px solid #fecaca;
                border-radius:12px;
                padding:16px;
                margin: 8px 0;
                grid-template-columns: 120px 1fr;
            }
            .ad-row-price span{
                color: var(--danger);
                font-size:22px;
                font-weight:800;
            }

            /* Status Pills */
            .status-pill{
                display: inline-block;
                padding: 4px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
                text-transform: uppercase;
            }
            .status-active{
                background: #dcfce7;
                color: var(--success);
            }
            .status-inactive{
                background: #fee2e2;
                color: var(--danger);
            }

            .gift-pill{
                display: inline-block;
                padding: 4px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
            }
            .gift-freebie{
                background: #dbeafe;
                color: #1d4ed8;
            }
            .gift-sellable{
                background: #f3e8ff;
                color: var(--accent);
            }

            .quantity-info{
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .quantity-badge{
                padding: 4px 8px;
                border-radius: 6px;
                font-size: 12px;
                font-weight: 600;
            }
            .quantity-high{
                background: #dcfce7;
                color: var(--success);
            }
            .quantity-medium{
                background: #fef3c7;
                color: var(--warning);
            }
            .quantity-low{
                background: #fee2e2;
                color: var(--danger);
            }

            /* Description */
            .ad-desc{
                margin-top:20px;
                padding-top:20px;
                border-top:2px dashed var(--border);
            }
            .ad-desc h3{
                margin-top:0;
                margin-bottom: 12px;
                color: var(--text);
                font-size: 18px;
            }
            .ad-desc p{
                line-height: 1.6;
                color: #4b5563;
            }

            /* Action Buttons */
            .ad-actions{
                margin-top: 24px;
                padding-top: 20px;
                border-top: 1px dashed var(--border);
                display: flex;
                gap: 12px;
                flex-wrap: wrap;
            }
            .btn{
                padding: 10px 20px;
                border-radius: 8px;
                border: none;
                font-weight: 600;
                font-size: 14px;
                cursor: pointer;
                text-decoration: none;
                display: inline-block;
                text-align: center;
                transition: all 0.2s ease;
            }
            .btn-primary{
                background: var(--accent);
                color: white;
            }
            .btn-primary:hover{
                background: #6d28d9;
                transform: translateY(-1px);
            }
            .btn-secondary{
                background: #f3f4f6;
                color: var(--text);
            }
            .btn-secondary:hover{
                background: #e5e7eb;
            }
            .btn-danger{
                background: var(--danger);
                color: white;
            }
            .btn-danger:hover{
                background: #be185d;
            }

            /* ---------- Empty state ---------- */
            .empty-state{
                text-align:center;
                padding:60px 20px;
            }
            .empty-state h3{
                font-size:24px;
                margin-bottom:10px;
                color: var(--text);
            }
            .empty-state p{
                font-size:16px;
                color: var(--muted);
                margin-bottom: 20px;
            }

            .sd-actions {
                display: flex;
                flex-wrap: wrap;          /* tự động xuống hàng nếu chật */
                gap: 12px;                /* khoảng cách giữa các nút */
                margin-top: 20px;
                justify-content: center;  /* căn giữa các nút */
            }

            .btn-service {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                padding: 10px 18px;
                font-size: 15px;
                font-weight: 500;
                border-radius: 8px;
                border: none;
                cursor: pointer;
                text-decoration: none;    /* áp dụng cho thẻ <a> */
                transition: all 0.25s ease;
            }

            .btn-primary {
                background-color: #007bff;
                color: #fff;
            }

            .btn-primary:hover {
                background-color: #0069d9;
            }

            .btn-secondary {
                background-color: #f1f3f5;
                color: #333;
            }

            .btn-secondary:hover {
                background-color: #e2e6ea;
            }

            .btn-service:active {
                transform: scale(0.96);   /* hiệu ứng nhấn */
            }

            /* =========================
               Responsive
            ========================= */
            @media (max-width: 1200px){
                .accessory-detail{
                    grid-template-columns: minmax(380px, 4fr) minmax(0, 6fr);
                    gap:20px;
                }
                .ad-main{
                    height: clamp(350px, 45vh, 500px);
                }
                .sidebar{
                    display:none !important;
                }
            }
            @media (max-width: 1024px){
                .accessory-detail{
                    grid-template-columns: 1fr;
                }
                .ad-right{
                    position: static;
                }
                .ad-main{
                    height: clamp(320px, 40vh, 480px);
                }
            }
            @media (max-width: 640px){
                .container{
                    padding:12px;
                }
                .ad-row{
                    grid-template-columns: 100px 1fr;
                    font-size: 14px;
                }
                .ad-row-price{
                    grid-template-columns: 100px 1fr;
                }
                .ad-row-price span{
                    font-size: 18px;
                }
                .ad-actions{
                    flex-direction: column;
                }
            }

            @media (max-width: 768px) {
                .sd-actions {
                    flex-direction: column;
                    align-items: stretch; /* full width theo container */
                }

                .btn-service {
                    width: 100%; /* nút chiếm full chiều ngang */
                    font-size: 16px;
                }
            }

            @media (prefers-reduced-motion: reduce){
                .ad-main img{
                    transition: none;
                }
                .btn{
                    transition: none;
                }
            }
        </style>
    </head>

    <body>
        <div class="wrapper"> 
            <!-- Sidebar -->
            <div class="sidebar">
                <jsp:include page="sidebar.jsp"/>
            </div>

            <!-- Main -->
            <div class="Main_content">
                <!-- Header -->
                <jsp:include page="header.jsp"/>

                <!-- ====== Nội dung trang ====== -->
                <div class="container">
                    <!-- Breadcrumb -->
                    <div class="breadcrumb">
                        <a href="MainController?action=listPhuKien">Danh sách phụ kiện</a>
                        <span>/</span>
                        <span>Chi tiết phụ kiện</span>
                    </div>

                    <c:choose>
                        <c:when test="${not empty accessory}">
                            <div class="accessory-detail">
                                <!-- LEFT: Image -->
                                <div class="ad-left">
                                    <div class="ad-main">
                                        <c:choose>
                                            <c:when test="${not empty accessory.coverImg}">
                                                <img src="${accessory.coverImg}" alt="${accessory.name}" loading="eager"/>
                                            </c:when>
                                            <c:otherwise>
                                                <img src="assets/accessories/no-image.png" alt="Không có hình ảnh" loading="eager"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <!-- RIGHT: Info + Description -->
                                <div class="ad-right">
                                    <div class="ad-name">${accessory.name}</div>
                                    <div class="ad-id">Mã phụ kiện: #${accessory.id}</div>

                                    <div class="ad-basic">
                                        <div class="ad-row-price">
                                            <b>Giá bán</b>
                                            <span><fmt:formatNumber value="${accessory.price}" type="number" groupingUsed="true"/> VND</span>
                                        </div>

                                        <div class="ad-row">
                                            <b>Tồn kho</b>
                                            <div class="quantity-info">
                                                <span>${accessory.quantity}</span>
                                                <c:choose>
                                                    <c:when test="${accessory.quantity >= 50}">
                                                        <span class="quantity-badge quantity-high">Còn nhiều</span>
                                                    </c:when>
                                                    <c:when test="${accessory.quantity >= 10}">
                                                        <span class="quantity-badge quantity-medium">Còn ít</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="quantity-badge quantity-low">Sắp hết</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <div class="ad-row">
                                            <b>Phân loại</b>
                                            <span>
                                                <c:choose>
                                                    <c:when test="${accessory.gift == 'Phụ kiện tặng kèm'}">
                                                        <span class="gift-pill gift-freebie">Tặng kèm</span>
                                                    </c:when>
                                                    <c:when test="${accessory.gift == 'Phụ kiện bán'}">
                                                        <span class="gift-pill gift-sellable">Phụ kiện bán</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span>${accessory.gift}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>

                                        <div class="sd-actions">
                                            <button onclick="bookService('${serviceDetail.id}', '${serviceDetail.service_type}', '${serviceDetail.price}')" class="btn-service btn-primary">
                                                🛒 Đặt hàng qua Zalo
                                            </button>
                                            <button onclick="callDirectly()" class="btn-service btn-secondary">
                                                📞 Gọi trực tiếp
                                            </button>
                                            <a href="MainController?action=listPhuKien" class="btn-service btn-secondary">
                                                📋 Xem sản phẩm khác
                                            </a>
                                        </div>     

                                        <!-- Description -->
                                        <div class="ad-desc">
                                            <h3>Mô tả sản phẩm</h3>
                                            <c:choose>
                                                <c:when test="${not empty accessory.description}">
                                                    <p>${accessory.description}</p>
                                                </c:when>
                                                <c:otherwise>
                                                    <p><em>Chưa có mô tả chi tiết cho phụ kiện này.</em></p>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <!-- Action Buttons -->
                                        <div class="ad-actions">
                                            <a href="MainController?action=listPhuKien" class="btn btn-secondary">
                                                Quay lại danh sách
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </c:when>

                            <c:otherwise>
                                <div class="empty-state">
                                    <h3>Không tìm thấy phụ kiện</h3>
                                    <p>Phụ kiện bạn đang tìm không tồn tại hoặc đã bị xóa.</p>
                                    <c:if test="${not empty checkError}">
                                        <p style="color: var(--danger); font-weight: 600;">
                                            <c:out value="${checkError}"/>
                                        </p>
                                    </c:if>
                                    <a href="MainController?action=listPhuKien" class="btn btn-primary">
                                        Xem tất cả phụ kiện
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
        <!-- Footer đặt NGOÀI wrapper để luôn hiển thị khi body cuộn -->
        <jsp:include page="footer.jsp"/>
        <script>
            // ===== CONFIG - Thay đổi thông tin liên hệ ở đây =====
            const SHOP_CONFIG = {
                zaloId: '0943391235', // Thay bằng Zalo ID thực tế
                phoneNumber: '0943391235', // Thay bằng SĐT thực tế
                shopName: 'SGV38 Shop'
            };

            // ===== MAIN FUNCTIONS =====

            // Đặt dịch vụ qua Zalo
            function bookService(serviceId, serviceName, price) {
                // Log user interest (optional - có thể bỏ nếu không cần track)
                logUserInterest(serviceId, 'book_service');

                // Tạo message template
                const message = "🎮 ĐẶT DỊCH VỤ - " + SHOP_CONFIG.shopName + "\n\n" +
                        "📋 Dịch vụ: " + serviceName + "\n" +
                        "💰 Giá: " + new Intl.NumberFormat('vi-VN').format(price) + " VND\n" +
                        "🆔 Mã: #SV" + serviceId + "\n\n" +
                        "Xin chào! Tôi muốn đặt dịch vụ trên. Vui lòng tư vấn thêm cho tôi.";

                // Mở Zalo
                const zaloUrl = "https://zalo.me/" + SHOP_CONFIG.zaloId + "?message=" + encodeURIComponent(message);
                window.open(zaloUrl, '_blank');
            }

            // Tư vấn dịch vụ qua Zalo  
            function consultService(serviceName) {
                const message = "💬 TƯ VẤN DỊCH VỤ - " + SHOP_CONFIG.shopName + "\n\n" +
                        "📋 Về dịch vụ: " + serviceName + "\n\n" +
                        "Xin chào! Tôi cần được tư vấn thêm về dịch vụ này. Cảm ơn!";

                const zaloUrl = "https://zalo.me/" + SHOP_CONFIG.zaloId + "?message=" + encodeURIComponent(message);
                window.open(zaloUrl, '_blank');
            }

            // Gọi điện trực tiếp
            function callDirectly() {
                if (confirm("Gọi đến " + SHOP_CONFIG.phoneNumber + "?")) {
                    window.open("tel:" + SHOP_CONFIG.phoneNumber, '_self');
                }
            }

            // Log user interest (optional - để tracking)
            function logUserInterest(serviceId, action) {
                // Có thể gọi API để log, hoặc bỏ nếu không cần
                fetch('MainController', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: `action=logServiceInterest&serviceId=${serviceId}&interestType=${action}`
                }).catch(e => console.log('Tracking failed:', e)); // Silent fail
            }

            // ===== UI EFFECTS =====
            document.addEventListener('DOMContentLoaded', function () {
                // Hover effects
                const actionButtons = document.querySelectorAll('.btn-service');
                actionButtons.forEach(btn => {
                    btn.addEventListener('mouseenter', function () {
                        this.style.transform = 'translateY(-2px)';
                    });
                    btn.addEventListener('mouseleave', function () {
                        this.style.transform = 'translateY(0)';
                    });
                });

                // Success notification after page load (if redirected back)
                const urlParams = new URLSearchParams(window.location.search);
                if (urlParams.get('contacted') === 'true') {
                    showNotification('✅ Cảm ơn bạn đã liên hệ! Chúng tôi sẽ phản hồi sớm nhất.', 'success');
                }
            });

            // Simple notification system
            function showNotification(message, type = 'info') {
                const notification = document.createElement('div');
                notification.style.cssText =
                        "position: fixed; top: 20px; right: 20px; z-index: 9999;" +
                        "padding: 12px 20px; border-radius: 8px; color: white; font-weight: 600;" +
                        "background: " + (type === 'success' ? '#10b981' : '#3b82f6') + ";" +
                        "box-shadow: 0 4px 12px rgba(0,0,0,0.15); cursor: pointer;" +
                        "transform: translateX(100%); transition: transform 0.3s ease;";
                notification.textContent = message;
                notification.onclick = () => notification.remove();

                document.body.appendChild(notification);
                setTimeout(() => notification.style.transform = 'translateX(0)', 100);
                setTimeout(() => notification.remove(), 5000);
            }
        </script>
    </body>
</html>
