<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!-- Pagination Component -->
<c:if test="${pageResult.totalPages > 1}">
    <div class="pagination-section">
        <!-- Thông tin trang -->
        <div class="pagination-info">
            <span class="results-count">
                Hiển thị ${pageResult.startItem} - ${pageResult.endItem} 
                của ${pageResult.totalElements} sản phẩm
            </span>
        </div>

        <!-- Navigation -->
        <div class="pagination-nav">
            <!-- Previous Button -->
            <c:if test="${pageResult.hasPrevious}">
                <a href="javascript:void(0)" onclick="goToPage(${pageResult.currentPage - 1})" 
                   class="page-btn prev-btn">
                    <span>‹</span> Trước
                </a>
            </c:if>

            <!-- Page Numbers -->
            <div class="page-numbers">
                <c:set var="startPage" value="${pageResult.currentPage - 2}" />
                <c:set var="endPage" value="${pageResult.currentPage + 2}" />

                <c:if test="${startPage < 1}">
                    <c:set var="startPage" value="1" />
                    <c:set var="endPage" value="${fn:length(pageResult.totalPages) > 5 ? 5 : pageResult.totalPages}" />
                </c:if>

                <c:if test="${endPage > pageResult.totalPages}">
                    <c:set var="endPage" value="${pageResult.totalPages}" />
                    <c:set var="startPage" value="${pageResult.totalPages - 4 > 0 ? pageResult.totalPages - 4 : 1}" />
                </c:if>

                <!-- First page -->
                <c:if test="${startPage > 1}">
                    <a href="javascript:void(0)" onclick="goToPage(1)" class="page-btn">1</a>
                    <c:if test="${startPage > 2}">
                        <span class="page-dots">...</span>
                    </c:if>
                </c:if>

                <!-- Page range -->
                <c:forEach var="pageNum" begin="${startPage}" end="${endPage}">
                    <c:choose>
                        <c:when test="${pageNum == pageResult.currentPage}">
                            <span class="page-btn current">${pageNum}</span>
                        </c:when>
                        <c:otherwise>
                            <a href="javascript:void(0)" onclick="goToPage(${pageNum})" 
                               class="page-btn">${pageNum}</a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>

                <!-- Last page -->
                <c:if test="${endPage < pageResult.totalPages}">
                    <c:if test="${endPage < pageResult.totalPages - 1}">
                        <span class="page-dots">...</span>
                    </c:if>
                    <a href="javascript:void(0)" onclick="goToPage(${pageResult.totalPages})" 
                       class="page-btn">${pageResult.totalPages}</a>
                </c:if>
            </div>

            <!-- Next Button -->
            <c:if test="${pageResult.hasNext}">
                <a href="javascript:void(0)" onclick="goToPage(${pageResult.currentPage + 1})" 
                   class="page-btn next-btn">
                    Sau <span>›</span>
                </a>
            </c:if>
        </div>

        <!-- Go to Page -->
        <div class="goto-page">
            <span>Đến trang:</span>
            <input type="number" id="gotoPageInput" min="1" max="${pageResult.totalPages}" 
                   placeholder="${pageResult.currentPage}" onkeypress="handleGotoPageEnter(event)">
            <button onclick="gotoPage()" class="goto-btn">Đi</button>
        </div>
    </div>
</c:if>

