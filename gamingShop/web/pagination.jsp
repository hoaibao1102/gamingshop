<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%>

<c:set var="pg"    value="${pageResult.currentPage}" />
<c:set var="size"  value="${pageResult.pageSize}" />
<c:set var="tot"   value="${pageResult.totalElements}" />
<c:set var="max"   value="${pageResult.totalPages}" />
<c:set var="start" value="${pageResult.startItem}" />
<c:set var="end"   value="${pageResult.endItem}" />

<div class="pagination-section">
    <!-- ===== Info: luôn hiển thị ===== -->
    <div class="pagination-info">
        <c:choose>
            <c:when test="${tot == 0}">
                <span class="results-count">Không tìm thấy sản phẩm</span>
            </c:when>
            <c:when test="${tot <= size}">
                <span class="results-count">
                    Hiển thị <fmt:formatNumber value="${tot}" type="number" groupingUsed="true"/> sản phẩm
                </span>
            </c:when>
            <c:otherwise>
                <span class="results-count">
                    Hiển thị
                    <fmt:formatNumber value="${start}" type="number" groupingUsed="true"/> -
                    <fmt:formatNumber value="${end}"   type="number" groupingUsed="true"/>
                    của
                    <fmt:formatNumber value="${tot}"   type="number" groupingUsed="true"/> sản phẩm
                </span>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- ===== Nav: chỉ hiển thị khi > 1 trang ===== -->
    <c:if test="${max > 1}">
        <div class="pagination-nav">
            <!-- Prev -->
            <c:if test="${pg > 1}">
                <c:url var="prevHref" value="${pageContext.request.requestURI}">
                    <c:if test="${not empty param.action}"><c:param name="action" value="${param.action}"/></c:if>
                    <c:if test="${not empty param.name}"><c:param name="name" value="${param.name}"/></c:if>
                    <c:if test="${not empty param.type}"><c:param name="type" value="${param.type}"/></c:if>
                    <c:if test="${not empty param.minPrice}"><c:param name="minPrice" value="${param.minPrice}"/></c:if>
                    <c:if test="${not empty param.maxPrice}"><c:param name="maxPrice" value="${param.maxPrice}"/></c:if>
                    <c:if test="${not empty param.sortBy}"><c:param name="sortBy" value="${param.sortBy}"/></c:if>
                    <c:param name="page" value="${pg - 1}"/>
                </c:url>
                <a href="${prevHref}" onclick="return goToPage(${pg - 1})" class="page-btn prev-btn">
                    <span>‹</span> Trước
                </a>
            </c:if>

            <!-- Page numbers (cửa sổ ±2) -->
            <div class="page-numbers">
                <c:set var="from" value="${pg - 2}"/>
                <c:if test="${from < 1}"><c:set var="from" value="1"/></c:if>
                <c:set var="to" value="${pg + 2}"/>
                <c:if test="${to > max}"><c:set var="to" value="${max}"/></c:if>

                    <!-- First -->
                <c:if test="${from > 1}">
                    <c:url var="firstHref" value="${pageContext.request.requestURI}">
                        <c:if test="${not empty param.action}"><c:param name="action" value="${param.action}"/></c:if>
                        <c:if test="${not empty param.name}"><c:param name="name" value="${param.name}"/></c:if>
                        <c:if test="${not empty param.type}"><c:param name="type" value="${param.type}"/></c:if>
                        <c:if test="${not empty param.minPrice}"><c:param name="minPrice" value="${param.minPrice}"/></c:if>
                        <c:if test="${not empty param.maxPrice}"><c:param name="maxPrice" value="${param.maxPrice}"/></c:if>
                        <c:if test="${not empty param.sortBy}"><c:param name="sortBy" value="${param.sortBy}"/></c:if>
                        <c:param name="page" value="1"/>
                    </c:url>
                    <a href="${firstHref}" onclick="return goToPage(1)" class="page-btn">1</a>
                    <c:if test="${from > 2}">
                        <span class="page-dots">...</span>
                    </c:if>
                </c:if>

                <!-- Range -->
                <c:forEach begin="${from}" end="${to}" var="p">
                    <c:choose>
                        <c:when test="${p == pg}">
                            <span class="page-btn current" aria-current="page">${p}</span>
                        </c:when>
                        <c:otherwise>
                            <c:url var="pHref" value="${pageContext.request.requestURI}">
                                <c:if test="${not empty param.action}"><c:param name="action" value="${param.action}"/></c:if>
                                <c:if test="${not empty param.name}"><c:param name="name" value="${param.name}"/></c:if>
                                <c:if test="${not empty param.type}"><c:param name="type" value="${param.type}"/></c:if>
                                <c:if test="${not empty param.minPrice}"><c:param name="minPrice" value="${param.minPrice}"/></c:if>
                                <c:if test="${not empty param.maxPrice}"><c:param name="maxPrice" value="${param.maxPrice}"/></c:if>
                                <c:if test="${not empty param.sortBy}"><c:param name="sortBy" value="${param.sortBy}"/></c:if>
                                <c:param name="page" value="${p}"/>
                            </c:url>
                            <a href="${pHref}" onclick="return goToPage(${p})" class="page-btn">${p}</a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>

                <!-- Last -->
                <c:if test="${to < max}">
                    <c:if test="${to < max - 1}">
                        <span class="page-dots">...</span>
                    </c:if>
                    <c:url var="lastHref" value="${pageContext.request.requestURI}">
                        <c:if test="${not empty param.action}"><c:param name="action" value="${param.action}"/></c:if>
                        <c:if test="${not empty param.name}"><c:param name="name" value="${param.name}"/></c:if>
                        <c:if test="${not empty param.type}"><c:param name="type" value="${param.type}"/></c:if>
                        <c:if test="${not empty param.minPrice}"><c:param name="minPrice" value="${param.minPrice}"/></c:if>
                        <c:if test="${not empty param.maxPrice}"><c:param name="maxPrice" value="${param.maxPrice}"/></c:if>
                        <c:if test="${not empty param.sortBy}"><c:param name="sortBy" value="${param.sortBy}"/></c:if>
                        <c:param name="page" value="${max}"/>
                    </c:url>
                    <a href="${lastHref}" onclick="return goToPage(${max})" class="page-btn">${max}</a>
                </c:if>
            </div>

            <!-- Next -->
            <c:if test="${pg < max}">
                <c:url var="nextHref" value="${pageContext.request.requestURI}">
                    <c:if test="${not empty param.action}"><c:param name="action" value="${param.action}"/></c:if>
                    <c:if test="${not empty param.name}"><c:param name="name" value="${param.name}"/></c:if>
                    <c:if test="${not empty param.type}"><c:param name="type" value="${param.type}"/></c:if>
                    <c:if test="${not empty param.minPrice}"><c:param name="minPrice" value="${param.minPrice}"/></c:if>
                    <c:if test="${not empty param.maxPrice}"><c:param name="maxPrice" value="${param.maxPrice}"/></c:if>
                    <c:if test="${not empty param.sortBy}"><c:param name="sortBy" value="${param.sortBy}"/></c:if>
                    <c:param name="page" value="${pg + 1}"/>
                </c:url>
                <a href="${nextHref}" onclick="return goToPage(${pg + 1})" class="page-btn next-btn">
                    Sau <span>›</span>
                </a>
            </c:if>
        </div>

        <!-- Goto -->
        <div class="goto-page">
            <span>Đến trang:</span>
            <input type="number" id="gotoPageInput" min="1" max="${max}"
                   placeholder="${pg}" onkeypress="handleGotoPageEnter(event)">
            <button onclick="gotoPage()" class="goto-btn">Đi</button>
        </div>
    </c:if>
