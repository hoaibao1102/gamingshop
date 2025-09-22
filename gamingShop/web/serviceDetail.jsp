<%-- 
    Document   : serviceDetail
    Created on : Sep 19, 2025
    Author     : ddhuy
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:setLocale value="vi_VN" />

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <title>SHOP GAME VIỆT 38 - Chi tiết dịch vụ</title>
        <%@ include file="/WEB-INF/jspf/head.jspf" %>
        <style>
            /* =========================
   Base + Variables (giữ gọn)
========================= */
            :root{
                --bg:#f8fafc;
                --text:#111827;
                --muted:#6b7280;
                --accent:#7c3aed;
                --service-accent:#2563eb;
                --danger:#e11d48;
                --success:#10b981;
                --border:#e5e7eb;
                --shadow:0 10px 40px rgba(0,0,0,.08);
            }
            *{
                box-sizing:border-box;
            }
            html,body{
                margin:0;
                padding:0;
                width:100%;
                height:100%;
                background:var(--bg);
                color:var(--text);
                font-family:Inter,-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Oxygen,Ubuntu,Cantarell,sans-serif;
            }

            /* =========================
               App Shell
            ========================= */
            .wrapper{
                display:flex;
                gap:20px;
                padding:0 20px;
                min-height:100vh;
                width:100%;
            }
            .sidebar{
                flex:3;
                background:linear-gradient(135deg,#2c3e50,#34495e);
                color:#fff;
                border-radius:20px;
                padding:24px;
                box-shadow:var(--shadow);
                position:sticky;
                top:20px;
                height:fit-content;
            }
            .Main_content{
                flex:7;
                background:#fff;
                border-radius:20px;
                box-shadow:var(--shadow);
                display:flex;
                flex-direction:column;
                min-width:0;
            }
            .container{
                padding:16px 20px;
            }

            /* =========================
               Service Detail Layout
            ========================= */
            .service-detail{
                display:grid;
                gap:20px;
                align-items:start;
                grid-template-columns:minmax(380px,2fr) minmax(0,8fr);
            }

            /* Service Icon/Visual */
            .sd-left{
                background:#fff;
                border-radius:16px;
                box-shadow:var(--shadow);
                padding:20px;
                position:sticky;
                top:16px;
            }
            
            .sd-visual{
                width:100%;
                height:320px;
                border:2px dashed var(--border);
                border-radius:12px;
                display:flex;
                flex-direction:column;
                align-items:center;
                justify-content:center;
                background:linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
                position:relative;
                overflow:hidden;
            }
            
            .sd-visual::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: 
                    radial-gradient(circle at 20% 80%, rgba(37, 99, 235, 0.1) 0%, transparent 50%),
                    radial-gradient(circle at 80% 20%, rgba(124, 58, 237, 0.1) 0%, transparent 50%);
            }
            
            .service-icon{
                font-size: 80px;
                margin-bottom: 16px;
                color: var(--service-accent);
                position: relative;
                z-index: 1;
            }
            
            .service-type-badge{
                background: linear-gradient(135deg, var(--service-accent), var(--accent));
                color: white;
                padding: 8px 16px;
                border-radius: 20px;
                font-size: 14px;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                position: relative;
                z-index: 1;
            }

            /* Service Info */
            .sd-right{
                background:#fff;
                border-radius:16px;
                box-shadow:var(--shadow);
                padding:24px;
                height:fit-content;
            }
            
            .sd-header{
                border-bottom: 2px solid var(--border);
                padding-bottom: 20px;
                margin-bottom: 24px;
            }
            
            .sd-name{
                margin:0 0 12px;
                font-size:28px;
                font-weight:800;
                line-height:1.2;
                color: var(--text);
            }
            
            .sd-basic{
                display:grid;
                gap:16px;
                margin-bottom:20px;
            }
            
            .sd-row{
                display:grid;
                grid-template-columns:140px 1fr;
                gap:16px;
                align-items:center;
                font-size:15px;
                padding: 12px 0;
                border-bottom: 1px solid #f1f5f9;
            }
            
            .sd-row:last-child {
                border-bottom: none;
            }
            
            .sd-row b{
                color:var(--muted);
                font-weight:700;
                text-transform: uppercase;
                font-size: 13px;
                letter-spacing: 0.5px;
            }
            
            .sd-row span{
                color:var(--text);
                font-weight:600;
                font-size: 16px;
            }
            
            .sd-row-price{
                background: linear-gradient(135deg, #fee2e2, #fef3c7);
                border: 2px solid #fed7aa;
                border-radius:16px;
                padding:20px;
                margin-top:12px;
                position: relative;
                overflow: hidden;
            }
            
            .sd-row-price::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: linear-gradient(45deg, transparent 30%, rgba(255,255,255,0.2) 50%, transparent 70%);
                animation: shimmer 2s infinite;
            }
            
            @keyframes shimmer {
                0% { transform: translateX(-100%); }
                100% { transform: translateX(100%); }
            }
            
            .sd-row-price b {
                color: #b91c1c;
            }
            
            .sd-row-price span{
                color:#dc2626;
                font-size:24px;
                font-weight:900;
                position: relative;
                z-index: 1;
            }

            /* Service Status & Meta */
            .sd-meta {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 16px;
                margin: 20px 0;
                padding: 20px;
                background: #f8fafc;
                border-radius: 12px;
                border: 1px solid var(--border);
            }
            
            .sd-meta-item {
                text-align: center;
                padding: 12px;
            }
            
            .sd-meta-item .label {
                font-size: 12px;
                color: var(--muted);
                text-transform: uppercase;
                font-weight: 600;
                margin-bottom: 6px;
            }
            
            .sd-meta-item .value {
                font-size: 14px;
                font-weight: 700;
                color: var(--text);
            }
            
            .status-active {
                color: var(--success);
            }

            /* Description */
            .sd-desc{
                margin-top:24px;
                padding-top:24px;
                border-top:2px dashed var(--border);
                font-size:15px;
                line-height:1.7;
                color:#1f2937;
            }
            
            .sd-desc-title {
                font-size: 20px;
                font-weight: 700;
                margin-bottom: 16px;
                color: var(--service-accent);
                display: flex;
                align-items: center;
                gap: 8px;
            }
            
            .sd-desc-title::before {
                content: "📋";
                font-size: 24px;
            }
            
            .sd-desc-content {
                background: #fafbfc;
                border: 1px solid var(--border);
                border-radius: 12px;
                padding: 20px;
            }
            
            .sd-desc-content > *:first-child{
                margin-top:0;
            }
            .sd-desc-content h1,.sd-desc-content h2,.sd-desc-content h3{
                margin:16px 0 10px;
                line-height:1.3;
                color: var(--service-accent);
            }
            .sd-desc-content p{
                margin:10px 0;
            }
            .sd-desc-content ul, .sd-desc-content ol{
                padding-left:24px;
                margin:10px 0;
            }
            .sd-desc-content li {
                margin: 6px 0;
            }
            .sd-desc-content img, .sd-desc-content iframe{
                max-width:100%;
                height:auto;
                display:block;
                margin:12px auto;
                border-radius: 8px;
            }
            .sd-desc-content table{
                width:100%;
                border-collapse:collapse;
                margin: 16px 0;
            }
            .sd-desc-content table td, .sd-desc-content table th{
                border:1px solid #e5e7eb;
                padding:10px;
            }

            /* Action Buttons */
            .sd-actions {
                margin-top: 24px;
                padding-top: 20px;
                border-top: 1px solid var(--border);
                display: flex;
                gap: 12px;
                flex-wrap: wrap;
            }
            
            .btn-service {
                padding: 12px 24px;
                border: none;
                border-radius: 8px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 8px;
                font-size: 14px;
            }
            
            .btn-primary {
                background: linear-gradient(135deg, var(--service-accent), var(--accent));
                color: white;
            }
            
            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(37, 99, 235, 0.3);
            }
            
            .btn-secondary {
                background: #f1f5f9;
                color: var(--text);
                border: 1px solid var(--border);
            }
            
            .btn-secondary:hover {
                background: #e2e8f0;
                transform: translateY(-1px);
            }

            /* Empty state */
            .empty-state{
                text-align:center;
                padding:60px 20px;
                background: #fff;
                border-radius: 16px;
                box-shadow: var(--shadow);
            }
            .empty-state h3{
                font-size:24px;
                margin-bottom:12px;
                color: var(--text);
            }
            .empty-state p{
                font-size:16px;
                color: var(--muted);
                margin-bottom: 20px;
            }

            /* Back button */
            .back-link {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                margin-bottom: 16px;
                color: var(--service-accent);
                text-decoration: none;
                font-weight: 600;
                padding: 8px 12px;
                border-radius: 6px;
                transition: all 0.3s ease;
            }
            
            .back-link:hover {
                background: #f1f5f9;
                transform: translateX(-4px);
            }

            /* =========================
               Responsive
            ========================= */
            @media (max-width:1280px){
                html,body{
                    overflow-x:hidden;
                }

                .wrapper{
                    display:block;
                    padding:0 !important;
                    gap:0 !important;
                    min-height:100dvh;
                }
                .sidebar{
                    display:none !important;
                }

                .Main_content{
                    width:100% !important;
                    max-width:100% !important;
                    border-radius:0 !important;
                    box-shadow:none !important;
                    overflow:visible;
                }
                .container{
                    padding:12px !important;
                }

                .service-detail{
                    grid-template-columns:1fr !important;
                    gap:12px !important;
                }

                .sd-left{
                    position:static !important;
                    padding:16px !important;
                    border-radius:12px !important;
                }
                
                .sd-visual {
                    height: 200px !important;
                }
                
                .service-icon {
                    font-size: 60px !important;
                }

                .sd-right{
                    padding:16px !important;
                    border-radius:12px !important;
                }
                
                .sd-name{
                    font-size:22px !important;
                }
                
                .sd-row{
                    grid-template-columns:120px 1fr !important;
                    gap:12px !important;
                    font-size:14px !important;
                    padding: 10px 0 !important;
                }
                
                .sd-row-price{
                    padding:16px !important;
                }
                .sd-row-price span{
                    font-size:20px !important;
                }
                
                .sd-meta {
                    grid-template-columns: 1fr 1fr !important;
                    gap: 12px !important;
                    padding: 16px !important;
                }
                
                .sd-actions {
                    flex-direction: column !important;
                }
                
                .btn-service {
                    justify-content: center !important;
                }
            }

            @media (max-width:640px){
                .container{
                    padding:10px !important;
                }
                
                .sd-visual {
                    height: 160px !important;
                }
                
                .service-icon {
                    font-size: 48px !important;
                }
                
                .sd-row{
                    grid-template-columns:100px 1fr !important;
                    gap:10px !important;
                }
                
                .sd-meta {
                    grid-template-columns: 1fr !important;
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
                    <a href="MainController?action=getServices" class="back-link">
                        ← Quay lại danh sách dịch vụ
                    </a>
                    
                    <c:choose>
                        <c:when test="${not empty serviceDetail}">
                            <div class="service-detail">
                                <!-- LEFT: Service Visual -->
                                <div class="sd-left">
                                    <div class="sd-visual">
                                        <div class="service-icon">🎮</div>
                                        <div class="service-type-badge">${serviceDetail.service_type}</div>
                                    </div>
                                </div>

                                <!-- RIGHT: Service Info + Description -->
                                <div class="sd-right">
                                    <div class="sd-header">
                                        <div class="sd-name">${serviceDetail.service_type}</div>
                                    </div>

                                    <div class="sd-basic">
                                        <div class="sd-row">
                                            <b>Mã dịch vụ</b>
                                            <span>#SV${serviceDetail.id}</span>
                                        </div>
                                        <div class="sd-row">
                                            <b>Loại dịch vụ</b>
                                            <span>${serviceDetail.service_type}</span>
                                        </div>
                                        <div class="sd-row sd-row-price">
                                            <b>Giá dịch vụ</b>
                                            <span>
                                                <fmt:formatNumber value="${serviceDetail.price}" type="number" groupingUsed="true" maxFractionDigits="0"/> VND
                                            </span>
                                        </div>
                                    </div>

                                    <!-- Service Meta Information -->
                                    <div class="sd-meta">
                                        <div class="sd-meta-item">
                                            <div class="label">Trạng thái</div>
                                            <div class="value status-active">
                                                <c:choose>
                                                    <c:when test="${serviceDetail.status eq 'active'}">
                                                        ✅ Đang hoạt động
                                                    </c:when>
                                                    <c:otherwise>
                                                        ❌ Tạm dừng
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        <div class="sd-meta-item">
                                            <div class="label">Ngày tạo</div>
                                            <div class="value">
                                                <fmt:formatDate value="${serviceDetail.created_at}" pattern="dd/MM/yyyy"/>
                                            </div>
                                        </div>
                                        <c:if test="${not empty serviceDetail.updated_at}">
                                            <div class="sd-meta-item">
                                                <div class="label">Cập nhật</div>
                                                <div class="value">
                                                    <fmt:formatDate value="${serviceDetail.updated_at}" pattern="dd/MM/yyyy"/>
                                                </div>
                                            </div>
                                        </c:if>
                                    </div>

                                    <!-- Action Buttons -->
                                    <div class="sd-actions">
                                        <button onclick="bookService('${serviceDetail.id}', '${serviceDetail.service_type}', '${serviceDetail.price}')" class="btn-service btn-primary">
                                            🛒 Đặt dịch vụ qua Zalo
                                        </button>
                                        <button onclick="callDirectly()" class="btn-service btn-secondary">
                                            📞 Gọi trực tiếp
                                        </button>
                                        <a href="MainController?action=listDichVu" class="btn-service btn-secondary">
                                            📋 Xem dịch vụ khác
                                        </a>
                                    </div>

                                    <!-- Description -->
                                    <c:if test="${not empty serviceDetail.description_html}">
                                        <div class="sd-desc">
                                            <div class="sd-desc-title">
                                                Mô tả chi tiết dịch vụ
                                            </div>
                                            <div class="sd-desc-content">
                                                ${serviceDetail.description_html}
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </c:when>

                        <c:otherwise>
                            <div class="empty-state">
                                <h3>Không tìm thấy dịch vụ</h3>
                                <p>Dịch vụ bạn đang tìm kiếm không tồn tại hoặc đã bị xóa.</p>
                                <c:if test="${not empty checkErrorService}">
                                    <p><c:out value="${checkErrorService}"/></p>
                                </c:if>
                                <form action="MainController" method="get" style="margin-top:16px;">
                                    <input type="hidden" name="action" value="getServices"/>
                                    <button class="btn-service btn-primary" type="submit">
                                        Xem tất cả dịch vụ
                                    </button>
                                </form>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <jsp:include page="footer.jsp"/>

        <script>
            // ===== CONFIG - Thay đổi thông tin liên hệ ở đây =====
            const SHOP_CONFIG = {
                zaloId: '0357394235',        // Thay bằng Zalo ID thực tế
                phoneNumber: '0357394235',   // Thay bằng SĐT thực tế
                shopName: 'SHOP GAME VIỆT'
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
            document.addEventListener('DOMContentLoaded', function() {
                // Hover effects
                const actionButtons = document.querySelectorAll('.btn-service');
                actionButtons.forEach(btn => {
                    btn.addEventListener('mouseenter', function() {
                        this.style.transform = 'translateY(-2px)';
                    });
                    btn.addEventListener('mouseleave', function() {
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