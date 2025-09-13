<%-- 
    Document   : footer
    Created on : Sep 2, 2025, 10:12:16 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>footer</title>
    <style>
      /* ========== SOCIAL FOLLOW styles ========== */
      .social-follow{
        background:#fff;
        padding: 24px 0 8px;
        border-top: 1px solid rgba(0,0,0,.06);
      }
      .sf-inner{
        width:min(1200px,94vw);
        margin-inline:auto;
        display:flex; align-items:center; justify-content:center;
        gap:28px;
      }
      .sf-title{
        margin:0; font-size:18px; font-weight:600; color:#333; white-space:nowrap;
      }
      .sf-icons{
        display:flex; align-items:center; gap:28px;
      }
      .sf-btn{
        position:relative;
        width:64px; height:64px; border-radius:999px;
        display:grid; place-items:center;
        text-decoration:none; isolation:isolate;
        transition: transform .12s ease;
      }
      .sf-btn:active{ transform: translateY(1px); }
      .sf-btn .ring{
        position:absolute; inset:0; border-radius:inherit;
        background:#fff;
        box-shadow: inset 0 0 0 2px #e5e7eb;
        z-index:0;
      }
      .sf-btn svg{
        width:28px; height:28px; z-index:1; fill:#555;
        transition: transform .2s ease, filter .2s ease, fill .2s ease;
      }
      .sf-fb .ring{ box-shadow: inset 0 0 0 2px #1778F2; }
      .sf-fb:hover .ring{ box-shadow: inset 0 0 0 2px #0b5fd8, 0 0 0 6px rgba(23,120,242,.12); }
      .sf-fb svg{ fill:#1778F2; }
      .sf-ig .ring{
        box-shadow: inset 0 0 0 2px #E1306C;
        background: radial-gradient(circle at 30% 30%, #FEDA77, transparent 30%),
                    radial-gradient(circle at 70% 70%, #F58529, transparent 30%),
                    radial-gradient(circle at 70% 30%, #DD2A7B, transparent 40%),
                    radial-gradient(circle at 30% 70%, #8134AF, transparent 40%),
                    #fff;
      }
      .sf-ig:hover .ring{ box-shadow: inset 0 0 0 2px #DD2A7B, 0 0 0 6px rgba(221,42,123,.12); }
      .sf-ig svg{ fill:#DD2A7B; }
      .sf-yt .ring{ box-shadow: inset 0 0 0 2px #FF0000; }
      .sf-yt:hover .ring{ box-shadow: inset 0 0 0 2px #CC0000, 0 0 0 6px rgba(255,0,0,.12); }
      .sf-yt svg{ fill:#FF0000; }
      .sf-tt .ring{
        box-shadow: inset 0 0 0 2px #69C9D0;
        background: linear-gradient(135deg, rgba(105,201,208,.35), rgba(255,64,86,.35)) #fff;
      }
      .sf-tt:hover .ring{ box-shadow: inset 0 0 0 2px #FF4056, 0 0 0 6px rgba(105,201,208,.12); }
      .sf-tt svg{ fill:#FF0050; }
      @media (max-width: 680px){
        .sf-inner{ flex-direction:column; gap:18px; }
        .sf-icons{ gap:18px; }
        .sf-btn{ width:56px; height:56px; }
        .sf-btn svg{ width:24px; height:24px; }
      }

      /* ===== Footer ===== */
      .site-footer{
        --primary:#232E76;
        --accent:#78ADDB;
        color:#e0d9d9;
        background:
          radial-gradient(90% 140% at 100% 0%, rgba(120, 173, 219, .15), transparent 42%),
          linear-gradient(180deg, #19245c 0%, #06070c 100%);
        padding: 20px 0;
        border-top: 1px solid rgba(255,255,255,.06);
      }
      .footer-inner{
        width:min(1200px, 94vw);
        margin-inline:auto;
        display:grid;
        gap: 16px;
        grid-template-columns: 1fr;
        align-items: center;
      }
      .footer-col{
        font-size:14.5px;
        line-height:1.65;
        color:#e0d9d9;
      }
      .footer-col p{ margin:0; }
      .footer-col .label{ margin:0; font-weight:700; }
      .footer-col .value{ margin:0; opacity:.9; }
      .footer-col.contact{
        background: linear-gradient(180deg, rgba(255,255,255,.08), rgba(0,0,0,.12));
        border: 1px solid rgba(255,255,255,.12);
        border-radius: 12px;
        padding: 12px;
        display:flex;
        flex-direction:column;
        gap:10px;
        backdrop-filter: saturate(140%) blur(4px);
        box-shadow: inset 0 1px 0 rgba(255,255,255,.06), 0 8px 24px rgba(0,0,0,.18);
      }
      .contact-item{
        display:flex; align-items:center; gap:10px;
        color:#e0d9d9;
        text-decoration:none;
        padding:10px 12px;
        border-radius:10px;
        transition: background .2s ease, transform .06s ease, color .2s ease;
      }
      .contact-item:hover{ background: rgba(120,173,219,.18); color:#fff; }
      .contact-item:active{ transform: translateY(1px); }
      .contact-item span:last-child{ font-weight:600; letter-spacing:.15px; }
      .contact-item .ico{
        width:22px; height:22px; flex:0 0 22px;
        background-size:22px 22px; background-repeat:no-repeat;
      }
      .contact-item.phone .ico{
        background-image:url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%23ffffff'><path d='M6.62 10.79a15.05 15.05 0 0 0 6.59 6.59l1.87-1.87a1 1 0 0 1 1.02-.24 11.36 11.36 0 0 0 3.56.57 1 1 0 0 1 1 1V20a1 1 0 0 1-1 1A16 16 0 0 1 3 9a1 1 0 0 1 1-1h2.16a1 1 0 0 1 1 1.02c-.02 1.23.18 2.43.46 2.77z'/></svg>");
      }
      .contact-item.mail .ico{
        background-image:url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%23ffffff'><path d='M20 4H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V6a2 2 0 0 0-2-2zm0 4-8 5-8-5V6l8 5 8-5v2z'/></svg>");
      }
      .contact-item.zalo .ico{
        background-image:url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%23ffffff'><path d='M20 2H4a2 2 0 0 0-2 2v14l4-3h14a2 2 0 0 0 2-2V4a2 2 0 0 0-2-2z'/></svg>");
      }
      @media (min-width:576px){
        .footer-inner{ grid-template-columns: 1.2fr 1fr; }
        .footer-col.contact{ grid-column: 1 / -1; }
      }
      @media (min-width:992px){
        .footer-inner{
          grid-template-columns: 1.25fr 1.1fr .95fr;
          gap:18px;
        }
        .footer-col.contact{ grid-column: auto; }
      }
    </style>
  </head>
  <body>

    <!-- SOCIAL FOLLOW -->
    <section class="social-follow">
      <div class="sf-inner">
        <h3 class="sf-title">Theo dõi thông tin tại</h3>
        <nav class="sf-icons">
          <a class="sf-btn sf-fb" href="https://facebook.com/" target="_blank">
            <span class="ring"></span>
            <svg viewBox="0 0 24 24"><path d="M22 12.06C22 6.49 17.52 2 12 2S2 6.49 2 12.06c0 4.99 3.66 9.13 8.44 9.94v-7.03H7.9v-2.91h2.54V9.41c0-2.5 1.49-3.88 3.77-3.88 1.09 0 2.23.2 2.23.2v2.46h-1.26c-1.24 0-1.63.77-1.63 1.56v1.87h2.78l-.44 2.91h-2.34V22c4.78-.81 8.44-4.95 8.44-9.94Z"/></svg>
          </a>
          <a class="sf-btn sf-ig" href="https://instagram.com/" target="_blank">
            <span class="ring"></span>
            <svg viewBox="0 0 24 24"><path d="M7 2h10a5 5 0 0 1 5 5v10a5 5 0 0 1-5 5H7a5 5 0 0 1-5-5V7a5 5 0 0 1 5-5Zm0 2a3 3 0 0 0-3 3v10a3 3 0 0 0 3 3h10a3 3 0 0 0 3-3V7a3 3 0 0 0-3-3H7Zm5 3.5A5.5 5.5 0 1 1 6.5 13 5.5 5.5 0 0 1 12 7.5Zm0 2A3.5 3.5 0 1 0 15.5 13 3.5 3.5 0 0 0 12 9.5Zm5.75-3.25a1.25 1.25 0 1 1-1.25 1.25 1.25 1.25 0 0 1 1.25-1.25Z"/></svg>
          </a>
          <a class="sf-btn sf-yt" href="https://youtube.com/" target="_blank">
            <span class="ring"></span>
            <svg viewBox="0 0 24 24"><path d="M23.5 7.2a3.2 3.2 0 0 0-2.24-2.27C19.6 4.5 12 4.5 12 4.5s-7.6 0-9.26.43A3.2 3.2 0 0 0 .5 7.2 33 33 0 0 0 .5 12a33 33 0 0 0 .24 4.8 3.2 3.2 0 0 0 2.24 2.27C4.6 19.5 12 19.5 12 19.5s7.6 0 9.26-.43a3.2 3.2 0 0 0 2.24-2.27A33 33 0 0 0 23.5 12a33 33 0 0 0 0-4.8ZM9.75 15.02v-6L15.5 12l-5.75 3.02Z"/></svg>
          </a>
          <a class="sf-btn sf-tt" href="https://tiktok.com/" target="_blank">
            <span class="ring"></span>
            <svg viewBox="0 0 24 24"><path d="M21 8.13a7.3 7.3 0 0 1-4.26-1.36v7.3A6.93 6.93 0 1 1 9.9 7.2v2.6a3.87 3.87 0 1 0 2.65 3.67V2h2.58a4.7 4.7 0 0 0 4.07 4.2V8.1Z"/></svg>
          </a>
        </nav>
      </div>
    </section>

    <!-- FOOTER -->
    <footer class="site-footer">
      <div class="footer-inner">
        <div class="footer-col about">
          <p><strong>CỬA GỖ VIỆT PHÁT</strong> chuyên sản xuất, thiết kế thi công nội thất và cửa gỗ công nghiệp, cửa nhựa vân gỗ, cửa chống cháy theo tiêu chuẩn Việt Nam.</p>
        </div>
        <div class="footer-col address">
          <div class="label">Trụ sở:</div>
          <div class="value">130 Đại Lộ Bình Dương, phường Phú Lợi, Thành phố Hồ Chí Minh</div>
        </div>
        <aside class="footer-col contact">
          <a href="tel:0888223779" class="contact-item phone">
            <span class="ico"></span><span>0888.223.779</span>
          </a>
          <a href="mailto:info@vietduchome.vn" class="contact-item mail">
            <span class="ico"></span><span>Info@vietduchome.vn</span>
          </a>
          <a href="https://zalo.me/0888223779" class="contact-item zalo">
            <span class="ico"></span><span>zalo: 0888 223 779</span>
          </a>
        </aside>
      </div>
    </footer>

  </body>
</html>