</div>

<style>
    /* giữ style nguyên như bạn, rút gọn để ngắn tin nhắn */
    .pagination-section{
        background:linear-gradient(135deg,#fff 0%,#f8fafc 100%);
        border-radius:16px;
        padding:20px;
        margin:24px 0;
        box-shadow:0 4px 15px rgba(0,0,0,.08);
        border:1px solid rgba(102,126,234,.1);
        display:flex;
        flex-direction:column;
        gap:16px
    }
    .pagination-info{
        text-align:center
    }
    .results-count{
        color:var(--text-dark);
        font-weight:500;
        font-size:14px;
        background:var(--primary-gradient);
        -webkit-background-clip:text;
        -webkit-text-fill-color:transparent
    }
    .pagination-nav{
        display:flex;
        justify-content:center;
        align-items:center;
        gap:8px;
        flex-wrap:wrap
    }
    .page-numbers{
        display:flex;
        align-items:center;
        gap:4px;
        margin:0 12px
    }
    .page-btn{
        padding:10px 16px;
        border-radius:8px;
        text-decoration:none;
        color:var(--text-dark);
        font-weight:500;
        font-size:14px;
        transition:.3s;
        background:#fff;
        border:2px solid #e2e8f0;
        cursor:pointer;
        display:flex;
        align-items:center;
        gap:4px;
        min-width:44px;
        justify-content:center
    }
    .page-btn:hover:not(.current){
        background:var(--primary-gradient);
        color:#fff;
        border-color:transparent;
        transform:translateY(-2px);
        box-shadow:0 4px 12px rgba(102,126,234,.3)
    }
    .page-btn.current{
        background:var(--primary-gradient);
        color:#fff;
        border-color:transparent;
        box-shadow:0 4px 15px rgba(102,126,234,.4);
        transform:scale(1.05)
    }
    .page-btn.prev-btn,.page-btn.next-btn{
        padding:10px 20px;
        font-weight:600
    }
    .page-dots{
        padding:10px 8px;
        color:#64748b;
        font-weight:bold
    }
    .goto-page{
        display:flex;
        justify-content:center;
        align-items:center;
        gap:12px;
        padding-top:16px;
        border-top:1px solid #e2e8f0
    }
    .goto-page span{
        color:var(--text-dark);
        font-weight:500;
        font-size:14px
    }
    .goto-page input{
        width:80px;
        padding:8px 12px;
        border:2px solid #e2e8f0;
        border-radius:6px;
        text-align:center;
        font-size:14px;
        font-weight:500
    }
    .goto-page input:focus{
        outline:none;
        border-color:#667eea;
        box-shadow:0 0 0 2px rgba(102,126,234,.1)
    }
    .goto-btn{
        padding:8px 16px;
        background:var(--primary-gradient);
        color:#fff;
        border:none;
        border-radius:6px;
        font-weight:600;
        font-size:14px;
        cursor:pointer;
        transition:.3s
    }
    .goto-btn:hover{
        transform:translateY(-1px);
        box-shadow:0 4px 12px rgba(102,126,234,.3)
    }
    @media (max-width:768px){
        .pagination-section{
            padding:16px;
            margin:16px 0
        }
        .pagination-nav{
            gap:6px
        }
        .page-numbers{
            margin:0 8px
        }
        .page-btn{
            padding:8px 12px;
            min-width:36px;
            font-size:13px
        }
        .page-btn.prev-btn,.page-btn.next-btn{
            padding:8px 16px
        }
        .goto-page{
            flex-wrap:wrap;
            gap:8px
        }
    }
    @media (max-width:480px){
        .page-numbers .page-btn:not(.current){
            display:none
        }
        .page-numbers .page-btn.current{
            display:flex
        }
        .page-numbers .page-btn:first-child,
        .page-numbers .page-btn:last-child{
            display:flex!important
        }
    }
</style>

<script>
    // Dùng dữ liệu thật từ backend, không hard-code
    const MAX_PAGE = ${max};

    // Điều hướng: giữ nguyên mọi filter param hiện có
    function goToPage(n) {
        if (!n || n < 1 || n > MAX_PAGE)
            return false;    // prevent default nếu invalid
        const url = new URL(window.location.href);
        url.searchParams.set('page', n);
        window.location.assign(url.toString());
        return false; // chặn default click của <a>
    }
    function gotoPage() {
        const input = document.getElementById('gotoPageInput');
        if (!input)
            return;
        const n = parseInt(input.value, 10);
        if (!isNaN(n) && n >= 1 && n <= MAX_PAGE)
            goToPage(n);
        else
            alert('Vui lòng nhập số trang từ 1 đến ' + MAX_PAGE);
        input.value = '';
    }
    function handleGotoPageEnter(e) {
        if (e.key === 'Enter') {
            gotoPage();
        }
    }
</script>
