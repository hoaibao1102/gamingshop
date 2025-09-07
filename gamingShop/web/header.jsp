<%-- 
    Document   : header
    Created on : May 12, 2025
    Author     : MSI PC
--%>
<%@ page import="dto.Accounts"%>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <title>Header Mobile + Desktop</title>
        <style>
            :root{
                --bg:#ffffff;
                --text:#111827;
                --muted:#6b7280;
                --primary:#2563eb;
                --ring:#e5e7eb;
                --soft:#f8fafc;
                --accent:#111827;
                --badge:#16a34a;
                --danger:#ef4444;
                --shadow:0 10px 24px rgba(0,0,0,.06);
                --radius:12px;
                --maxw:1200px;
            }
            *{
                box-sizing: border-box
            }
            body{
                margin:0;
                font-family: ui-sans-serif, system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial, sans-serif;
                color:var(--text);
                background:#fafafa;
            }
            a{
                color:inherit;
                text-decoration:none
            }

            /* ===== HEADER WRAPPER ===== */
            .site-header{
                position: sticky;
                top:0;
                z-index: 60;
                background: var(--bg);
                box-shadow: var(--shadow);
            }

            /* ===== MOBILE TOP BAR ===== */
            .topbar{
                display:grid;
                grid-template-columns:auto 1fr auto;
                align-items:center;
                gap:10px;
                padding:10px 12px;
                border-bottom:1px solid var(--ring);
            }
            .left-group{
                display:flex;
                align-items:center;
                gap:10px
            }
            .brand-name{
                font-weight:800;
                letter-spacing:.3px
            }

            .icon-btn, .hamburger{
                width:38px;
                height:38px;
                border:1px solid var(--ring);
                border-radius:10px;
                background:#fff;
                position:relative;
                cursor:pointer;
            }
            .hamburger::before, .hamburger::after, .hamburger span{
                content:"";
                position:absolute;
                left:9px;
                right:9px;
                height:2px;
                background:var(--text);
                transition:.2s;
            }
            .hamburger::before{
                top:11px
            }
            .hamburger span{
                top:18px
            }
            .hamburger::after{
                top:25px
            }

            /* Search pill */
            .search{
                position:relative
            }
            .search input{
                width:100%;
                height:38px;
                border:1px solid var(--ring);
                border-radius:999px;
                background:var(--soft);
                padding:0 40px 0 38px;
                outline:none;
            }
            .search button{
                position:absolute;
                left:8px;
                top:50%;
                transform:translateY(-50%);
                width:26px;
                height:26px;
                border:0;
                background:transparent;
                padding:0;
                cursor:pointer;
            }
            .search svg{
                width:20px;
                height:20px
            }

            /* Mobile drawer */
            #nav-toggle{
                display:none
            }
            .drawer{
                position:fixed;
                top:0;
                left:0;
                bottom:0;
                width:70%;
                max-width:320px;
                background:#fff;
                border-right:1px solid var(--ring);
                padding:16px 18px 24px;
                transform:translateX(-100%);
                transition:transform .22s ease;
                z-index:70;
                overflow:auto;
            }
            .drawer .menu{
                list-style:none;
                margin:0;
                padding:0
            }
            .drawer .menu li a{
                display:block;
                padding:14px 6px;
                font-weight:600;
                border-bottom:1px solid var(--ring);
            }
            .backdrop{
                position:fixed;
                inset:0;
                background:rgba(0,0,0,.28);
                opacity:0;
                pointer-events:none;
                transition:.2s;
                z-index:65;
            }
            #nav-toggle:checked ~ .topbar .hamburger::before{
                transform:translateY(7px) rotate(45deg)
            }
            #nav-toggle:checked ~ .topbar .hamburger span{
                opacity:0
            }
            #nav-toggle:checked ~ .topbar .hamburger::after{
                transform:translateY(-7px) rotate(-45deg)
            }
            #nav-toggle:checked ~ .drawer{
                transform:translateX(0)
            }
            #nav-toggle:checked ~ .backdrop{
                opacity:1;
                pointer-events:auto
            }

            /* Hide desktopbar on mobile */
            .desktopbar{
                display:none
            }

            /* ===== DESKTOP BAR ===== */
            @media (min-width: 992px){
                .topbar{
                    display:none
                }

                /* Thanh header full-width, canh giữa/nav ở giữa, actions dính mép phải */
                .desktopbar{
                    display:block;
                    position:relative;
                    height:64px;
                    width:100%;
                    padding:10px 20px;
                    border-bottom:1px solid var(--ring);
                    background:var(--bg);
                }

                /* NAV: nằm chính giữa theo trục ngang + dọc */
                .nav{
                    position:absolute;
                    left:50%;
                    top:50%;
                    transform:translate(-50%, -50%);
                }
                .nav ul{
                    display:flex;
                    gap:28px;
                    list-style:none;
                    margin:0;
                    padding:0;
                }
                .nav a{
                    font-weight:600;
                    padding:12px 2px;
                    border-radius:8px;
                    white-space:nowrap;
                }
                .nav a:hover{
                    color:var(--primary);
                    background:#eff6ff;
                }
                .nav a.active{
                    color:var(--primary);
                    position:relative;
                }
                .nav a.active::after{
                    content:"";
                    position:absolute;
                    left:0;
                    right:0;
                    bottom:4px;
                    height:3px;
                    border-radius:999px;
                    background:var(--primary);
                }

                /* === DROPDOWN CHO "MÁY CHƠI GAME" === */
                .nav li{ position: relative; }
                .nav .dropdown{
                    position:absolute;
                    top:100%;
                    left:0;
                    min-width:180px;
                    background:#fff;
                    border:1px solid var(--ring);
                    border-radius:10px;
                    box-shadow: var(--shadow);
                    padding:8px;
                    list-style:none;
                    margin:8px 0 0 0;
                    opacity:0;
                    visibility:hidden;
                    transform: translateY(6px);
                    transition: .16s ease;
                    z-index: 80;
                }
                .nav li:hover > .dropdown{
                    opacity:1;
                    visibility:visible;
                    transform: translateY(0);
                }
                .nav .dropdown a{
                    display:block;
                    padding:10px 12px;
                    border-radius:8px;
                    font-weight:600;
                    white-space:nowrap;
                }
                .nav .dropdown a:hover{
                    background:#f8fafc;
                    color:var(--primary);
                }
                /* Mũi tên nhỏ chỉ dropdown (tuỳ chọn) */
                .nav li.has-dd > a::after{
                    content:"▾";
                    margin-left:6px;
                    font-size:12px;
                }

                /* ACTIONS: dính sát mép phải màn hình */
                .actions{
                    position:absolute;
                    right:20px;
                    top:50%;
                    transform:translateY(-50%);
                    display:flex;
                    align-items:center;
                    gap:10px;
                }

                /* Pill user + nút */
                .user-pill{
                    display:flex;
                    align-items:center;
                    gap:10px;
                    background:#f1f5f9;
                    border:1px solid var(--ring);
                    border-radius:999px;
                    padding:6px 10px;
                    font-weight:600;
                }
                .avatar{
                    width:28px;
                    height:28px;
                    border-radius:50%;
                    display:grid;
                    place-items:center;
                    background:#111827;
                    color:#fff;
                    font-weight:800;
                    font-size:12px;
                }
                .badge{
                    display:inline-block;
                    padding:2px 8px;
                    border-radius:999px;
                    background:#dcfce7;
                    color:#166534;
                    font-size:12px;
                    font-weight:700;
                }
                .btn{
                    display:inline-flex;
                    align-items:center;
                    gap:8px;
                    cursor:pointer;
                    border-radius:999px;
                    border:1px solid var(--ring);
                    background:#fff;
                    padding:8px 14px;
                    font-weight:700;
                }
                .btn:hover{
                    background:#f9fafb
                }
                .btn.primary{
                    background:#111827;
                    color:#fff;
                    border-color:#111827
                }
                .btn svg{
                    width:18px;
                    height:18px
                }
                .link{
                    font-weight:700;
                    color:var(--primary);
                    padding:8px 12px;
                    border-radius:8px
                }
                .link:hover{
                    background:#eff6ff
                }
            }

        </style>
    </head>
    <body>

        <%
            // Lấy user từ session (đặt ở chỗ login)
            Accounts user = (Accounts) session.getAttribute("user");
            boolean loginCheck = user != null;
            String username = loginCheck ? (user.getUsername() != null ? user.getUsername() : "Admin") : "";
            String avatarChar = "";
            if (loginCheck && username.trim().length() > 0) {
                avatarChar = username.substring(0,1).toUpperCase();
            }
        %>

        <header class="site-header">
            <!-- Toggle ẩn/hiện menu mobile -->
            <input id="nav-toggle" type="checkbox">

            <!-- ====== TOP BAR (MOBILE) ====== -->
            <div class="topbar">
                <div class="left-group">
                    <label for="nav-toggle" class="hamburger" aria-label="Mở menu"><span></span></label>
                    <span class="brand-name">MYSHOP</span>
                </div>

                <form class="search" role="search" aria-label="Tìm kiếm">
                    <button aria-label="Tìm">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="7"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                    </button>
                    <input type="search" placeholder="Tìm sản phẩm...">
                </form>
            </div>

            <!-- ====== MENU DRAWER (MOBILE) ====== -->
            <nav class="drawer" aria-label="Menu di động">
                <div style="font-weight:800; margin-bottom:10px;">Danh mục</div>
                <ul class="menu">
                    <li><a href="#">Máy chơi game</a></li>
                    <li><a href="#">Phụ kiện</a></li>
                    <li><a href="#">Thẻ game</a></li>
                    <li><a href="#">Dịch vụ</a></li>
                    <li><a href="#">Liên hệ</a></li>
                </ul>

                <hr style="margin:14px 0; border:0; height:1px; background:var(--ring)">

                <div style="display:flex; gap:10px; align-items:center;">
                    <%
                        if (loginCheck) {
                    %>
                    <div class="avatar"><%= avatarChar %></div>
                    <div>
                        <div style="font-weight:700;"><%= username %></div>
                        <div style="font-size:12px; color:var(--muted);">Đã đăng nhập</div>
                    </div>
                    <%
                        } else {
                    %>
                    <div style="font-size:14px; color:var(--muted);">Bạn chưa đăng nhập</div>
                    <%
                        }
                    %>
                </div>

                <div style="margin-top:12px; display:flex; gap:8px; flex-wrap:wrap;">
                    <%
                        if (loginCheck) {
                    %>
                    <form action="MainController" method="post" style="margin:0">
                        <input type="hidden" name="action" value="logout"/>
                        <button class="btn" type="submit">Đăng xuất</button>
                    </form>
                    <%
                        } else {
                    %>
                    <a class="btn primary" href="login.jsp">Đăng nhập</a>
                    <%
                        }
                    %>
                </div>
            </nav>
            <label class="backdrop" for="nav-toggle" aria-hidden="true"></label>

            <!-- ====== DESKTOP BAR ====== -->
            <div class="desktopbar">
                <!-- Nav -->
                <nav class="nav" aria-label="Chính">
                    <ul>
                        <!-- Mục có dropdown -->
                        <li class="has-dd">
                            <a href="#">Máy chơi game</a>
                            <ul class="dropdown" aria-label="Danh mục Máy chơi game">
                                <li><a href="products.jsp?condition=new">New</a></li>
                                <li><a href="products.jsp?condition=likenew">Like New</a></li>
                            </ul>
                        </li>

                        <li><a href="#">Phụ kiện</a></li>
                        <li><a href="#">Thẻ game</a></li>
                        <li><a href="#">Dịch vụ</a></li>
                        <li><a href="#">Liên hệ</a></li>
                    </ul>
                </nav>

                <!-- Actions (Đăng nhập / Đăng xuất) -->
                <div class="actions">
                    <%
                        if (loginCheck) {
                    %>
                    <!-- Đã đăng nhập: hiển thị avatar + tên + badge + nút logout -->
                    <div class="user-pill">
                        <div class="avatar"><%= avatarChar %></div>
                        <div style="display:flex; flex-direction:column; line-height:1.2;">
                            <span><%= username %></span>
                            <span class="badge">Admin</span>
                        </div>
                    </div>
                    <form action="MainController" method="post" style="margin:0">
                        <input type="hidden" name="action" value="logout"/>
                        <button class="btn" type="submit" title="Đăng xuất">
                            <!-- icon logout -->
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/>
                                <path d="M10 17l5-5-5-5"/>
                                <path d="M15 12H3"/>
                            </svg>
                            Đăng xuất
                        </button>
                    </form>
                    <%
                        } else {
                    %>
                    <!-- Chưa đăng nhập: nút login -->
                    <a class="btn primary" href="login.jsp" title="Đăng nhập">
                        <!-- icon user -->
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                            <circle cx="12" cy="7" r="4"/>
                        </svg>
                        Đăng nhập
                    </a>
                    <%
                        }
                    %>
                </div>
            </div>
        </header>

    </body>
</html>
