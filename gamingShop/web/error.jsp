<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
    // Lấy thông tin lỗi tiêu chuẩn từ container (nếu được map qua <error-page> trong web.xml)
    Integer statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");
    String errorMessage = (String) request.getAttribute("javax.servlet.error.message");
    String requestUri   = (String) request.getAttribute("javax.servlet.error.request_uri");
    Throwable ex        = (Throwable) request.getAttribute("javax.servlet.error.exception");
    String ctx          = request.getContextPath();
    if (requestUri == null) requestUri = "N/A";
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>${empty requestScope['javax.servlet.error.status_code'] ? 'Có lỗi xảy ra' : 'Lỗi ' += requestScope['javax.servlet.error.status_code']}</title>
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <%@ include file="/WEB-INF/jspf/head.jspf" %>
        <!-- App CSS (nếu có) -->
        <link rel="stylesheet" href="<%=ctx%>/assets/css/maincss.css"/>

        <style>
            :root{
                --bg-1:#0f172a;      /* slate-900 */
                --bg-2:#111827;      /* gray-900 */
                --fg:#e5e7eb;        /* gray-200 */
                --muted:#94a3b8;     /* slate-400 */
                --brand:#60a5fa;     /* blue-400 */
                --brand-2:#a78bfa;   /* violet-400 */
                --accent:#34d399;    /* emerald-400 */
                --danger:#ef4444;    /* red-500 */
                --card:#0b1022aa;    /* glassy */
                --glass: rgba(255,255,255,0.08);
                --glass-border: rgba(255,255,255,0.16);
            }
            *{
                box-sizing:border-box
            }
            html,body{
                height:100%
            }
            body{
                margin:0;
                color:var(--fg);
                background:
                    radial-gradient(1200px 800px at 10% -10%, #1e293b 0%, transparent 60%),
                    radial-gradient(800px 600px at 110% 10%, #1f2937 0%, transparent 60%),
                    linear-gradient(120deg, var(--bg-1), var(--bg-2));
                overflow:hidden;
                font-family: ui-sans-serif, system-ui, -apple-system, Segoe UI, Roboto, "Helvetica Neue", Arial, "Noto Sans", "Liberation Sans", sans-serif;
            }

            /* Gradient chuyển động */
            .gradient {
                position:fixed;
                inset:-20%;
                background: conic-gradient(from 0deg at 50% 50%, rgba(96,165,250,.25), rgba(167,139,250,.2), rgba(52,211,153,.25), rgba(96,165,250,.25));
                filter: blur(80px) saturate(120%);
                animation: spin 18s linear infinite;
                z-index:0;
            }
            @keyframes spin {
                to {
                    transform: rotate(1turn);
                }
            }

            /* Các blob bay lơ lửng */
            .blob {
                position: fixed;
                width: 34vmin;
                height: 34vmin;
                border-radius: 50%;
                background: radial-gradient(circle at 30% 30%, rgba(96,165,250,.65), rgba(167,139,250,.2));
                filter: blur(10px);
                opacity:.35;
                z-index:0;
                animation: float 12s ease-in-out infinite;
            }
            .blob.b2 {
                background: radial-gradient(circle at 70% 20%, rgba(167,139,250,.6), rgba(52,211,153,.2));
                animation-duration:16s;
            }
            .blob.b3 {
                background: radial-gradient(circle at 40% 80%, rgba(52,211,153,.55), rgba(96,165,250,.2));
                animation-duration:20s;
            }
            @keyframes float {
                0%,100% {
                    transform: translate3d(0,0,0) scale(1);
                }
                50% {
                    transform: translate3d(2vw,-2vh,0) scale(1.07);
                }
            }

            .wrap {
                position:relative;
                z-index:1;
                height:100%;
                display:grid;
                place-items:center;
                padding:24px;
            }

            .card {
                width:min(960px, 92vw);
                background: linear-gradient(180deg, rgba(255,255,255,.06), rgba(255,255,255,.03));
                border:1px solid var(--glass-border);
                border-radius:20px;
                backdrop-filter: blur(10px);
                box-shadow: 0 20px 60px rgba(0,0,0,.35);
                overflow:hidden;
            }
            .card-header{
                position:relative;
                padding:22px 24px;
                border-bottom:1px solid var(--glass-border);
                display:flex;
                align-items:center;
                justify-content:space-between;
                gap:12px;
                flex-wrap:wrap;
            }
            .badge-soft{
                background: rgba(99,102,241,.15);
                color:#c7d2fe;
                border:1px solid rgba(99,102,241,.35);
                padding:6px 10px;
                border-radius:999px;
                font-weight:600;
                font-size:.85rem;
            }
            .card-body{
                padding:22px 24px;
                display:grid;
                grid-template-columns: 1.2fr .8fr;
                gap:22px;
            }
            @media (max-width:900px){
                .card-body{
                    grid-template-columns:1fr;
                }
            }

            /* Khối trái: tiêu đề & mô tả */
            .title{
                margin:0 0 6px 0;
                font-weight:800;
                font-size: clamp(28px, 4.2vw, 44px);
                letter-spacing:.2px;
                line-height:1.06;
                display:flex;
                align-items:center;
                gap:12px;
            }
            .code{
                display:inline-flex;
                align-items:center;
                gap:8px;
                font-weight:800;
                font-size:clamp(22px, 3.5vw, 36px);
                background: linear-gradient(90deg, var(--brand), var(--brand-2));
                -webkit-background-clip:text;
                background-clip:text;
                color:transparent;
                filter: drop-shadow(0 2px 10px rgba(99,102,241,.35));
                animation: glow 2.6s ease-in-out infinite;
            }
            @keyframes glow {
                0%,100% {
                    filter: drop-shadow(0 2px 10px rgba(99,102,241,.35));
                }
                50% {
                    filter: drop-shadow(0 4px 18px rgba(96,165,250,.55));
                }
            }
            .desc{
                color:var(--muted);
                font-size:1.05rem;
                line-height:1.5;
            }

            /* Khối phải: minh hoạ */
            .scene{
                position:relative;
                height:280px;
                overflow:visible;
            }
            .planet, .ring, .rocket, .spark {
                position:absolute;
                will-change: transform;
            }
            .planet{
                width:160px;
                height:160px;
                left:50%;
                top:50%;
                transform: translate(-50%,-50%);
                background: radial-gradient(circle at 30% 30%, #93c5fd, #1d4ed8);
                border-radius:50%;
                box-shadow: inset -10px -18px 30px rgba(0,0,0,.25), 0 20px 50px rgba(29,78,216,.45);
                animation: planet-breathe 6s ease-in-out infinite;
            }
            @keyframes planet-breathe {
                0%,100% {
                    transform: translate(-50%,-50%) scale(1);
                }
                50% {
                    transform: translate(-50%,-50%) scale(1.04);
                }
            }
            .ring{
                width:260px;
                height:260px;
                left:50%;
                top:50%;
                transform: translate(-50%,-50%) rotateX(65deg) rotateZ(0deg);
                border:2px dashed rgba(255,255,255,.25);
                border-radius:50%;
                animation: ring-rotate 12s linear infinite;
            }
            @keyframes ring-rotate {
                to {
                    transform: translate(-50%,-50%) rotateX(65deg) rotateZ(360deg);
                }
            }

            .rocket{
                width:54px;
                height:54px;
                left:calc(50% + 160px);
                top:calc(50% - 40px);
                transform-origin: -140px 80px;
                animation: orbit 7s linear infinite;
                filter: drop-shadow(0 6px 12px rgba(0,0,0,.35));
            }
            @keyframes orbit {
                to {
                    transform: rotate(360deg);
                }
            }
            .rocket svg{
                width:54px;
                height:54px;
                display:block;
            }

            .spark{
                width:10px;
                height:10px;
                background: radial-gradient(circle, #fff, rgba(255,255,255,.1));
                border-radius:50%;
                animation: sparkle 2.6s ease-in-out infinite;
                opacity:.8;
            }
            .spark.s1{
                left:12%;
                top:30%;
                animation-delay:.2s;
            }
            .spark.s2{
                right:8%;
                top:20%;
                animation-delay:1s;
            }
            .spark.s3{
                left:6%;
                bottom:8%;
                animation-delay:1.6s;
            }
            @keyframes sparkle {
                0%,100% {
                    transform: translate3d(0,0,0) scale(1);
                    opacity:.35;
                }
                50% {
                    transform: translate3d(0,-8px,0) scale(1.3);
                    opacity:.9;
                }
            }

            .meta{
                margin-top:14px;
                display:flex;
                gap:10px;
                flex-wrap:wrap;
                font-size:.92rem;
                color:#9ca3af;
            }
            .meta .pill{
                border:1px dashed var(--glass-border);
                background: rgba(255,255,255,.06);
                padding:6px 10px;
                border-radius:999px;
            }

            /* Actions */
            .actions{
                display:flex;
                gap:10px;
                flex-wrap:wrap;
                margin-top:18px;
            }
            .btn{
                padding:10px 14px;
                border-radius:12px;
                border:1px solid transparent;
                font-weight:700;
                cursor:pointer;
                transition: transform .12s ease, box-shadow .2s ease, background .2s ease;
            }
            .btn:active{
                transform: translateY(1px) scale(.99);
            }
            .btn.primary{
                background: linear-gradient(90deg, var(--brand), var(--brand-2));
                color:white;
                box-shadow: 0 10px 30px rgba(99,102,241,.35);
            }
            .btn.primary:hover{
                box-shadow: 0 14px 36px rgba(99,102,241,.55);
            }
            .btn.line{
                background: transparent;
                color:var(--fg);
                border-color:var(--glass-border);
            }
            .btn.line:hover{
                background: var(--glass);
            }
            .btn.ghost{
                background: rgba(239,68,68,.1);
                color:#fecaca;
                border:1px solid rgba(239,68,68,.35);
            }
            .btn.ghost:hover{
                background: rgba(239,68,68,.16);
            }

            /* Parallax nhẹ theo chuột cho scene */
            .parallax{
                transition: transform .2s ease-out;
            }
        </style>
    </head>
    <body>
        <!-- Nền động -->
        <div class="gradient"></div>
        <div class="blob" style="left:-6vmin; top:20vh;"></div>
        <div class="blob b2" style="right:-10vmin; top:10vh;"></div>
        <div class="blob b3" style="left:20vw; bottom:-8vmin;"></div>

        <div class="wrap">
            <div class="card">
                <div class="card-header">
                    <span class="badge-soft">Hệ thống thông báo</span>
                    <span class="badge-soft">Time: <span id="now"></span></span>
                </div>

                <div class="card-body">
                    <!-- Trái: thông tin lỗi -->
                    <div>
                        <h1 class="title">
                            <span class="code"><%= statusCode != null ? statusCode : 404 %></span>
                            — Ôi không, có trục trặc nhỏ!
                        </h1>
                        <p class="desc">
                            Có vẻ như yêu cầu của bạn chưa thể được xử lý ngay bây giờ.
                            <c:choose>
                                <c:when test="${not empty requestScope['javax.servlet.error.message']}">
                                    Thông điệp: <b>${requestScope['javax.servlet.error.message']}</b>.
                                </c:when>
                                <c:otherwise>
                                    Hãy thử làm mới trang hoặc quay lại trang trước.
                                </c:otherwise>
                            </c:choose>
                        </p>

                        <div class="meta">
                            <span class="pill">URL: <%= requestUri %></span>
                            <c:if test="<%= ex != null %>">
                                <span class="pill">Exception: <%= ex.getClass().getSimpleName() %></span>
                            </c:if>
                        </div>

                        <div class="actions">
                            <button class="btn primary" onclick="window.location.href = '<%=ctx%>/MainController?action=home'">Về trang chủ</button>
                            <button class="btn line" onclick="history.back()">Quay lại</button>
                            <button class="btn line" onclick="location.reload()">Thử lại</button>
                            <a class="btn ghost" href="#">Báo lỗi</a>
                        </div>
                    </div>

                    <!-- Phải: minh hoạ động -->
                    <div class="scene parallax" id="scene">
                        <div class="planet"></div>
                        <div class="ring"></div>
                        <div class="rocket" aria-hidden="true">
                            <!-- Rocket SVG -->
                            <svg viewBox="0 0 64 64" fill="none" xmlns="http://www.w3.org/2000/svg" role="img" aria-label="Rocket">
                            <path d="M33 6c9 3 17 15 17 25 0 7-5 11-11 14l-6 3-6-3C21 42 16 38 16 31 16 21 24 9 33 6Z" fill="url(#g1)"/>
                            <path d="M22 44l-6 10 10-6-4-4Z" fill="#fca5a5"/>
                            <circle cx="36" cy="25" r="6" fill="#e0f2fe" stroke="#93c5fd" stroke-width="2"/>
                            <path d="M30 46l-2 10 6-8-4-2Z" fill="#fcd34d"/>
                            <defs>
                            <linearGradient id="g1" x1="16" y1="6" x2="50" y2="48" gradientUnits="userSpaceOnUse">
                            <stop stop-color="#93c5fd"/><stop offset="1" stop-color="#6366f1"/>
                            </linearGradient>
                            </defs>
                            </svg>
                        </div>
                        <div class="spark s1"></div>
                        <div class="spark s2"></div>
                        <div class="spark s3"></div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            // Hiển thị thời gian hiện tại
            (function () {
                const el = document.getElementById('now');
                const fmt = new Intl.DateTimeFormat('vi-VN', {dateStyle: 'medium', timeStyle: 'medium'});
                const tick = () => el && (el.textContent = fmt.format(new Date()));
                tick();
                setInterval(tick, 1000);
            })();

            // Parallax rất nhẹ theo chuột cho phần minh hoạ (không gây chóng mặt)
            (function () {
                const scene = document.getElementById('scene');
                let raf = null;
                let targetX = 0, targetY = 0, x = 0, y = 0;

                window.addEventListener('mousemove', (e) => {
                    const {innerWidth: w, innerHeight: h} = window;
                    targetX = (e.clientX - w / 2) / (w / 2) * 8; // phạm vi ±8px
                    targetY = (e.clientY - h / 2) / (h / 2) * 8;
                    if (!raf)
                        loop();
                });

                function loop() {
                    x += (targetX - x) * 0.08;
                    y += (targetY - y) * 0.08;
                    scene && (scene.style.transform = `translate3d(${x}px, ${y}px, 0)`);
                    if (Math.abs(targetX - x) < .1 && Math.abs(targetY - y) < .1) {
                        raf = null;
                        return;
                    }
                    raf = requestAnimationFrame(loop);
                }
            })();

            // Đặt vị trí blob ngẫu nhiên nhẹ khi tải trang
            (function () {
                const blobs = document.querySelectorAll('.blob');
                blobs.forEach((b, i) => {
                    const x = Math.random() * 60 + (i === 1 ? 30 : 0);
                    const y = Math.random() * 60 + (i === 2 ? 30 : 0);
                    b.style.transform = `translate(${x}vw, ${y}vh)`;
                });
            })();
        </script>
    </body>
</html>
