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
                box-sizing:border-box
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

            /* Form button như link */
            .link-form {
                display:inline;
                margin:0;
                padding:0;
            }
            .link-button{
                background:none;
                border:none;
                padding:0;
                margin:0;
                font:inherit;
                color:inherit;
                text-decoration:none;
                cursor:pointer;
                display:inline-flex;
                align-items:center;
                gap:8px;
                font-weight:600;
                line-height:1;
                white-space:nowrap;
            }
            .link-button:hover{
                color:var(--primary);
                background:#eff6ff;
            }

            /* Mobile menu button */
            .mobile-link-form{
                width:100%;
                margin:0;
                padding:0;
            }
            .mobile-link-button{
                width:100%;
                background:none;
                border:none;
                padding:14px 6px;
                margin:0;
                font:inherit;
                color:inherit;
                cursor:pointer;
                display:block;
                font-weight:600;
                border-bottom:1px solid var(--ring);
                text-align:left;
                position:relative;
            }

            /* (GIỮ LẠI CLASS cho tương thích, nhưng dropdown luôn mở) */
            .mobile-dropdown{
                max-height:0;
                overflow:hidden;
                background:#f8fafc;
                transition:max-height .3s ease;
            }
            .mobile-dropdown .mobile-link-form{
                border-left:3px solid var(--primary);
            }
            .mobile-dropdown .mobile-link-button{
                padding:12px 20px;
                font-size:14px;
                background:#f8fafc;
                border-bottom:1px solid #e2e8f0;
            }
            .mobile-dropdown .mobile-link-button:hover{
                background:#e2e8f0;
                color:var(--primary);
            }

            /* Toggle caret (không dùng nữa) */
            .mobile-dropdown-toggle{
                position:relative;
            }
            .mobile-dropdown-toggle::after{
                content:"▾";
                position:absolute;
                right:6px;
                top:50%;
                transform:translateY(-50%);
                font-size:12px;
                transition:transform .3s ease;
            }

            /* Desktop nav */
            .nav .link-form{
                display:inline;
            }
            .nav .link-button{
                padding:10px 6px;
                border-radius:8px;
                display:flex;
                flex-direction:column;
            }
            .nav .link-button.active{
                color:var(--primary);
                position:relative;
            }
            .nav .link-button.active::after{
                content:"";
                position:absolute;
                left:0;
                right:0;
                bottom:-6px;
                height:3px;
                border-radius:999px;
                background:var(--primary);
            }
            .nav .dropdown .link-form{
                display:block;
                width:100%;
            }
            .nav .dropdown .link-button{
                display:block;
                width:100%;
                padding:10px 12px;
                border-radius:8px;
                font-weight:600;
                white-space:nowrap;
                text-align:left;
            }
            .nav .dropdown .link-button:hover{
                background:#f8fafc;
                color:var(--primary);
            }

            .site-header{
                position:sticky;
                top:0;
                z-index:60;
                background:var(--bg);
                box-shadow:var(--shadow);
            }
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
            .icon-btn,.hamburger{
                width:38px;
                height:38px;
                border:1px solid var(--ring);
                border-radius:10px;
                background:#fff;
                position:relative;
                cursor:pointer
            }
            .hamburger::before,.hamburger::after,.hamburger span{
                content:"";
                position:absolute;
                left:9px;
                right:9px;
                height:2px;
                background:var(--text);
                transition:.2s
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
                border-bottom:1px solid var(--ring)
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

            .desktopbar{
                display:none
            }

            /* Responsive button */
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
                font-size:14px;
                transition:all .2s ease;
            }
            .btn:hover{
                background:#f9fafb
            }
            .btn.primary{
                background:#111827;
                color:#fff;
                border-color:#111827
            }
            .btn.primary:hover{
                background:#374151
            }
            .btn svg{
                width:18px;
                height:18px
            }

            .logoHeader{
                width:65px;
                height:100%;
            }

            /* Mobile tweaks */
            @media (max-width:768px){
                .btn{
                    padding:6px 12px;
                    font-size:13px;
                    gap:6px;
                }
                .btn svg{
                    width:16px;
                    height:16px;
                }
                .search input{
                    font-size:14px;
                }
                .logoHeader{
                    width:65px;
                    height:100%;
                }
            }
            @media (max-width:480px){
                .btn{
                    padding:8px 10px;
                    font-size:12px;
                }
                .btn svg{
                    width:14px;
                    height:14px;
                }
                .topbar{
                    padding:8px 10px;
                }
                .drawer{
                    width:85%;
                    max-width:280px;
                }
            }

            /* Desktop layout */
            @media (min-width:1200px){
                .topbar{
                    display:none
                }
                .desktopbar{
                    display:grid;
                    grid-template-columns:7.5fr 2.5fr;
                    grid-auto-rows:minmax(64px,auto);
                    gap:0 16px;
                    align-items:center;
                    width:100%;
                    padding:10px 20px;
                    border-bottom:1px solid var(--ring);
                    background:var(--bg);
                }
                .nav{
                    justify-self:center;
                    width:100%;
                    max-width:calc(var(--maxw) + 240px)
                }
                .nav ul{
                    display:flex;
                    flex-wrap:wrap;
                    justify-content:space-between;
                    align-items:center;
                    gap:7px;
                    list-style:none;
                    margin:0;
                    padding:0;
                }
                .nav a{
                    display:inline-flex;
                    align-items:center;
                    gap:8px;
                    font-weight:600;
                    padding:10px 6px;
                    border-radius:8px;
                    white-space:nowrap;
                    line-height:1;
                }
                .nav a svg{
                    width:18px;
                    height:18px
                }
                .nav a:hover{
                    color:var(--primary);
                    background:#eff6ff
                }
                .nav a.active{
                    color:var(--primary);
                    position:relative
                }
                .nav a.active::after{
                    content:"";
                    position:absolute;
                    left:0;
                    right:0;
                    bottom:-6px;
                    height:3px;
                    border-radius:999px;
                    background:var(--primary);
                }
                .nav li{
                    position:relative
                }
                .nav .dropdown{
                    position:absolute;
                    top:100%;
                    left:0;
                    min-width:286px;
                    background:#fff;
                    border:1px solid var(--ring);
                    border-radius:10px;
                    box-shadow:var(--shadow);
                    padding:8px;
                    list-style:none;
                    margin:8px 0 0 0;
                    opacity:0;
                    visibility:hidden;
                    transform:translateY(6px);
                    transition:.16s ease;
                    z-index:80;
                }
                .nav li:hover > .dropdown{
                    opacity:1;
                    visibility:visible;
                    transform:translateY(0)
                }
                .nav .dropdown a{
                    display:block;
                    padding:10px 12px;
                    border-radius:8px;
                    font-weight:600;
                    white-space:nowrap
                }
                .nav .dropdown a:hover{
                    background:#f8fafc;
                    color:var(--primary)
                }
                .nav li.has-dd > a::after{
                    content:"▾";
                    margin-left:6px;
                    font-size:12px
                }
                .nav li.has-dd > .link-button::after{
                    content:"▾";
                    margin-left:6px;
                    font-size:12px
                }
                .actions{
                    justify-self:end;
                    display:flex;
                    align-items:center;
                    gap:10px
                }
                .user-pill{
                    display:flex;
                    align-items:center;
                    gap:10px;
                    background:#f1f5f9;
                    border:1px solid var(--ring);
                    border-radius:999px;
                    padding:6px 10px;
                    font-weight:600
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
                    font-size:12px
                }
                .badge{
                    display:inline-block;
                    padding:2px 8px;
                    border-radius:999px;
                    background:#dcfce7;
                    color:#166534;
                    font-size:12px;
                    font-weight:700
                }
                .nav_icon{
                    width:50px;
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
                @media (max-width:1250px){
                    .nav .link-button{
                        padding:8px 4px;
                        font-size:14px
                    }
                    .nav ul{
                        gap:14px 18px
                    }
                    .nav .link-button svg{
                        width:16px;
                        height:16px
                    }
                }
                @media (max-width:1100px){
                    .desktopbar{
                        grid-template-columns:1fr;
                        grid-auto-rows:auto;
                        row-gap:8px
                    }
                    .nav{
                        justify-self:center
                    }
                    .actions{
                        justify-self:end
                    }
                }
            }

            /* ==== OVERRIDE: TẮT HẲN DROPDOWN TRÊN MOBILE (LUÔN MỞ) ==== */
            @media (max-width:1199.98px){
                /* luôn mở phần con */
                .mobile-dropdown{
                    max-height:none !important;
                    overflow:visible !important;
                    background:transparent !important;
                }
                /* bỏ mũi tên caret */
                .mobile-dropdown-toggle::after{
                    display:none !important;
                }
                /* căn lề nhẹ cho mục con */
                .mobile-dropdown .mobile-link-form{
                    border-left:3px solid #4f1964;
                }
                .mobile-dropdown .mobile-link-button{
                    padding:10px 16px;
                    font-size:14px;
                    background:transparent;
                    border-bottom:1px solid var(--ring);
                }
            }
        </style>
    </head>
    <body>
        <%
          Accounts user = (Accounts) session.getAttribute("user");
          boolean loginCheck = user != null;
          String username = loginCheck ? (user.getUsername() != null ? user.getUsername() : "Admin") : "";
          String avatarChar = "";
          if (loginCheck && username.trim().length() > 0) {
            avatarChar = username.substring(0,1).toUpperCase();
          }
        %>

        <header class="site-header">
            <input id="nav-toggle" type="checkbox">
            <div class="topbar">
                <div class="left-group">
                    <label for="nav-toggle" class="hamburger" aria-label="Mở menu"><span></span></label>
                    <span class="brand-name">
                        <a href="MainController?action=prepareHome">
                            <img class="logoHeader" src="assets/img/logo/logo.png" alt="Logo cửa hàng">
                        </a>
                    </span>
                </div>
                <form class="search" role="search" aria-label="Tìm kiếm" action="MainController" method="post">
                    <button aria-label="Tìm" type="submit">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="11" cy="11" r="7"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
                        </svg>
                    </button>
                    <input type="search" name="searchKeyword" placeholder="Tìm sản phẩm...">
                    <input type="hidden" name="action" value="search">
                </form>
            </div>

            <nav class="drawer" aria-label="Menu di động">
                <div style="font-weight:800; margin-bottom:10px;">Danh mục</div>
                <ul class="menu">
                    <li>
                        <form class="mobile-link-form" action="MainController" method="post">
                            <input type="hidden" name="action" value="prepareHome"/>
                            <button class="mobile-link-button" type="submit">Trang chủ</button>
                        </form>
                        <!-- BỎ toggle, để nút gửi form bình thường -->
                        <form class="mobile-link-form" action="MainController" method="post">
                            <input type="hidden" name="action" value="listMayChoiGame"/>
                            <button class="mobile-link-button" type="submit">Máy chơi game</button>
                        </form>
                        <!-- LUÔN MỞ: danh mục con -->
                        <div class="mobile-dropdown">
                            <form class="mobile-link-form" action="MainController" method="post">
                                <input type="hidden" name="action" value="listMayChoiGame"/>
                                <input type="hidden" name="condition" value="nintendo"/>
                                <button class="mobile-link-button" type="submit">Nintendo</button>
                            </form>
                            <form class="mobile-link-form" action="MainController" method="post">
                                <input type="hidden" name="action" value="listMayChoiGame"/>
                                <input type="hidden" name="condition" value="sony"/>
                                <button class="mobile-link-button" type="submit">Sony</button>
                            </form>
                            <form class="mobile-link-form" action="MainController" method="post">
                                <input type="hidden" name="action" value="listMayChoiGame"/>
                                <input type="hidden" name="condition" value="others"/>
                                <button class="mobile-link-button" type="submit">Hãng khác</button>
                            </form>
                        </div>
                    </li>

                    <li>
                        <form class="mobile-link-form" action="MainController" method="post">
                            <input type="hidden" name="action" value="listSanPhamCongNghe"/>
                            <button class="mobile-link-button" type="submit">Sản phẩm khác</button>
                        </form>
                    </li>
                    <li>
                        <form class="mobile-link-form" action="MainController" method="post">
                            <input type="hidden" name="action" value="listPhuKien"/>
                            <button class="mobile-link-button" type="submit">Phụ kiện</button>
                        </form>
                    </li>
                    <li>
                        <form class="mobile-link-form" action="MainController" method="post">
                            <input type="hidden" name="action" value="listTheGame"/>
                            <button class="mobile-link-button" type="submit">Thẻ game</button>
                        </form>
                    </li>
                    <li>
                        <form class="mobile-link-form" action="MainController" method="post">
                            <input type="hidden" name="action" value="listDichVu"/>
                            <button class="mobile-link-button" type="submit">Dịch vụ</button>
                        </form>
                    </li>
                    <li>
                        <form class="mobile-link-form" action="MainController" method="post">
                            <input type="hidden" name="action" value="searchPosts"/>
                            <button class="mobile-link-button" type="submit">Bài đăng</button>
                        </form>
                    </li>
                    <li>
                        <a class="link-button" href="https://zalo.me/0357394235" target="_blank" rel="noopener noreferrer">
                            Liên hệ
                        </a>
                    </li>
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
                    <form action="MainController" method="post" style="margin:0">
                        <input type="hidden" name="action" value="goLoginForm"/>
                        <button class="btn primary" type="submit">Đăng nhập</button>
                    </form>
                    <%
                      }
                    %>
                </div>
            </nav>
            <label class="backdrop" for="nav-toggle" aria-hidden="true"></label>

            <div class="desktopbar">
                <nav class="nav" aria-label="Chính">
                    <ul>
                        <li class="has-dd">
                            <form class="link-form" action="MainController" method="post">
                                <input type="hidden" name="action" value="listMayChoiGame"/>
                                <button class="link-button" type="submit">
                                    <img class="nav_icon" src="assets/img/iconHeader/may_choi_game.png" alt="alt"/>
                                    Máy chơi game
                                </button>
                            </form>
                            <ul class="dropdown" aria-label="Danh mục Máy chơi game">
                                <li>
                                    <form class="link-form" action="MainController" method="post">
                                        <input type="hidden" name="action" value="listMayChoiGame"/>
                                        <input type="hidden" name="condition" value="nintendo"/>
                                        <button class="link-button" type="submit">Nintendo</button>
                                    </form>
                                </li>
                                <li>
                                    <form class="link-form" action="MainController" method="post">
                                        <input type="hidden" name="action" value="listMayChoiGame"/>
                                        <input type="hidden" name="condition" value="sony"/>
                                        <button class="link-button" type="submit">Sony</button>
                                    </form>
                                </li>
                                <li>
                                    <form class="link-form" action="MainController" method="post">
                                        <input type="hidden" name="action" value="listMayChoiGame"/>
                                        <input type="hidden" name="condition" value="others"/>
                                        <button class="link-button" type="submit">Hãng khác</button>
                                    </form>
                                </li>
                            </ul>
                        </li>
                        <li>
                            <form class="link-form" action="MainController" method="post">
                                <input type="hidden" name="action" value="listSanPhamCongNghe"/>
                                <button class="link-button" type="submit">
                                    <img class="nav_icon" src="assets/img/iconHeader/san_pham_khac.png" alt="alt"/>
                                    Sản phẩm khác
                                </button>
                            </form>
                        </li>
                        <li>
                            <form class="link-form" action="MainController" method="post">
                                <input type="hidden" name="action" value="listPhuKien"/>
                                <button class="link-button" type="submit">
                                    <img class="nav_icon" src="assets/img/iconHeader/game-controller.png" alt="alt"/>
                                    Phụ kiện
                                </button>
                            </form>
                        </li>
                        <li>
                            <form class="link-form" action="MainController" method="post">
                                <input type="hidden" name="action" value="listTheGame"/>
                                <button class="link-button" type="submit">
                                    <img class="nav_icon" src="assets/img/iconHeader/the_game.png" alt="alt"/>
                                    Thẻ game
                                </button>
                            </form>
                        </li>
                        <li>
                            <form class="link-form" action="MainController" method="post">
                                <input type="hidden" name="action" value="listDichVu"/>
                                <button class="link-button" type="submit">
                                    <img class="nav_icon" src="assets/img/iconHeader/dich_vu.png" alt="alt"/>
                                    Dịch vụ
                                </button>
                            </form>
                        </li>
                        <li>
                            <form class="link-form" action="MainController" method="post">
                                <input type="hidden" name="action" value="searchPosts"/>
                                <button class="link-button" type="submit">
                                    <img class="nav_icon" src="assets/img/iconHeader/bai_dang.png" alt="alt"/>
                                    Bài đăng
                                </button>
                            </form>
                        </li>
                        <li>
                            <a class="link-button" href="https://zalo.me/0357394235" target="_blank" rel="noopener noreferrer">
                                <img class="nav_icon" src="assets/img/iconHeader/lien_hen.png" alt="alt"/>
                                Liên hệ
                            </a>
                        </li>
                    </ul>
                </nav>

                <div class="actions">
                    <%
                      if (loginCheck) {
                    %>
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
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/>
                            <path d="M10 17l5-5-5-5"/><path d="M15 12H3"/>
                            </svg>
                            Đăng xuất
                        </button>
                    </form>
                    <%
                      } else {
                    %>
                    <form action="MainController" method="post" style="margin:0">
                        <input type="hidden" name="action" value="goLoginForm"/>
                        <button class="btn primary" type="submit" title="Đăng nhập">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                            <circle cx="12" cy="7" r="4"/>
                            </svg>
                            Đăng nhập
                        </button>
                    </form>
                    <%
                      }
                    %>
                </div>
            </div>
        </header>

        <!-- Không cần JS dropdown nữa -->
        <script>
            // Dropdown mobile đã vô hiệu hoá hoàn toàn bằng CSS.
        </script>
    </body>
</html>
