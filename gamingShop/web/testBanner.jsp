<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, dto.Banners" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Test Banner</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin:0;
                padding:0;
                background:#f6f7fb;
            }
            .banner-container {
                display:flex;
                flex-wrap:wrap;
                gap:16px;
                padding:24px;
                justify-content:center;
            }
            .banner-card {
                background:#fff;
                border-radius:8px;
                box-shadow:0 2px 6px rgba(0,0,0,0.1);
                width:260px;
                overflow:hidden;
                transition:.3s;
            }
            .banner-card:hover {
                transform: translateY(-4px);
            }
            .banner-img {
                width:100%;
                height:160px;
                object-fit:cover;
            }
            .banner-body {
                padding:12px;
            }
            .banner-title {
                font-weight:bold;
                margin:0 0 8px 0;
            }
            .banner-status {
                font-size:12px;
                padding:2px 8px;
                border-radius:12px;
                color:#fff;
            }
            .active {
                background:#198754;
            }
            .inactive {
                background:#6c757d;
            }
        </style>
    </head>
    <body>

        <h2 style="text-align:center; padding:16px 0; margin:0;">Danh sách Banners Active</h2>

        <div class="banner-container">
            <%
                @SuppressWarnings("unchecked")
                List<Banners> list = (List<Banners>) request.getAttribute("list");
                if (list != null && !list.isEmpty()) {
                    for (Banners b : list) {
                        if ("active".equalsIgnoreCase(b.getStatus())) {
            %>
            <div class="banner-card">
                <% if (b.getImage_url() != null && !b.getImage_url().isEmpty()) { %>
                <img class="banner-img" src="<%= request.getContextPath() + "/" + b.getImage_url() %>" alt="banner"/>
                <% } else { %>
                <div style="width:100%; height:160px; background:#eee; display:flex; align-items:center; justify-content:center;">
                    <span style="color:#888;">(Không có ảnh)</span>
                </div>
                <% } %>
                <div class="banner-body">
                    <div class="banner-title"><%= b.getTitle() %></div>
                    <div class="banner-status active"><%= b.getStatus() %></div>
                </div>
            </div>
            <%
                        }
                    }
                } else {
            %>
            <p style="color:#888;">Không có banner nào.</p>
            <%
                }
            %>
        </div>

    </body>
</html>
