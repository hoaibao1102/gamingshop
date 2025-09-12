
<%-- 
    Document   : welcome
    Created on : Sep 2, 2025, 12:36:54 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.Accounts" %>
<%@page import="utils.AuthUtils" %>
<%@page import="java.util.List" %>
<%@page import="dto.Products" %>
<%@page import="dto.Product_images" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Welcome Page</title>
        <style>
            .products-table img {
                width: 100px;
                height: auto;
                border: 1px solid #ccc;
                border-radius: 5px;
            }
        </style>
    </head>
    <body>
        <%
            Accounts accounts = AuthUtils.getCurrentUser(request);
            String keyword = (String) request.getAttribute("keyword");
            String checkErrorSearch = (String) request.getAttribute("checkErrorSearch");
            List<Products> list = (List<Products>) request.getAttribute("list");
            String messageUpdateProductImage = (String) request.getAttribute("messageUpdateProductImage");
            String checkErrorUpdateProductImage = (String) request.getAttribute("checkErrorUpdateProductImage");
            String messageDeleteProduct = (String) request.getAttribute("messageDeleteProduct");
            String checkErrorDeleteProduct = (String) request.getAttribute("checkErrorUpdateProduct");
        %>
        <div class="container">
            <div class="header-section">
                <% if (accounts != null) { %>
                <h1>Welcome <%= accounts.getFull_name() %>!</h1>
                <div class="header-actions">
                    <a href="MainController?action=logout" class="logout-btn">Logout</a>
                </div>
                <% } else { %>
                <div class="header-actions">
                    <a href="login.jsp" class="login-btn">Login</a>
                </div>
                <% } %>
            </div>

            <div class="content">
                <div class="search-section">
                    <form action="MainController" method="post" class="search-form">
                        <input type="hidden" name="action" value="searchProduct"/>
                        <label>Search product by name:</label>
                        <input type="text" name="keyword" 
                               value="<%= (keyword != null) ? keyword : "" %>" 
                               placeholder="Enter product name..."/>
                        <input type="submit" value="Search"/>
                    </form>
                </div>

                <% if (list != null && !list.isEmpty()) { %>
                <table class="products-table" border="1" cellpadding="8" cellspacing="0">
                    <thead>
                        <tr>
                            <th>Image</th>
                            <th>Product ID</th>
                            <th>Product Name</th>
                            <th>Product Sku</th>
                            <th>Price</th>
                            <th>Product Type</th>
                            <th>Quantity</th>
                            <th>Description</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            for (Products p : list) {
                                if ("inactive".equals(p.getStatus())) { 
                                    continue; 
                                }

                                double price = p.getPrice();
                                java.text.DecimalFormat df = new java.text.DecimalFormat("#,###");
                                String formatted = df.format(price) + " VND";

                                List<Product_images> imgs = p.getImage();
                                Product_images img = (imgs != null && !imgs.isEmpty()) ? imgs.get(0) : null;
                                String imgUrl = (img != null && img.getImage_url() != null && !img.getImage_url().isEmpty())
                                                ? img.getImage_url()
                                                : "assets/img/no-image.png";
                        %>
                        <tr>
                            <td>
                                <img src="<%= imgUrl %>" alt="<%= p.getName() %>"/>
                            </td>
                            <td><%= p.getId() %></td>
                            <td><%= p.getName() %></td>
                            <td><%= p.getSku() %></td>
                            <td><%= formatted %></td>
                            <td><%= p.getProduct_type() %></td>
                            <td><%= p.getQuantity() %></td>
                            <td><%= p.getDescription_html() %></td>
                            <td><%= p.getStatus() %></td>
                            <td>
                                <form action="MainController" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="editMainProduct"/>
                                    <input type="hidden" name="product_id" value="<%= p.getId() %>"/>
                                    <input type="hidden" name="price" value="<%= formatted %>"/>
                                    <input type="hidden" name="keyword" value="<%= (keyword != null) ? keyword : "" %>" />
                                    <input type="submit" value="Edit" class="edit-btn" />
                                </form>

                                <form action="MainController" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="deleteProduct"/>
                                    <input type="hidden" name="product_id" value="<%= p.getId() %>"/>
                                    <input type="hidden" name="keyword" value="<%= (keyword != null) ? keyword : "" %>" />
                                    <input type="submit" value="Delete" class="edit-btn" />
                                </form>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <% } else if (checkErrorSearch != null && !checkErrorSearch.isEmpty()) { %>
                <div class="error-message"><%= checkErrorSearch %></div>
                <% } else if (messageDeleteProduct != null) { %>
                <div class="alert alert-success"><%= messageDeleteProduct %></div>
                <% } else if (checkErrorDeleteProduct != null) { %>
                <div class="alert alert-danger"><%= checkErrorDeleteProduct %></div>
                <% } %>
            </div>
        </div>
    </body>
</html>