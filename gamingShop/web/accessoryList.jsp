<%-- 
    Document   : accessoryList
    Created on : Sep 12, 2025, 10:16:52 AM
    Author     : ddhuy
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Accessories Management</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css" rel="stylesheet">
        <style>
            .main-container {
                margin: 2rem auto;
                max-width: 1400px;
            }
            .card-custom {
                border-radius: 15px;
                box-shadow: 0 0 20px rgba(0,0,0,0.1);
                border: none;
            }
            .btn-custom {
                border-radius: 25px;
                padding: 8px 20px;
                font-weight: 600;
            }
            .status-badge {
                padding: 5px 12px;
                border-radius: 15px;
                font-size: 0.8rem;
                font-weight: 600;
            }
            .status-active {
                background-color: #d4edda;
                color: #155724;
            }
            .status-inactive {
                background-color: #f8d7da;
                color: #721c24;
            }
            .status-out_of_stock {
                background-color: #fff3cd;
                color: #856404;
            }
            .product-image {
                width: 60px;
                height: 60px;
                object-fit: cover;
                border-radius: 8px;
                border: 2px solid #e9ecef;
            }
            .search-container {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border-radius: 15px;
                padding: 2rem;
                color: white;
                margin-bottom: 2rem;
            }
            .table-responsive {
                border-radius: 10px;
                overflow: hidden;
            }
            .action-buttons {
                gap: 5px;
            }
            .pagination-container {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-top: 1rem;
            }
        </style>
    </head>
    <body class="bg-light">
        <div class="container-fluid">
            <!-- Header -->
            <div class="row">
                <div class="col-12">
                    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
                        <div class="container">
                            <a class="navbar-brand" href="MainController?action="><i class="fas fa-cogs me-2"></i>Accessories Management</a>
                            <div class="navbar-nav ms-auto">
                                <a class="nav-link" href="MainController?action=prepareHome"><!<!-- consider : ""-->
                                    <i class="fas fa-home me-1"></i>Home
                                </a>
                            </div>
                        </div>
                    </nav>
                </div>
            </div>

            <div class="main-container">
                <!-- Search Section -->
                <div class="search-container">
                    <div class="row align-items-center">
                        <div class="col-lg-8">
                            <h3 class="mb-3"><i class="fas fa-search me-2"></i>Search Accessories</h3>
                            <form action="MainController" method="get" class="d-flex">
                                <input type="hidden" name="action" value="searchAccessory">
                                <input type="text" class="form-control me-2" name="keyword" 
                                       placeholder="Search by accessory name..." value="${keyword}">
                                <button type="submit" class="btn btn-light btn-custom">
                                    <i class="fas fa-search"></i>
                                </button>
                            </form>
                        </div>
                        <div class="col-lg-4 text-lg-end mt-3 mt-lg-0">
                            <a href="MainController?action=showAddAccessoryForm" class="btn btn-success btn-custom">
                                <i class="fas fa-plus me-2"></i>Add New Accessory
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Messages -->
                <c:if test="${not empty messageDeleteAccessory}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${messageDeleteAccessory}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${not empty checkError}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>${checkError}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Accessories List -->
                <div class="card card-custom">
                    <div class="card-header bg-white py-3">
                        <div class="row align-items-center">
                            <div class="col-md-6">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-list me-2"></i>Accessories List
                                    <c:if test="${not empty totalAccessories}">
                                        <span class="badge bg-primary ms-2">${totalAccessories} items</span>
                                    </c:if>
                                </h5>
                            </div>
                            <div class="col-md-6 text-md-end">
                                <small class="text-muted">
                                    <c:if test="${not empty keyword}">
                                        Search results for: "<strong>${keyword}</strong>"
                                    </c:if>
                                </small>
                            </div>
                        </div>
                    </div>

                    <div class="card-body p-0">
                        <c:choose>
                            <c:when test="${not empty accessories && accessories.size() > 0}">
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0" id="accessoriesTable">
                                        <thead class="table-light">
                                            <tr>
                                                <th width="5%">#</th>
                                                <th width="15%">Image</th>
                                                <th width="15%">Name</th>
                                                <th width="18%">Description</th>
                                                <th width="10%">Quantity</th>
                                                <th width="12%">Price</th>
                                                <th width="15%">Status</th>
                                                <th width="15%">Gift</th>
                                                <th width="15%">Last Updated</th>
                                                <th width="8%">Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="accessory" items="${accessories}" varStatus="status">
                                                <tr>
                                                    <td class="align-middle">
                                                        <strong>${accessory.id}</strong>
                                                    </td>
                                                    <td class="align-middle">
                                                        <c:choose>
                                                            <c:when test="${not empty accessory.image_url}">
                                                                <img src="${accessory.image_url}" 
                                                                     alt="${accessory.name}" 
                                                                     class="product-image">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="product-image bg-light d-flex align-items-center justify-content-center">
                                                                    <i class="fas fa-image text-muted"></i>
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="align-middle">
                                                            <span>${accessory.name}</span>
                                                    </td>
                                                    <td class="align-middle">
                                                        <c:if test="${not empty accessory.description}">
                                                                <small class="text-muted">
                                                                    <c:choose>
                                                                        <c:when test="${fn:length(accessory.description) > 50}">
                                                                            ${fn:substring(accessory.description, 0, 50)}...
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            ${accessory.description}
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </small>
                                                            </c:if>
                                                    </td>
                                                    
                                                    <td class="align-middle">
                                                        <span class="fw-bold">${accessory.quantity}</span>
                                                    </td>
                                                    <td class="align-middle">
                                                        <span class="fw-bold text-success">
                                                            $<fmt:formatNumber value="${accessory.price}" pattern="#,##0.00"/>
                                                        </span>
                                                    </td>
                                                    <td class="align-middle">
                                                        <span class="status-badge status-${accessory.status}">
                                                            <c:choose>
                                                                <c:when test="${accessory.status == 'active'}">
                                                                    <i class="fas fa-check-circle me-1"></i>Active
                                                                </c:when>
                                                                <c:when test="${accessory.status == 'inactive'}">
                                                                    <i class="fas fa-times-circle me-1"></i>Inactive
                                                                </c:when>
                                                                <c:when test="${accessory.status == 'out_of_stock'}">
                                                                    <i class="fas fa-exclamation-circle me-1"></i>Out of Stock
                                                                </c:when>
                                                                <c:otherwise>
                                                                    ${accessory.status}
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </td>
                                                    <td class="align-middle">
                                                        <span class="status-badge status-${accessory.gift}">
                                                            <c:choose>
                                                                <c:when test="${accessory.gift == 'Phụ kiện tặng kèm'}">
                                                                    <i class="fas fa-check-circle me-1"></i>Phụ kiện tặng kèm
                                                                </c:when>
                                                                <c:when test="${accessory.gift == 'Phụ kiện bán'}">
                                                                    <i class="fas fa-times-circle me-1"></i>Phụ kiện bán
                                                                </c:when>
                                                                <c:otherwise>
                                                                    ${accessory.gift}
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </td>
                                                    <td class="align-middle">
                                                        <small class="text-muted">
                                                            <fmt:formatDate value="${accessory.updated_at}" pattern="dd/MM/yyyy"/>
                                                            <br>
                                                            <fmt:formatDate value="${accessory.updated_at}" pattern="HH:mm"/>
                                                        </small>
                                                    </td>
                                                    <td class="align-middle">
                                                        <div class="d-flex action-buttons">
                                                            <a href="ProductController?action=showEditAccessoryForm&id=${accessory.id}" 
                                                               class="btn btn-sm btn-outline-primary" 
                                                               title="Edit">
                                                                <i class="fas fa-edit"></i>
                                                            </a>
                                                            <button type="button" 
                                                                    class="btn btn-sm btn-outline-danger" 
                                                                    onclick="confirmDelete(${accessory.id}, '${accessory.name}')"
                                                                    title="Delete">
                                                                <i class="fas fa-trash"></i>
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- Pagination -->
                                <c:if test="${not empty totalPages && totalPages > 1}">
                                    <div class="pagination-container p-3 bg-light">
                                        <div>
                                            <small class="text-muted">
                                                Showing page ${currentPage} of ${totalPages} 
                                                (${totalAccessories} total items)
                                            </small>
                                        </div>
                                        <nav>
                                            <ul class="pagination pagination-sm mb-0">
                                                <c:if test="${currentPage > 1}">
                                                    <li class="page-item">
                                                        <a class="page-link" href="MainController?action=viewAllAccessories&page=${currentPage - 1}">
                                                            <i class="fas fa-chevron-left"></i>
                                                        </a>
                                                    </li>
                                                </c:if>

                                                <c:forEach begin="1" end="${totalPages}" var="i">
                                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                        <a class="page-link" href="MainController?action=viewAllAccessories&page=${i}">
                                                            ${i}
                                                        </a>
                                                    </li>
                                                </c:forEach>

                                                <c:if test="${currentPage < totalPages}">
                                                    <li class="page-item">
                                                        <a class="page-link" href="MainController?action=viewAllAccessories&page=${currentPage + 1}">
                                                            <i class="fas fa-chevron-right"></i>
                                                        </a>
                                                    </li>
                                                </c:if>
                                            </ul>
                                        </nav>
                                    </div>
                                </c:if>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-5">
                                    <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                    <h5 class="text-muted">No accessories found</h5>
                                    <p class="text-muted">
                                        <c:choose>
                                            <c:when test="${not empty keyword}">
                                                No accessories match your search criteria.
                                            </c:when>
                                            <c:otherwise>
                                                Start by adding your first accessory.
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                    <a href="MainController?action=showAddAccessoryForm" class="btn btn-primary btn-custom">
                                        <i class="fas fa-plus me-2"></i>Add New Accessory
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <!-- Delete Confirmation Modal -->
        <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header bg-danger text-white">
                        <h5 class="modal-title" id="deleteModalLabel">
                            <i class="fas fa-exclamation-triangle me-2"></i>Confirm Delete
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure you want to delete this accessory?</p>
                        <div class="alert alert-warning">
                            <strong>Name:</strong> <span id="deleteAccessoryName"></span><br>
                            <strong>ID:</strong> <span id="deleteAccessoryId"></span>
                        </div>
                        <p class="text-muted"><i class="fas fa-info-circle me-1"></i>This action cannot be undone.</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-1"></i>Cancel
                        </button>
                        <a id="confirmDeleteBtn" href="#" class="btn btn-danger">
                            <i class="fas fa-trash me-1"></i>Delete Accessory
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>
        <script>
                                                                        // Initialize DataTable
                                                                        $(document).ready(function () {
                                                                            $('#accessoriesTable').DataTable({
                                                                                "paging": false,
                                                                                "searching": false,
                                                                                "ordering": true,
                                                                                "info": false,
                                                                                "columnDefs": [
                                                                                    {"orderable": false, "targets": [1, 7]} // Disable sorting for Image and Actions columns
                                                                                ],
                                                                                "order": [[0, "asc"]] // Default sort by ID
                                                                            });
                                                                        });

                                                                        // Delete confirmation function
                                                                        function confirmDelete(id, name) {
                                                                            document.getElementById('deleteAccessoryId').textContent = id;
                                                                            document.getElementById('deleteAccessoryName').textContent = name;
                                                                            document.getElementById('confirmDeleteBtn').href = 'MainController?action=deleteAccessory&id=' + id;

                                                                            const deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
                                                                            deleteModal.show();
                                                                        }

                                                                        // Auto hide alerts after 5 seconds
                                                                        setTimeout(function () {
                                                                            const alerts = document.querySelectorAll('.alert');
                                                                            alerts.forEach(function (alert) {
                                                                                const bsAlert = new bootstrap.Alert(alert);
                                                                                bsAlert.close();
                                                                            });
                                                                        }, 10000);

                                                                        // Search form enhancement
                                                                        document.addEventListener('DOMContentLoaded', function () {
                                                                            const searchForm = document.querySelector('form[action*="searchAccessory"]');
                                                                            const searchInput = searchForm.querySelector('input[name="keyword"]');

                                                                            // Clear search functionality
                                                                            if (searchInput.value.trim() !== '') {
                                                                                const clearBtn = document.createElement('button');
                                                                                clearBtn.type = 'button';
                                                                                clearBtn.className = 'btn btn-outline-light btn-custom ms-1';
                                                                                clearBtn.innerHTML = '<i class="fas fa-times"></i>';
                                                                                clearBtn.title = 'Clear search';
                                                                                clearBtn.onclick = function () {
                                                                                    searchInput.value = '';
                                                                                    window.location.href = 'MainController?action=viewAllAccessories';
                                                                                };
                                                                                searchForm.appendChild(clearBtn);
                                                                            }
                                                                        });
        </script>
    </body>
</html>
