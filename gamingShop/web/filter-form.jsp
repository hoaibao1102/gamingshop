<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- Filter Form Section -->
<div class="filter-section">
    <div class="filter-header">
        <h3>Lọc & Sắp xếp sản phẩm</h3>
        <button type="button" class="filter-toggle" onclick="toggleFilter()">
            <span class="filter-icon">🔍</span>
            <span class="toggle-text">Mở rộng</span>
        </button>
    </div>

    <div class="filter-content" id="filterContent">
        <form action="ProductController" method="GET" class="filter-form">
            <input type="hidden" name="action" value="filterProducts">

            <div class="filter-row">
                <!-- Tên sản phẩm -->
                <div class="filter-group">
                    <label for="name">Tên sản phẩm:</label>
                    <input type="text" id="name" name="name" 
                           value="${currentFilter.name}" 
                           placeholder="Tìm theo tên sản phẩm...">
                </div>

                <!-- Loại sản phẩm -->
                <div class="filter-group">
                    <label for="productType">Loại sản phẩm:</label>
                    <select id="productType" name="productType">
                        <option value="all" ${currentFilter.productType eq 'all' ? 'selected' : ''}>Tất cả</option>
                        <option value="new" ${currentFilter.productType eq 'new' ? 'selected' : ''}>Mới</option>
                        <option value="used" ${currentFilter.productType eq 'used' ? 'selected' : ''}>Đã sử dụng</option>
                    </select>
                </div>
            </div>

            <div class="filter-row">
                <!-- Khoảng giá -->
                <div class="filter-group price-range">
                            <label>Khoảng giá (VND):</label>
                            <div class="price-inputs">
                                <input type="number" id="minPrice" name="minPrice" 
                                       placeholder="Giá từ..." min="0" step="1000">
                                <span class="price-separator">→</span>
                                <input type="number" id="maxPrice" name="maxPrice" 
                                       placeholder="Giá đến..." min="0" step="1000">
                            </div>
                        </div>

                <!-- Sắp xếp -->
                <div class="filter-group">
                    <label for="sortBy">Sắp xếp theo:</label>
                    <select id="sortBy" name="sortBy">
                        <option value="name_asc" ${currentFilter.sortBy eq 'name_asc' ? 'selected' : ''}>Tên A → Z</option>
                        <option value="name_desc" ${currentFilter.sortBy eq 'name_desc' ? 'selected' : ''}>Tên Z → A</option>
                        <option value="price_asc" ${currentFilter.sortBy eq 'price_asc' ? 'selected' : ''}>Giá thấp → cao</option>
                        <option value="price_desc" ${currentFilter.sortBy eq 'price_desc' ? 'selected' : ''}>Giá cao → thấp</option>
                        <option value="date_desc" ${currentFilter.sortBy eq 'date_desc' ? 'selected' : ''}>Mới nhất</option>
                        <option value="date_asc" ${currentFilter.sortBy eq 'date_asc' ? 'selected' : ''}>Cũ nhất</option>
                    </select>
                </div>
            </div>

            <!-- Buttons -->
            <div class="filter-actions">
                <button type="submit" class="btn-filter">
                    <span>🔍</span> Lọc sản phẩm
                </button>
                <button type="button" class="btn-reset" onclick="resetFilter()">
                    <span>🔄</span> Reset
                </button>
            </div>
        </form>
    </div>
</div>

<style>
    /* Filter Section Styles */
    .filter-section {
        background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);
        border-radius: 16px;
        margin: 20px 24px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        border: 1px solid rgba(102, 126, 234, 0.1);
        overflow: hidden;
        transition: all 0.3s ease;
    }

    .filter-header {
        background: var(--primary-gradient);
        color: white;
        padding: 16px 24px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        cursor: pointer;
        user-select: none;
    }

    .filter-header h3 {
        margin: 0;
        font-size: 18px;
        font-weight: 600;
    }

    .filter-toggle {
        background: rgba(255,255,255,0.2);
        border: 1px solid rgba(255,255,255,0.3);
        color: white;
        padding: 8px 16px;
        border-radius: 20px;
        cursor: pointer;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        gap: 8px;
        font-size: 14px;
    }

    .filter-toggle:hover {
        background: rgba(255,255,255,0.3);
        transform: scale(1.05);
    }

    .filter-content {
        padding: 24px;
        display: block;
        transition: all 0.3s ease;
    }

    .filter-content.collapsed {
        display: none;
    }

    .filter-form {
        display: flex;
        flex-direction: column;
        gap: 20px;
    }

    .filter-row {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 20px;
    }

    .filter-group {
        display: flex;
        flex-direction: column;
        gap: 8px;
    }

    .filter-group label {
        font-weight: 600;
        color: var(--text-dark);
        font-size: 14px;
    }

    .filter-group input,
    .filter-group select {
        padding: 12px 16px;
        border: 2px solid #e2e8f0;
        border-radius: 10px;
        font-size: 14px;
        transition: all 0.3s ease;
        background: white;
    }

    .filter-group input:focus,
    .filter-group select:focus {
        outline: none;
        border-color: #667eea;
        box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        transform: translateY(-1px);
    }

    .price-range .price-inputs {
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .price-range .price-inputs input {
        flex: 1;
    }

    .price-separator {
        font-weight: 600;
        color: var(--text-dark);
        white-space: nowrap;
    }

    .filter-actions {
        display: flex;
        gap: 16px;
        justify-content: flex-end;
        margin-top: 8px;
    }

    .btn-filter,
    .btn-reset {
        padding: 12px 24px;
        border-radius: 10px;
        font-weight: 600;
        font-size: 14px;
        cursor: pointer;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        gap: 8px;
        border: none;
    }

    .btn-filter {
        background: var(--primary-gradient);
        color: white;
        box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
    }

    .btn-filter:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
    }

    .btn-reset {
        background: #f1f5f9;
        color: var(--text-dark);
        border: 2px solid #e2e8f0;
    }

    .btn-reset:hover {
        background: #e2e8f0;
        transform: translateY(-1px);
    }

    /* Responsive */
    @media (max-width: 768px) {
        .filter-section {
            margin: 15px 16px;
        }

        .filter-header {
            padding: 12px 16px;
        }

        .filter-content {
            padding: 16px;
        }

        .filter-row {
            grid-template-columns: 1fr;
            gap: 16px;
        }

        .filter-actions {
            flex-direction: column;
        }

        .btn-filter,
        .btn-reset {
            justify-content: center;
        }
    }
</style>

<script>
    function toggleFilter() {
        const content = document.getElementById('filterContent');
        const toggleBtn = document.querySelector('.filter-toggle .toggle-text');

        if (content.classList.contains('collapsed')) {
            content.classList.remove('collapsed');
            toggleBtn.textContent = 'Thu gọn';
        } else {
            content.classList.add('collapsed');
            toggleBtn.textContent = 'Mở rộng';
        }
    }

    function resetFilter() {
        // Reset form
        document.getElementById('name').value = '';
        document.getElementById('productType').value = 'all';
        document.getElementById('minPrice').value = '';
        document.getElementById('maxPrice').value = '';
        document.getElementById('sortBy').value = 'name_asc';

        // Submit form to reset
        const form = document.querySelector('.filter-form');
        form.submit();
    }

// Initialize filter state
    document.addEventListener('DOMContentLoaded', function () {
        // Mặc định thu gọn form trên mobile
        if (window.innerWidth <= 768) {
            const content = document.getElementById('filterContent');
            const toggleBtn = document.querySelector('.filter-toggle .toggle-text');
            content.classList.add('collapsed');
            toggleBtn.textContent = 'Mở rộng';
        }
    });
</script>