<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dto.Products, java.util.List, dto.Product_images" %>
<html>
    <head>
        <title>Product Management</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"/>
    </head>
    <body class="bg-light">
        <%
            Products product = (Products) request.getAttribute("product");
            String messageAddProduct = (String) request.getAttribute("messageAddProduct");
            String checkErrorAddProduct = (String) request.getAttribute("checkErrorAddProduct");
            String checkErrorEditProduct = (String) request.getAttribute("checkErrorEditProduct");
            List<Product_images> productImages = (List<Product_images>) request.getAttribute("productImages");
        %>
        <div class="container mt-5">
            <h2 class="mb-4"><%= (product != null) ? "Edit Product" : "Add New Product" %></h2>

            <!-- Thông báo -->
            <% if (messageAddProduct != null) { %>
            <div class="alert alert-success"><%= messageAddProduct %></div>
            <% } else if (checkErrorAddProduct != null) { %>
            <div class="alert alert-danger"><%= checkErrorAddProduct %></div>
            <% } else if (checkErrorEditProduct != null) { %>
            <div class="alert alert-danger"><%= checkErrorEditProduct %></div>
            <% } %>

            <!-- Form -->
            <form action="MainController" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="<%= (product != null) ? "updateProduct" : "addProduct" %>"/>
                <% if (product != null) { %>
                <input type="hidden" name="productId" value="<%= product.getId() %>"/>
                <% } %>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Product Name</label>
                        <input type="text" name="name" class="form-control"
                               value="<%= (product != null) ? product.getName() : "" %>" required/>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">SKU</label>
                        <input type="text" name="sku" class="form-control"
                               value="<%= (product != null) ? product.getSku() : "" %>" required/>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Price</label>
                        <input type="number" step="0.01" name="price" class="form-control"
                               value="<%= (product != null) ? product.getPrice() : "" %>" required/>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Quantity</label>
                        <input type="number" name="quantity" class="form-control"
                               value="<%= (product != null) ? product.getQuantity() : "" %>" required/>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Product Type</label>
                        <input type="text" name="product_type" class="form-control"
                               value="<%= (product != null) ? product.getProduct_type() : "" %>" required/>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Model ID</label>
                        <input type="number" name="model_id" class="form-control"
                               value="<%= (product != null) ? product.getModel_id() : "" %>" required/>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Memory ID</label>
                        <input type="number" name="memory_id" class="form-control"
                               value="<%= (product != null) ? product.getMemory_id() : "" %>" required/>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Guarantee ID</label>
                        <input type="number" name="guarantee_id" class="form-control"
                               value="<%= (product != null) ? product.getGuarantee_id() : "" %>" required/>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Specification (HTML)</label>
                    <textarea name="spec_html" class="form-control" rows="5"><%= (product != null) ? product.getDescription_html() : "" %></textarea>
                </div>

                <div class="mb-3">
                    <label class="form-label">Status</label>
                    <select name="status" class="form-select">
                        <option value="active" <%= (product != null && "active".equals(product.getStatus())) ? "selected" : "" %>>Active</option>
                        <option value="inactive" <%= (product != null && "inactive".equals(product.getStatus())) ? "selected" : "" %>>Inactive</option>
                        <option value="prominent" <%= (product != null && "prominent".equals(product.getStatus())) ? "selected" : "" %>>Prominent</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label class="form-label">Upload Images (max 4)</label>
                    <div class="row g-2">
                        <div class="col-md-3">
                            <input type="file" name="imageFile1" class="form-control" accept="image/*"/>
                        </div>
                        <div class="col-md-3">
                            <input type="file" name="imageFile2" class="form-control" accept="image/*"/>
                        </div>
                        <div class="col-md-3">
                            <input type="file" name="imageFile3" class="form-control" accept="image/*"/>
                        </div>
                        <div class="col-md-3">
                            <input type="file" name="imageFile4" class="form-control" accept="image/*"/>
                        </div>
                    </div>

                    <% if (productImages != null && !productImages.isEmpty()) { %>
                    <div class="mt-3">
                        <p>Current Images:</p>
                        <div class="d-flex flex-wrap gap-2">
                            <% for (Product_images img : productImages) { %>
                            <img src="<%= request.getContextPath() %>/<%= img.getImage_url() %>"
                                 class="img-thumbnail" style="max-width:150px;"/>
                            <% } %>
                        </div>
                    </div>
                    <% } %>
                </div>

                <button type="submit" class="btn btn-primary">
                    <%= (product != null) ? "Update Product" : "Add Product" %>
                </button>
                <a href="welcome.jsp" class="btn btn-secondary">Back to List</a>
            </form>
        </div>
    </body>
</html>