<style>
    /* Pagination Styles */
    .pagination-section {
        background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);
        border-radius: 16px;
        padding: 20px;
        margin: 24px 0;
        box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        border: 1px solid rgba(102, 126, 234, 0.1);
        display: flex;
        flex-direction: column;
        gap: 16px;
    }

    .pagination-info {
        text-align: center;
    }

    .results-count {
        color: var(--text-dark);
        font-weight: 500;
        font-size: 14px;
        background: var(--primary-gradient);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
    }

    .pagination-nav {
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 8px;
        flex-wrap: wrap;
    }

    .page-numbers {
        display: flex;
        align-items: center;
        gap: 4px;
        margin: 0 12px;
    }

    .page-btn {
        padding: 10px 16px;
        border-radius: 8px;
        text-decoration: none;
        color: var(--text-dark);
        font-weight: 500;
        font-size: 14px;
        transition: all 0.3s ease;
        background: white;
        border: 2px solid #e2e8f0;
        cursor: pointer;
        display: flex;
        align-items: center;
        gap: 4px;
        min-width: 44px;
        justify-content: center;
    }

    .page-btn:hover:not(.current) {
        background: var(--primary-gradient);
        color: white;
        border-color: transparent;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
    }

    .page-btn.current {
        background: var(--primary-gradient);
        color: white;
        border-color: transparent;
        box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        transform: scale(1.05);
    }

    .page-btn.prev-btn,
    .page-btn.next-btn {
        padding: 10px 20px;
        font-weight: 600;
    }

    .page-dots {
        padding: 10px 8px;
        color: #64748b;
        font-weight: bold;
    }

    .goto-page {
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 12px;
        padding-top: 16px;
        border-top: 1px solid #e2e8f0;
    }

    .goto-page span {
        color: var(--text-dark);
        font-weight: 500;
        font-size: 14px;
    }

    .goto-page input {
        width: 80px;
        padding: 8px 12px;
        border: 2px solid #e2e8f0;
        border-radius: 6px;
        text-align: center;
        font-size: 14px;
        font-weight: 500;
    }

    .goto-page input:focus {
        outline: none;
        border-color: #667eea;
        box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.1);
    }

    .goto-btn {
        padding: 8px 16px;
        background: var(--primary-gradient);
        color: white;
        border: none;
        border-radius: 6px;
        font-weight: 600;
        font-size: 14px;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .goto-btn:hover {
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
    }

    /* Responsive */
    @media (max-width: 768px) {
        .pagination-section {
            padding: 16px;
            margin: 16px 0;
        }

        .pagination-nav {
            gap: 6px;
        }

        .page-numbers {
            margin: 0 8px;
        }

        .page-btn {
            padding: 8px 12px;
            min-width: 36px;
            font-size: 13px;
        }

        .page-btn.prev-btn,
        .page-btn.next-btn {
            padding: 8px 16px;
        }

        .goto-page {
            flex-wrap: wrap;
            justify-content: center;
            gap: 8px;
        }
    }

    @media (max-width: 480px) {
        .page-numbers .page-btn:not(.current) {
            display: none;
        }

        .page-numbers .page-btn.current {
            display: flex;
        }

        /* Show first, last và current page */
        .page-numbers .page-btn:first-child,
        .page-numbers .page-btn:last-child {
            display: flex !important;
        }
    }
</style>

<script>
    // Pagination Functions
        function goToPage(pageNumber) {
            console.log('Going to page:', pageNumber);
            
            // Update current page display
            const currentBtn = document.querySelector('.page-btn.current');
            if (currentBtn) {
                currentBtn.classList.remove('current');
                currentBtn.innerHTML = currentBtn.textContent;
                currentBtn.href = 'javascript:void(0)';
                currentBtn.onclick = () => goToPage(parseInt(currentBtn.textContent));
            }
            
            // Find and update new current page
            const pageButtons = document.querySelectorAll('.page-btn');
            pageButtons.forEach(btn => {
                if (btn.textContent.trim() === pageNumber.toString()) {
                    btn.classList.add('current');
                    btn.removeAttribute('href');
                    btn.onclick = null;
                }
            });
            
            // Update goto input
            document.getElementById('gotoPageInput').placeholder = pageNumber.toString();
            
            // Here you would make the actual page request
        }

        function gotoPage() {
            const pageInput = document.getElementById('gotoPageInput');
            const pageNumber = parseInt(pageInput.value);
            const maxPage = 13; // This would come from your backend

            if (pageNumber && pageNumber >= 1 && pageNumber <= maxPage) {
                goToPage(pageNumber);
                pageInput.value = '';
            } else {
                alert('Vui lòng nhập số trang từ 1 đến ' + maxPage);
                pageInput.value = '';
            }
        }

        function handleGotoPageEnter(event) {
            if (event.key === 'Enter') {
                gotoPage();
            }
        }

        // Initialize
        document.addEventListener('DOMContentLoaded', function() {
            // Auto focus and select goto page input
            const gotoInput = document.getElementById('gotoPageInput');
            if (gotoInput) {
                gotoInput.addEventListener('focus', function() {
                    this.select();
                });
            }

            // Format number inputs to remove decimals
            const priceInputs = document.querySelectorAll('#minPrice, #maxPrice');
            priceInputs.forEach(input => {
                input.addEventListener('input', function() {
                    // Remove any decimal part
                    let value = this.value;
                    if (value.includes('.')) {
                        this.value = Math.floor(parseFloat(value)).toString();
                    }
                });
            });

            // Default collapsed on mobile
            if (window.innerWidth <= 768) {
                const content = document.getElementById('filterContent');
                const toggleBtn = document.querySelector('.filter-toggle .toggle-text');
                content.classList.add('collapsed');
                toggleBtn.textContent = 'Mở rộng';
            }
        });
</script>