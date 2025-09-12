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
            *{box-sizing:border-box}
            body{
                margin:0;
                font-family: ui-sans-serif, system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial, sans-serif;
                color:var(--text);
                background:#fafafa;
            }
            a{color:inherit;text-decoration:none}
            .site-header{position:sticky;top:0;z-index:60;background:var(--bg);box-shadow:var(--shadow)}
            .topbar{display:grid;grid-template-columns:auto 1fr auto;align-items:center;gap:10px;padding:10px 12px;border-bottom:1px solid var(--ring)}
            .left-group{display:flex;align-items:center;gap:10px}
            .brand-name{font-weight:800;letter-spacing:.3px}
            .icon-btn,.hamburger{width:38px;height:38px;border:1px solid var(--ring);border-radius:10px;background:#fff;position:relative;cursor:pointer}
            .hamburger::before,.hamburger::after,.hamburger span{content:"";position:absolute;left:9px;right:9px;height:2px;background:var(--text);transition:.2s}
            .hamburger::before{top:11px}
            .hamburger span{top:18px}
            .hamburger::after{top:25px}
            .search{position:relative}
            .search input{width:100%;height:38px;border:1px solid var(--ring);border-radius:999px;background:var(--soft);padding:0 40px 0 38px;outline:none}
            .search button{position:absolute;left:8px;top:50%;transform:translateY(-50%);width:26px;height:26px;border:0;background:transparent;padding:0;cursor:pointer}
            .search svg{width:20px;height:20px}
            #nav-toggle{display:none}
            .drawer{position:fixed;top:0;left:0;bottom:0;width:70%;max-width:320px;background:#fff;border-right:1px solid var(--ring);padding:16px 18px 24px;transform:translateX(-100%);transition:transform .22s ease;z-index:70;overflow:auto}
            .drawer .menu{list-style:none;margin:0;padding:0}
            .drawer .menu li a{display:block;padding:14px 6px;font-weight:600;border-bottom:1px solid var(--ring)}
            .backdrop{position:fixed;inset:0;background:rgba(0,0,0,.28);opacity:0;pointer-events:none;transition:.2s;z-index:65}
            #nav-toggle:checked ~ .topbar .hamburger::before{transform:translateY(7px) rotate(45deg)}
            #nav-toggle:checked ~ .topbar .hamburger span{opacity:0}
            #nav-toggle:checked ~ .topbar .hamburger::after{transform:translateY(-7px) rotate(-45deg)}
            #nav-toggle:checked ~ .drawer{transform:translateX(0)}
            #nav-toggle:checked ~ .backdrop{opacity:1;pointer-events:auto}
            .desktopbar{display:none}
            @media (min-width: 1200px){
                .topbar{display:none}
                .desktopbar{display:grid;grid-template-columns:7.5fr 2.5fr;grid-auto-rows:minmax(64px,auto);gap:0 16px;align-items:center;width:100%;padding:10px 20px;border-bottom:1px solid var(--ring);background:var(--bg)}
                .nav{justify-self:center;width:100%;max-width:calc(var(--maxw) + 240px)}
                .nav ul{display:flex;flex-wrap:wrap;justify-content:center;align-items:center;gap:5px 75px;list-style:none;margin:0;padding:0}
                .nav a{display:inline-flex;align-items:center;gap:8px;font-weight:600;padding:10px 6px;border-radius:8px;white-space:nowrap;line-height:1}
                .nav a svg{width:18px;height:18px}
                .nav a:hover{color:var(--primary);background:#eff6ff}
                .nav a.active{color:var(--primary);position:relative}
                .nav a.active::after{content:"";position:absolute;left:0;right:0;bottom:-6px;height:3px;border-radius:999px;background:var(--primary)}
                .nav li{position:relative}
                .nav .dropdown{position:absolute;top:100%;left:0;min-width:180px;background:#fff;border:1px solid var(--ring);border-radius:10px;box-shadow:var(--shadow);padding:8px;list-style:none;margin:8px 0 0 0;opacity:0;visibility:hidden;transform:translateY(6px);transition:.16s ease;z-index:80}
                .nav li:hover > .dropdown{opacity:1;visibility:visible;transform:translateY(0)}
                .nav .dropdown a{display:block;padding:10px 12px;border-radius:8px;font-weight:600;white-space:nowrap}
                .nav .dropdown a:hover{background:#f8fafc;color:var(--primary)}
                .nav li.has-dd > a::after{content:"▾";margin-left:6px;font-size:12px}
                .actions{justify-self:end;display:flex;align-items:center;gap:10px}
                .user-pill{display:flex;align-items:center;gap:10px;background:#f1f5f9;border:1px solid var(--ring);border-radius:999px;padding:6px 10px;font-weight:600}
                .avatar{width:28px;height:28px;border-radius:50%;display:grid;place-items:center;background:#111827;color:#fff;font-weight:800;font-size:12px}
                .badge{display:inline-block;padding:2px 8px;border-radius:999px;background:#dcfce7;color:#166534;font-size:12px;font-weight:700}
                .btn{display:inline-flex;align-items:center;gap:8px;cursor:pointer;border-radius:999px;border:1px solid var(--ring);background:#fff;padding:8px 14px;font-weight:700}
                .btn:hover{background:#f9fafb}
                .btn.primary{background:#111827;color:#fff;border-color:#111827}
                .btn svg{width:18px;height:18px}
                .link{font-weight:700;color:var(--primary);padding:8px 12px;border-radius:8px}
                .link:hover{background:#eff6ff}
                @media (max-width:1250px){.nav a{padding:8px 4px;font-size:14px}.nav ul{gap:14px 18px}.nav a svg{width:16px;height:16px}}
                @media (max-width:1100px){.desktopbar{grid-template-columns:1fr;grid-auto-rows:auto;row-gap:8px}.nav{justify-self:center}.actions{justify-self:end}}
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
                    <span class="brand-name">MENU</span>
                </div>
                <form class="search" role="search" aria-label="Tìm kiếm">
                    <button aria-label="Tìm">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="7"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                    </button>
                    <input type="search" placeholder="Tìm sản phẩm...">
                </form>
            </div>

            <nav class="drawer" aria-label="Menu di động">
                <div style="font-weight:800; margin-bottom:10px;">Danh mục</div>
                <ul class="menu">
                    <li><a href="#">Máy chơi game</a></li>
                    <li><a href="#">Phụ kiện</a></li>
                    <li><a href="#">Thẻ game</a></li>
                    <li><a href="#">Dịch vụ</a></li>
                    <li><a href="#">Sản phẩm công nghệ khác</a></li>
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

            <div class="desktopbar">
                <nav class="nav" aria-label="Chính">
                    <ul>
                        <li class="has-dd">
                            <a href="#">
                                <!-- ICON Máy chơi game -->
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                  <rect x="2" y="6" width="20" height="12" rx="3"/>
                                  <circle cx="8" cy="12" r="2"/>
                                  <circle cx="16" cy="10" r="1"/>
                                  <circle cx="16" cy="14" r="1"/>
                                </svg>
                                Máy chơi game
                            </a>
                            <ul class="dropdown" aria-label="Danh mục Máy chơi game">
                                <li><a href="products.jsp?condition=new">New</a></li>
                                <li><a href="products.jsp?condition=likenew">Like New</a></li>
                            </ul>
                        </li>
                        <li>
                            <a href="#">
                                <!-- ICON Sản phẩm công nghệ khác -->
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                  <rect x="3" y="4" width="18" height="12" rx="2"/>
                                  <path d="M2 20h20"/>
                                </svg>
                                Sản phẩm công nghệ khác
                            </a>
                        </li>
                        <li>
                            <a href="#">
                                <!-- ICON Phụ kiện -->
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                  <path d="M4 12a8 8 0 0 1 16 0v6a2 2 0 0 1-2 2h-2v-6h4M6 14h4v6H8a2 2 0 0 1-2-2v-4z"/>
                                </svg>
                                Phụ kiện
                            </a>
                        </li>
                        <li>
                            <a href="#">
                                <!-- ICON Thẻ game -->
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                  <rect x="2" y="5" width="20" height="14" rx="2"/>
                                  <path d="M2 10h20"/>
                                </svg>
                                Thẻ game
                            </a>
                        </li>
                        <li>
                            <a href="#">
                                <!-- ICON Dịch vụ -->
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                  <path d="M14.7 6.3a5 5 0 0 1-6.4 6.4l-4.3 4.3a1 1 0 0 0 1.4 1.4l4.3-4.3a5 5 0 0 1 6.4-6.4z"/>
                                </svg>
                                Dịch vụ
                            </a>
                        </li>
                        <li>
                            <a href="#">
                                <!-- ICON Liên hệ -->
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                  <path d="M21 15v4a2 2 0 0 1-2 2H6l-4 2V5a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v2"/>
                                  <circle cx="12" cy="12" r="3"/>
                                </svg>
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
                    <a class="btn primary" href="login.jsp" title="Đăng nhập">
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
