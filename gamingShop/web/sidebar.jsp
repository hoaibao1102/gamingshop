<%-- 
    Document   : sidebar
    Created on : 05-09-2025, 14:22:20
    Author     : MSI PC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <title>Sidebar Sản phẩm nổi bật</title>
        <style>
            :root{
                --ring:#e5e7eb;
                --ink:#111827;
                --muted:#6b7280;
                --chip:#e6e6e6;            /* nền khối TÊN/GIÁ */
                --shadow:0 6px 18px rgba(0,0,0,.08);
            }
            *{
                box-sizing:border-box
            }
            body{
                margin:0;
                font-family:system-ui,-apple-system,Segoe UI,Roboto,Helvetica,Arial,sans-serif;
                color:var(--ink);
                background:#fafafa
            }

            /* Sidebar */
            .sidebar{
                width:100%;
                max-width:280px;
                background:var(--panel);
                border:1px solid var(--ring);
                padding:12px;
                box-shadow:var(--shadow);
                position:sticky;
                top:12px;
            }

            /* Logo card */
            .logo-card{
                background:var(--panel);
                border-radius:14px;
                padding:18px 12px 8px;
                display:grid;
                place-items:center;
                box-shadow:var(--shadow);
            }
            .logo{
                width:110px;
                height:110px;
                border-radius:50%;
                object-fit:cover;
                display:block;
                box-shadow:0 10px 22px rgba(0,0,0,.18);
            }

            /* Menu dưới logo */
            .sb-nav {
                display: flex;
                flex-direction: column;
                margin: 14px 4px;
                gap: 10px;
            }
            .sb-nav a {
                display: block;
                padding: 10px 12px;
                border-radius: 10px;
                background: #fff;
                color: var(--ink);
                font-weight: 600;
                text-decoration: none;
                box-shadow: var(--shadow);
                transition: background 0.2s;
            }
            .sb-nav a:hover {
                background: #f1f5f9;
            }

            .divider{
                height:1px;
                background:var(--ring);
                margin:12px 4px 10px;
                border:0;
            }

            /* Title */
            .sb-title{
                margin:0 4px 10px;
                font-size:16px;
                font-weight:800;
                letter-spacing:.2px;
                color:#1f2937;
            }

            /* List */
            .featured-list{
                list-style:none;
                margin:0;
                padding:0;
                display:grid;
                gap:12px
            }
            .item{
                display:grid;
                grid-template-columns:1fr auto;
                gap:10px;
                align-items:center;
                background:#fff;
                padding:8px;
                border-radius:12px;
                box-shadow:var(--shadow);
                transition: transform .12s;
            }
            .item:hover{
                transform:translateY(-2px);
            }
            .thumb{
                width:100%;
                height:82px;
                object-fit:cover;
                border-radius:10px;
            }

            /* TÊN / GIÁ box */
            .meta{
                width:60px;
                height:82px;
                background:var(--chip);
                border-radius:8px;
                display:grid;
                grid-template-rows:1fr 1fr;
                overflow:hidden;
                text-decoration:none;
            }
            .meta .cell{
                display:flex;
                align-items:center;
                justify-content:center;
                font-weight:700;
                font-size:13px;
                color:#2b2b2b;
                border-bottom:1px solid rgba(0,0,0,.08);
            }
            .meta .cell:last-child{
                border-bottom:0
            }

            /* Responsive: full width khi màn hình hẹp */
            @media (max-width: 768px){
                .sidebar{
                    max-width:100%;
                    border-radius:16px
                }
            }
        </style>
    </head>
    <body>

        <aside class="sidebar">
            <!-- Logo -->
            <div class="logo-card">
                <img class="logo" src="https://via.placeholder.com/220x220.png?text=LOGO" alt="Logo cửa hàng">
            </div>

            <!-- Menu -->
            <nav class="sb-nav">
                <a href="index.jsp">🏠 Trang chủ</a>
                <a href="#">📰 Bài đăng gần đây</a>
            </nav>

            <hr class="divider">

            <!-- Danh sách sản phẩm nổi bật -->
            <h3 class="sb-title">Sản phẩm nổi bật</h3>
            <ul class="featured-list">
                <li class="item">
                    <img class="thumb" src="https://via.placeholder.com/320x220.jpg?text=SP+1" alt="Sản phẩm 1">
                    <a class="meta" href="#">
                        <span class="cell">TÊN</span>
                        <span class="cell">GIÁ</span>
                    </a>
                </li>
                <li class="item">
                    <img class="thumb" src="https://via.placeholder.com/320x220.jpg?text=SP+2" alt="Sản phẩm 2">
                    <a class="meta" href="#">
                        <span class="cell">TÊN</span>
                        <span class="cell">GIÁ</span>
                    </a>
                </li>
                <li class="item">
                    <img class="thumb" src="https://via.placeholder.com/320x220.jpg?text=SP+3" alt="Sản phẩm 3">
                    <a class="meta" href="#">
                        <span class="cell">TÊN</span>
                        <span class="cell">GIÁ</span>
                    </a>
                </li>
            </ul>
        </aside>

    </body>
</html>
